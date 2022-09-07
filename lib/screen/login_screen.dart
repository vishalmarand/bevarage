import 'package:baverage_login_system/screen/home_screen.dart';
import 'package:baverage_login_system/screen/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class login_Screen extends StatefulWidget {
  const login_Screen({super.key});

  @override
  State<login_Screen> createState() => _login_ScreenState();
}

class _login_ScreenState extends State<login_Screen> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final _auth = FirebaseAuth.instance;

  String? errorMessage;

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Homescreen())),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailfield = TextFormField(
        autofocus: false,
        controller: emailcontroller,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("please Enter your Email");
          }
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        //validator: (){}
        onSaved: (value) {
          emailcontroller.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            prefixIcon: Icon(Icons.account_circle),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Enter Your User Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final passwordfield = TextFormField(
        autofocus: false,
        controller: passwordcontroller,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },

        //validator: (){}
        onSaved: (value) {
          passwordcontroller.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            suffixIcon: IconButton(
                onPressed: () => {},
                icon: Icon(
                  Icons.visibility_off,
                )),
            prefixIcon: Icon(Icons.vpn_key),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Enter Your Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color(hexColor('#6666ff')),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            //Navigator.pushReplacement(
            // context, MaterialPageRoute(builder: (context) => Homescreen()));
            signIn(emailcontroller.text, passwordcontroller.text);
          },
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/water_splash.png"),
          fit: BoxFit.cover,
        )),
        child: Center(
            child: SingleChildScrollView(
                child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //add google fonts and colour code
                  Padding(
                      padding: const EdgeInsets.all(80.0),
                      child: Text("Login",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.roboto(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Color(hexColor('#6666ff'))))),
                  emailfield,
                  SizedBox(
                    height: 25,
                  ),
                  passwordfield,
                  SizedBox(
                    height: 30,
                  ),
                  //add forgot button and gap
                  Text("Forgot Password"),
                  SizedBox(height: 10),
                  loginButton,
                  SizedBox(
                    height: 45,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have account?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationScreen()));
                        },
                        child: Text(
                          "SignUp",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w900,
                              fontSize: 15),
                        ),
                      )
                    ],
                  )
                ],
              )),
        ))),
      ),
    );
  }
}

int hexColor(String color) {
  //adding prefix
  String newColor = '0xff' + color;
  //removing # sign
  newColor = newColor.replaceAll('#', '');
  //converting it to the integer
  int finalColor = int.parse(newColor);
  return finalColor;
}
