# Chat App

A Flutter/GetX messaging-app foundation using Firebase Auth, Cloud Firestore, Firebase Storage, Hive, and Flutter WebRTC. The current implementation includes the app bootstrap, green/white theme, authentication screens, chat and group flows, status creation/viewing, and call UI/signaling scaffolding. It is not yet a production-complete WhatsApp replacement: Firebase project configuration, security rules, server-side FCM delivery, TURN configuration, secure call-token generation, and several requested settings/media workflows still need deployment-specific work.

## Setup

1. Install the current stable Flutter SDK and run `flutter pub get`.
2. Create a Firebase project and register Android package `com.example.chat_app` and the iOS bundle identifier used by your Xcode target.
3. For Android, add your Firebase `google-services.json` and configure the Google Services Gradle plugin following the official FlutterFire setup guide. For iOS, add `GoogleService-Info.plist` to the Runner target in Xcode. Enable Email/Password and Phone authentication, Firestore, Storage, and Cloud Messaging in Firebase Console.
4. Configure APNs for iOS push delivery. Do not put service-account credentials or call-provider secrets in the Flutter app.
5. Run `flutter run` on a configured device. Without native Firebase configuration, startup intentionally displays the setup error rather than showing a fake signed-in state.

## Current Firestore paths

- `users/{uid}`: account/profile, online state, and blocked-user IDs.
- `chats/{chatId}`: participant IDs and conversation summary; `chats/{chatId}/messages/{messageId}` stores messages.
- `groups/{groupId}`: group metadata and membership.
- `status/{uid}`: status items and viewer IDs; clients filter updates to a 24-hour window.
- `calls/{callId}`: call metadata and WebRTC offer/answer signaling; ICE candidates are in `callerCandidates` and `calleeCandidates` subcollections.

Deploy restrictive Firestore and Storage rules before using real accounts. In particular, authorize chat/message access by membership and call signaling by caller/receiver; do not rely on client-side checks. The current WebRTC service uses public STUN servers and Firestore signaling only, so production calling still requires authenticated signaling rules, TURN relay infrastructure, lifecycle cleanup, and a trusted backend for call tokens/notifications.

## Validation

Run `flutter analyze` and `flutter test`. The app has no Firebase project secrets or uploaded design-reference image in this repository; configure your own Firebase resources and provide the reference image to match it exactly.
