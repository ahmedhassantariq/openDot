importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyC3aPQIKJwpW3LGmtoFu2GRX8yNy2toXLk",
    authDomain: "opendot-0.firebaseapp.com",
    projectId: "opendot-0",
    storageBucket: "opendot-0.appspot.com",
    messagingSenderId: "409889097164",
    appId: "1:409889097164:android:21b992ac858d83826bc969",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
});