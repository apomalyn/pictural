# Pictural
[![ui](https://img.shields.io/badge/UI-0.5.0-blue.svg)](https://shields.io/)

Pictural is an image repository to upload and share your pictures with your friends and loved ones.

This project was built to satisfy the shopify Challenge for Summer 2021.

You are here on the UI side of the project.

## Requirements

- Flutter: v1.25 or higher (beta channel)
- Pictural API: 1.2.0 or higher

## Run the project

After cloning the repo, you will have to get the packages and generate the l10n classes. To do that run the following command:
```
flutter pub get
flutter pub run intl_utils:generate
```

Then you will need to enable the web support using this command:
```
flutter config --enable-web
```

And finally run the project:
```
flutter run -d chrome
```
