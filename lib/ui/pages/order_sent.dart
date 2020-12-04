import 'package:Bra7tk/services/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:Bra7tk/ui/res/colors.dart';

class OrderSentPage extends StatelessWidget {
  const OrderSentPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container
    (
      width: double.infinity,
      height: double.infinity,
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenSize.width * 0.25,),
            Container(
              width: screenSize.width/2,
              height: screenSize.width/2,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: primary,
                      style: BorderStyle.solid,
                      width: 8.0,
                    )),
                child: Center(
                  child: Icon(
                    Icons.done,
                    color: primary,
                    size: screenSize.width/4,
                  ),
                ),
              ),
            Text(
                allTranslations.translate('congrats'),
                style: TextStyle(
                  fontSize: 28.0,
                  color: kTextColor,
                ),
              ),
            Text(
              allTranslations.translate('ordered_successfuly'),
              style: TextStyle(
                fontSize: 28.0,
                color: kTextColor,
              ),
            ),
            SizedBox(height: screenSize.height / 10,),
            Text(
              allTranslations.translate('track_your_order'),
              style: TextStyle(
                fontSize: 16.0,
                color: kTextColor2,
              ),
            ),
            Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: FlatButton(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    allTranslations.translate('backback_to_products_menu'),
                    style: TextStyle(
                      fontSize: 22.0,
                      color: kTextColor,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
