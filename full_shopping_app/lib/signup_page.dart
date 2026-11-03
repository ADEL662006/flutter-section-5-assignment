// 1. كيف تعمل المكونات معاً (Form, TextFormField, Controller, Validator, GlobalKey):
//    - GlobalKey<FormState>: المفتاح الذي يعطينا صلاحية الوصول لـ FormState من خارج الـ Form.
//    - Form: الـ Container الأساسي الذي يربط جميع الـ TextFormFields بمفتاح واحد (_keyForm).
//    - TextFormField: حقل إدخال النص المزود بـ Validator و Controller.
//    - TextEditingController: كائن مسؤول عن الاستماع لقيمة النص المدخل وتحصيله أو تعديله.
//    - Validator: دالة تُستدعى لكل حقل عند تنفيذ _keyForm.currentState!.validate()؛
//      إذا أعادت null يكون الحقل سليماً، وإذا أعادت String تعيد رسالة الخطأ لتُعرض تحت الحقل.
//
// 2. أهمية dispose() مع الـ Controllers وتسريب الذاكرة (Memory Leak):
//    الـ TextEditingController يستمع للأحداث ويتصل بذاكرة النظام (ChangeNotifier).
//    إذا لم نقم باستدعاء dispose() عند تدمير الصفحة (Unmount)، سيظل الكائن محجوزاً في الذاكرة
//    مما يسبب تسريب الذاكرة (Memory Leak) وإبطاء التطبيق.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'test.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _keyForm = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_keyForm.currentState!.validate()) {
      Database.username = _usernameController.text.trim();
      Database.password = _passwordController.text;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created, please login")),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _keyForm,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: "Username"),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty || v.trim().length < 3) {
                      return "Username must be at least 3 characters";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (v) {
                    if (v == null ||
                        v.trim().isEmpty ||
                        !v.contains("@") ||
                        !v.contains(".")) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password"),
                  validator: (v) {
                    if (v == null || v.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: "Confirm Password"),
                  validator: (v) {
                    if (v != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text("Sign Up"),
                ),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text("Back to Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
