// FILE: prabit_design/lib/auth/auth_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Add Firestore instance
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign Up with Email & Password
  Future<User?> signUp(String email, String password, String username, /* Add other fields like DOB if needed */ BuildContext context) async { // Added username and context
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // --- Create user document in Firestore ---
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(), // Add creation timestamp
          // Add other fields like 'dateOfBirth' if you collect them
          // 'dateOfBirth': dateOfBirth?.toIso8601String(),
          'isEmailVerified': user.emailVerified, // Store initial verification state
        });
        // --- Optionally create username document for uniqueness checks ---
        // await _firestore.collection('usernames').doc(username).set({'uid': user.uid});

        // --- Send verification email ---
        // Consider adding UI feedback about verification email being sent
        await user.sendEmailVerification();
        // Optionally show a message:
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Verification email sent to $email')),
        // );
      }
      return user;
    } on FirebaseAuthException catch (e) { // Catch specific exception for better error handling
      print('Error during sign up: ${e.message}');
      // Show specific error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up failed: ${e.message ?? "Unknown error"}')),
      );
      return null;
    } catch (e) {
      print('Unexpected error during sign up: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up failed: An unexpected error occurred.')),
      );
      return null;
    }
  }

  // Login with Email & Password
  Future<User?> login(String email, String password, BuildContext context) async { // Added context
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) { // Catch specific exception
      print('Error during login: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.message ?? "Invalid credentials"}')),
      );
      return null;
    } catch (e) {
      print('Unexpected error during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: An unexpected error occurred.')),
      );
      return null;
    }
  }

  // Sign In with Google
  Future<User?> signInWithGoogle(BuildContext context) async {
    // Show loading indicator (optional, can be handled in the UI)
    // showDialog(...);

    try {
      await _googleSignIn.signOut(); // Ensure fresh login
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        // if (context.mounted) Navigator.pop(context); // Dismiss loading indicator if shown
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      // Check if it's a new user to create Firestore doc
      if (user != null && userCredential.additionalUserInfo?.isNewUser == true) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': user.displayName ?? user.email?.split('@')[0], // Use display name or part of email as default
          'email': user.email,
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'profilePictureUrl': user.photoURL, // Store Google profile picture
          'isEmailVerified': user.emailVerified,
        });
        // Optionally create username document too
        // await _firestore.collection('usernames').doc(user.displayName ?? user.email!.split('@')[0]).set({'uid': user.uid});
      }


      // if (context.mounted) Navigator.pop(context); // Dismiss loading indicator if shown

      return user;
    } catch (e) {
      print("❌ Google Sign-In Error: $e");
      // if (context.mounted) Navigator.pop(context); // Dismiss loading indicator if shown
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: ${e.toString()}')), // Show error
      );
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    await _googleSignIn.signOut(); // Sign out from Google first
    await _auth.signOut();      // Then sign out from Firebase
  }

  // Check Auth State
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Password Reset
  Future<void> sendPasswordResetEmail(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent to $email')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message ?? "Could not send email"}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred.')),
      );
    }
  }
}