import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_app/business_logic/authphone/authphone_cubit.dart';
import 'package:flutter_map_app/business_logic/authphone/authphone_state.dart';
import 'package:flutter_map_app/presentaion/widgets/button.dart';
import 'package:flutter_map_app/presentaion/widgets/circle_progress_indicator.dart';
import '../../constant/colors.dart';
import '../../constant/strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  late String phoneNumber = '';

  Widget _buildIntoText() {
    return Column(
      children: [
        const Text(
          'What is Your Phone Number',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: const Text(
            'Please Enter Your Phone Number to verfiy Your account .',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                border: Border.all(color: MyColors.lightGrey),
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Text(
                '${generateCountryFlag()} +20',
                style: const TextStyle(fontSize: 18, letterSpacing: 2.0),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                border: Border.all(color: MyColors.lightGrey),
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: TextFormField(
                autofocus: true,
                decoration: const InputDecoration(border: InputBorder.none),
                cursorColor: Colors.black,
                keyboardType: TextInputType.number,
                onSaved: (newValue) {
                  phoneNumber = newValue!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Your phone number!';
                  } else if (value.length < 11) {
                    return 'Too short for a phone number';
                  }
                  return null;
                },
                style: const TextStyle(
                  fontSize: 18,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String generateCountryFlag() {
    String countryCode = 'eg';
    String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    return flag;
  }

  Widget _buildPhoneNumberSubmitedBloc() {
    return BlocListener<AuthphoneCubit,AuthphoneState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is Loading) {
          showProgressIndicator;
        } else if (state is PhoneNumberSubmited) {
          Navigator.pop(context);
          Navigator.pushNamed(context, otpScreen, arguments: phoneNumber);
        } else if (state is ErrorOccurred) {
          String errorMessage = (state).errMessage;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 3),
          ));
        }
      },
      child: Container(),
    );
  }
  Future<void> _register(BuildContext context)async{
    if(!_formKey.currentState!.validate()){
      Navigator.pop(context);
      return;
    }
    else{
      Navigator.pop(context);
      _formKey.currentState!.save();
      BlocProvider.of<AuthphoneCubit>(context).submitPhoneNumber(phoneNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              _buildIntoText(),
              const SizedBox(
                height: 110,
              ),
              _buildPhoneFormField(),
              const SizedBox(
                height: 200,
              ),
              ButtonWidget(funButton: (){
                 showProgressIndicator(context);
                _register(context);
              }),
              _buildPhoneNumberSubmitedBloc(),
            ],
          ),
        ),
      ),
    ));
  }
}


