# Dual WhatsApp for macOS

Run a **second WhatsApp account** on your Mac alongside the official WhatsApp desktop app.

The official WhatsApp Mac app only allows one logged-in account. **Dual WhatsApp for macOS** is a small native app that opens [WhatsApp Web](https://web.whatsapp.com) in its own window and **persistent session**, so you can stay signed into account #2 while the official app keeps account #1.

---

## Features

- Second WhatsApp session on Mac (separate from the official app and Safari)
- Persistent login — scan the QR code once; it stays signed in across restarts
- Native macOS window with Reload and Sign Out in the toolbar
- Camera / microphone support for WhatsApp Web features that need them
- No unofficial WhatsApp protocol reverse-engineering — it’s WhatsApp Web in an app shell

---

## Requirements

| Item | Detail |
|------|--------|
| Mac | macOS **14** (Sonoma) or later |
| Tools | [Xcode](https://apps.apple.com/app/xcode/id497799835) 16+ (free from the Mac App Store) |
| Phone | Your **second** WhatsApp number’s phone, nearby, to scan the QR code once |
| Network | Internet connection |

---

## Install & run (from source)

### 1. Clone the repo

```bash
git clone https://github.com/secret-wizard-007/dual-whatsapp-for-macos.git
cd dual-whatsapp-for-macos
```

### 2. Open in Xcode

```bash
open "WA Dual/WA Dual.xcodeproj"
```

### 3. Build and run

1. In the toolbar, select scheme **WA Dual** and destination **My Mac**.
2. Press **Run** (⌘R).
3. When macOS asks about network / camera / microphone, allow what you need.

### Optional: install into Applications

After a successful Release build:

1. In Xcode: **Product → Archive** (or build Release from the command line below).
2. Copy `WA Dual.app` into `/Applications`.

Command-line Release build:

```bash
cd "WA Dual"
xcodebuild -scheme "WA Dual" -configuration Release -derivedDataPath build \
  CODE_SIGN_IDENTITY="-" CODE_SIGNING_ALLOWED=YES build
cp -R "build/Build/Products/Release/WA Dual.app" /Applications/
open "/Applications/WA Dual.app"
```

> **Gatekeeper note:** This project is typically signed for local use (“Sign to Run Locally”). On another Mac, if macOS blocks the app: right-click → **Open** → **Open**, or allow it under **System Settings → Privacy & Security**.

---

## How to use (two accounts)

1. Keep the official **WhatsApp** Mac app signed into your **primary** account.
2. Open **WA Dual** (Dual WhatsApp for macOS).
3. On your **second** phone:
   - Open WhatsApp → **Settings** → **Linked devices** → **Link a device**
   - Scan the QR code shown in WA Dual
4. Chat on account #2 in WA Dual; use the official app for account #1.

### Toolbar

| Action | What it does |
|--------|----------------|
| **Reload** | Reloads WhatsApp Web |
| **Sign Out** | Clears **only this app’s** session (official WhatsApp is unaffected). You’ll need to scan QR again. |

---

## What works / what doesn’t

| Works | Limitation |
|-------|------------|
| Chats, media, voice notes, status (WhatsApp Web features) | **Voice/video calls** are not available in WhatsApp Web the same way as in the official Mac app. You’ll see WhatsApp’s “Get the app” prompt for calls. |
| Persistent linked-device session | Same rules as WhatsApp Web: keep the phone linked; WhatsApp may ask you to refresh the link occasionally. |
| Separate cookies from Safari / official app | This is not a reverse-engineered multi-account client. |

For calls on a second number, use that number’s phone, or WhatsApp Business on Mac if that number is a Business account.

---

## Project layout

```
dual-whatsapp-for-macos/
├── README.md                 ← you are here
├── .gitignore
└── WA Dual/
    ├── WA Dual.xcodeproj     ← open this in Xcode
    ├── README.md
    └── WA Dual/              ← SwiftUI + WKWebView sources
        ├── WA_DualApp.swift
        ├── ContentView.swift
        ├── WhatsAppWebView.swift
        ├── Info.plist
        ├── WA_Dual.entitlements
        └── Assets.xcassets
```

---

## Privacy & security

- Your chat data stays between you and WhatsApp (same as using web.whatsapp.com).
- Session data is stored by WebKit in this app’s own data store on your Mac.
- This project does not send your messages to a third-party server.
- Always download/clone from this GitHub repository you trust.

---

## Disclaimer

This is an unofficial helper app. It is **not** affiliated with, endorsed by, or supported by WhatsApp or Meta. Use WhatsApp in line with their Terms of Service. Linked-device and feature availability can change when WhatsApp updates Web or desktop clients.

---

## Contributing

Issues and pull requests are welcome — especially for build docs, packaging (DMG), notifications, or multi-window sessions.

---

## License

No license file is attached yet. If you fork or redistribute, please keep attribution to this repo and the disclaimer above until a formal license is added.
