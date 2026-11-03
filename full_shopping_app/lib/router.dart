// ===================== إجابات أسئلة 5.1: Navigation & GoRouter =====================
//
// 1. What is GoRouter?
//    مكتبة توجيه رسمية في فلاتر تعتمد على الـ Declarative Routing (Routing 2.0)
//    وتربط بين واجهات التطبيقات والـ URLs.
// 2. What is a Route?
//    مسار محدد (Path) يربط بين نص عنوان الصفحة (مثل "/login") والـ Widget الخاضعة للبناء.
// 3. What is Redirect?
//    دالة مراقبة (Auth Guard) تفحص حالة التطبيق قبل الانتقال لأي مسار؛ وتوجه المستخدم
//    لمسار مختلف إذا لم تتوفر شروط الوصول (مثل حظر غير المسجلين من دخول /home).
// 4. Why does Signup need to be a top-level route?
//    لأن دالة الـ redirect تمنع أي مستخدم غير مسجل (loggedIn = false) من دخول أي مسار
//    يبدأ بـ /home. فلو كانت /signup مساراً فرعياً تحت /home (مثل /home/signup)،
//    كانت دالة الـ redirect ستقوم بتحويل المستخدم فورا لـ /login ولن يتمكن من رؤية /signup أبداً.
// 5. How does existing redirect affect access to Login and Signup?
//    الـ Redirect يفحص فقط المسارات التي تبدأ بـ /home (goingToHome). بما أن /login و /signup
//    مسارات Top-level ولا تبدأ بـ /home، يسمح الـ Redirect بفتحهما مجاناً وبدون قيود.
// ================================================================================

import 'package:go_router/go_router.dart';
import 'test.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'products_page.dart';
import 'signup_page.dart';

final router = GoRouter(
  initialLocation: "/login",
  redirect: (context, state) {
    final loggedIn = Database.isLoggedIn;
    final goingToHome = state.matchedLocation.startsWith("/home");

    if (!loggedIn && goingToHome) return "/login";
    return null;
  },
  routes: [
    GoRoute(path: "/login", builder: (context, state) => const LoginPage()),
    GoRoute(path: "/signup", builder: (context, state) => const SignupPage()),
    GoRoute(
      path: "/home",
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: "products",
          builder: (context, state) => const ProductsPage(),
        ),
      ],
    ),
  ],
);
