## 0.0.1

Notice: version 0.0.1 is deprecated, consider using the latest version.

* Support for AES/CBC/NoPadding
* Support for argon2i, argon2d with pre-configured arguments

## 0.0.2

* Full support for AES(128bit, 256bit) in CBC/ECB mode, also support NoPadding or PKCS5Padding
* Full support for argon2i, argon2d, argon2id
* Now it's able to configure custom argon2 parameters
* Added a test report UI in example, for which you can validate the result in real devices

## 0.0.3

* Implicitly declare api return value type
* Using separate thread to run android native code, thus it might help to un-block the ui thread

## 0.0.2+1

* Added blocking size check when using AES with NoPadding scheme
* Removed annoying log in Android side

## 0.0.4

* No changes but just bump version to replace 0.0.3

## 0.0.4+2

* Fixed pubspec.yaml accroding to https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin
* Only support for flutter ^1.10.0

## 0.0.5

* **NEW** `*Isloated` APIs are now available for running in separated isolate, since argon2 and AES may take long time to finish, which will then block the UI. Old APIs are still available.
* Refactor examples

## 0.0.6

* Removed the `*Isloated` APIs introduced in 0.0.5, because the performance is not ideal.
* Using native thread(in Android) and DispatchQueue(in ios) to unblock main UI

## 1.0.0

* Upgrade to  dart 2.12.0 (null safety)

## 1.1.0

Migrated to support flutter 2.5+, according to [Supporting the new Android plugins APIs](https://flutter.dev/docs/development/packages-and-plugins/plugin-api-migration)

Users should also consider to migrate your application, see [Android v1 embedding app and plugin creation deprecation
](https://flutter.dev/docs/release/breaking-changes/android-v1-embedding-create-deprecation).

Also, fixed the following issues:

* [The plugin encryptions uses a deprecated version of the Android embedding](https://github.com/drriguz/encryptions/issues/7)
* [uses a deprecated version of the Android embedding](https://github.com/drriguz/encryptions/issues/6)

Please note that NDK 23+ seems not working, only tested in:

* Flutter 2.5.3 
* Dart 2.14.4
* NDK 22.1.7171670
* Android 11