import 'package:dawn_ui_flutter/prompts/prompts.dart';
import 'package:flutter/material.dart';
import 'package:transportia/api/user.dart';
import 'package:transportia/main_old.dart';
import 'package:transportia/util_widgets/center_page_container.dart';
import 'package:transportia/widgets/pages/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  bool showPassword = false;
  bool showConfirmPassword = false;

  String? usernameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  void initState() {
    super.initState();

    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  void clearErrors() {
    setState(() {
      passwordError = null;
      confirmPasswordError = null;
      usernameError = null;
      emailError = null;
    });
  }

  bool hasError() {
    return usernameError != null ||
        passwordError != null ||
        confirmPasswordError != null ||
        emailError != null;
  }

  void register() async {
    clearErrors();

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        passwordError = "Passwords must match";
        confirmPasswordError = "Passwords must match";
      });
    }

    final usernameValid = RegExp(
      r'^[a-z0-9._]+$',
    ).hasMatch(usernameController.text);

    if (!usernameValid) {
      setState(() {
        usernameError = "Must be a-z, . and _ only";
      });
    }

    if (!isValidEmail(emailController.text)) {
      setState(() {
        emailError = "Invalid email";
      });
    }

    if (hasError()) return;

    final result = await ApiUser.register(
      usernameController.text,
      emailController.text,
      passwordController.text,
    );

    if (result.$1) {
      await showMessagePrompt(
        // ignore: use_build_context_synchronously
        context,
        Text("Welcome!"),
        Text("Your account has been created, you must now login."),
      );

      setAppPage(LoginPage());
    } else {
      // ignore: use_build_context_synchronously
      showErrorPrompt(context, result.$2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CenterPageContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Register",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text("Create a Transportia account"),
          const SizedBox(height: 16),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              hint: Text("Username"),
              errorText: usernameError,
            ),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              hint: Text("Email"),
              errorText: emailError,
            ),
          ),
          TextField(
            controller: passwordController,
            obscureText: !showPassword,
            decoration: InputDecoration(
              hintText: "Password",
              errorText: passwordError,
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              ),
            ),
          ),
          TextField(
            controller: confirmPasswordController,
            obscureText: !showConfirmPassword,
            decoration: InputDecoration(
              hintText: "Confirm Password",
              errorText: confirmPasswordError,
              suffixIcon: IconButton(
                icon: Icon(
                  showConfirmPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    showConfirmPassword = !showConfirmPassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(onPressed: () {}, child: const Text("Login")),
              Spacer(),
              ElevatedButton.icon(
                onPressed: register,
                label: Text("Register"),
                icon: const Icon(Icons.login),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

bool isValidEmail(String email) {
  final at = email.indexOf('@');

  return at > 0 &&
      at == email.lastIndexOf('@') &&
      at < email.length - 1 &&
      email.substring(at + 1).contains('.');
}
