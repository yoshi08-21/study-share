import firebase from "firebase/compat/app"
import "firebase/compat/auth"


const firebaseConfig = {
  apiKey: "AIzaSyAl2DmUqSRy9xVC9NQC1ibBMoZjl-HouJ4",
  authDomain: "spa-portfolio-app.firebaseapp.com",
  projectId: "spa-portfolio-app",
  storageBucket: "spa-portfolio-app.appspot.com",
  messagingSenderId: "845062907122",
  appId: "1:845062907122:web:6bdde013e7878a68ea9c6b",
  measurementId: "G-HPDNZEHEV0"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);

export default firebase
