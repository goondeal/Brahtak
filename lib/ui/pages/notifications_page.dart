import 'package:Bra7tk/services/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:Bra7tk/ui/res/colors.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          allTranslations.translate("notifications"),
          style: const TextStyle(color: kTextColor),
        ),
        actions: [
          IconButton(
            icon: Directionality(
              textDirection: TextDirection.ltr,
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: 7,
        itemBuilder: (context, i) {
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  style: BorderStyle.none,
                ),
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(Icons.notifications, color: kTextColor2),
            ),
            title: Column(
              children: <Widget>[
                Text(
                  allTranslations.translate('call_soon'),
                  style: const TextStyle(color: kTextColor2),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      allTranslations.translate('yesterday'),
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: kTextColor2,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, i) {
          return const Divider();
        },
      ),
    );
  }
}
