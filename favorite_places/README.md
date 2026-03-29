# Favorite Places App

A location-aware Flutter application that allows users to capture, store, and manage their favorite places. This project demonstrates the implementation of local data persistence and robust state management in a mobile environment.

## 🚀 Features

* **Add New Places:** Capture and save your favorite locations with ease.
* **Local Storage:** Uses a local relational database to ensure your data is available offline.
* **Reactive UI:** Seamlessly updates the user interface when data changes.
* **Location Integration:** Handles geographical data and images for a personalized experience.

## 🛠️ Tech Stack

* **Framework:** [Flutter](https://flutter.dev/)
* **State Management:** [Riverpod](https://riverpod.dev/) — utilized for managing application state and ensuring a predictable data flow.
* **Local Database:** [sqflite](https://pub.dev/packages/sqflite) — used for persistent storage of user-defined places.
* **Language:** Dart

## 📦 Getting Started

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/RashedKhanSezan/flutter_projects.git](https://github.com/RashedKhanSezan/flutter_projects.git)
   cd flutter_projects/favorite_places
   flutter pub get
   flutter run
2. ## 📂 Project Structure

* `lib/providers/`: Contains Riverpod providers for managing the application state.
* `lib/screens/`: UI screens for displaying the list of favorite places and adding new entries.
* `lib/widgets/`: Reusable UI components including location pickers and image inputs.
* `lib/models/`: Data models defining the structure of a "Place."
