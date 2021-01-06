import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:Bra7tk/models/Address.dart';
import 'package:Bra7tk/services/api_identifier.dart';

class ApiService {
  // Singleton Object.
  static final ApiService _apiService = ApiService._();

  factory ApiService() => _apiService;

  ApiService._();

  /**
   * please make your [api_identifier.dart] file with your custom api
   * stuff. mine is in .gitignore.
   */
  // The base api url which used in all requests.
  static const _baseUrl = BASE_URL;
  // access token
  String _token;

  set token(String newToken) {
    _token = newToken;
  }

  /// called when the user logout
  void deleteToken() {
    _token = null;
  }

  /// Used in requests that do not require authentication.
  Map<String, dynamic> get _nonAuthHeader => {'Accept': 'application/json'};

  /// Used in requests that do require authentication.
  Map<String, dynamic> get _authHeader => {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      };

  /// A helper method, which is considered the base function for all GET methods.
  /// (server for coming methods that use "GET" request)
  Future<dynamic> getResponse({String path, bool needsToken = true}) async {
    final dio = Dio();

    try {
      final response = await dio.getUri(Uri.parse('$_baseUrl$path'),
          options: Options(
            headers: needsToken ? _authHeader : _nonAuthHeader,
          ));
      var res;
      if (response.statusCode == 200) {
        res = response.data;
      }
      return res;
    } catch (e) {
      print(e.toString());
      return null;
    } finally {
      dio.close();
    }
  }

  /// A helper method, which is considered the base function for all POST methods.
  /// (server for coming methods that use "POST" request)
  Future<dynamic> postData({
    String path,
    dynamic data,
    needsToken = true,
  }) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        '$_baseUrl$path',
        data: data,
        options: Options(
          headers: needsToken ? _authHeader : _nonAuthHeader,
        ),
      );

      var res;
      if (response.statusCode == 200) {
        res = response.data;
      }
      print(response.statusCode);
      return res;
    } catch (e) {
      print(e.toString());
      return null;
    } finally {
      dio.close();
    }
  }

/* For all users (the request does not need an access token) */
  /// GET request: get all products.
  /// A client for "getResponse" method.
  Future<Map<String, dynamic>> getAllProducts() async {
    const String path = ALL_PRODUCTS;

    final result = await getResponse(
      path: path,
      needsToken: false,
    );
    return result; // could be null
  }

  /// GET request: get offer
  /// A client for "getResponse" method.
  Future<List<dynamic>> getOffers() async {
    const String path = OFFERS;
    final result = await getResponse(
      path: path,
      needsToken: false,
    );

    if (result == null) {
      return null;
    }

    final productsList = result['Products'];
    return productsList;
  }

  /* For a spesific user (needs access token) */

  /// GET request: get user Favourites
  /// A client for "getResponse" method.
  /// used by "UserRepository" class
  Future<List<dynamic>> getFavourites() async {
    const String path = FAVOURITES;

    final result = await getResponse(path: path);

    if (result == null) {
      return null;
    }

    final productsList = result['massage'];
    return productsList;
  }

  /// GET request: get User addresses
  /// A client for "getResponse" method.
  // used by "UserRepository" class
  Future<List<dynamic>> getAddresses() async {
    const String path = ADDRESSES;

    final result = await getResponse(path: path);

    if (result == null) {
      return null;
    }

    final addressesList = result['massage'];
    return addressesList;
  }

  /// GET request: get delivery fees for available areas.
  /// A client for "getResponse" method.
  Future<List<dynamic>> getAreas() async {
    const String path = AREA_FEE;

    final result = await getResponse(path: path);

    if (result == null) {
      return null;
    }

    final areasList = result['massage'];
    return areasList;
  }

  /// POST request: Register a new user
  /// A client for "postData" method.
  Future<Map<String, dynamic>> register({
    @required String name,
    @required String password,
    @required String phoneNumber,
  }) async {
    const String path = REGISTER;
    final formData = FormData.fromMap({
      'name': name,
      'password': password,
      'PhoneNumber': phoneNumber,
    });

    final result =
        await postData(path: path, data: formData, needsToken: false);

    return result; // could be null
  }

  /// POST request: Login user
  /// A client for "postData" method.
  Future<Map<String, dynamic>> login({
    @required String phoneNumber,
    @required String password,
  }) async {
    const String path = LOGIN;
    final formData = FormData.fromMap({
      'phone': phoneNumber,
      'password': password,
    });

    final result =
        await postData(path: path, data: formData, needsToken: false);

    return result; // could be null
  }

  /// POST request: enables the user to add address
  /// A client for "postData" method.
  Future<bool> addAddress(Address address) async {
    const String path = ADD_ADDRESS;

    final result = await postData(path: path, data: address.toMap);

    return result != null;
  }

  /// POST request: Add to Cart
  /// A client for "postData" method.
  Future<bool> addToCart(List<Map<String, String>> data) async {
    const String path = ADD_TO_CART;

    final result = await postData(path: path, data: data);

    return result != null;
  }

  /// POST request: AddOrDelete Fav
  /// A client for "postData" method.
  Future<bool> addToOrDeleteFromFav(int productId) async {
    const String path = ADD_FAV;

    final result =
        await postData(path: path, data: {'product_id': '$productId'});

    return result != null;
  }

  /// POST request Store Coupon
  /// A client for "postData" method.
  Future<int> storeCoupon({String couponCode}) async {
    const String path = STORE_COUPON;

    try {
      final result =
          await postData(path: path, data: {'coupon_code': couponCode});

      print('from storeCoupon: $result');
      return result['subTotal'];
    } catch (e) {
      return null;
    }
  }

  // Delete Coupon
  Future<bool> deleteCoupon({String couponCode}) async {
    const String path = DELETE_COUPON;

    final result =
        await postData(path: path, data: {'coupon_code': couponCode});

    print('from addToOrDeleteFromFav: $result');
    return result != null;
  }

  Future<bool> checkout({String userID, String address}) async {
    const String path = CHECKOUT;
    final formData = FormData.fromMap({
      'user_id': userID,
      'address': address,
    });

    final result = await postData(path: path, data: formData);

    print('from checkout: $result');
    return result != null;
  }
}
