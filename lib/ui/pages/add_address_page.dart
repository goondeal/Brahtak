import 'package:Bra7tk/services/all_translations.dart';
import 'package:Bra7tk/services/api_stuff.dart';
import 'package:flutter/material.dart';
import 'package:Bra7tk/models/Address.dart';
import 'package:Bra7tk/services/user_repository.dart';
import 'package:Bra7tk/ui/res/colors.dart';
import 'package:provider/provider.dart';

class AddAdressPage extends StatefulWidget {
  @override
  _AddAdressPageState createState() => _AddAdressPageState();
}

class _AddAdressPageState extends State<AddAdressPage> {
  TextEditingController _addressNameController;
  TextEditingController _phoneNumberController;
  TextEditingController _commentController;
  TextEditingController _flatController;
  TextEditingController _streetController;

  UserRepository userRepo;
  //int _selected;
  String _selectedAreaName;

  @override
  void initState() {
    super.initState();
    userRepo = Provider.of<UserRepository>(context, listen: false);
    _addressNameController = TextEditingController(text: allTranslations.translate('address_1'));
    _commentController = TextEditingController();
    _streetController = TextEditingController();
    _flatController = TextEditingController();
    _phoneNumberController =
        TextEditingController(text: userRepo.user?.phone ?? ' ');
  }

  @override
  void dispose() {
    _addressNameController.dispose();
    _commentController.dispose();
    _streetController.dispose();
    _phoneNumberController.dispose();
    _flatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          allTranslations.translate('address_details'),
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: SizedBox(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: allTranslations.translate('address_name'),
              controller: _addressNameController,
              hintText: allTranslations.translate('address_1'),
            ),
            Column(
              children: [
                Container(
                  width: 150,
                  //color: Colors.grey[300],
                  margin:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child:
                      Consumer<UserRepository>(builder: (context, userRepo, _) {
                    return userRepo.areas != null
                        ? PopupMenuButton<String>(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedAreaName ?? allTranslations.translate('region'),
                                  style: TextStyle(color: primary, fontSize: 18.0),
                                ),
                                Icon(
                                  Icons.expand_more,
                                  color: primary,
                                ),
                              ],
                            ),
                            itemBuilder: (context) {
                              return userRepo.areas
                                  .map(
                                    (e) => PopupMenuItem<String>(
                                      value: e.name,
                                      child: Text(e.name),
                                    ),
                                  )
                                  .toList();
                            },
                            onSelected: (text) {
                              setState(() {
                                _selectedAreaName = text;
                              });
                            },
                          )
                        : Text(allTranslations.translate('load_regions'));
                  }),
                ),
              ],
            ),
            _buildSection(
                title: allTranslations.translate('streat'),
                controller: _streetController,
                hintText: allTranslations.translate('streat_name')),
            _buildSection(
              title: allTranslations.translate('house_number'),
              controller: _flatController,
            ),
            _buildSection(
              title: allTranslations.translate('phone'),// PHONE_NUMBER,
              controller: _phoneNumberController,
              textInputType: TextInputType.phone,
            ),

            // comment TextField
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    allTranslations.translate('add_comment'),
                    style: TextStyle(color: primary, fontSize: 22.0),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  width: double.infinity,
                  height: 200,
                  child: TextField(
                    maxLines: 8,

                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 22,
                    ),
                    controller: _commentController,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      hintText: allTranslations.translate('add_mark'),
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.solid,
                          color: Colors.black,
                        ),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    onChanged: (text) {}, //onTextChanged,
                  ),
                ),
              ],
            ),

            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
              child: Center(
                child: RaisedButton(
                  color: primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    allTranslations.translate('save'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    final address = Address(
                      addressName: _addressNameController.text,
                      areaID: userRepo
                          .getAreaByName(_selectedAreaName)
                          .id
                          .toString(),
                      //areaName: userRepo.getAreaNameByID(_selected),
                      comment: _commentController.text,
                      phoneNumber: _phoneNumberController.text,
                      flat: _flatController.text,
                      st: _streetController.text,
                    );

                    userRepo.addAddress(address);
                    userRepo.choosenAddress = address;

                    ApiService()
                        .addAddress(address)
                        .then((value) => print(value));
                    Navigator.of(context).pop();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      {String title,
      TextEditingController controller,
      String hintText,
      textInputType,}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Text(
            title,
            style: TextStyle(color: primary, fontSize: 18.0),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          width: double.infinity,
          height: 50.0,
          child: TextField(
            keyboardType: textInputType ?? TextInputType.text,
            style: TextStyle(
              color: kTextColor,
              fontSize: 22,
            ),

            controller: controller,
            textAlignVertical: TextAlignVertical(y: 0),
            decoration: InputDecoration(
              hintText: hintText ?? '',
              contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  width: 1,
                  style: BorderStyle.solid,
                  color: kTextColor,
                ),
              ),
              fillColor: Colors.white,
              filled: true,
            ),
            onChanged: (text) {}, //onTextChanged,
          ),
        ),
      ],
    );
  }
}
