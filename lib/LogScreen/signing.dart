// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_wallet/fire_auth/authenticator.dart';
import '../tasks/homePage.dart';

// ignore: camel_case_types
class signingIn extends StatefulWidget {

  const signingIn({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<signingIn> createState() => _signingInState();
}

// ignore: camel_case_types
class _signingInState extends State<signingIn> {

  bool checker = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  bool seePassword = true;
  bool error = false;
  String errorMsg = "";
  IconData passwordVisibility = Icons.visibility_off;
  int flag = 0;
  bool screenLoader = false;

  signUpUser() {
    if (formKey.currentState!.validate()) {
      setState(() {
        screenLoader = true;
      });
      signUp(emailController.text, passwordController.text, nameController.text)
          .then((value) => {
                if (value == null)
                  {
                    //Go to next Screen
                    setState(() {
                      error = false;
                      screenLoader = false;
                    }),
                    print("User Created Without Interruption."),
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>const requestSender(

                                ))),
                  }
                else
                  {
                    setState(() {
                      error = true;
                      screenLoader = false;
                      int i;
                      for (i = 1; i < value.toString().length; i++) {
                        if (value.toString()[i] == "]") {
                          break;
                        }
                      }
                      errorMsg = value.toString().substring(i + 2);
                    })
                  }
              });
    }
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  logInUser() {
    if (formKey.currentState!.validate()) {
      setState(() {
        screenLoader = true;
      });
      logIn(emailController.text, passwordController.text).then((value) {
        if (value == null) {
          setState(() {
            error = false;
            FirebaseFirestore.instance
                .collection("User Data")
                .doc(auth.currentUser!.uid)
                .update({
              "Password": passwordController.text,
              "Last SignedIn": DateTime.now().toString().substring(0, 16),
            });
            print("User Logged In ");
          });
          //next Screen
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const requestSender(
                       // userName: auth.currentUser!.displayName.toString(),
                      )));
        } else {
          setState(() {
            error = true;
            screenLoader = false;
            int i;
            for (i = 1; i < value.toString().length; i++) {
              if (value.toString()[i] == "]") {
                break;
              }
            }
            errorMsg = value.toString().substring(i + 2);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(22, 23, 48, 1),
        body: screenLoader
            ? Center(
                child: LottieBuilder.asset(
                  "assets/server.json",
                  repeat: false,
                  animate: true,
                ),
              )
            : Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 45.0,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          LottieBuilder.asset("assets/server.json"),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                checker ? "Welcome," : "Welcome Back!",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                              error
                                  ? Text(
                                      errorMsg,
                                      style: const TextStyle(
                                          color: Colors.tealAccent,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )
                                  :
                                  // Text(
                                  //   checker?"Please sign in here.":"Please login to your account.",
                                  //   style: const TextStyle(
                                  //       color: Color.fromRGBO(143, 142, 154, 1),
                                  //       fontSize: 20,
                                  //       fontWeight: FontWeight.bold),
                                  // ),
                                  const SizedBox(
                                      height: 20,
                                    ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromRGBO(51, 54, 67, 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: TextFormField(
                                    decoration: buildInputDecoration(
                                        "Email", Icons.email),
                                    cursorColor: Colors.white70,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: emailController,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (value!.contains(" ", 0)) {
                                        return "Enter an email without space";
                                      } else if (RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value)) {
                                        return null;
                                      } else {
                                        return "Enter valid Email";
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              checker
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            const Color.fromRGBO(51, 54, 67, 1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: TextFormField(
                                          validator: (value) {
                                            return value.toString().length <= 4
                                                ? "Minimum character required is 5"
                                                : null;
                                          },
                                          decoration: buildInputDecoration(
                                              "Username", Icons.account_box),
                                          cursorColor: Colors.white70,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: nameController,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              checker
                                  ? const SizedBox(
                                      height: 15,
                                    )
                                  : const SizedBox(),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromRGBO(51, 54, 67, 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      String val =
                                          value.toString().toLowerCase();
                                      int charCounter = 0;
                                      if (value!.isEmpty || value.length < 8) {
                                        return "character required is 8";
                                      } else {
                                        for (int i = 0; i < value.length; i++) {
                                          if (val.codeUnitAt(i) >= 97 &&
                                              val.codeUnitAt(i) <= 122) {
                                          } else {
                                            charCounter++;
                                          }
                                        }
                                        return charCounter != 0
                                            ? null
                                            : "Enter characters other than alphabets, ex: 1,/,-...";
                                      }
                                    },
                                    obscureText: seePassword,
                                    decoration: buildInputDecoration(
                                        "Password", passwordVisibility),
                                    cursorColor: Colors.white70,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: passwordController,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              checker
                                  ? const SizedBox(
                                      height: 25,
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              if(emailController.text == ""){
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                  content: Text('Enter a valid email'),
                                                  duration: Duration(milliseconds: 1500),
                                                ),);
                                              }else{

                                                auth.sendPasswordResetEmail(email: emailController.text);
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                  content: Text('A email attached with a password reset link has been send'),
                                                  duration: Duration(milliseconds: 1500),
                                                ),);
                                                emailController.text = "";
                                              }

                                            },
                                            child: const Text(
                                              "Forgot Password ?",
                                              style: TextStyle(
                                                color: Colors.white60,
                                                fontWeight: FontWeight.w700,
                                                //decoration: TextDecoration.underline,
                                              ),
                                            )),
                                      ],
                                    ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width / 7.5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromRGBO(141, 52, 242, 1),
                                        Color.fromRGBO(0, 125, 254, 1),
                                      ],
                                    )),
                                child: MaterialButton(
                                  onPressed: () {
                                    if (checker) {
                                      signUpUser();
                                    } else {
                                      logInUser();
                                    }
                                  },
                                  child: Text(
                                    checker ? "REGISTER NOW" : "LOGIN",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // Container(
                              //   width: MediaQuery.of(context).size.width / 1,
                              //   height: MediaQuery.of(context).size.width / 7.5,
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(20),
                              //       gradient: const LinearGradient(
                              //         colors: [
                              //           Color.fromRGBO(32, 34, 68, 1),
                              //           Color.fromRGBO(32, 34, 68, 1)
                              //         ],
                              //       )),
                              //   child: MaterialButton(
                              //       onPressed: () {
                              //         setState(() {
                              //           checker = !checker;
                              //         });
                              //       },
                              //       elevation: 5,
                              //       child: Center(
                              //           child: Text(
                              //         checker ? "Login" : "Register",
                              //         style: const TextStyle(
                              //             color: Colors.white70,
                              //             fontSize: 20,
                              //             fontWeight: FontWeight.w600),
                              //       ))),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ));
  }

  InputDecoration buildInputDecoration(String text, IconData iconData) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      hintText: text,
      labelText: text,
      hintStyle: fieldStyle(true),
      labelStyle: fieldStyle(false),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 3.5,
        ),
      ),
      suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              if (iconData == Icons.visibility_off) {
                seePassword = false;
                passwordVisibility = Icons.visibility;
              } else if (passwordVisibility == Icons.visibility) {
                seePassword = true;
                passwordVisibility = Icons.visibility_off;
              }
            });
          },
          child: Icon(
            iconData,
            color: Colors.white54,
            size: 25,
          )),
    );
  }

  TextStyle fieldStyle(bool bold) {
    Color t = Colors.white70;
    if (bold) {
      t = Colors.white24;
    }
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: t,
      fontSize: 14,
    );
  }
}
