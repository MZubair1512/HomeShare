import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/widgets.dart";
import "package:flutter_login/screens/home.dart";
import "package:flutter_login/screens/register.dart";
import "package:flutter_login/widgets/backgroundImage.dart";
import "package:flutter_login/widgets/google_sign.dart";
import "package:google_fonts/google_fonts.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
                          SizedBox(height: 50,),
                          SizedBox(
                            height: 160,
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                 Image.asset("assets/icon.png",height: 60,width: 60,),
                                 SizedBox(width: 10,),
                                Text("HomeShare",style: GoogleFonts.righteous(
                                fontSize: 30,color: Colors.white),),
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
                                    controller: emailController,
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
                                    controller: passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    style: const TextStyle(color: Colors.white,fontSize: 12),
                                    decoration: const  InputDecoration(
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
                                  width: 260,
                                  child: ElevatedButton(                                  
                                    child: Text('Login',style: GoogleFonts.righteous(
                                                          fontSize: 20,color: const Color.fromARGB(255, 0, 0, 0)),),
                                    onPressed: () async {
                                      if(emailController.text!="" && passwordController.text!=""){
                                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                                        await prefs.setString('email', emailController.text);
                                        await prefs.setString('password', passwordController.text);
                                          FirebaseAuth.instance.signInWithEmailAndPassword(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        ).then((value)=>{
                                          
                                          Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const Home()),
                                        )
                                        }).catchError((error){
                                          showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Login'),
                                              content: Text('${error.message}'),
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
                                        return Future.value(null);
                                        });
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
                                        Icon(Icons.account_circle,size: 22,color: Colors.orange[700],),
                                        SizedBox(width: 32,),
                                        Text('Login With Google',style: GoogleFonts.poppins(
                                                              fontSize: 13,color: const Color.fromARGB(255, 0, 0, 0)),),
                                      ],
                                    ),
                                    onPressed: () async{
                                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                                       
                                      signIn().signInWithGoogle().then((value){
                                        prefs.setString('email', value?.user!.email);
                                         if (value?.user!.email != null){
                                           
                                           Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const Home()),
                                        );
                                         }
                                      }).catchError((error){
                                          showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Login'),
                                              content: Text('${error}'),
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
                                        return Future.value(null);
                                        });
                                    },
                                  ),
                                ),
                                 SizedBox(height: 22),
                                 Container(
                                  width: 260,
                                  child: ElevatedButton(                                  
                                    child: Row(
                                      children: [
                                        Icon(Icons.person_3_outlined,size: 22,color: Colors.orange[700],),
                                        SizedBox(width: 32,),
                                        Text('Register Account',style: GoogleFonts.poppins(
                                                              fontSize: 13,color: const Color.fromARGB(255, 0, 0, 0)),),
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const Register()),
                                        );
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


