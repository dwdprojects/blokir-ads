package com.dwd.blokirads

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.net.VpnService
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {

    companion object {
        private const val VPN_CHANNEL = "com.blokirads/vpn"
        private const val APPS_CHANNEL = "com.blokirads/apps"
        private const val LOGS_CHANNEL = "com.blokirads/logs"
        private const val STATUS_CHANNEL = "com.blokirads/status"
        private const val VPN_REQUEST_CODE = 1001

        // EventSink untuk stream log real-time ke Flutter
        var logEventSink: EventChannel.EventSink? = null
        // EventSink untuk status aktif/nonaktif VPN
        var statusEventSink: EventChannel.EventSink? = null
    }

    private var pendingResult: MethodChannel.Result? = null
    private var pendingPackages: List<String> = emptyList()

    // ────────────────────────────────────────────────────────────
    // Flutter Engine Setup
    // ────────────────────────────────────────────────────────────

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        setupVpnChannel(flutterEngine)
        setupAppsChannel(flutterEngine)
        setupLogsChannel(flutterEngine)
        setupStatusChannel(flutterEngine)
    }

    // ────────────────────────────────────────────────────────────
    // Logs Channel
    // ────────────────────────────────────────────────────────────

    private fun setupLogsChannel(flutterEngine: FlutterEngine) {
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, LOGS_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    logEventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    logEventSink = null
                }
            })
    }

    // ────────────────────────────────────────────────────────────
    // Status Channel
    // ────────────────────────────────────────────────────────────

    private fun setupStatusChannel(flutterEngine: FlutterEngine) {
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, STATUS_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    statusEventSink = events
                    // Langsung kirim status saat ini ketika mulai mendengarkan
                    events?.success(BlokirVpnService.isRunning.get())
                }

                override fun onCancel(arguments: Any?) {
                    statusEventSink = null
                }
            })
    }

    // ────────────────────────────────────────────────────────────
    // VPN Channel
    // ────────────────────────────────────────────────────────────

    private fun setupVpnChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, VPN_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {

                    "requestPermission" -> {
                        val intent = VpnService.prepare(this)
                        if (intent == null) {
                            result.success(true)
                        } else {
                            pendingResult = result
                            startActivityForResult(intent, VPN_REQUEST_CODE)
                        }
                    }

                    "startVpn" -> {
                        val packages = call.argument<List<String>>("targetPackages")
                            ?: emptyList()
                        val prepareIntent = VpnService.prepare(this)
                        if (prepareIntent != null) {
                            pendingResult = result
                            pendingPackages = packages
                            startActivityForResult(prepareIntent, VPN_REQUEST_CODE)
                            return@setMethodCallHandler
                        }
                        result.success(startVpnService(packages))
                    }

                    "stopVpn" -> {
                        startService(Intent(this, BlokirVpnService::class.java).apply {
                            action = BlokirVpnService.ACTION_STOP
                        })
                        result.success(true)
                    }

                    "getStatus" -> {
                        result.success(mapOf(
                            "isActive" to BlokirVpnService.isRunning.get(),
                            "blockedCount" to BlokirVpnService.blockedCount.get(),
                            "uptimeSeconds" to 0,
                            "targetPackages" to emptyList<String>()
                        ))
                    }

                    "getBlocklistInfo" -> {
                        result.success(mapOf(
                            "domainCount" to BlokirVpnService.blocklistDomainCount,
                            "isDynamicLoaded" to BlokirVpnService.isDynamicLoaded
                        ))
                    }

                    "updateBlocklist" -> {
                        Thread {
                            BlokirVpnService.forceUpdateBlocklist(applicationContext) { progress ->
                                runOnUiThread {
                                    // Kirim progress via Event Channel (simplified: log saja)
                                    android.util.Log.d("MainActivity", "Blocklist update: $progress")
                                }
                            }
                            runOnUiThread { result.success(true) }
                        }.also { it.isDaemon = true; it.start() }
                    }

                    "addCustomDomain" -> {
                        val domain = call.argument<String>("domain")
                        if (domain != null) {
                            BlokirVpnService.addCustomDomain(applicationContext, domain)
                            result.success(true)
                        } else {
                            result.error("INVALID_ARG", "Domain is required", null)
                        }
                    }

                    "removeCustomDomain" -> {
                        val domain = call.argument<String>("domain")
                        if (domain != null) {
                            BlokirVpnService.removeCustomDomain(applicationContext, domain)
                            result.success(true)
                        } else {
                            result.error("INVALID_ARG", "Domain is required", null)
                        }
                    }

                    "addCustomWhitelist" -> {
                        val domain = call.argument<String>("domain")
                        if (domain != null) {
                            BlokirVpnService.addCustomWhitelist(applicationContext, domain)
                            result.success(true)
                        } else {
                            result.error("INVALID_ARG", "Domain is required", null)
                        }
                    }

                    "removeCustomWhitelist" -> {
                        val domain = call.argument<String>("domain")
                        if (domain != null) {
                            BlokirVpnService.removeCustomDomain(applicationContext, domain)
                            result.success(true)
                        } else {
                            result.error("INVALID_ARG", "Domain is required", null)
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }

    // ────────────────────────────────────────────────────────────
    // Apps Channel (list installed apps + icons)
    // ────────────────────────────────────────────────────────────

    private fun setupAppsChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, APPS_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInstalledApps" -> {
                        Thread {
                            try {
                                val apps = getInstalledUserApps()
                                runOnUiThread { result.success(apps) }
                            } catch (e: Exception) {
                                runOnUiThread {
                                    result.error("APPS_ERROR", e.message, null)
                                }
                            }
                        }.start()
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun getInstalledUserApps(): List<Map<String, Any?>> {
        val pm = packageManager
        val intent = Intent(Intent.ACTION_MAIN).apply {
            addCategory(Intent.CATEGORY_LAUNCHER)
        }

        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PackageManager.MATCH_ALL.toLong()
        } else {
            0L
        }

        val resolvedApps = pm.queryIntentActivities(intent, 0)

        // Package yang dikecualikan
        val excluded = setOf(packageName, "com.android.systemui", "com.android.settings")

        return resolvedApps
            .filter { info -> !excluded.contains(info.activityInfo.packageName) }
            .sortedBy { it.loadLabel(pm).toString().lowercase() }
            .map { info ->
                val pkg = info.activityInfo.packageName
                val appName = info.loadLabel(pm).toString()
                val versionName = try {
                    pm.getPackageInfo(pkg, 0).versionName ?: ""
                } catch (e: Exception) { "" }

                // Konversi icon ke ByteArray (PNG)
                val iconBytes: ByteArray? = try {
                    val drawable: Drawable = info.loadIcon(pm)
                    drawableToPngBytes(drawable)
                } catch (e: Exception) { null }

                mapOf(
                    "packageName" to pkg,
                    "appName" to appName,
                    "versionName" to versionName,
                    "icon" to iconBytes
                )
            }
    }

    private fun drawableToPngBytes(drawable: Drawable): ByteArray {
        val width = maxOf(drawable.intrinsicWidth, 1).coerceAtMost(96)
        val height = maxOf(drawable.intrinsicHeight, 1).coerceAtMost(96)

        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        drawable.setBounds(0, 0, width, height)
        drawable.draw(canvas)

        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 80, stream)
        bitmap.recycle()
        return stream.toByteArray()
    }

    // ────────────────────────────────────────────────────────────
    // VPN Permission Result
    // ────────────────────────────────────────────────────────────

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == VPN_REQUEST_CODE) {
            val granted = resultCode == Activity.RESULT_OK
            if (granted && pendingPackages.isNotEmpty()) {
                val started = startVpnService(pendingPackages)
                pendingResult?.success(started)
                pendingPackages = emptyList()
            } else {
                pendingResult?.success(granted)
            }
            pendingResult = null
        }
    }

    private fun startVpnService(packages: List<String>): Boolean {
        return try {
            startService(Intent(this, BlokirVpnService::class.java).apply {
                action = BlokirVpnService.ACTION_START
                putStringArrayListExtra(
                    BlokirVpnService.EXTRA_TARGET_PACKAGES,
                    ArrayList(packages)
                )
            })
            true
        } catch (e: Exception) { false }
    }
}
