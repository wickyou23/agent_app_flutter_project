# App Summary:
- Flutter: v3.3.4 or later.
- State management: BLoC (cubit).
- Dependency Injection: get_it.
- Manager flutter SDK using the FVM tool: https://fvm.app/docs/getting_started/overview.

# BASE APP

My Base Flutter project.

## Running:
- Production App: `flutter run`
- Dev App: `flutter run -t lib/main_dev.dart --debug --flavor=dev`
<br/><br/>

## iOS Build:
At the root flutter project:
```
cd ios
```
#### 1. DEV App:

- Running command:

Building the Adhoc app and uploading to Diawi:
```
fastlane app_dev_adhoc
```
Building the Appstore app and uploading to Testflight:
```
fastlane app_dev
```

#### 2. PROD App:
- Running command:
 
Building the Adhoc app and uploading to Diawi:
```
fastlane app_prod_adhoc
```
Building the Appstore app and uploading to Testflight:
```
fastlane app_prod
```

<br/>

## Android Build:
At the root flutter project:
```
cd android
```
#### 1. DEV App:

- Running command:

Building the APK file and upload to Diawi:
```
fastlane app_dev_apk
```
Building the AAB build and upload to PlayStore:
```
fastlane app_dev
```
#### 2. PROD App:

- Running command:

Building the APK file and upload to Diawi:
```
fastlane app_prod_apk
```
Building the AAB build and upload to PlayStore:
```
fastlane app_prod
```
