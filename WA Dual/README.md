# WA Dual

A lightweight macOS app that runs **WhatsApp Web** in its own session so you can stay signed into a **second WhatsApp account** while the official WhatsApp Mac app uses your primary one.

## How it works

- Loads [web.whatsapp.com](https://web.whatsapp.com) in a native `WKWebView`
- Uses a **dedicated persistent cookie store** (separate from Safari and the official app)
- Scan the QR code with your **second** phone’s WhatsApp → Linked devices

## Requirements

- macOS 14+
- Xcode 16+
- Your second phone nearby to scan the QR code once

## Open & run

```bash
open "WA Dual.xcodeproj"
```

In Xcode: select the **WA Dual** scheme → **My Mac** → Run (⌘R).

Or from the terminal:

```bash
xcodebuild -scheme "WA Dual" -configuration Debug -derivedDataPath build build
open "build/Build/Products/Debug/WA Dual.app"
```

## Usage

1. Keep the official **WhatsApp** Mac app logged into account #1.
2. Open **WA Dual** and scan the QR code with account #2 (phone → Settings → Linked devices).
3. Use **Sign Out** in the toolbar only if you want to clear *this* app’s session.

## Notes

- This is WhatsApp Web in an app shell — not a reverse-engineered client.
- Both phones must stay online occasionally (same rules as WhatsApp Web / linked devices).
- Calls and media need camera/mic permission when macOS prompts you.
