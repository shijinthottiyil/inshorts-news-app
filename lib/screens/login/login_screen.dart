import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:let_me_grab/controller/firebase_controller.dart';
import 'package:let_me_grab/screens/login/widget/button_widget.dart';
import 'package:let_me_grab/screens/login/widget/textform_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController signupEmailController = TextEditingController();
    TextEditingController signupPasswordController = TextEditingController();
    TextEditingController signupConfirmController = TextEditingController();
    TextEditingController loginEmailController = TextEditingController();
    TextEditingController loginPasswordController = TextEditingController();
    return Consumer<FirebaseController>(
      builder: (context, value, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Inshorts",
            style: GoogleFonts.montserratAlternates(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _loginKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormWidget(
                  label: "Email",
                  controller: loginEmailController,
                  validateFn: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    } else if (!RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                        .hasMatch(value)) {
                      return 'Please enter correct email';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormWidget(
                  isObscure: true,
                  label: "Password",
                  controller: loginPasswordController,
                  validateFn: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password ';
                    } else if (value.length < 6) {
                      return 'Please enter 6 letter password';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                ButtonWidget(
                  buttonChild: value.isLogin
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                  buttonAction: () async {
                    if (_loginKey.currentState!.validate()) {
                      await value.loginFn(
                        loginEmail: loginEmailController.text.trim(),
                        loginPassword: loginPasswordController.text.trim(),
                        context: context,
                      );
                      loginPasswordController.clear();
                      loginEmailController.clear();
                    }
                  },
                ),
                const SizedBox(
                  height: 100,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'New here? ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: 'Signup',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _showBottomSheet(
                                context,
                                signupEmailController,
                                signupPasswordController,
                                signupConfirmController);
                          },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(
      BuildContext context,
      TextEditingController signupEmailController,
      TextEditingController signupPasswordController,
      TextEditingController signupConfirmController) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: double.infinity,
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Create an account",
                  style: GoogleFonts.montserratAlternates(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormWidget(
                  label: "Email",
                  controller: signupEmailController,
                  validateFn: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    } else if (!RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                        .hasMatch(value)) {
                      return 'Please enter correct email';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormWidget(
                  isObscure: true,
                  label: "Password",
                  controller: signupPasswordController,
                  validateFn: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password ';
                    } else if (value.length < 6) {
                      return 'Please enter 6 letter password';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormWidget(
                  isObscure: true,
                  label: "Confirm Password",
                  controller: signupConfirmController,
                  validateFn: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter confirm password';
                    } else if (value != signupPasswordController.text) {
                      return 'Password does not match';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                ButtonWidget(
                    buttonChild:
                        Provider.of<FirebaseController>(context).isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "SignUp",
                                style: TextStyle(color: Colors.white),
                              ),
                    buttonAction: () async {
                      if (_formKey.currentState!.validate()) {
                        await Provider.of<FirebaseController>(context,
                                listen: false)
                            .signUpFn(
                          signupEmail: signupEmailController.text.trim(),
                          signupPassword: signupPasswordController.text.trim(),
                        );
                        signupEmailController.clear();
                        signupPasswordController.clear();
                        signupConfirmController.clear();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          content: Container(
                            height: 50,
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x19000000),
                                  spreadRadius: 2.0,
                                  blurRadius: 8.0,
                                  offset: Offset(2, 4),
                                )
                              ],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "User Created Successfully",
                              style: GoogleFonts.montserratAlternates(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            // content: Text("User Created Successfully"),
                          ),
                        ));
                        // form is valid, do something with the input
                      }
                    })
              ],
            ),
          ),
        );
      },
    );
  }
}
