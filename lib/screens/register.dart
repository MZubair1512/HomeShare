import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/widgets.dart";
import "package:flutter_login/screens/home.dart";
import "package:flutter_login/screens/personInfo.dart";
import "package:flutter_login/widgets/backgroundImage.dart";
import "package:google_fonts/google_fonts.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController registerEmail = TextEditingController();
  final TextEditingController registerPass = TextEditingController();
  final TextEditingController registerCP = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
              children: [
                const BackgroundImage(),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 160,
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                 Image.asset("assets/icon.png",height: 60,width: 60,),
                                 SizedBox(width: 10,),
                          Text("HomeShare",style: GoogleFonts.righteous(
                          fontSize: 30,color: Colors.white),                                                ),
                            ],
                          ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(color: Colors.grey[600]!.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10)),
                                  child: TextField(
                                    controller:registerEmail,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(color: Colors.white,fontSize: 12),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(16),
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      hintStyle: TextStyle(color: Colors.white, fontSize: 12,),
                                      prefixIcon: Icon(Icons.email,color: Colors.white,size: 22,),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Container(
                                  decoration: BoxDecoration(color: Colors.grey[600]!.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10)),
                                  child: TextField(
                                    obscureText: true,
                                    controller: registerPass,
                                    keyboardType: TextInputType.visiblePassword,
                                    style: const TextStyle(color: Colors.white,fontSize: 12),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(16),
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.white, fontSize: 12,),
                                      prefixIcon: Icon(Icons.key,color: Colors.white,size: 22,),
                                      
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  decoration: BoxDecoration(color: Colors.grey[600]!.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10)),
                                  child: TextField(
                                    obscureText: true,
                                    controller: registerCP,
                                    keyboardType: TextInputType.visiblePassword,
                                    style: TextStyle(color: Colors.white,fontSize: 12),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(16),
                                      border: InputBorder.none,
                                      hintText: "Confirrm Password",
                                      hintStyle: TextStyle(color: Colors.white, fontSize: 12,),
                                      prefixIcon: Icon(Icons.key,color: Colors.white,size: 22,),
                                      
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  width: 260,
                                  child: ElevatedButton(                                  
                                    child: Text('Next',style: GoogleFonts.righteous(
                                                          fontSize: 20,color: const Color.fromARGB(255, 0, 0, 0)),),
                                    onPressed: ()async {
                                      if(registerCP.text==registerPass.text){
                                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                                      await prefs.setString('email', registerEmail.text);
                                      await prefs.setString('password', registerPass.text);
                                      FirebaseAuth.instance.createUserWithEmailAndPassword(
                                      email: registerEmail.text, 
                                      password: registerPass.text,
                                    ).then((value)=>{
                                      
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const PersonalInfo()),
                                        )
                                    }).catchError((onError)=>{
                                       showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Register'),
                                              content: Text(onError.message),
                                              actions: [
                                                TextButton(
                                                  onPressed: () async {
                                                    
                                                    
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Close'),
                                                ),
                                              ],
                                            );
                                          },
                                        )
                                    });
                                      }else{
                                         showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Register'),
                                              content: Text('Kindly Re-Enter Password and Confirm Password'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Close'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                      
                                    },
                                  ),
                                ),
                                SizedBox(height: 22),
                                Container(width: 300,child: Divider(thickness: 2,color: Color.fromARGB(255, 242, 234, 161) ,)),
                                SizedBox(height: 22),
                                Container(
                                  width: 260,
                                  child: ElevatedButton(                                  
                                    child: Row(
                                      children: [
                                        Icon(Icons.login,size: 22,color: Colors.orange[700],),
                                        SizedBox(width: 32,),
                                        Text('Login With Google',style: GoogleFonts.poppins(
                                                              fontSize: 13,color: const Color.fromARGB(255, 0, 0, 0)),),
                                      ],
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                                SizedBox(height: 22),
                                Container(
                                  width: 260,
                                  child: ElevatedButton(                                  
                                    child: Row(
                                      children: [
                                        Icon(Icons.keyboard_arrow_left_sharp,size: 22,color: Colors.orange[700],),
                                        SizedBox(width: 36,),
                                        Text('Back to Login!',style: GoogleFonts.poppins(
                                                              fontSize: 13,color: const Color.fromARGB(255, 0, 0, 0)),),
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],) ,
                          ),
                      
                          
                        ],
                      ),
                    ),
                  ),
                  ),
              ],
    );
  }
}

