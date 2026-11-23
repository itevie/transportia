import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:transportia/api/user.dart';
import 'package:transportia/stores/current_user_store.dart';
import 'package:transportia/util/auth.dart';
import 'package:transportia/widgets/prompts/error.dart';
import 'package:transportia/util/prefs.dart';
import 'package:transportia/widgets/util/center_page_container.dart';

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
    final currentUser = context.read<CurrentUserStore>();
    final result = await ApiUser.login(
      emailController.text,
      passwordController.text,
    );

    if (result.$1) {
      await Preferences().setString("token", result.$2);
      checkLogin();
      context.push("/");
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
              TextButton(
                onPressed: () {
                  context.go("/register");
                },
                child: const Text("Register"),
              ),
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
