# 🛡️ Blokir Ads

![Flutter Version](https://img.shields.io/badge/Flutter-%E2%89%A53.0.0-blue.svg)
![Android API](https://img.shields.io/badge/Android-API%2021%2B-brightgreen.svg)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-orange.svg)
![State Management](https://img.shields.io/badge/State_Management-BLoC%20%2F%20Cubit-purple.svg)

**Blokir Ads** is a premium, open-source Android application built with Flutter that blocks digital advertisements in other applications using a local, device-only VPN. It operates without requiring root access and allows users to selectively target which apps they want to block ads on.

---

## ✨ Key Features

- **🎯 Per-App Targeting**: Choose exactly which applications you want to block ads in. The VPN tunnel will only intercept traffic from your selected apps, leaving the rest of your device's network untouched.
- **🚫 Root-less Ad Blocking**: Utilizes Android's native `VpnService` to perform DNS-level interception. No device rooting is required.
- **⚡ Local Processing (Privacy First)**: All DNS interception and traffic routing happens locally on your device. No data is sent to an external VPN server. 
- **🌐 Comprehensive Blocklist**: Comes with a built-in, hardcoded blocklist targeting major mobile ad networks including Google AdMob, Meta (Facebook Ads), Unity Ads, AppLovin, Vungle, and many more.
- **🎨 Premium Dark UI**: Features a sleek, modern, glassmorphism-inspired dark theme (Deep Navy and Electric Cyan) for a premium user experience.

---

## 🛠️ How It Works (Technical Deep Dive)

Unlike traditional ad blockers that modify the hosts file (which requires root) or route all traffic through an external server (which raises privacy concerns), **Blokir Ads** uses a local VPN loopback mechanism.

1. **App Selection**: When a user selects a target app (e.g., a free game filled with ads), the Flutter UI passes the package name to the native Android layer via `MethodChannel`.
2. **VPN Configuration**: The native Kotlin code starts a `VpnService`. Crucially, it uses `builder.addAllowedApplication(packageName)`. This tells the Android OS to route *only* the traffic from the selected app into our custom VPN interface.
3. **DNS Interception**: The app runs a packet processing thread that listens for UDP traffic on port 53 (DNS requests).
4. **Packet Inspection**: 
   - When a DNS request is made (e.g., the target app tries to resolve `admob.com`), the service parses the UDP packet.
   - If the domain matches our internal blocklist, the app constructs a spoofed DNS response resolving the domain to `0.0.0.0` (null-route). The ad network fails to load.
   - If the domain is safe (e.g., the app's actual backend server), the service forwards the DNS query to a public resolver (`8.8.8.8`), receives the response, and forwards it back to the target app seamlessly.

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
- **Communication**: Flutter `MethodChannel` (`com.dwd.blokirads/vpn` and `com.dwd.blokirads/apps`)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (v3.0.0 or higher)
- Android Studio / Android SDK
- A physical Android device running API 21+ (Testing VPN features on an emulator may cause unexpected network behavior).

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/blokir_ads.git
   ```
2. Navigate to the project directory:
   ```bash
   cd blokir_ads
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

---
*Built with ❤️ using Flutter & Kotlin.*
