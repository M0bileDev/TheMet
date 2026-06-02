# TheMet

A small SwiftUI iOS app that searches the **Metropolitan Museum of Art** public collection and shows the results both in the app and in a **home-screen widget**. The app and the widget share data through an **App Group**.

> Learning project exploring SwiftUI navigation, `async/await` networking, WidgetKit, App Groups, and deep linking.

## Features

- **Search the Met collection** by keyword (image-only results).
- **Object list** with two paths depending on rights:
  - *Public domain* objects open an in-app detail screen with the artwork image.
  - *Non–public domain* objects open the Met website in an in-app Safari view.
- **Home-screen widget** (medium and large) that shows objects fetched by the app.
- **Deep linking**: tapping a widget entry opens the app straight to that object.
- Shared storage between app and widget via an **App Group**.

## How it works

The interesting part of this project is the app ↔ widget data flow:

1. The app fetches objects from the Met API and keeps them in an `ObservableObject` store (`TheMetStore`).
2. After a successful fetch, the store writes the objects to `objects.json` inside the **shared App Group container**, then calls `WidgetCenter.shared.reloadTimelines`.
3. The widget's `TimelineProvider` reads the same `objects.json` from the shared container and builds a timeline (one entry per object, one hour apart).
4. Each widget entry sets a `widgetURL` like `themet://<objectID>`. Tapping it launches the app, which handles the URL in `onOpenURL` and navigates to the matching object (in-app detail for public-domain items, Safari for the rest).

```
The Met API  ──fetch──▶  TheMetStore  ──write──▶  objects.json (App Group)
                              │                          │
                          UI (List)                  read │
                                                          ▼
                                                   Widget timeline
                                                          │
                                          tap (themet://id) │
                                                          ▼
                                              app onOpenURL → navigate
```

## Tech stack

- **Swift 5** / **SwiftUI**
- `async/await` + `URLSession` for networking
- `NavigationStack` with value-based `navigationDestination(for:)`
- **WidgetKit** (`StaticConfiguration`, `TimelineProvider`)
- **App Groups** for shared storage (`FileManager.containerURL(forSecurityApplicationGroupIdentifier:)`)
- `SFSafariViewController` wrapped via `UIViewControllerRepresentable`
- `AsyncImage` for remote image loading
- Custom URL scheme (`themet://`) for deep linking

## Project structure

```
TheMet/
├─ TheMet/                      # Main app target
│  ├─ TheMetApp.swift           # App entry point
│  ├─ Models/
│  │  ├─ Object.swift           # Met object model + ObjectIDs + sample data
│  │  └─ TheMetStore.swift      # ObservableObject store + App Group write
│  ├─ Service/
│  │  └─ TheMetService.swift    # Met API calls (search + object by id)
│  ├─ Views/
│  │  ├─ ContentView.swift      # Search, list, navigation, deep link handling
│  │  ├─ ObjectView.swift       # Public-domain object detail
│  │  ├─ SafariView.swift       # In-app web view for non-public objects
│  │  ├─ WebIndicatorView.swift
│  │  ├─ DetailIndicatorView.swift
│  │  └─ PlaceholderView.swift
│  ├─ Extensions/               # Color + URLComponents helpers
│  └─ TheMet.entitlements       # App Group entitlement
└─ TheMetWidget/                # Widget extension target
   ├─ TheMetWidget.swift        # Provider, timeline, widget view
   └─ TheMetWidgetBundle.swift
```

## The Met API

Uses the [Met Collection API](https://metmuseum.github.io/) (no API key required):

- `GET /public/collection/v1/search?hasImages=true&q=<query>` — returns matching object IDs.
- `GET /public/collection/v1/objects/<objectID>` — returns a single object.

The app fetches up to `maxIndex` objects per search (set to `5` in `ContentView`).

## Requirements

- Xcode that supports the **iOS 26.2** deployment target set in the project.
- An Apple Developer account / team for signing (needed because the app uses an App Group).

## Getting started

```bash
git clone https://github.com/M0bileDev/TheMet.git
cd TheMet
open TheMet.xcodeproj
```

Then, before running:

1. Select your **signing team** for both the `TheMet` and `TheMetWidgetExtension` targets.
2. The project ships with the placeholder App Group `group.org.example.TheMet.objects`. Either:
   - keep it as-is (it still works for local builds once you can register it under your team), **or**
   - replace it with your own App Group ID in **both** targets' entitlements and in `FileManager.getSharedContainerURL()` in `TheMetStore.swift`. The app and the widget must use the **same** App Group ID, or data sharing will fail.
3. Build and run on a device or simulator. Search for something, then add **The Met** widget to your home screen.

## Notes / known limitations

- Network and decoding errors are currently logged with `print` and the call returns `nil` rather than surfacing an error in the UI.
- Image display in the detail view depends on the object being public domain and having a valid `primaryImageSmall`.
- The number of fetched objects is capped (`maxIndex = 5`), so the widget timeline is short by design.

## Credits

- Based on the **"TheMet" project from Kodeco's [SwiftUI Apprentice](https://www.kodeco.com/books/swiftui-apprentice) book** (networking, search, and the Widgets / App Groups chapters). Built as a learning exercise following that material.
- Artwork data and images from the **Metropolitan Museum of Art Open Access** program via the Met Collection API.
- Built by [M0bileDev](https://github.com/M0bileDev).
