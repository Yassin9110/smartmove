import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/auth/presentation/pages/login_page.dart';
import 'package:smart/core/app_theme.dart';
import 'package:smart/ui/controller_page.dart';

import '../../data/model/auth_model.dart';
import '../../data/model/user_model.dart';
import '../bloc/auth_bloc/authentication_bloc.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var email = TextEditingController();
  var name = TextEditingController();
  var password = TextEditingController();
  var age = TextEditingController();
  var emergencyName = TextEditingController();
  var emergencyNumber = TextEditingController();

  var GlobalKeyForm = GlobalKey<FormState>();
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UserErrorState) {
            showToast(state.error);
          }
          if (state is UserAuthorizedState) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => ControllerPage()));
          }
        },
  child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: GlobalKeyForm,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  _buildTextFormField(name, 'Name', Icons.person),
                  const SizedBox(height: 15.0),
                  TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.email,
                      ),
                    ),
                    validator: (text) {
                      if (text!.isEmpty) {
                        return 'field can not be null';
                      }
                      if (text.length < 6 ||
                          !text.contains('@') ||
                          !text.endsWith('.com') ||
                          text.startsWith('@')) {
                        return 'Wrong data ';
                      } else
                        return null;
                    },
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    controller: password,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: !flag,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            flag = !flag;
                          });
                        },
                        icon: Icon(
                          flag ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (text) {
                      if (text!.isEmpty) {
                        return 'field can not be null';
                      }
                      if (text.length < 8) {
                        return 'password must be strong';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 15.0),
                  _buildTextFormField(age, 'Age', Icons.calendar_today),
                  const SizedBox(height: 15.0),
                  _buildTextFormField(
                      emergencyName, 'Emergency Name', Icons.phone),
                  const SizedBox(height: 15.0),
                  _buildTextFormField(
                      emergencyNumber, 'Emergency Number', Icons.phone),
                  const SizedBox(height: 35.0),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        if (GlobalKeyForm.currentState!.validate()) {
                          String sanitizedEmail = email.text.trim();
                          String sanitizedName = name.text.trim();
                          String sanitizedPassword = password.text.trim();
                          String sanitizedAge = age.text.trim();
                          String sanitizedEmergencyName = emergencyName.text.trim();
                          String sanitizedEmergencyNumber = emergencyNumber.text.trim();
                  
                  
                          AuthModel authModel = AuthModel(
                            password: sanitizedPassword,
                            email: sanitizedEmail,
                          );
                          UserModel userModel = UserModel(
                            name: sanitizedName,
                            userId: '',
                            email: sanitizedEmail,
                            emergencyName: sanitizedEmergencyName,
                            emergencyNumber: sanitizedEmergencyNumber,
                            age: int.parse(sanitizedAge),
                          );
                  
                          // إرسال حدث التسجيل إلى الـ AuthBloc
                          context.read<AuthBloc>().add(SignUp(
                              authModel: authModel, userModel: userModel));
                        }
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account ? ',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const LoginPage())
                                );
                              },
                              child: Text('Login now ', style: TextStyle(fontSize: 18, color: primaryColor)),
                            )

                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
),
    );
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  TextFormField _buildTextFormField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: (text) {
        if (text!.isEmpty) {
          return '$label field cannot be empty';
        }
        return null;
      },
    );
  }
}
