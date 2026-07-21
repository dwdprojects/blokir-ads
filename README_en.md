<p align="center">
  <img src="assets/icon/icon.png" width="200">
</p>

<h1 align="center">Blokir Ads</h1>

<p align="center">
  <b>Local VPN Ad Blocker · Smart DNS Filtering</b><br>
  Per-App Targeting · Privacy First · No Root Required
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%E2%89%A53.0.0-blue.svg" alt="Flutter Version">
  <img src="https://img.shields.io/badge/Android-API%2021%2B-brightgreen.svg" alt="Android API">
  <img src="https://img.shields.io/badge/Architecture-Clean%20Architecture-orange.svg" alt="Architecture">
  <img src="https://img.shields.io/badge/State_Management-BLoC%20%2F%20Cubit-purple.svg" alt="State Management">
  <br>
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License">
</p>

<p align="center">
  🌐 🇮🇩 <a href="README.md">Bahasa Indonesia</a> | 🇬🇧 <a href="README_en.md">English</a>
</p>

---

**Blokir Ads** is a premium, open-source Android application built with Flutter that blocks digital advertisements in other applications using a local, device-only VPN. It operates without requiring root access and allows users to selectively target which apps they want to block ads on.

<p align="center">
  <img src="assets/ss/1.png" width="19%">
  <img src="assets/ss/2.png" width="19%">
  <img src="assets/ss/3.png" width="19%">
  <img src="assets/ss/4.png" width="19%">
  <img src="assets/ss/5.png" width="19%">
</p>

---

## ✨ Key Features

- **🎯 Per-App Targeting**: Choose exactly which applications you want to block ads in. The VPN tunnel will only intercept traffic from your selected apps, leaving the rest of your device's network untouched.
- **🚫 Root-less Ad Blocking**: Utilizes Android's native `VpnService` to perform DNS-level interception. No device rooting is required.
- **⚡ Local Processing (Privacy First)**: All DNS interception and traffic routing happens locally on your device. No data is sent to an external VPN server.
- **🌐 Multi-Layer Blocklist**: Combines a built-in static blocklist, a dynamic community blocklist (100,000+ domains from Steven Black & Hagezi), and a user-defined custom blocklist.
- **✅ Smart Whitelist (Allowlist)**: Protects essential domains — including reward systems, in-app points, CDN video streams, Firebase, and payment gateways — from being accidentally blocked.
- **🎨 Premium Dark UI**: Features a sleek, modern, glassmorphism-inspired dark theme (Deep Navy and Electric Cyan) for a premium user experience.

---

## 🛠️ How It Works (Technical Deep Dive)

Unlike traditional ad blockers that modify the hosts file (which requires root) or route all traffic through an external server (which raises privacy concerns), **Blokir Ads** uses a local VPN loopback mechanism.

1. **App Selection**: When a user selects a target app (e.g., a free game filled with ads), the Flutter UI passes the package name to the native Android layer via `MethodChannel`.
2. **VPN Configuration**: The native Kotlin code starts a `VpnService`. Crucially, it uses `builder.addAllowedApplication(packageName)`. This tells the Android OS to route *only* the traffic from the selected app into our custom VPN interface.
3. **DNS Interception**: The app runs a packet processing thread that listens for UDP traffic on port 53 (DNS requests).
4. **Smart Packet Inspection** *(Updated)*:
   - Every DNS request from the target app is intercepted and checked through a **4-layer decision system**:
     1. **Whitelist Check (Priority 0)** — If the domain is in the protected allowlist, it is **always allowed through**, regardless of any blocklist.
     2. **Custom Blocklist (Priority 1)** — User-defined blocked domains are checked next.
     3. **Dynamic Blocklist (Priority 2)** — 100,000+ community-sourced ad domains are checked.
     4. **Static Blocklist (Priority 3)** — Built-in hardcoded ad network domains as a final fallback (works offline).
   - **If blocked**: The service returns a spoofed DNS response pointing to `0.0.0.0` (null-route). The ad network fails to load.
   - **If allowed**: The DNS query is forwarded to Google's public DNS (`8.8.8.8`), and the real response is returned seamlessly.

---

## ✅ Whitelist System (New in v1.0)

A critical improvement over a simple blocklist is the **Whitelist (Allowlist)** system. This prevents important app functionality from being broken by overly aggressive blocking.

The following categories are **always allowed** and will never be blocked:

| Category | Examples | Why Protected |
|---|---|---|
| **Reward & Points Systems** | AppsFlyer, Adjust, Branch, Kochava | These platforms verify that you actually watched content and credit your reward/points. Blocking them would break earning systems. |
| **CDN & Video Streaming** | Cloudflare, Akamai, AWS CloudFront, Fastly | These serve the actual video, image, and audio content of the apps you use. Blocking them would break playback. |
| **Google Core Services** | Firebase, FCM, Play Services, googleapis.com | Essential for login, push notifications, app updates, and crash reporting. |
| **Payment Gateways** | Midtrans, Xendit, Stripe, GoPay, OVO, DANA | Blocking these would prevent in-app purchases and withdrawals from working. |
| **Security & Certificates** | Let's Encrypt, DigiCert, GlobalSign | Blocking OCSP/CRL endpoints would break SSL certificate validation. |

> **Example:** Apps like **FreeReels** use `appsflyer.com` and `adjust.com` to track whether you completed a watch session and to credit your reward points. Without the whitelist, these domains would be blocked because they also appear in community ad-blocking lists. With the whitelist, your points are credited correctly while banner/interstitial ads from other networks are still blocked.

---

## 🛑 What Can & Cannot Be Blocked (Limitations)

Due to the nature of DNS-based ad blocking, not all advertisements can be intercepted. It is important to understand the difference between **Third-Party Ads** and **First-Party Ads**.

### ✅ Successfully Blocked (~70–80% of Ads)
Apps that rely on external ad networks (like Google AdMob, Unity Ads, AppLovin, etc.) are successfully blocked. The ad requests are sent to different domains than the main content.
- **Free Games** (e.g., Mobile Legends, Subway Surfers, Candy Crush)
- **Utility Apps** (e.g., File managers, photo editors, weather apps)
- **News Readers & Alternative Social Media**
- **Streaming apps using AdMob / AppLovin video interstitials**

### ❌ Cannot Be Blocked (First-Party / Embedded Ads)
Giant tech platforms serve their ads from the **exact same domains** as their actual content. If we block these domains via DNS, the app itself will break entirely.
- **YouTube / YouTube Music**: Video ads come from the same server as the actual videos (`googlevideo.com`).
- **Instagram / Facebook**: Sponsored posts are injected directly into the feed from the same CDN (`cdninstagram.com`).
- **TikTok & X (Twitter)**: Similar inline native ads served from content CDNs.
- **HTTPS/DoH Ads**: Ad networks that use DNS-over-HTTPS (port 443) bypass port 53 entirely and cannot be intercepted by this VPN.

> **Best Practice:** For apps like YouTube, DNS ad blockers are not the right tool. You should use a modified client application (e.g., YouTube ReVanced or NewPipe) which removes ads at the code/API level instead of the network level.

---

## 🏗️ Architecture & Tech Stack

This project strictly follows **Clean Architecture** principles to separate concerns and ensure maintainability.

### Flutter (Frontend & Logic Layer)
- **Domain**: Entities, Repositories (Interfaces), and Usecases.
- **Data**: Models, Datasources, and Repository Implementations.
- **Presentation**: UI (Pages/Widgets) and State Management (Cubit).
- **State Management**: `flutter_bloc`
- **Dependency Injection**: `get_it`

### Android (Native Layer)
- **Language**: Kotlin
- **Core Engine**: `android.net.VpnService`
- **Blocklist Manager**: `DynamicBlocklistManager` — auto-downloads and caches 100,000+ domains from community sources (Steven Black, Hagezi, AdGuard Mobile, HostsVN). Cache refreshed every 7 days.
- **Whitelist Engine**: `BlokirVpnService.isWhitelisted()` — parent-domain aware allowlist that protects reward systems, CDNs, and payment gateways.
- **Communication**: Flutter `MethodChannel` (`com.dwd.blokirads/vpn` and `com.dwd.blokirads/apps`)

---

## 📋 Changelog

### v1.0.0 — Initial Release
- ✅ Per-app VPN-based DNS ad blocking without root
- ✅ Built-in static blocklist for 30+ major ad networks (AdMob, Unity, AppLovin, etc.)
- ✅ Dynamic blocklist auto-downloaded from community sources (100,000+ domains)
- ✅ **Smart Whitelist System** — protects reward/points APIs, CDN streams, Firebase, and payment gateways from being accidentally blocked
- ✅ User-defined custom blocklist
- ✅ Premium dark UI with real-time DNS query log terminal
- ✅ Foreground notification with live blocked-count counter

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (v3.0.0 or higher)
- Android Studio / Android SDK
- A physical Android device running API 21+ (Testing VPN features on an emulator may cause unexpected network behavior).

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/dwdprojects/blokir-ads.git
   ```
2. Navigate to the project directory:
   ```bash
   cd blokir-ads
   ```
3. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application on a connected Android device:
   ```bash
   flutter run
   ```

### Building the APK
To generate a release APK:
```bash
flutter build apk --release
```
The APK will be available at `build/app/outputs/flutter-apk/app-release.apk`.

---

## ⚠️ Disclaimer

This application is created for educational purposes and personal use to enhance user experience by removing intrusive advertisements. The developers are not responsible for any misuse of this application. Some apps may detect VPN usage and refuse to function until the VPN is disabled.

DNS-based ad blocking is not a 100% complete solution. Ads served from first-party domains (e.g., YouTube, Instagram) or via DoH (DNS-over-HTTPS) cannot be intercepted by this method.

---

## 📄 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for more details.

---
*Built with ❤️ using Flutter & Kotlin.*
