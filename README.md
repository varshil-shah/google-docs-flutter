# Google docs clone

The goal of this project was to learn how actual Google Docs works and to implement a simplified version of it. The project was implemented using Flutter and Node.js. The project supports almost all the features of Google Docs like real-time collaboration, text formatting, and many more. The important part of the project was to implement real-time collaboration, which was achieved using _WebSockets_.

## Features

- Real-time collaboration
- Text formatting
- Google authentication
- File management
- Real-time cursor position
- Auto-save

## Screenshots

![Screens snapshot](https://ik.imagekit.io/varshilshah/uploads/screens.png)

## How to run

_NOTE: As the backend is hosted on Free Server, it may take some time to load the app for the first time._

- Find the [Reelase apk](https://github.com/varshil-shah/google-docs-flutter/releases/tag/v1) in the release folder and install it on your device.
- Open the app and sign in with your Google account.
- Start creating documents and collaborate with your friends.

## How to run locally

- Clone the repository
  ```bash
  git clone https://github.com/varshil-shah/google-docs-flutter.git
  ```
- Inside server folder, create a `.env` file and add the following content
  ```env
  PORT=3000
  MONGO_URI=<Your MongoDB URI>
  JWT_SECRET=SomeSecret
  ```
- Create an account on Google Cloud Platform and create a new project.
- Create a Oauth 2.0 Client Id and store the json file in `/android/app/<google-services.json>`.
- For web, copy the meta tag provided and paste your client id in `/web/index.html`.
- Run the server using `yarn start` inside the server folder.

## Tech Stack

- Flutter
- Node.js
- Express
- MongoDB
- WebSockets

## Open Source Libraries

- [Quill](https://pub.dev/packages/flutter_quill) - A modern WYSIWYG editor built for compatibility and extensibility.
- [Socket.io](https://pub.dev/packages/socket_io_client) - Socket.IO client for Flutter.
- [Google Sign In](https://pub.dev/packages/google_sign_in) - Google Sign-In plugin for Flutter.

## Future Scope

- Download documents as PDF.
- Add support for images and tables.
- Implement CURD operations for documents.
