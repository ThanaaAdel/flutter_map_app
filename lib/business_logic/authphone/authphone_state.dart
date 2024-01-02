
abstract class AuthphoneState {}
class AuthphoneInitial extends AuthphoneState {}
class Loading extends AuthphoneState{}
class PhoneNumberSubmited extends AuthphoneState{
}
class ErrorOccurred extends AuthphoneState{
  final String errMessage;

  ErrorOccurred(this.errMessage);

}
class PhoneOtpVerified extends AuthphoneState{}


