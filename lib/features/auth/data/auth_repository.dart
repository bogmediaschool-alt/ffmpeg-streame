import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/app_user.dart';

class AuthRepository {
  AuthRepository(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        final seedUser = AppUser.initial(user.uid, email: user.email);
        await _firestore.collection('users').doc(user.uid).set(seedUser.toJson());
        return seedUser;
      }
      return AppUser.fromJson(user.uid, doc.data()!);
    });
  }

  Future<AppUser> signIn({required String email, required String password}) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _loadOrCreateUser(credential.user);
  }

  Future<AppUser> register({required String email, required String password}) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _loadOrCreateUser(credential.user);
  }

  Future<AppUser> signInAnonymously() async {
    final credential = await _auth.signInAnonymously();
    return _loadOrCreateUser(credential.user);
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> updateProfile(AppUser user) async {
    await _firestore.collection('users').doc(user.id).set(user.toJson(), SetOptions(merge: true));
  }

  Future<AppUser> _loadOrCreateUser(User? firebaseUser) async {
    if (firebaseUser == null) {
      throw Exception('No firebase user');
    }
    final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    if (doc.exists) {
      return AppUser.fromJson(firebaseUser.uid, doc.data()!);
    }
    final seedUser = AppUser.initial(firebaseUser.uid, email: firebaseUser.email);
    await _firestore.collection('users').doc(firebaseUser.uid).set(seedUser.toJson());
    return seedUser;
  }
}
