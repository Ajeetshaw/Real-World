import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:real_world/Loader/color_loader_2.dart';
import 'package:real_world/Models/user_data.dart';
import 'package:real_world/Screens/LoginScreen.dart';
import 'package:real_world/passwordAnimation/validation_item.dart';
import 'package:real_world/services/auth_services.dart';
import 'dart:math' as math;

String _email,_password,_name;

class SignUp extends StatefulWidget {
  static String id ='SignupScreen';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin{
 
final  _formkey= GlobalKey<FormState> ();
Color appColor =Color(0xff68FE9A);
Color bgColor =Color(0xFF24272C);
String error;
bool loading=false;
static final _auth = FirebaseAuth.instance;
static final _firestore = Firestore.instance;
TextEditingController textController = TextEditingController();

 AnimationController _controller;
  Animation<double> _fabScale;

  bool eightChars = false;
  bool number = false;

  @override
  void initState() {
    super.initState();

    textController.addListener(() {
      setState(() {
        eightChars = textController.text.length >= 8;
        number = textController.text.contains(RegExp(r'\d'), 0);
        
      });

      if (_allValid()) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });

    _controller = AnimationController(vsync: this,
      duration: const Duration(milliseconds: 500));

    _fabScale = Tween<double>(begin: 0, end: 1)
    .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

    _fabScale.addListener((){
      setState(() {

      });
    });
  }


_submit(){
  if(_formkey.currentState.validate()){
    _formkey.currentState.save();
   AuthService.signUpUser(context,_name,_email,_password);
  }
}
Widget showAlert() {
  if(error != null){
    return Container(
      color: Colors.amberAccent,
      width: double.infinity,
      padding: EdgeInsets.all(2.0),
      child: Row(
          children: <Widget>[
            Icon(Icons.error_outline,color:Colors.white,size:22),
            Expanded(child: Text(error)),
            IconButton(icon:Icon( Icons.close), onPressed:(){
              setState(() {
                error=null;
                loading=false;
              });
            })
          ],
      ),

    );
  }
  return SizedBox(height:0);
}


  @override
  Widget build(BuildContext context) {
    return loading ? ColorLoader2() :  Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context,LoginPage.id);
                      },
                      child: Text(
                        'Log In',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white54),
                      ),
                    )
                  ],
                ),
                showAlert(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.acme(
                    textStyle:TextStyle(
                      fontWeight: FontWeight.bold,
                       fontSize: 22,
                      color:appColor,
                    )
                )
                  ),
                ),
                SizedBox(
                height: 10.0,
              ),
              Center(child:Text("Real World",style: GoogleFonts.righteous(
                    textStyle:TextStyle(
                      fontWeight: FontWeight.bold,
                       fontSize: 24,
                      color: Colors.white,
                    )))),

            
              Padding(
                padding: const EdgeInsets.all(20.0), child: _validationStack()),

            Form(
                   key: _formkey,
               child:Column(children: <Widget>[
                 TextFormField(
                   cursorColor: appColor,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color:appColor,fontWeight: FontWeight.w300),
                  decoration: InputDecoration(
                     enabledBorder:OutlineInputBorder(
                          borderSide:BorderSide(color: Colors.white,)
                        ) ,
                        focusedBorder: OutlineInputBorder(
                          borderSide:BorderSide(color:appColor)),
                          focusColor: appColor,
                          
                      hoverColor: appColor,fillColor: appColor,
                      labelText: 'Username',labelStyle: TextStyle(color:Colors.white,fontSize:18,),
                      
                    ),
                      validator:(input)=> input.trim().isEmpty ? "Please provide an username":null,
                      onSaved: (input)=> _name=input,
                      ),
                       SizedBox(
                height: 30.0,
              ),

                 TextFormField(
                   cursorColor: appColor,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color:appColor,fontWeight: FontWeight.w300),
                  decoration: InputDecoration(
                     enabledBorder:OutlineInputBorder(
                          borderSide:BorderSide(color: Colors.white,)
                        ) ,
                        focusedBorder: OutlineInputBorder(
                          borderSide:BorderSide(color:appColor)),
                          focusColor: appColor,
                          
                      hoverColor: appColor,fillColor: appColor,
                      labelText: 'Your Email',labelStyle: TextStyle(color:Colors.white,fontSize:18,),
                      
                    ),
                      validator:(input)=> input.length==0 ? "Please enter an email":null,
                      onSaved: (input)=> _email=input,
                      ),
              SizedBox(
                height: 30.0,
              ),
              TextFormField(
                controller: textController,
                cursorColor: appColor,
                  obscureText: true,
                  style: TextStyle(color:appColor,fontWeight: FontWeight.w300),
                  decoration: InputDecoration(
                     enabledBorder:OutlineInputBorder(
                          borderSide:BorderSide(color: Colors.white,)
                        ) ,
                        focusedBorder: OutlineInputBorder(
                          borderSide:BorderSide(color:appColor)),
                          focusColor: appColor,
                          
                      hoverColor: appColor,fillColor: appColor,
                      labelText: 'Password',labelStyle: TextStyle(color:Colors.white,fontSize:18,),
                      
                    ),
                      validator:(input)=> input.length==0 || input.length <6 ? "Please provide a valid password"  :null,
                      onSaved: (input)=> _password=input,
                      ),
                      SizedBox(
                height: 30.0,
              ),
              TextFormField(
                cursorColor: appColor,
                  obscureText: true,
                  style: TextStyle(color:appColor,fontWeight: FontWeight.w300),
                  decoration: InputDecoration(
                     enabledBorder:OutlineInputBorder(
                          borderSide:BorderSide(color: Colors.white,)
                        ) ,
                        focusedBorder: OutlineInputBorder(
                          borderSide:BorderSide(color:appColor)),
                          focusColor: appColor,
                          
                      hoverColor: appColor,fillColor: appColor,
                      labelText: 'Conform Password',labelStyle: TextStyle(color:Colors.white,fontSize:18,),
                      
                    ),
                      validator:(input)=> input.length==0 || input.length <6  ? "Please provide a valid password"  :null,
                     
                      ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: RawMaterialButton(
                  onPressed: () async {
                   
                    _submit();
                    if(_formkey.currentState.validate()){
                      setState(() => loading=true);
                      _formkey.currentState.save();

                      try {
                        AuthResult authResult = await _auth.createUserWithEmailAndPassword(
                          email: _email,
                          password: _password,
                        );
                        if(authResult == null){
                          setState(() {
                           loading =false;
                           
                          });
                        
                        }
                        FirebaseUser signedInUser = authResult.user;
                        if (signedInUser != null) {
                          _firestore.collection('/users').document(signedInUser.uid).setData({
                            'name': _name,
                            'email': _email,
                            'profileImageUrl':'',
                          });
                          Provider.of<UserData>(context).currentUserId = signedInUser.uid;
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        print(e);
                        setState(() {
                            error=e.message;
                             loading =false;
                          });
                      }



                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 11.0,horizontal: 45.0),
                     
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.acme(
                    textStyle:TextStyle(
                      fontWeight: FontWeight.bold,
                       fontSize: 14,
                      color: bgColor,
                    ),)
                    ),
                  
                  ),
                  elevation: 10.0,
                  fillColor: appColor,
                  shape: StadiumBorder(),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),

               ],)
             
              ),



              ]
            ),
          ),
        ),
      
    );
  }
  
Widget _separator() {
    return Container(
      height: 1,
      decoration: BoxDecoration(color: Colors.blue.withAlpha(100)),
    );
  }

  Stack _validationStack() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: <Widget>[
        Card(
          shape: CircleBorder(),
          color: Colors.black.withOpacity(0.2),
          child: Container(height: 150, width: 150,),),
        Padding(
          padding: const EdgeInsets.only(bottom: 32.0, left: 10),
          child: Transform.rotate(
            angle: -math.pi/20,
            child: Icon(
              Icons.lock,
              color:appColor.withOpacity(0.2),
              size: 60,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 30),
          child: Transform.rotate(
            angle: -math.pi / -60,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              elevation: 4,
              color: Colors.black.withOpacity(0.9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.brightness_1, color: appColor)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 0, 4),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.brightness_1, color: appColor,)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 0, 4),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.brightness_1, color: appColor,)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 0, 8),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.brightness_1, color: appColor,)),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 74),
          child: Transform.rotate(
            angle: math.pi / -45,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Center(child:Text("Password",style: GoogleFonts.arefRuqaa(
                    textStyle:TextStyle(
                      fontWeight: FontWeight.bold,
                       fontSize: 18,
                      color:bgColor
                    )
                    ))),
                        
                        _separator(),
                        ValidationItem("8 digits", eightChars),
                       
                        _separator(),

                        ValidationItem("1 number", number)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Transform.scale(
                      scale: _fabScale.value,
                      child: Card(
                        shape: CircleBorder(),
                        color: appColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.check,
                            color: bgColor
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  bool _allValid() {
    return eightChars && number;
  }
}
