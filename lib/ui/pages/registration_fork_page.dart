import 'package:Bra7tk/services/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:Bra7tk/ui/pages/home.dart';
import 'package:Bra7tk/ui/pages/login_page.dart';
import 'package:Bra7tk/ui/pages/phone_sumit.dart';
import 'package:Bra7tk/ui/res/colors.dart';
import 'package:Bra7tk/ui/res/styles.dart';

const double radius = 32.0;

class RegisterOrSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            color: primary,
            child: Align(
              alignment: const Alignment(0, -0.30),
              child: Image.asset(
                'assets/images/logo_2.png',
                semanticLabel: 'logo',
                scale: 5.0,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 0.35 * screenSize.height,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  topRight: Radius.circular(radius),
                ),
                color: primarySwatch,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    allTranslations.translate('registration'),
                    style: textStyle.copyWith(fontSize: 20),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    buttonPadding: const EdgeInsets.fromLTRB(28.5, 6, 27.5, 9),
                    children: [
                      RaisedButton(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        color: buttonColor,
                        child: Text(
                          allTranslations.translate('login'),
                          style: textStyle,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return LoginPage();
                            }),
                          );
                        },
                      ),
                      RaisedButton(
                        elevation: 0.0,
                        color: secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Text(
                          allTranslations.translate('sign_up'),
                          style: textStyle.copyWith(
                            color: primary,
                            fontSize: 15.0,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return PhoneSubmit();
                          }));
                        },
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return Home();
                      }));
                    },
                    child: Text(
                      allTranslations.translate('continue_without_login'),
                      style: textStyle,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
