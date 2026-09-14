<a name="top"></a>
![Moneye Repository Banner](https://github.com/ernestodecrecchio/Moneye-Money-Manager/blob/main/Readme_Support_Files/Images/Repository_Banner.png)
![Static Badge](https://img.shields.io/badge/DART_%3E%3D3.0.0_%3C4.0.0-1e2833?style=for-the-badge&logo=dart&logoColor=%236dcff9)
![Static Badge](https://img.shields.io/badge/FLUTTER_%3E%3D3.38.7-f7f7f7?style=for-the-badge&logo=flutter&logoColor=%236dcff9)
![Static Badge](https://img.shields.io/badge/Status-In_development-blue?style=for-the-badge)
![GitHub last commit](https://img.shields.io/github/last-commit/ernestodecrecchio/Moneye-Money-Manager?style=for-the-badge)
![Static Badge](https://img.shields.io/badge/License-AGPL--3.0-red?style=for-the-badge)

## Table of Contents
- [About the Project](#-about-the-project)
- [Screenshots & Video](#-screenshots--Video)
- [Features](#-features)
- [Technologies & Architecture](#-technologies--architecture)
- [How to Run](#-how-to-run)
- [Contributions](#-contributions)
- [License](#-license)

## 📖 About the Project
**Moneye** is a money management app for tracking income and expenses, setting budgets, and reviewing spending with charts. Data stays on device so you can manage your finances offline with privacy in mind.

<p align="center">Moneye is available on both Apple Store and Play Store</p>
<p align="center">
  <a href="https://apps.apple.com/us/app/moneye-money-manager/id6447369037">
    <img src="https://github.com/ernestodecrecchio/Moneye-Money-Manager/blob/main/Readme_Support_Files/Images/Store_Badges/Apple_App_Store_Badge.png" alt="Download Moneye the Apple App Store">
  </a>
  <a href="https://play.google.com/store/apps/details?id=com.ernestodecrecchio.moneye">
    <img src="https://github.com/ernestodecrecchio/Moneye-Money-Manager/blob/main/Readme_Support_Files/Images/Store_Badges/Google_Play_Store_Badge.png" alt="Download Moneye on the Google Play Store">
  </a>
</p>

## 📱 Screenshots & Video
<p align="center">
<img src="https://github.com/ernestodecrecchio/Moneye-Money-Manager/blob/main/Readme_Support_Files/Images/App_Preview/Screenshots/Frame%206.png" width="180">
<img src="https://github.com/ernestodecrecchio/Moneye-Money-Manager/blob/main/Readme_Support_Files/Images/App_Preview/Screenshots/Frame%207.png" width="180">
<img src="https://github.com/ernestodecrecchio/Moneye-Money-Manager/blob/main/Readme_Support_Files/Images/App_Preview/Screenshots/Frame%208.png" width="180">
<img src="https://github.com/ernestodecrecchio/Moneye-Money-Manager/blob/main/Readme_Support_Files/Images/App_Preview/Screenshots/Frame%209.png" width="180">
<img src="https://github.com/ernestodecrecchio/Moneye-Money-Manager/blob/main/Readme_Support_Files/Images/App_Preview/Screenshots/Frame%2010.png" width="180">
<img src="https://github.com/ernestodecrecchio/Moneye-Money-Manager/blob/main/Readme_Support_Files/Images/App_Preview/App_Video.gif" width="180">
</p>

## ✨ Features
### ✅ Current Features
- Create and customize accounts and categories with icons and colors; transfer transactions when deleting a category.
- Dashboard with balance, monthly overview, and recent transactions.
- Budgeting with a dedicated tab, progress on home, periods, multi-category budgets, and rollover.
- Recurring transactions generated automatically when the app starts.
- Backup and restore via local ZIP export and import.
- Graphs and statistics for spending habits.
- Light, dark, and system themes.
- Daily reminder notifications to log transactions.
- Financial data stored locally in SQLite; Firebase Analytics is optional and requires consent.
- Home Widgets on iOS for quick access from the home screen.
- Languages: Italian, English (US/UK), Español, Deutsch, Français, Türkçe, and Português (BR/PT).

### 🔮 Upcoming Features
- Home Widgets for Android.

## 🛠 Technologies & Architecture
Moneye is a Flutter app for iOS and Android. The codebase follows Clean Architecture with a feature-first layout; see [expense_tracker/lib/README.md](expense_tracker/lib/README.md) for details.

- **Framework**: Flutter
- **Language**: Dart >=3.0.0 <4.0.0
- **State Management**: Riverpod ^3.0.3
- **Local Database**: SQLite (sqflite)

#### Dependencies
```
intl: ^0.20.2
flutter_riverpod: ^3.0.3
sqflite: ^2.4.2
path: ^1.9.1
fl_chart: ^1.1.1
collection: ^1.19.1
salomon_bottom_bar: ^3.3.2
flutter_slidable: ^4.0.3
cupertino_icons: ^1.0.8
shared_preferences: ^2.5.3
flutter_local_notifications: ^20.0.0
flutter_timezone: ^5.0.1
in_app_review: ^2.0.11
app_settings: ^6.1.1
home_widget: ^0.8.1
timezone: ^0.10.1
vector_graphics: ^1.1.20
equatable: ^2.0.7
file_picker: ^10.3.10
path_provider: ^2.1.5
share_plus: ^12.0.1
firebase_core: ^3.11.0
firebase_analytics: ^11.3.6
firebase_crashlytics: ^4.3.10
package_info_plus: ^9.0.0
url_launcher: ^6.3.2
archive: ^4.0.2
uuid: ^4.5.3
```

## 🚀 How to run
To clone and run this application, you'll need git and flutter installed on your computer. From your command line:

#### Clone this repository
`$ git clone https://github.com/ernestodecrecchio/Moneye-Money-Manager.git`

#### Go into the repository
`$ cd Moneye-Money-Manager/expense_tracker`

#### Install dependencies
`$ flutter pub get`

#### Run the app
`$ flutter run`

## 🤝 Contributions
Contributions are welcome! Please read the [Contributing Guide](.github/CONTRIBUTING.md) to get started.  

## 📃 License
This project is licensed under the terms of the AGPL-3.0 license.

[Back to top](#top)
