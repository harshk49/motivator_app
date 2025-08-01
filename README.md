# Motivator App

A minimalist, dark-themed Flutter mobile app that delivers daily motivation through carefully curated inspirational quotes.

## 📱 Features

- **Instant Inspiration**: Get a random motivational quote every time you open the app
- **Dark Theme**: Modern, elegant dark theme designed for comfortable viewing
- **Tap to Refresh**: Simply tap anywhere on the screen to get a new quote
- **Smooth Animations**: Beautiful fade-in/fade-out transitions between quotes
- **Offline Ready**: All quotes are stored locally for instant access
- **Clean UI**: Minimalist design with no clutter or distractions

## 🏗️ Project Structure

```
lib/
├── main.dart                   # App entry point and theme configuration
├── models/
│   └── quote.dart             # Quote data model
├── services/
│   └── quote_service.dart     # Quote loading and management service
├── screens/
│   └── home_screen.dart       # Main app screen
└── widgets/
    └── quote_card.dart        # Styled quote display component

assets/
└── quotes.json                # Collection of motivational quotes
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.4.3 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:

```bash
git clone <your-repo-url>
cd motivator_app
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## 🎨 Design Philosophy

The app follows a **"less is more"** approach:

- Single screen, single purpose
- Dark theme for modern aesthetics
- Large, readable typography
- Subtle animations and transitions
- No unnecessary navigation or complexity

## 🔧 Technical Details

- **Framework**: Flutter 3.x with Material 3
- **State Management**: Simple `setState` for lightweight state handling
- **Asset Loading**: Uses `rootBundle.loadString` for JSON quotes
- **Animations**: `AnimatedOpacity` for smooth fade effects
- **Architecture**: Clean separation with models, services, and widgets

## 🎯 Target Platforms

- **Phase 1**: Android (Current)
- **Phase 2**: iOS (Planned)

## 📝 Quote Management

Quotes are stored in `assets/quotes.json` with the following structure:

```json
[
  {
    "text": "The only way to do great work is to love what you do.",
    "author": "Steve Jobs"
  }
]
```

## 🧪 Testing

Run tests with:

```bash
flutter test
```

## 🚀 Building for Release

For Android:

```bash
flutter build apk --release
```

---

_Built with ❤️ using Flutter_
