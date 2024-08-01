import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supplychaintracking/Models/StaticAccount.dart';
import 'package:supplychaintracking/Models/StaticSettings.dart';
import 'package:supplychaintracking/Views/HomeView/navBar.dart';
import 'package:supplychaintracking/ViewModel/AccountViewModel.dart';
import 'package:supplychaintracking/Views/OrderView/addOrder.dart';
import 'resetPassword.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AccountViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
      ),
    ),
  );
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;

  TextEditingController _usernameController = TextEditingController(text: StaticSettings.username);
  TextEditingController _passwordController = TextEditingController(text: StaticSettings.password);
  bool _rememberMe = StaticSettings.rememberMe ;


  void _goToResetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResetPassword(),
      ),
    );
  }

  Future<void> _login(AccountViewModel viewModel) async {
    if (_formKey.currentState?.validate() == true) {
      bool loginSuccess = await viewModel.login();




      if (loginSuccess) {
        _rememberMe = await viewModel.rememberMe;

        if(_rememberMe==true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('username',viewModel.usernameController.text);
          prefs.setString('password', viewModel.passwordController.text);
          prefs.setBool("rememberMe", viewModel.rememberMe);
        }
        else{
          SharedPreferences prefs = await SharedPreferences.getInstance();
          _usernameController.text="";
          _passwordController.text="";
          prefs.remove('username');
          prefs.remove('password');
          prefs.setBool("rememberMe", false);
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NavBar(),
          ),
        );
      } else {
        // Show error message for unsuccessful login
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Connection error'),
              content: Text(
                'Please check your phone number or password.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height+40;
    double width = MediaQuery.of(context).size.width;
    final viewModel = Provider.of<AccountViewModel>(context);
    if(_usernameController.text !="" ) {
      setState(() {
        viewModel.usernameController.text =_usernameController.text;
        viewModel.passwordController.text =_passwordController.text;
        viewModel.rememberMe= _rememberMe;
      });

    }


    print(viewModel.rememberMe);

    return Scaffold(
      body: Container(

        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color(0xFF0E9695),
              Color(0xFF44C4C3),
              Color(0xFF88DCDA),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 100),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Column(

                      children: <Widget>[
                        Image.asset(
                          'assets/images/logo.png',
                          height: 100,
                          width: 100,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        "Welcome",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        "TRACKING",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: height+11.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 60),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: viewModel.usernameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your phone number.';
                                    }
                                    if (value.length < 2) {
                                      return 'The phone number must be at least 8 characters long.';
                                    }
                                    _usernameController=viewModel.usernameController;
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Phone Number",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: viewModel.passwordController,
                                  obscureText: !_showPassword,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password.';
                                    }
                                    if (value.length < 2) {
                                      return 'The password must be at least 6 characters long.';
                                    }
                                    _passwordController=viewModel.passwordController;
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _showPassword = !_showPassword;
                                        });
                                      },
                                      child: Icon(
                                        _showPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0.0), // Set your desired border radius here
                                color: Colors.white, // Set your desired background color for the checkbox
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0), // Adjust padding as needed
                                child: Checkbox(
                                  value: viewModel.rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      StaticSettings.rememberMe = value ?? false;
                                      viewModel.rememberMe = value ?? false;
                                      _rememberMe = viewModel.rememberMe;
                                    });
                                  },
                                  activeColor: Colors.transparent, // Set your desired active color for the checkbox
                                  checkColor: Colors.teal, // Set your desired check color
                                ),
                              ),
                            ),
                            SizedBox(width: 0), // Adjust spacing as needed
                            Text("Remember me",style: TextStyle(color: Colors.teal)),
                          ],
                        ),

                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: () => _login(viewModel),
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xFF0E9695),
                            ),
                            child: Center(
                              child: viewModel.isLoading
                                  ? CircularProgressIndicator()
                                  : Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: _goToResetPassword,
                          child: Text(
                            "Forget password ?",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 70),
                          child: Text(
                            "PGS International © copyright 2024",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
