// 1. What is a Key in Flutter?
//    الـ Key هو مُعرّف فريد (Identifier) للـ Widgets والـ Elements، بيساعد Flutter يميّز
//    بين الـ Widgets ويحافظ على الـ State بتاعهم عند إعادة الترتيب أو التعديل في الـ Widget Tree.
// 2. What does super.key do?
//    بيمرّر الـ key المبعوت في الـ constructor بتاع الكلاس الحالي للـ constructor بتاع الكلاس الأب
//    (زي StatefulWidget أو StatelessWidget).
// 3. Where does the key go?
//    بيتحط كـ named parameter في الـ constructor: const MyWidget({super.key});
// 4. Difference between Key? key and GlobalKey<FormState>?
//    - Key? key: مفتاح عام للـ Widget بيستخدمه فلاتر داخلياً لإدارة الـ Widget Tree.
//    - GlobalKey<FormState>: مفتاح عالمي خاص بـ FormState بيسمحلنا نوصل للـ Form وننادي
//      دوال زي validate() و reset() من أي مكان داخل الـ State.
// 5. Why do we use GlobalKey with Form?
//    عشان نربط الـ Form بـ Key يخلينا نقدر نتحكم فيه ونشغّل الـ validation على كل الـ TextFormFields
//    اللي جواه عن طريق currentState!.validate().
//
// 1. What is compile-time constant?
//    قيمة أو كائن بيتحدد وبيتجهز وقت الـ Compile (قبل ما البرنامج يشتغل) ومش بتتغير أصلًا وقت الـ Runtime.
// 2. Difference between const and runtime values?
//    - const: معروفة ومحددة قبل التشغيل وتُحفظ في الذاكرة مرة واحدة (Canonicalized).
//    - runtime: قيم بيتسحب حسابها أثناء تشغيل التطبيق (زي النص من Controller أو الوقت الحالي).
// 3. Why does const help Flutter performance?
//    لأن Flutter بيعيد استخدام نفس الـ Instance المرتجعة في الذاكرة بدل ما ينشئ كائنات جديدة،
//    وده بيقلل استخدام الـ Memory والـ Garbage Collection.
// 4. How does const relate to widget rebuilds?
//    عند حدوث Rebuild للـ Parent Widget، إذا كان الـ Child مسبوقاً بـ const، فلاتر بتتخطى
//    إعادة بناءه (Skip rebuild) لأنه مفيش أي تغيير حصل فيه.
// 5. Why can't we use const with dynamic values or controllers?
//    لأن الـ Controllers والـ Dynamic values قيمها وكائناتها بتتأنشئ وتتغير في الـ Runtime،
//    بالتالي مستحيل تحديدها وقت الـ Compile.
//
// 1. What does _ mean in Dart?
//    إضافة _ قبل اسم المتغير أو الكلاس أو الدالة بتخليه Private (خاص) على مستوى الملف (Library).
// 2. What is Library Privacy?
//    في Dart، الخصوصية بتكون على مستوى الملف بالكامل (Library level) وليس على مستوى الكلاس فقط.
// 3. What is Encapsulation?
//    مفهوم كبسلة البيانات في البرمجة الكائنية (OOP)، يعني إخفاء تفاصيل التطبيق الداخلية
//    ومنع الوصول إليها أو تعديلها مباشرة من ملفات خارجية.
// 4. Why should State classes be private?
//    لأن الـ State بيحتوي على التفاصيل الداخلية للـ UI والـ Controllers والـ FormKeys الخاصة بالصفحة،
//    ومينفعش أي ملف خارجي يتدخل فيها مباشرة.
// 5. How should createState() be updated?
//    تُحدث لتُرجع الـ Private State Class:
//    @override State<LoginPage> createState() => _LoginPageState();

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'test.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _keyForm = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("start Login");
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    print("finish Login");
    super.dispose();
  }

  void _inputCheck() {
    if (_keyForm.currentState!.validate()) {
      if (_usernameController.text == Database.username &&
          _passwordController.text == Database.password) {
        Database.isLoggedIn = true;
        context.go("/home");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Wrong info")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _keyForm,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Enter username" : null,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
                validator: (v) =>
                    (v == null || v.isEmpty) ? "Enter password" : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _inputCheck,
                child: const Text("Login"),
              ),
              TextButton(
                onPressed: () => context.push("/signup"),
                child: const Text("Don't have an account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
