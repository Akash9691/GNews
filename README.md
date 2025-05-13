# gnews_article

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

GNews Flutter App Documentation


1. Overview

The GNews Flutter App is a lightweight and scalable news reader application built using Flutter. It integrates with the GNews API to fetch the latest news articles categorized by topics. It supports pagination, detailed views of articles, and a clean UI for both browsing and reading news.

since we are using the api key of Gnews we are using the free api which is giving 100 request per day

if your 100 calls in a day used then use another api key by signing into the GNews dashboard and put the api key in here file called:  appconstants.dart


2. Project Features

Fetches articles from the GNews API.

Supports a list of categories (e.g., Technology, Business, Sports, etc.).

Displays articles based on the selected category.

Implements pagination – loads 10 articles at a time as the user scrolls.

Has a List Screen to show all articles:

Displays article title and a short description.

Has a Detail Screen:

Displays full article details (title, description, content, publication date, source, etc.).



3. Project Requirements

To run this project, you must have the following installed:

Flutter version: 3.24.0

Dart version: 3.5.0

🛠️ Commands to Run the Project
Clean previous builds and cache:

flutter clean
Get all necessary dependencies:

flutter pub get
Run the project:

flutter run


4. State Management

Why I chose provider:
I chose the Provider package for state management because:

It’s simple, lightweight, and powerful.

It is officially recommended by the Flutter team.

It has a large community, great documentation, and frequent updates.

It integrates easily with Flutter’s widget rebuild system.

It supports app-wide state sharing like theme control, authentication, and more.



5. Development Challenges

Problem:
While integrating packages like url_launcher and connectivity_plus, I encountered JDK compatibility errors. The build system (Gradle) failed due to a mismatch between the installed JDK version and what the Flutter/Android tooling expected.

since it is taking lot more time to get the jdk version to download and install i am not able to setup it 
that is why i am not able to add url_launcher and connectivity plus

i have even searched for the alternative of these two packages but all of them using these packages it self soo i am not able to manage that.

solution: I already know the solution of it but because of the time i am not able to do it.

6. Download the App

You can download the app using the following Google Drive link:

https://drive.google.com/file/d/1KltaRQ9mrbEkvF-GsYThaF48-uPTXeKy/view?usp=sharing
