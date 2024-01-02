import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'authphone_state.dart';

class AuthphoneCubit extends Cubit<AuthphoneState> {
  AuthphoneCubit() : super(AuthphoneInitial());

  late String verificationId = '';
  // when user inter the phone number
  Future<void> submitPhoneNumber(String phoneNumber) async {
    // first step the app loading .
    emit(Loading());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber', // pass the phone number.
      timeout: const Duration(seconds: 14), //process between the firebase and the sms
      verificationCompleted: verificationCompleted, // read the code automatic
      verificationFailed: verificationFailed,//error ely hayasal lw fe problem
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    print('verificationCompleted');
    await signIn(credential);
  }

  void verificationFailed(FirebaseAuthException e) {
    emit(ErrorOccurred(e.toString()));
    print("verificationFailed${e.toString()}");
  }

  void codeSent(String verificationId, int? resendToken) {
    this.verificationId = verificationId;
    //right phone number
    emit(PhoneNumberSubmited());
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    this.verificationId = verificationId;
    print(verificationId);
    print("Timout");
    print('codeAutoRetrievalTimeout');
  }

  Future<void> submitOtb(String otbCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: this.verificationId, smsCode: otbCode);
    await signIn(credential);
  }

  Future<void> signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneOtpVerified()); // code otp right.
    } on Exception catch (e) {
      emit(ErrorOccurred(e.toString()));
    }
  }
  Future<void> logOut()async{
    await FirebaseAuth.instance.signOut();

  }
  User getLoggedInUser(){
    User firebaseUser = FirebaseAuth.instance.currentUser!;
    return firebaseUser;
  }
}
