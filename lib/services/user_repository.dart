import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Bra7tk/models/area.dart';
import 'package:Bra7tk/models/Address.dart';
import 'package:Bra7tk/models/user.dart';
import 'package:Bra7tk/services/api_stuff.dart';

class UserRepository with ChangeNotifier {
  User _user;
  List<Address> _addresses;
  Set<int> _favs = <int>{};
  Address choosenAddress;
  List<Area> areas;
  bool requestFavs = false;

  bool keepedLoggedIn = false;
  String verifiedPhoneNumber;
  // UserRepository() {
  //   checkIfKeepedLoggedIn();
  //   // if (keepedLoggedIn) {
  //   //   _user = User.fromCache();
  //   //   ApiService().token = _user?.token;
  //   //   print(_user);
  //   // }
  // }

  User get user => _user;
  List<Address> get addresses => _addresses;
  Set<int> get favs => _favs;
  bool isFav(int productID) => _favs?.contains(productID) ?? false;

  void addToFavs(int productID) {
    _favs?.add(productID);
    notifyListeners();
  }

  void deleteFromFavs(int productID) {
    _favs?.remove(productID);
    notifyListeners();
  }

  set user(User newUser) {
    this._user = newUser;
    notifyListeners();
  }

  void addAddress(Address address) {
    _addresses?.add(address);
    notifyListeners();
  }

  Area getAreaByID(int id) {
    return areas?.firstWhere((area) => area.id == id, orElse: () => null);
  }

  Area getAreaByName(String name) {
    return areas?.firstWhere((area) => area.name == name, orElse: () => null);
  }

  String getAreaNameByID(int areaID) {
    return getAreaByID(areaID)?.name ?? null;
  }

  void loadUserAddresses() {
    ApiService().getAddresses().then((value) {
      if (value != null) {
        _addresses = value.map((e) => Address.fromMap(e)).toList();
        if (_addresses.isNotEmpty) choosenAddress = _addresses.first;
        notifyListeners();
      }
    });
  }

  void loadAreas() {
    ApiService().getAreas().then((value) {
      if (value != null) {
        areas = value.map((e) => Area.fromMap(e)).toList();
        notifyListeners();
      }
    });
  }

  void loadFavs() {
    requestFavs = true;
    ApiService().getFavourites().then((value) {
      if (value != null) {
        _favs.addAll(value.map((e) => int.parse(e['product_id'])).toSet());
        notifyListeners();
      } else {
        requestFavs = false;
      }
    });
  }

  Future<void> checkIfKeepedLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    keepedLoggedIn = prefs.getBool('keep_login') ?? false;
    //print('keepedLoggedIn now  = $keepedLoggedIn');
    if (keepedLoggedIn) {
      //_user = await getUserFromCache();
      _user = User(
        id: prefs.getInt('uid'),
        name: prefs.getString('name'),
        avatar: prefs.getString('avatar'),
        phone: prefs.getString('phone'),
        token: prefs.getString('token'),
        // print('user came from cache'),
      );
      //print('user from cache: $_user');
      ApiService().token = _user?.token;
    }

    notifyListeners();
  }

  void cacheUser() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('uid', _user.id);
      prefs.setString('name', _user.name);
      prefs.setString('avatar', _user.avatar);
      prefs.setString('phone', _user.phone);
      prefs.setString('token', _user.token);
      // print('user was cached');
    });
  }

  Future<User> getUserFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    return User(
      id: prefs.getInt('uid'),
      name: prefs.getString('name'),
      avatar: prefs.getString('avatar'),
      phone: prefs.getString('phone'),
      token: prefs.getString('token'),
      // print('user came from cache'),
    );
  }

  void _setLoggedInTo(bool val) {
    SharedPreferences.getInstance().then(
      (SharedPreferences prefs) => prefs.setBool('keep_login', val),
    );
    // print('keepedLoggedIn now  = $val');
    keepedLoggedIn = val;
    notifyListeners();
  }

  void keepLoggedIn() => _setLoggedInTo(true);
  void cancelKeepLoggedIn() => _setLoggedInTo(false);

  void logout() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('keep_login', false);
      keepedLoggedIn = false;

      prefs.setInt('uid', null);
      prefs.setString('name', null);
      prefs.setString('avatar', null);
      prefs.setString('phone', null);
      prefs.setString('token', null);
      // print('user was deleted');
    });
    _user = null;
    _addresses = null;
    _favs.clear();
    verifiedPhoneNumber = null;
    notifyListeners();
  }
}
