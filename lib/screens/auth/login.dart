import 'package:explension/constants.dart';
import 'package:explension/injector.dart';
import 'package:explension/screens/home.dart';
import 'package:explension/services/category.dart';
import 'package:explension/services/expense.dart';
import 'package:explension/services/sub_category.dart';
import 'package:explension/services/wallet.dart';
import 'package:explension/utils/validator.dart';
import 'package:explension/widgets/login/custom_text_input.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? formErrorText = "failed login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: padding,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Welcome Back!",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Don't have an account yet?"),
                          TextButton(
                            onPressed: () {
                              print('Navigate to registration page');
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Show form error here
                    if (formErrorText != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formErrorText!,
                              style: const TextStyle(color: Colors.white),
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              onPressed: () =>
                                  setState(() => formErrorText = null),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                        controller: _emailController,
                        labelText: "Email Address",
                        validator: Validator.validateEmail),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                        controller: _passwordController,
                        labelText: "Password",
                        validator: Validator.validatePassword),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          print('Forgot Password clicked');
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return HomePage(
                                  expenseService: sl<ExpenseService>(),
                                  walletService: sl<WalletService>(),
                                  categoryService: sl<CategoryService>(),
                                  subCategoryService: sl<SubCategoryService>(),
                                );
                              }),
                            );
                          }
                        },
                        child: const Text('Log In'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: FooterText(
              text:
                  'By logging in, you agree to our Terms of Service and Privacy Policy.',
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class FooterText extends StatelessWidget {
  final String text;

  const FooterText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
    );
  }
}
