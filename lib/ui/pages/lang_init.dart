import 'package:Bra7tk/services/all_translations.dart';
import 'package:Bra7tk/ui/pages/registration_fork_page.dart';
import 'package:Bra7tk/ui/res/colors.dart';
import 'package:flutter/material.dart';

class LangInit extends StatefulWidget {
  @override
  _LangInitState createState() => _LangInitState();
}

class _LangInitState extends State<LangInit> {
    bool _showButton = false;

  final langs = {
    'English': 'en',
    'Arabic': 'ar',
  };
  String currentLang;
  @override
  void initState() {
    super.initState();
    langs.forEach((key, value) {
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
        title: Text('Welcome أهلا بك'),
      ),
      body: Container(
        child: Center(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('من فضلك، قم باختيار لغة '),
              SizedBox(height: 16),
              Text('(Choose a language please)'),
              SizedBox(height: 24),
              PopupMenuButton<String>(
                child: ListTile(
                  title: Text(
                    'اللغة (Language)',
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(currentLang ?? ' '),
                  trailing: Icon(Icons.expand_more),
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
                onSelected: (selectedLanguage) {
                  setState(() {
                    langs.forEach((key, value) {
                      if (selectedLanguage == value) {
                        currentLang = key;
                      }
                    });
                  });
                  allTranslations.setNewLanguage(selectedLanguage);
                                                    _showButton = true;

                  print('done');
                },
              ),
               SizedBox(height: 100),
              RaisedButton(
                //padding: const EdgeInsets.symmetric(vertical: 8),
                
                color: primary,
                child: Text(allTranslations.translate('ok'), style: TextStyle(color: Colors.white, fontSize: 20)),
                onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterOrSignIn()));
              })

            ],
          ),
        ),
      ),
    );
  }
}
