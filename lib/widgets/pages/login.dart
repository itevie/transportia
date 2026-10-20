import 'package:flutter/material.dart';
import 'package:transportia/api/user.dart';
import 'package:transportia/main_old.dart';
import 'package:transportia/prompts/error.dart';
import 'package:transportia/util/prefs.dart';
import 'package:transportia/util_widgets/center_page_container.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  void login() async {
    final result = await ApiUser.login(
      emailController.text,
      passwordController.text,
    );

    if (result.$1) {
      await Preferences().setString("token", result.$2);
      reload();
    } else {
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
            "Login",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text("Welcome to Transportia"),
          const SizedBox(height: 16),
          TextField(
            controller: emailController,
            decoration: InputDecoration(hint: Text("Email")),
          ),
          TextField(
            controller: passwordController,
            obscureText: !showPassword,
            decoration: InputDecoration(
              hintText: "Password",
              suffixIcon: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 20,
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
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(onPressed: () {}, child: const Text("Register")),
              Spacer(),
              ElevatedButton.icon(
                onPressed: login,
                label: Text("Login"),
                icon: const Icon(Icons.login),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
