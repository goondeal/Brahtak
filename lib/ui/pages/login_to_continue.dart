import 'package:Bra7tk/services/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:Bra7tk/ui/pages/registration_fork_page.dart';
import 'package:Bra7tk/ui/res/colors.dart';

class LoginToContinue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        color: kBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 50.0,
                ),
                child: Text(
                  allTranslations.translate('plz_login'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black, fontSize: 18.0),
                ),
              ),
            ),
            RaisedButton(
              color: primary,
              shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                allTranslations.translate("goto_registration"),
                style: const TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RegisterOrSignIn(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
