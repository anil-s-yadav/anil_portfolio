import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> loginUser({
  required String mobile,
  required String password,
}) async {
  try {
    final doc =
        await FirebaseFirestore.instance.collection('login').doc('login').get();

    if (!doc.exists) {
      return false;
    }

    final data = doc.data()!;

    final storedMobile = data['mobile'];
    final storedPassword = data['password'];

    if (mobile == storedMobile && password == storedPassword) {
      return true; // ✅ Login success
    } else {
      return false; // ❌ Wrong credentials
    }
  } catch (e) {
    print("Login error: $e");
    return false;
  }
}
