// // ignore_for_file: prefer_const_constructors

// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../models/http_exception.dart';
// import '../providers/auth.dart';

// enum AuthMode { Signup, Login }

// class AuthScreen extends StatelessWidget {
//   static const routeName = '/auth';

//   @override
//   Widget build(BuildContext context) {
//     final deviceSize = MediaQuery.of(context).size;
//     // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
//     // transformConfig.translate(-10.0);
//     return Scaffold(
//       // resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
//                   const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 stops: const [0, 1],
//               ),
//             ),
//           ),
//           SingleChildScrollView(
//             child: Container(
//               height: deviceSize.height,
//               width: deviceSize.width,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Flexible(
//                     child: Container(
//                       margin: const EdgeInsets.only(bottom: 20.0),
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 8.0, horizontal: 94.0),
//                       transform: Matrix4.rotationZ(-8 * pi / 180)
//                         ..translate(-10.0),
//                       // ..translate(-10.0),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: Theme.of(context).primaryColor,
//                         boxShadow: const [
//                           BoxShadow(
//                             blurRadius: 8,
//                             color: Colors.black26,
//                             offset: Offset(0, 2),
//                           )
//                         ],
//                       ),
//                       child: Text(
//                         'MyShop',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 50,
//                           // fontFamily: 'Anton',
//                           fontWeight: FontWeight.normal,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Flexible(
//                     flex: deviceSize.width > 600 ? 2 : 1,
//                     child: AuthCard(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AuthCard extends StatefulWidget {
//   const AuthCard({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _AuthCardState createState() => _AuthCardState();
// }

// class _AuthCardState extends State<AuthCard>
//     with SingleTickerProviderStateMixin {
//   final GlobalKey<FormState> _formKey = GlobalKey();
//   AuthMode _authMode = AuthMode.Login;
//   final Map<String, String> _authData = {
//     'email': '',
//     'password': '',
//   };
//   var _isLoading = false;
//   final _passwordController = TextEditingController();
//  AnimationController? _controller;
//   // Animation<Size>? _heightAnimation;   instead of this we used animation container

//  Animation<Offset>? _slideAnimation;
//   Animation<double>? _opacityAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(
//         milliseconds: 300,
//       ),
//     );
//     _slideAnimation = Tween<Offset>(
//       begin: Offset(0, -1.5),
//       end: Offset(0, 0),
//     ).animate(
//       CurvedAnimation(
//         parent: _controller!,
//         curve: Curves.fastOutSlowIn,
//       ),
//     );
//     _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller!,
//         curve: Curves.easeIn,
//       ),
//     );
//     // _heightAnimation.addListener(() => setState(() {}));
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _controller!.dispose();
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('An Error Occurred!'),
//         content: Text(message),
//         actions: <Widget>[
//           TextButton(
//             child: Text('Okay'),
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//           )
//         ],
//       ),
//     );
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) {
//       // Invalid!
//       return;
//     }
//     _formKey.currentState!.save();
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       if (_authMode == AuthMode.Login) {
//         // Log user in
//         await Provider.of<Auth>(context, listen: false).login(
//           _authData['email']!,
//           _authData['password']!,
//         );
//       } else {
//         // Sign user up
//         await Provider.of<Auth>(context, listen: false).signup(
//           _authData['email']!,
//           _authData['password']!,
//         );
//       }
//     } on HttpException catch (error) {
//       var errorMessage = 'Authentication failed';
//       if (error.toString().contains('EMAIL_EXISTS')) {
//         errorMessage = 'This email address is already in use.';
//       } else if (error.toString().contains('INVALID_EMAIL')) {
//         errorMessage = 'This is not a valid email address';
//       } else if (error.toString().contains('WEAK_PASSWORD')) {
//         errorMessage = 'This password is too weak.';
//       } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
//         errorMessage = 'Could not find a user with that email.';
//       } else if (error.toString().contains('INVALID_PASSWORD')) {
//         errorMessage = 'Invalid password.';
//       }
//       _showErrorDialog(errorMessage);
//     } catch (error) {
//       const errorMessage =
//           'Could not authenticate you. Please try again later.';
//       _showErrorDialog(errorMessage);
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   void _switchAuthMode() {
//     if (_authMode == AuthMode.Login) {
//       setState(() {
//         _authMode = AuthMode.Signup;
//       });
//       _controller!.forward();
//     } else {
//       setState(() {
//         _authMode = AuthMode.Login;
//       });
//       _controller!.reverse();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final deviceSize = MediaQuery.of(context).size;
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       elevation: 8.0,
//       child:
//           //  AnimatedBuilder(
//           //   animation: _heightAnimation!,
//           //   builder: (ctx, ch) =>
//           AnimatedContainer(
//         // height: _heightAnimation!.value.height,
//         duration: Duration(milliseconds: 300),
//         curve: Curves.fastOutSlowIn,
//         height: _authMode == AuthMode.Signup ? 320 : 260,
//         constraints: BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
//         // BoxConstraints(minHeight: _heightAnimation!.value.height),
//         width: deviceSize.width * 0.75,
//         padding: EdgeInsets.all(16.0),
//         // child:
//         // ch),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 TextFormField(
//                   decoration: const InputDecoration(labelText: 'E-Mail'),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value!.isEmpty || !value.contains('@')) {
//                       return 'Invalid email!';
//                     }
//                     return null;
//                     // return null;
//                   },
//                   onSaved: (value) {
//                     _authData['email'] = value!;
//                   },
//                 ),
//                 TextFormField(
//                   decoration: const InputDecoration(labelText: 'Password'),
//                   obscureText: true,
//                   controller: _passwordController,
//                   validator: (value) {
//                     if (value!.isEmpty || value.length < 5) {
//                       return 'Password is too short!';
//                     }
//                   },
//                   onSaved: (value) {
//                     _authData['password'] = value!;
//                   },
//                 ),
//                   AnimatedContainer(
//                   constraints: BoxConstraints(
//                     minHeight: _authMode == AuthMode.Signup ? 60 : 0,
//                     maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
//                   ),
//                   duration: Duration(milliseconds: 300),
//                   curve: Curves.easeIn,
//                   child: FadeTransition(
//                     opacity: _opacityAnimation!,
//                     child: SlideTransition(
//                       position: _slideAnimation!,
//                       child: TextFormField(
//                         enabled: _authMode == AuthMode.Signup,
//                         decoration:
//                             InputDecoration(labelText: 'Confirm Password'),
//                         obscureText: true,
//                         validator: _authMode == AuthMode.Signup
//                             ? (value) {
//                                 if (value != _passwordController.text) {
//                                   return 'Passwords do not match!';
//                                 }
//                               }
//                             : null,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 if (_isLoading)
//                   const CircularProgressIndicator()
//                 else
//                   ElevatedButton(
//                     onPressed: _submit,
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor:
//                           Theme.of(context).primaryTextTheme.labelLarge?.color,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       backgroundColor: Theme.of(context).primaryColor,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 30.0, vertical: 8.0),
//                     ),
//                     child:
//                         Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
//                   ),
//                 TextButton(
//                   onPressed: _switchAuthMode,
//                   style: TextButton.styleFrom(
//                     foregroundColor: Theme.of(context).primaryColor,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 30.0, vertical: 4),
//                     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   ),
//                   child: Text(
//                     '${_authMode == AuthMode.Login ? 'SIGN UP' : 'LOGIN'} INSTEAD',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/http_exception.dart';
import '../providers/auth.dart';
import 'product_overview_screen.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body:
          //  Stack(
          //   children: <Widget>[
          Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 136, 116, 169),
              Color.fromARGB(255, 55, 25, 104),
              Color.fromARGB(255, 246, 246, 245),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // AnimatedLogo(),
                // const SizedBox(height: 20),
                SizedBox(
                  width: deviceSize.width * 0.90,
                  child: AuthCard(),
                ),
              ],
            ),
          ),
        ),
      ),

      //   ],
      // ),
    );
  }
}

class AnimatedLogo extends StatefulWidget {
  late AuthMode authMode;
   AnimatedLogo({
    Key? key,
    required this.authMode
  }) : super(key: key);
  @override
  _AnimatedLogoState createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _logoAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _logoAnimation,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.white,
        child: 
           Icon(widget.authMode == AuthMode.Signup ? Icons.person_add : Icons.lock, size: 50, color: Colors.blueAccent),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  bool _isLoading = false;
  final _passwordController = TextEditingController();

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);
            Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => productOverviewScreen()),
        );
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email']!, _authData['password']!);
            setState(() {
        _authMode = AuthMode.Login;
      });
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    } 

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [ AnimatedLogo(authMode: _authMode),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          // height: _authMode == AuthMode.Signup ? 320 : 260,
          // constraints: BoxConstraints(
          //     minHeight: _authMode == AuthMode.Signup ? 320 : 260),
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                  const SizedBox(height: 16),
                if (_authMode == AuthMode.Signup)
                  AnimatedContainer(
                    constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                      maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                    ),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: TextFormField(
                          enabled: _authMode == AuthMode.Signup,
                          obscureText: true,
                           style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: ' Confirm Password',
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                }
                              : null,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 10.0),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                   
                    style: TextStyle(color: Colors.white70),
                    '${_authMode == AuthMode.Login ? 'Don\'t have an account? Sign Up' : 'Already have an account? Login'}',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
