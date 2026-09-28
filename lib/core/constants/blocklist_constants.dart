/// Daftar domain iklan yang diblokir secara default.
/// Mencakup ad network utama: AdMob, Meta, Unity Ads, AppLovin, dan Install Redirect Trackers.
class BlocklistConstants {
  BlocklistConstants._();

  static List<String> defaultBlockedDomains = [
    // ── App Install & Redirect Trackers ──
    'appsflyer.com',
    'onelink.me',
    'app.appsflyer.com',
    'adjust.com',
    'adj.st',
    'adjustapi.com',
    'branch.io',
    'app.link',
    'bnc.lt',
    'kochava.com',
    'singular.net',
    'singular.io',
    'tenjin.io',
    'airbridge.io',

    // ── Google AdMob & Mobile Ads ──
    'admob.com',
    'googleadservices.com',
    'googlesyndication.com',
    'doubleclick.net',
    'googleads.g.doubleclick.net',
    'pagead2.googlesyndication.com',
    'ad.doubleclick.net',
    'adservice.google.com',
    'ads.google.com',
    'tpc.googlesyndication.com',
    'pubads.g.doubleclick.net',
    'securepubads.g.doubleclick.net',

    // ── Unity Ads Engine ──
    'unityads.unity3d.com',
    'auction.unityads.unity3d.com',
    'publisher-event.unityads.unity3d.com',
    'config.unityads.unity3d.com',
    'webview.unityads.unity3d.com',
    'unityads.cache.unity3d.com',
    'adserver.unityads.unity3d.com',
    'cdns.unityads.unity3d.com',
    'mediation.unityads.unity3d.com',
    'applifier.com',
    'unityads.com',

    // ── ironSource / Unity LevelPlay ──
    'ironsrc.com',
    'supersonic.com',
    'ads.supersonic.com',
    'supersonicads.com',
    'outcome-ssp.supersonicads.com',
    'level-play-cdn.com',
    'levelplay.com',
    'unity-levelplay.com',
    'is.com',
    'ssacdn.com',

    // ── AppLovin & MAX ──
    'applovin.com',
    'applvn.com',
    'a.applvn.com',
    'rtb.applovin.com',
    'd.applovin.com',
    'ads.applovin.com',
    'ms.applovin.com',
    'img.applovin.com',
    'pdn.applovin.com',

    // ── Mintegral / Mindworks ──
    'mintegral.com',
    'mbridge.com',
    'rayjump.com',
    'mktkts.com',
    'mrdatadog.com',

    // ── Pangle (TikTok Gaming Ads) ──
    'pangle.io',
    'pangleglobal.com',
    'pangolin-sdk-toutiao.com',
    'tobidad.com',
    'ad.toutiao.com',

    // ── Chartboost ──
    'chartboost.com',
    'live.chartboost.com',
    'a.chartboost.com',

    // ── Vungle / Liftoff ──
    'vungle.com',
    'ads.vungle.com',
    'cdn-lb.vungle.com',
    'liftoff.io',

    // ── InMobi & Bigo ──
    'inmobi.com',
    'w.inmobi.com',
    'c.inmobi.com',
    'inmobicdn.net',
    'bigossp.com',
    'ads.bigo.sg',

    // ── AdColony, Fyber, Tapjoy, StartApp ──
    'adcolony.com',
    'events.adcolony.com',
    'ads30.adcolony.com',
    'digitalturbine.com',
    'fyber.com',
    'tapjoy.com',
    'ltv.tapjoy.com',
    'startapp.com',
    'startapps.com',

    // ── Meta / Facebook Ads ──
    'an.facebook.com',
    'connect.facebook.net',
    'fbsbx.com',

    // ── General Ad Networks ──
    'media.net',
    'openx.net',
    'rubiconproject.com',
    'pubmatic.com',
    'criteo.com',
    'adsrvr.org',
    'moatads.com',
    'outbrain.com',
    'taboola.com',
    'smaato.net',
    'bidmachine.io',
  ];

  static Map<String, List<String>> domainsByCategory = {
    'Auto-Install & Trackers': [
      'appsflyer.com',
      'onelink.me',
      'adjust.com',
      'branch.io',
      'kochava.com',
      'singular.net',
    ],
    'Unity Ads': [
      'unityads.unity3d.com',
      'auction.unityads.unity3d.com',
      'applifier.com',
    ],
    'ironSource': [
      'ironsrc.com',
      'supersonic.com',
      'level-play-cdn.com',
    ],
    'AppLovin MAX': [
      'applovin.com',
      'applvn.com',
      'rtb.applovin.com',
    ],
    'Mintegral & Pangle': [
      'mintegral.com',
      'mbridge.com',
      'pangle.io',
      'pangleglobal.com',
    ],
    'Google Ads': [
      'admob.com',
      'googleadservices.com',
      'googlesyndication.com',
      'doubleclick.net',
    ],
    'Vungle & Chartboost': [
      'vungle.com',
      'liftoff.io',
      'chartboost.com',
    ],
    'InMobi & Lainnya': [
      'inmobi.com',
      'bigossp.com',
      'adcolony.com',
      'tapjoy.com',
    ],
  };
}
