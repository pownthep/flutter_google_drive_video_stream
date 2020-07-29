import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: ['https://www.googleapis.com/auth/drive.readonly'],
);

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  return googleSignInAuthentication.accessToken;
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  print("User Sign Out");
}
