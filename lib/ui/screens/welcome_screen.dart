import 'package:hasad/app/routes.dart';
import 'package:hasad/ui/theme/theme.dart';
import 'package:hasad/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/welcome/Bareeq_logo.png',
                  width: 210,
                  height: 197,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/welcome/Gold.png',
                  width: 315,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(Routes.onboarding); // عدّل الاسم حسب التوجيه الفعلي
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(305, 50.38),
                backgroundColor: const Color(0xFF221400),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                elevation: 0,
              ),
              child: const Text(
                'دخول',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18, // عدل حسب تصميمك
                  letterSpacing: 0.0,
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w800
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                // Navigator.of(context).pushReplacementNamed(Routes.signupMainScreen);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(305, 50.38),
                backgroundColor: Theme.of(context).colorScheme.surface,
                side: const BorderSide(
                  color: Color(0xFF1E232C),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: Text(
                'إنشاء حساب جديد',
                style: TextStyle(
                  color: context.color.mainBrown,
                  fontSize: 18,
                  fontFamily: 'Rubik', // تأكد من أنك أضفت خط Rubik في pubspec.yaml
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
