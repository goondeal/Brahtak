import 'package:Bra7tk/services/all_translations.dart';
import 'package:Bra7tk/ui/res/colors.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final langs = {
    'English': 'en',
    'Arabic': 'ar',
  };

  String currentLang;

  @override
  void initState() {
    // Init super.
    super.initState();
    // Get the current app language.
    langs.forEach((String key, String value) {
      if (value == allTranslations.locale?.languageCode) {
        currentLang = key;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        centerTitle: true,
        title: Text(allTranslations.translate('settings')),
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            PopupMenuButton<String>(
              child: ListTile(
                title: Text(
                  allTranslations.translate('lang'),
                  style: const TextStyle(fontSize: 20),
                ),
                subtitle: Text(currentLang ?? ' '),
                trailing: const Icon(Icons.expand_more),
              ),
              itemBuilder: (context) {
                final List<PopupMenuItem<String>> menuitems = [];
                langs.forEach((key, value) {
                  menuitems.add(PopupMenuItem<String>(
                    child: Text(key),
                    value: value,
                  ));
                });
                return menuitems;
              },
              onSelected: (String selectedLanguage) {
                setState(() {
                  langs.forEach((key, value) {
                    if (selectedLanguage == value) {
                      currentLang = key;
                    }
                  });
                });
                allTranslations.setNewLanguage(selectedLanguage);
              },
            ),
          ],
        ),
      ),
    );
  }
}
