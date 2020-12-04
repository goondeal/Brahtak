import 'package:Bra7tk/models/app_state_model.dart';
import 'package:Bra7tk/services/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:Bra7tk/models/Address.dart';
import 'package:Bra7tk/services/user_repository.dart';
import 'package:Bra7tk/ui/pages/add_address_page.dart';
import 'package:Bra7tk/ui/res/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({Key key}) : super(key: key);

  @override
  _AddressesPageState createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  UserRepository userRepo;
  AppStateModel model;

  @override
  void initState() {
    super.initState();
    userRepo = Provider.of<UserRepository>(context, listen: false);
    model = Provider.of<AppStateModel>(context, listen: false);
    if (userRepo.areas == null || userRepo.areas.isEmpty) {
      userRepo.loadAreas();
    }
    if (userRepo.addresses == null || userRepo.addresses.isEmpty) {
      userRepo.loadUserAddresses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          allTranslations.translate('addresses'),
          style: TextStyle(
            color: kTextColor,
          ),
        ),
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
        children: <Widget>[
          Expanded(
            child: Consumer<UserRepository>(builder: (context, repo, _) {
              if (repo.addresses == null || repo.addresses.isEmpty) {
                return Center(
                  child: repo.addresses == null
                      ? CircularProgressIndicator()
                      : Text(allTranslations.translate('no_addresses_yet')),
                );
              }
              return ListView.separated(
                itemBuilder: (context, i) {
                  return _buildAddressListTile(
                    repo.addresses[i],
                  );
                },
                separatorBuilder: (context, i) {
                  return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      child: Divider(
                        color: primary,
                      ));
                },
                itemCount: repo.addresses.length,
              );
            }),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 8.0,
            ),
            child: RaisedButton(
              color: primary,
              elevation: 4.0,
              padding: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                allTranslations.translate('add_new_address'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AddAdressPage();
                }));
              },
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildAddressListTile(Address address) {
    return ListTile(
      onTap: () {
        userRepo.choosenAddress = address;
        model.shippingCost =
            userRepo.getAreaByID(int.parse(address.areaID))?.deliveryPrice ??
                0.0;
        Navigator.of(context).pop();
        Fluttertoast.showToast(
          msg: '${address.addressName} ${allTranslations.translate('set_as_default')}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      },
      hoverColor: Colors.grey[300],
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
        child: Icon(
          Icons.notifications,
          color: kTextColor2,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(address.addressName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              )),
          Text(address.phoneNumber,
              style: TextStyle(
                color: kTextColor2,
              )),
          Text(
              userRepo.getAreaNameByID(int.parse(address.areaID)) ??
                  '${allTranslations.translate('region')} ${address.areaID}',
              style: TextStyle(
                color: kTextColor2,
              )),
          Text(address.st,
              style: TextStyle(
                color: kTextColor2,
              )),
          if (address.flat != null)
            Text(address.flat,
                style: TextStyle(
                  color: kTextColor2,
                )),
          Text(address.comment ?? ' ',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: kTextColor2,
              )),
        ],
      ),
    );
  }
}
