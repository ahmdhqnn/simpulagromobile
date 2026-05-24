# 🌾 SimpulAgro Mobile

> IoT Agricultural Monitoring App - Monitor, Analyze, and Optimize Your Farm

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8.1-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📱 About

SimpulAgro Mobile adalah aplikasi monitoring pertanian berbasis IoT yang membantu petani dalam:
- 📊 Monitoring sensor pertanian real-time
- 🤖 Mendapatkan rekomendasi AI/ML untuk pupuk dan perawatan
- 🌱 Tracking pertumbuhan tanaman dengan GDD (Growing Degree Days)
- ✅ Manajemen tugas dan perawatan tanaman
- 📈 Analisis data agronomi (VDP, ETC, Environmental Health)

---

## ✨ Features

### ✅ Implemented (100% Complete)

- **Authentication** - Login dengan JWT, secure token storage
- **Dashboard** - Environmental health, sensor overview, quick actions
- **Device Management** - CRUD operations untuk IoT devices
- **Sensor Management** - CRUD operations untuk sensors
- **Real-time Monitoring** - 4 tabs (Realtime, History, Maps, Analytics)
- **Plant Management** - Track plant growth dengan HST & phases
- **Task Management** - Create, manage, and complete tasks
- **AI Recommendations** - NPK, pH, watering, pest control, harvest recommendations
- **Agro Indicators** - VDP, GDD, ETC calculations dengan visualizations
- **Charts & Analytics** - Interactive charts dengan FL Chart
- **Phase Tracking** - Detailed growth phase tracking
- **Profile & Settings** - User profile management (Read-only compliant)
- **Admin Features** - User, role, permission management (Admin utilities)

---

## 🚀 Quick Start

### Prerequisites

```bash
Flutter SDK: >=3.8.1
Dart SDK: >=3.8.1
Android Studio / VS Code
```

### Installation

```bash
# Clone repository
git clone <repository-url>
cd simpulagromobile

# Install dependencies
flutter pub get

# Generate Freezed code
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run
```

### Configuration

1. Update API base URL in `lib/core/config/api_config.dart`:
   ```dart
   static const String baseUrl = 'http://YOUR_SERVER_IP:3000/api';
   ```

2. (Optional) Configure environment variables

### Test Credentials

```
Username: admin
Password: admin123
```

---

## 🏗️ Architecture

### Clean Architecture + Riverpod

```
┌─────────────────────────────────────┐
│      Presentation Layer             │
│  (Screens, Widgets, Providers)      │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│        Domain Layer                 │
│  (Entities, Repository Interfaces)  │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│         Data Layer                  │
│  (Models, Repositories, Datasources)│
└─────────────────────────────────────┘
```

### Folder Structure

```
lib/
├── core/              # Core infrastructure
│   ├── config/        # API configuration
│   ├── constants/     # Constants & endpoints
│   ├── error/         # Error handling
│   ├── network/       # HTTP client (Dio)
│   ├── providers/     # Core providers
│   ├── router/        # Navigation (GoRouter)
│   ├── storage/       # Secure storage
│   ├── theme/         # App theme
│   └── utils/         # Utilities
│
├── features/          # Feature modules
│   ├── auth/          # Authentication
│   ├── dashboard/     # Dashboard
│   ├── site/          # Site management
│   ├── device/        # Device management
│   ├── sensor/        # Sensor management
│   ├── monitoring/    # Real-time monitoring
│   ├── plant/         # Plant management
│   ├── task/          # Task management
│   ├── recommendation/# AI Recommendations
│   ├── agro/          # Agro indicators
│   ├── phase/         # Growth phases
│   └── profile/       # User profile
│
├── shared/            # Shared components
│   └── widgets/       # Reusable widgets
│
├── app.dart          # App widget
└── main.dart         # Entry point
```

---

## 🛠️ Tech Stack

### Core
- **Flutter**: 3.8.1
- **Dart**: 3.8.1

### State Management
- **Riverpod**: 2.6.1

### Navigation
- **GoRouter**: 14.8.1

### Networking
- **Dio**: 5.7.0

### Storage
- **Flutter Secure Storage**: 9.2.4

### UI Components
- **FL Chart**: 0.70.2 (Charts)
- **Google Fonts**: 6.2.1
- **Shimmer**: 3.0.0 (Loading effect)
- **Percent Indicator**: 4.2.5

### Code Generation
- **Freezed**: 2.5.8 (Immutable models)
- **JSON Serializable**: 6.9.5

### Utilities
- **Dartz**: 0.10.1 (Functional programming)
- **Intl**: 0.20.2 (Internationalization)

---

## 📚 Documentation

### Essential Documentation
- **[PROJECT_ANALYSIS.md](PROJECT_ANALYSIS.md)** - Complete project analysis & metrics
- **[MASTER_DOCUMENTATION.md](MASTER_DOCUMENTATION.md)** - Development guide & architecture
- **[UI_UX_GUIDE.md](UI_UX_GUIDE.md)** - UI/UX design system & guidelines
- **[api_documentation.md](api_documentation.md)** - Backend API reference

### Quick Links
- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Features](#features)
- [Development Guide](MASTER_DOCUMENTATION.md#development-guide)
- [API Integration](MASTER_DOCUMENTATION.md#api-integration)

---

## 🧪 Testing

### Run Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/widget_test.dart
```

**Current Status**: 141 automated tests implemented & verified (100% pass rate)

---

## 🚀 Build & Deploy

### Debug Build

```bash
flutter build apk --debug
```

### Release Build

```bash
# APK
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release
```

### Code Quality

```bash
# Analyze code
flutter analyze

# Format code
flutter format lib/

# Clean build
flutter clean && flutter pub get
```

---

## 📊 Project Status

### Completion: 100%

| Feature | Status | Files |
|---------|--------|-------|
| Core Infrastructure | ✅ 100% | 20 |
| Authentication | ✅ 100% | 15 |
| Dashboard | ✅ 100% | 12 |
| Site Management | ✅ 100% | 8 |
| Device Management | ✅ 100% | 10 |
| Sensor Management | ✅ 100% | 10 |
| Monitoring | ✅ 100% | 15 |
| Plant Management | ✅ 100% | 8 |
| Task Management | ✅ 100% | 10 |
| Recommendation | ✅ 100% | 8 |
| Agro Indicators | ✅ 100% | 10 |
| Phase Tracking | ✅ 100% | 8 |
| Profile/Settings | ✅ 100% | 3 |

**Total**: 373+ Dart files, 0 compilation errors, 141 passing tests.

---

## 🤝 Contributing

### Development Workflow

1. Create feature branch
2. Follow Clean Architecture pattern
3. Use Freezed for models
4. Add mock data for testing
5. Run build_runner
6. Test thoroughly
7. Create pull request

### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `flutter format` before commit
- Run `flutter analyze` to check for issues
- Add comments for complex logic

---

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👥 Team

**Development Team**  
**Last Updated**: 2 April 2026

---

## 📞 Support

For issues and questions:
- Create an issue on GitHub
- Contact development team
- Check documentation files

---

**Made with ❤️ using Flutter**

