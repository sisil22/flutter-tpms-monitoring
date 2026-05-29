# 🚗 TPMS Monitoring System - Flutter App

A mobile application for monitoring **car tire pressure and temperature** in real-time, developed as a Final Project for the D3 Telecommunications Engineering program at **PENS (Politeknik Elektronika Negeri Surabaya)**.

This project was showcased at the **Final Project Exhibition Competition** in June 2023.

---

## 📱 About The Project

This Android/iOS application serves as a monitoring dashboard for a **Tire Pressure Monitoring System (TPMS)**. It displays real-time tire pressure and temperature data from sensors installed on a car, helping drivers maintain safe tire conditions and prevent accidents caused by improper tire pressure.

---

## ✨ Features

- 📊 Real-time monitoring of tire **pressure** and **temperature**
- 🔔 Alert notification when pressure or temperature exceeds safe threshold
- 📱 Cross-platform support: **Android & iOS**
- 🔗 Wireless communication via **MQTT protocol**
- 🖥️ Clean and intuitive dashboard UI

---

## 🛠️ Built With

| Technology | Description |
|---|---|
| [Flutter](https://flutter.dev/) | Cross-platform mobile framework |
| [Dart](https://dart.dev/) | Programming language |
| [MQTT](https://mqtt.org/) | Lightweight messaging protocol for IoT |

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.x or above)
- Android Studio / VS Code
- A running MQTT broker (e.g., [Mosquitto](https://mosquitto.org/))

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/sisil22/flutter-tpms-monitoring.git
   ```

2. Navigate to the project directory
   ```bash
   cd flutter-tpms-monitoring
   ```

3. Install dependencies
   ```bash
   flutter pub get
   ```

4. Configure MQTT broker settings in the app (update broker IP/host in the source code)

5. Run the app
   ```bash
   flutter run
   ```

---

## 📁 Project Structure

```
flutter_application_1/
├── android/          # Android native code
├── ios/              # iOS native code
├── lib/              # Main Dart source code
├── images/           # Image assets
├── data/             # Data files
├── test/             # Unit tests
└── pubspec.yaml      # Project dependencies
```

---

## 👩‍💻 Author

**Sisilia** – D3 Telecommunications Engineering, PENS  
GitHub: [@sisil22](https://github.com/sisil22)

---

## 📄 License

This project is for academic purposes. All rights reserved © 2023.
