import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_app/business_logic/authphone/authphone_cubit.dart';
import 'package:flutter_map_app/business_logic/authphone/authphone_state.dart';
import 'package:flutter_map_app/constant/strings.dart';
import 'package:flutter_map_app/presentaion/widgets/button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../constant/colors.dart';
import '../widgets/circle_progress_indicator.dart';

class OtpScreen extends StatefulWidget {
   const OtpScreen({super.key, required this.phoneNumber});
   final  phoneNumber;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}
late String otpCode;
class _OtpScreenState extends State<OtpScreen> {
  Widget _buildPinCodeFields(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PinCodeTextField(
        keyboardType: TextInputType.number,
        appContext: context,
        length: 6,
        obscureText: false,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          activeColor: MyColors.blue,
          inactiveColor: MyColors.blue,
          inactiveFillColor: MyColors.lightGrey,
          selectedColor: MyColors.blue,
          selectedFillColor: Colors.white,
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 45,
          activeFillColor: Colors.white,
        ),

        animationDuration: const Duration(milliseconds: 300),
onCompleted: (code) {
  otpCode = code;
  print("completed");
},
        cursorColor: Colors.black,
        enableActiveFill: true,

      ),
    );
  }

  Widget _buildIntoText() {
    return Column(
      children: [
        const Text(
          'Verify Your Phone Number',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            text: TextSpan(
              text: 'Enter your 6 digit code number send to your number send to .',
              style: const TextStyle(color: Colors.black, fontSize: 18, height: 1.4),
              children: <TextSpan>[
                TextSpan(text: widget.phoneNumber,
                    style: const TextStyle(color: MyColors.blue,fontSize: 18))
              ],
            ),
          ),
        ),
      ],
    );
  }

Widget _buildPhoneVerificationBloc(){
    return BlocListener<AuthphoneCubit,AuthphoneState>

      (
      listenWhen: (previous, current) => previous!=current,
      listener: (context, state) {
        if (state is Loading) {
          showProgressIndicator;
        } else if (state is PhoneOtpVerified) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, homeMapScreen);
        } else if (state is ErrorOccurred) {
          String errorMessage = (state).errMessage;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 3),
          ));
        }
      },
    child: Container(),);
}

void _login(BuildContext context){
    BlocProvider.of<AuthphoneCubit>(context).submitOtb(otpCode);
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          _buildIntoText(),
          const SizedBox(height: 150,),
          _buildPinCodeFields(context),
          ButtonWidget(funButton: (){
            showProgressIndicator(context);
            _login(context);
          }),

          _buildPhoneVerificationBloc(),
        ]),
      ),
    ));
  }
}
