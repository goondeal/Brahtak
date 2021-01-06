import 'package:Bra7tk/services/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:Bra7tk/models/user.dart';
import 'package:Bra7tk/services/user_repository.dart';
import 'package:Bra7tk/ui/res/colors.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _showUsernameTextField = false;
  bool _showPhoneTextField = false;
  bool _switchVal = true;
  User user;
  @override
  void initState() {
    super.initState();
    user = Provider.of<UserRepository>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          allTranslations.translate('profile'),
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Directionality(
              textDirection: TextDirection.ltr,
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: screenSize.width / 3,
                    height: screenSize.width / 3,
                    child: Icon(
                      Icons.person,
                      color: Colors.grey[600],
                      size: 48 * 1.5,
                    ),
                    decoration: BoxDecoration(
                      // image: DecorationImage(
                      //   image: AssetImage('assets/images/Photo_Here.png'),
                      //   alignment: Alignment.center,
                      //   fit: BoxFit.cover,
                      //   repeat: ImageRepeat.noRepeat,
                      // ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400],
                          blurRadius: 32.0,
                          spreadRadius: 2.0,
                        )
                      ],
                      border: Border.all(
                        color: primary,
                        width: 4,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  Text(
                    user.name,
                    style: TextStyle(
                      color: kTextColor2,
                      fontSize: 22.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              width: screenSize.width,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400],
                    blurRadius: 32.0,
                    spreadRadius: 2.0,
                  )
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        allTranslations.translate('username'),
                        style: TextStyle(
                          color: kTextColor2,
                        ),
                      ),
                      _showUsernameTextField
                          ? Container(
                              width: 200, height: 28, child: TextField())
                          : InkWell(
                              child: Text(
                                user.name,
                                style: TextStyle(
                                  color: kTextColor2,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _showUsernameTextField = true;
                                });
                              },
                            ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        allTranslations.translate('change_phone'),
                        style: TextStyle(
                          color: kTextColor2,
                        ),
                      ),
                      _showPhoneTextField
                          ? Container(
                              width: 200,
                              height: 28,
                              child: TextField(
                                keyboardType: TextInputType.phone,
                              ))
                          : InkWell(
                              child: Text(
                                user.phone ?? '01066133855',
                                style: TextStyle(
                                  color: kTextColor2,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _showPhoneTextField = true;
                                });
                              },
                            ),
                    ],
                  ),
                  Divider(),
                  ListTile(
                    title: Text(allTranslations.translate('change_password')),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: primary,
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(allTranslations.translate('allow_notifications')),
                      Switch(
                          activeColor: primary,
                          value: _switchVal,
                          onChanged: (value) {
                            setState(() {
                              _switchVal = value;
                            });
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // return Scaffold(
    //   backgroundColor: kBackgroundColor,
    //   resizeToAvoidBottomInset: false,
    //   appBar: AppBar(
    //     title: Text(
    //       PROFILE_TITLE,
    //       style: TextStyle(
    //         color: Colors.black,
    //       ),
    //     ),
    //     centerTitle: true,
    //     elevation: 0,
    //     backgroundColor: Colors.transparent,
    //     actions: [
    //       IconButton(
    //         icon: Directionality(
    //           textDirection: TextDirection.ltr,
    //           child: Icon(
    //             Icons.arrow_back,
    //             color: Colors.black,
    //           ),
    //         ),
    //         onPressed: () {
    //           Navigator.of(context).pop();
    //         },
    //       ),
    //     ],
    //   ),
    //   body: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: [
    //       Flexible(
    //         flex: 2,
    //         child: Center(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //             children: [
    //               Container(
    //                 width: screenSize.width / 3,
    //                 height: screenSize.width / 3,
    //                 decoration: BoxDecoration(
    //                   image: DecorationImage(
    //                     image: AssetImage('assets/images/Photo_Here.png'),
    //                     alignment: Alignment.center,
    //                     fit: BoxFit.cover,
    //                     repeat: ImageRepeat.noRepeat,
    //                   ),
    //                   shape: BoxShape.circle,
    //                   boxShadow: [
    //                     BoxShadow(
    //                       color: Colors.grey[400],
    //                       blurRadius: 32.0,
    //                       spreadRadius: 2.0,
    //                     )
    //                   ],
    //                   border: Border.all(
    //                     color: primary,
    //                     width: 4,
    //                     style: BorderStyle.solid,
    //                   ),
    //                 ),
    //               ),
    //               Text(
    //                 user.name,
    //                 style: TextStyle(
    //                   color: kTextColor2,
    //                   fontSize: 22.0,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       Flexible(
    //         flex: 3,
    //         child: Container(
    //           width: screenSize.width,
    //           padding: const EdgeInsets.all(16),
    //           decoration: BoxDecoration(
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Colors.grey[400],
    //                 blurRadius: 32.0,
    //                 spreadRadius: 2.0,
    //               )
    //             ],
    //             borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(24),
    //               topRight: Radius.circular(24),
    //             ),
    //             color: Colors.white,
    //           ),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Text(
    //                     USERNAME,
    //                     style: TextStyle(
    //                       color: kTextColor2,
    //                     ),
    //                   ),
    //                   _showUsernameTextField
    //                       ? Container(
    //                           width: 200, height: 28, child: TextField())
    //                       : InkWell(
    //                           child: Text(
    //                             user.name,
    //                             style: TextStyle(
    //                               color: kTextColor2,
    //                             ),
    //                           ),
    //                           onTap: () {
    //                             setState(() {
    //                               _showUsernameTextField = true;
    //                             });
    //                           },
    //                         ),
    //                 ],
    //               ),
    //               Divider(),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Text(
    //                     CHANGE_PHONE_NUMBER,
    //                     style: TextStyle(
    //                       color: kTextColor2,
    //                     ),
    //                   ),
    //                   _showPhoneTextField
    //                       ? Container(
    //                           width: 200,
    //                           height: 28,
    //                           child: TextField(
    //                             keyboardType: TextInputType.phone,
    //                           ))
    //                       : InkWell(
    //                           child: Text(
    //                             user.phone?? '01066133855',
    //                             style: TextStyle(
    //                               color: kTextColor2,
    //                             ),
    //                           ),
    //                           onTap: () {
    //                             setState(() {
    //                               _showPhoneTextField = true;
    //                             });
    //                           },
    //                         ),
    //                 ],
    //               ),
    //               Divider(),
    //               ListTile(
    //                 title: Text(CHANGE_PASSWORD),
    //                 trailing: Icon(
    //                   Icons.arrow_forward_ios,
    //                   color: primary,
    //                 ),
    //               ),
    //               Divider(),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Text(ALLOW_NOTIFICATION),
    //                   Switch(
    //                       activeColor: primary,
    //                       value: _switchVal,
    //                       onChanged: (value) {
    //                         setState(() {
    //                           _switchVal = value;
    //                         });
    //                       }),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
