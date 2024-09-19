import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Widget logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.contain,
    height: 100,
  );
}

TextField reuseableTextField(
    String text,
    IconData icon,
    bool isPasswordType,
    TextEditingController controller,
    bool isPasswordVisible,
    VoidCallback togglePasswordVisibility) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType && !isPasswordVisible,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
      suffixIcon: isPasswordType
          ? IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.white70,
              ),
              onPressed: togglePasswordVisibility,
            )
          : null,
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTop) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    // width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTop();
      },
      child: Text(
        isLogin ? 'LOG IN' : 'SIGN UP',
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>['email'],
  );

  await googleSignIn.signOut();

  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  if (googleUser == null) {
    return Future.error('Sign in aborted by user');
  }

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final OAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}
