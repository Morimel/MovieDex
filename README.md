# 🎬 MovieDex

> Your pocket encyclopedia of movies 🍿, TV shows 📺 and the people 🧑‍🎤 who make them, powered by [The Movie Database (TMDB)](https://www.themoviedb.org/).

MovieDex is an iOS app written in **SwiftUI** 🧡. You can browse popular and top-rated titles, search the whole TMDB catalog, open a details page for anything, and ❤️ the things you love.

---

## ✨ Features

| | Feature | What it does |
|---|---|---|
| 🎞️ | **Feed** | An endless 2-column grid of *Popular* or *Top Rated* movies, TV shows or people |
| 🔍 | **Search** | Look up any movie, show or person by name, with infinite scrolling too |
| 📄 | **Details** | Backdrop, poster, tagline, genres, release date, runtime, status, episode count, biography and more |
| ❤️ | **Likes** | Tap the heart on any card or details page. Likes are saved on the device |
| ⭐ | **Rating badges** | Colour-coded score: 🔴 < 2.5 · 🟠 < 5 · 🟡 < 7 · 🟢 7+ |
| 🌗 | **Dark mode** | System colours throughout, so it looks good in light and dark |
| 💛 | **Favorites** | Tab is in place, screen is still a placeholder 🚧 |

---

## 🧱 Architecture: MVVM

The app follows **Model–View–ViewModel**:

```
 ┌────────────┐   user actions    ┌──────────────┐   builds URL + fetches   ┌────────────────┐
 │  🖼️ View    │ ───────────────▶ │ 🧠 ViewModel  │ ───────────────────────▶ │ 🌐 NetworkManager│
 │  (SwiftUI) │ ◀─────────────── │ ObservableObj │ ◀─────────────────────── │  + URLManager   │
 └────────────┘  @Published data  └──────────────┘   delegate / async return └────────────────┘
                                         │                                          │
                                         ▼                                          ▼
                                 💾 UserDefaults (likes)                    ☁️ api.themoviedb.org
```

- 🖼️ **Views** only describe the UI and forward taps to the view model.
- 🧠 **ViewModels** hold the state (`@Published` lists, liked IDs, current page, filters).
- 🌐 **NetworkManager** talks to TMDB and decodes JSON into the 📦 **Models**.

---

## 🗂️ Project Structure

```
MovieDex/
├── 🚀 App/
│   └── MovieDexApp.swift          # @main entry point → shows MainView
├── 📦 Models/
│   ├── MovieDatabaseModel.swift   # MDBItem protocol, enums, shared formatters
│   ├── MovieDataModel.swift       # 🎬 Movie
│   ├── TVShowDataModel.swift      # 📺 TVShow
│   └── PersonDataModel.swift      # 🧑 Person
├── 🌐 NetworkServide/
│   ├── URLManager.swift           # Builds every TMDB URL
│   └── NetworkManager.swift       # Downloads + decodes data
├── 📱 Screens/
│   ├── Main/        MainView.swift            # 🧭 TabView (Feed · Favorites · Search)
│   ├── Feed/        FeedView + FeedViewModel  # 🎞️ Popular / Top-rated grid
│   ├── Search/      SearchView + SearchViewModel # 🔍 Search grid
│   ├── Detailed/    DetailedView + Exts + ViewModel # 📄 Details page
│   ├── Favorites/   FavoritesView.swift       # 💛 Placeholder
│   └── Views/                                 # 🧩 Reusable components
│       ├── GridView.swift
│       ├── GridCell.swift
│       ├── SideInfoView.swift
│       └── NavBarCustomButtons.swift
├── Info.plist                     # Exposes API_KEY to the app
└── Secrets.xcconfig               # 🔑 Your TMDB key (git-ignored)
```

---

## 🔬 A Closer Look at the Code

### 🚀 `App/MovieDexApp.swift`
The `@main` entry point. It opens one `WindowGroup` that shows `MainView`.

### 📦 Models

#### 🧬 `MovieDatabaseModel.swift`: the shared base
- **`MDBItem` protocol**: the common shape of every item. Each one has an `id`, a `type`, a `dateString`, a `voteAverage` and a `mainImagePath`. Because `Movie`, `TVShow` and `Person` all conform to it, most views can be **generic** (`GridCell<Item: MDBItem>`, `DetailedView<Item: MDBItem>`) and work with all three types. 🪄
- **Enums** that also act as URL path pieces (through `URLPathItemType`):
  - `MDBItemType`: `.movie`, `.tvShow` (`"tv"`), `.person`
  - `MDBListType`: `.popular`, `.topRated` (`"top_rated"`)
  - `MDBImageSize`: `.original`, `.poster` (`w500`), `.backdrop` (`w1280`)
- **List wrappers** (`MovieListResults`, `TVShowListResuls`, `PersonListResults`) match TMDB's `{ "results": [...] }` responses.
- **Shared formatters**: 📅 `dateFormatter` (`yyyy-MM-dd`) and ⏱️ `timeFormatter` (turns minutes into `2h 15m`).

#### 🎬 `Movie` · 📺 `TVShow` · 🧑 `Person`
Plain `Decodable` structs with a few computed helpers:
- 🎬 `Movie.timeString` converts the runtime in minutes into readable text.
- 📺 `TVShow.runtime`, `numberOfEpisodesString` and `statusString` format the show info.
- 🧑 `Person.dates` returns *(birth, death?, age)*, working the age out up to today or to the date of death. `localizedGender` maps TMDB's 0–3 codes to text. `localizedName()` uses Apple's 🗣️ **NaturalLanguage** framework to choose a Russian or Bulgarian name from `alsoKnownAs` when one exists.

> 💡 The JSON decoder uses `.convertFromSnakeCase`, so `poster_path` maps to `posterPath` automatically.

### 🌐 Network layer

#### 🧭 `URLManager.swift`
Builds every URL with `URLComponents`:
- 🏠 Base: `https://api.themoviedb.org/3?api_key=…&language=en-US`
- 🖼️ Images: `https://image.tmdb.org/t/p/<size>/<path>`
- 🛠️ Helper methods: `listURL`, `searchURL`, `detailedURL` and `imageURL`
- 🔑 The API key is read from `Info.plist` (`API_KEY`), which is filled in from `Secrets.xcconfig`. If the key is missing, the app stops right away with a `fatalError` that tells you what to fix.

#### 📡 `NetworkManager.swift`
- `fetchList(itemType:url:)` uses ⚡ `async/await` with `URLSession`, decodes the matching list type, and returns the results on the main thread through the **delegate** (`NetworkManagerDelegate`).
- `fetchDetailedData(for:)` is **generic**: give it any `MDBItem` and it returns the full version of that same type. 🎁
- It also has small wrappers that build image, list and search URLs.

### 📱 Screens

#### 🧭 `MainView`
A `TabView` with three tabs: 🎞️ **Feed**, ❤️ **Favorites** and 🔍 **Search**.

#### 🎞️ Feed (`FeedView` + `FeedViewModel`)
- Two menus in the toolbar: **item type** (🎬/📺/🧑) on the left and **list type** (⭐ popular / 🔢 top rated) on the right.
- Changing either one calls `reloadList()` through `didSet`, which clears the data and loads page 1 again.
- ♾️ **Infinite scroll**: each cell calls `loadMoreContent` in `onAppear`. When the cell that is **3rd from the end** appears, the next page is loaded.
- 🔄 Likes are reloaded from `UserDefaults` each time the feed appears, so they stay in sync with the details screen.

#### 🔍 Search (`SearchView` + `SearchViewModel`)
- Uses SwiftUI's `.searchable` bar. The search runs when you press **Return** (`onSubmit(of: .search)`).
- An empty query shows *"What are we going to find today?"* 🤔
- It uses the same grid, cells and infinite scroll as the Feed.

#### 📄 Details (`DetailedView` + `DetailedViewModel`)
- Setting `currentItem` starts `fetchDetails()`, which loads the full record (runtime, genres, biography and so on).
- Layout: 🌄 a large **backdrop** with a gradient fade, the **title** on top of it, then the 🖼️ **poster** next to the **SideInfo** panel, then the **overview** or biography.
- Custom ⬅️ back button and ❤️ like button in the navigation bar.

#### 💛 Favorites
A placeholder for now: *"There will be Favorites"* 🚧

### 🧩 Reusable components (`Screens/Views/`)

| Component | Role |
|---|---|
| 🔲 `GridView` | A generic 2-column `LazyVGrid` for any `MDBItem` collection |
| 🃏 `GridCell` | A card with the poster, a ⭐ rating circle, a ❤️ like button and the title plus date (or department and gender for people). Tapping it opens `DetailedView` |
| 📋 `SideInfo` | The info column on the details page, with SF Symbol icons (📅 `calendar`, ⏱️ `timer`, 🗺️ `map`, …) |
| 🎛️ `NavBarCustomButtons` | Back and like buttons, item-type and list-type picker menus, and a custom `RightSideIconLabelStyle` with a `.titleMode()` helper |

### 💾 Persistence
Liked IDs are stored as three `Set<Int>` values (`likedMovies`, `likedTVShows`, `likedPersons`) and saved to **`UserDefaults`** each time you tap ❤️.

---

## 📦 Dependencies

Managed with **Swift Package Manager**:

- 🖼️ [**Nuke / NukeUI**](https://github.com/kean/Nuke) `13.2.0`: `LazyImage` loads and caches images quickly and asynchronously.

---

## 🛠️ Getting Started

1. 📥 **Clone** the repo
   ```bash
   git clone <repo-url> && cd MovieDex
   ```
2. 🔑 **Get a TMDB API key** at [themoviedb.org/settings/api](https://www.themoviedb.org/settings/api)
3. 📝 **Create** `MovieDex/Secrets.xcconfig`:
   ```
   API_KEY = your_tmdb_api_key_here
   ```
4. 🧰 Open `MovieDex.xcodeproj` in **Xcode**. SPM downloads Nuke automatically.
5. ▶️ Choose an iPhone or iPad simulator and press **⌘R**. 🎉

> ⚠️ `Secrets.xcconfig` is listed in `.gitignore`. **Never commit your API key!**

---

## 🧰 Tech Stack

`Swift` 🦅 · `SwiftUI` 🎨 · `async/await` ⚡ · `Combine` (`ObservableObject` / `@Published`) 🔁 · `URLSession` 🌐 · `Codable` 📦 · `NaturalLanguage` 🗣️ · `UserDefaults` 💾 · `Nuke` 🖼️

---

## 🗺️ Ideas for the Future

- [ ] 💛 Build the Favorites screen from the saved liked IDs
- [ ] 🧹 Move the like logic, now repeated in three view models, into one shared service
- [ ] 🛑 Stop paging at TMDB's real `total_pages`
- [ ] ⚠️ Show network errors in the UI, not just with `print`

---


<video src="https://github.com/user-attachments/assets/07bc1ba1-1578-4d20-a23a-5371813f25a8" width="100%"></video>


<p align="center">Made with ❤️ and lots of 🍿 · Data from <a href="https://www.themoviedb.org/">TMDB</a></p>
