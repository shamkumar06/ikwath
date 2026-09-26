# iKwath — Smart Decoction Platform 🌱

[![Vercel Deployment](https://img.shields.io/badge/Vercel-Deployed-000000?style=for-the-badge&logo=vercel)](https://ikwath-nine.vercel.app/)

### 🚀 Live Demo: [https://ikwath-nine.vercel.app/](https://ikwath-nine.vercel.app/)

**iKwath** is a pod-based smart Kwatha (Kadha) maker that prepares a fresh, **AFI/API-standardized decoction** from coarse powder (Yavakūṭa Cūrṇa) on demand, in the shortest practical time without altering the decoction's quality or yield.

This repository contains the Flutter Web Dashboard for monitoring the ESP32 hardware telemetry, live extraction graphs, and full smart device control.

---

## 🏆 Smart India Hackathon (SIH) 2026

**Team Name:** Team SAMADHANA
**Ministry:** Ministry of Ayush, Government of India
**Theme:** MedTech / BioTech / HealthTech

### Key Features
- **12+ Native Indian Languages** (NLP-Ready Localization)
- **Real-Time ESP32 Telemetry** (Temperature, Load Cell Mass, Turbidity, Stirrer RPM)
- **AFI Standardized Automation** (Automated 1/4th mass reduction endpoint)
- **Dynamic Physical Cutaway View** (Live hardware state mirroring)

---

## 🛠️ Local Development

To run this dashboard locally:

```bash
cd ikwath_app
flutter pub get
flutter run -d web-server --web-port=8080
```
