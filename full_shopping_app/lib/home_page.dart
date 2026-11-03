import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'test.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("welcome to Home Page"),
            ElevatedButton(
              onPressed: () => context.go("/home/products"),
              child: const Text("Products"),
            ),
            // الـ Bug: كان بيعمل context.pop() وده بيدي error بعد go
            // الحل: Logout والتسجيل خروج صراحة
            ElevatedButton(
              onPressed: () {
                Database.isLoggedIn = false;
                context.go("/login");
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
