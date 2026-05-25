/// Daftar domain iklan yang diblokir secara default.
/// Mencakup ad network utama: AdMob, Meta, Unity Ads, AppLovin, dll.
class BlocklistConstants {
  BlocklistConstants._();

  static const List<String> defaultBlockedDomains = [
    // Google AdMob
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

    // Meta / Facebook Ads
    'an.facebook.com',
    'connect.facebook.net',
    'edge-mqtt.facebook.com',
    'fbsbx.com',
    'instagram.com',

    // Unity Ads
    'unityads.unity3d.com',
    'auction.unityads.unity3d.com',
    'publisher-event.unityads.unity3d.com',
    'config.unityads.unity3d.com',
    'userreporting.unity3d.com',

    // AppLovin
    'applovin.com',
    'rtb.applovin.com',
    'd.applovin.com',
    'ads.applovin.com',
    'ms.applovin.com',
    'img.applovin.com',

    // Chartboost
    'chartboost.com',
    'live.chartboost.com',
    'a.chartboost.com',

    // Vungle / Liftoff
    'vungle.com',
    'ads.vungle.com',
    'cdn-lb.vungle.com',

    // IronSource
    'ironsrc.com',
    'supersonic.com',
    'ads.supersonic.com',
    'outcome-ssp.supersonicads.com',

    // InMobi
    'inmobi.com',
    'w.inmobi.com',
    'c.inmobi.com',

    // Adcolony
    'adcolony.com',
    'events.adcolony.com',
    'ads30.adcolony.com',

    // Tapjoy
    'tapjoy.com',
    'ltv.tapjoy.com',

    // StartApp
    'startapp.com',
    'startapps.com',

    // Amazon Ads
    'aax.amazon-adsystem.com',
    'amazon-adsystem.com',
    'adsystem.amazon.com',

    // MoPub (Twitter)
    'mopub.com',
    'ads.mopub.com',

    // General Networks
    'media.net',
    'openx.net',
    'rubiconproject.com',
    'pubmatic.com',
    'criteo.com',
    'adsrvr.org',
    'moatads.com',
    'adsafeprotected.com',
    'scorecardresearch.com',
    'outbrain.com',
    'taboola.com',
  ];

  static const Map<String, List<String>> domainsByCategory = {
    'Google Ads': [
      'admob.com',
      'googleadservices.com',
      'googlesyndication.com',
      'doubleclick.net',
    ],
    'Meta Ads': [
      'an.facebook.com',
      'connect.facebook.net',
      'fbsbx.com',
    ],
    'Unity Ads': [
      'unityads.unity3d.com',
      'auction.unityads.unity3d.com',
    ],
    'AppLovin': [
      'applovin.com',
      'rtb.applovin.com',
    ],
    'Chartboost': [
      'chartboost.com',
      'live.chartboost.com',
    ],
    'Vungle': [
      'vungle.com',
      'ads.vungle.com',
    ],
    'IronSource': [
      'ironsrc.com',
      'supersonic.com',
    ],
    'General': [
      'media.net',
      'openx.net',
      'criteo.com',
    ],
  };
}
