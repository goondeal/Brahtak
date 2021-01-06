import 'package:Bra7tk/services/all_translations.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:Bra7tk/services/api_stuff.dart';
import 'package:Bra7tk/services/user_repository.dart';
import 'package:Bra7tk/ui/pages/addresses_page.dart';
import 'package:Bra7tk/ui/pages/login_to_continue.dart';
import 'package:Bra7tk/ui/pages/order_sent.dart';
import 'package:Bra7tk/ui/widgets/loading_dialog.dart';
import 'package:Bra7tk/ui/widgets/wrong_data_dialog.dart';
import 'package:Bra7tk/models/app_state_model.dart';
import 'package:Bra7tk/models/product.dart';
import 'package:Bra7tk/ui/res/colors.dart';

const double _leftColumnWidth = 60.0;

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  AppStateModel model;
  UserRepository userRepo;
  final _couponController = TextEditingController();
  bool _addCoupon = false;

  @override
  void initState() {
    // Init super.
    super.initState();
    // Init the app state model.
    model = Provider.of<AppStateModel>(context, listen: false);
    // Init the user repository.
    userRepo = Provider.of<UserRepository>(context, listen: false);
  }

  List<Widget> _createShoppingCartRows(AppStateModel model) {
    return model.productsInCart.keys
        .map(
          (int id) => ShoppingCartRow(
              product: model.getProductById(id),
              quantity: model.productsInCart[id],
              remove: () {
                model.removeItemFromCart(id);
              },
              add: () {
                model.addProductToCart(id);
              }),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size.
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Container(
          child: Consumer<AppStateModel>(
            builder: (BuildContext context, AppStateModel model, Widget child) {
              return Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: _leftColumnWidth,
                            child: IconButton(
                              icon: const Icon(Icons.keyboard_arrow_down),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Text(
                            allTranslations.translate('cart'),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 16.0),
                          Text(
                            '${model.totalCartQuantity} ${allTranslations.translate('sold')}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Column(
                        children: _createShoppingCartRows(model),
                      ),
                      ShoppingCartSummary(model: model),
                      if (model.productsInCart.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.all(16),
                          width: double.infinity,
                          child: ListTile(
                            leading: RaisedButton(
                                color: primary,
                                padding: const EdgeInsets.all(8),
                                child: _addCoupon
                                    ? Text(
                                        allTranslations.translate('back'),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        allTranslations
                                            .translate('enter_coupon'),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                onPressed: () {
                                  setState(() {
                                    _addCoupon = !_addCoupon;
                                  });
                                }),
                            title: _addCoupon
                                ? TextField(
                                    style: const TextStyle(
                                      color: kTextColor,
                                      fontSize: 22,
                                    ),
                                    controller: _couponController,
                                    textAlignVertical: TextAlignVertical(y: 0),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: allTranslations
                                          .translate('enter_coupon'),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                          width: 1,
                                          style: BorderStyle.solid,
                                          color: kTextColor,
                                        ),
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                    onSubmitted: (text) async {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return LoadingDialog();
                                          });
                                      final discount = await ApiService()
                                          .storeCoupon(couponCode: text);
                                      if (discount != null) {
                                        model.couponDiscount = discount * 1.0;
                                        Navigator.of(context).pop();
                                      } else {
                                        Navigator.of(context).pop();
                                        showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (context) {
                                              return WrongDataDialog();
                                            });
                                      }
                                    },
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      const SizedBox(height: 100.0),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0.0,
                    right: 0.0,
                    child: Column(
                      children: <Widget>[
                        _prettyButton(
                            model, allTranslations.translate('clear_cart'),
                            (_) {
                          model.clearCart();
                          Future.delayed(Duration(milliseconds: 400), () {
                            Navigator.of(context).pop();
                          });
                        }),
                        const SizedBox(height: 8),
                        if (model.productsInCart.isNotEmpty)
                          Container(
                            width: double.infinity,
                            height: screenSize.height / 12,
                            color: primary,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (Provider.of<UserRepository>(
                                          context,
                                          listen: false,
                                        ).user ==
                                        null) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LoginToContinue(),
                                        ),
                                      );
                                    } else {
                                      print(Provider.of<UserRepository>(context,
                                              listen: false)
                                          .user);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => AddressesPage(),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: double.infinity,
                                    color: Colors.transparent,
                                    child: Text(
                                      userRepo.choosenAddress?.addressName ??
                                          allTranslations
                                              .translate('select_address'),
                                      overflow: TextOverflow.clip,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22.0,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (userRepo.choosenAddress == null) {
                                      Fluttertoast.showToast(
                                        msg: allTranslations
                                            .translate('plz_select_address'),
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    } else {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return LoadingDialog();
                                          });
                                      final idList =
                                          model.productsInCart.keys.toList();

                                      final List<Map<String, String>> details =
                                          idList
                                              .map(
                                                (e) => {
                                                  'name': model
                                                      .getProductById(e)
                                                      .name,
                                                  'id': e.toString(),
                                                  'quantity': model
                                                      .productsInCart[e]
                                                      .toString(),
                                                  'price': model
                                                      .getProductById(e)
                                                      .price
                                                      .toString(),
                                                },
                                              )
                                              .toList();
                                      ApiService()
                                          .addToCart(details)
                                          .then((value) {
                                        Navigator.of(context).pop();
                                        if (value) {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderSentPage(),
                                            ),
                                          );
                                          ApiService().checkout(
                                            userID: userRepo.user.id.toString(),
                                            address: userRepo.choosenAddress
                                                .toString(),
                                          );
                                          model.clearCart();
                                        } else {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (context) {
                                                return WrongDataDialog();
                                              });
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: double.infinity,
                                    color: Colors.transparent,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            allTranslations
                                                .translate('order_now'),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _prettyButton(AppStateModel model, String text, Function action) {
    return RaisedButton(
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(7.0),
        ),
      ),
      color: primary,
      splashColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      onPressed: () => action(model),
    );
  }
}

class ShoppingCartSummary extends StatelessWidget {
  const ShoppingCartSummary({this.model});

  final AppStateModel model;

  @override
  Widget build(BuildContext context) {
    final TextStyle smallAmountStyle = Theme.of(context).textTheme.bodyText2;
    final TextStyle largeAmountStyle =
        Theme.of(context).textTheme.headline4.copyWith(color: primary);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 4.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(allTranslations.translate('products_price')),
                    ),
                    Text(
                      model.subtotalCost.toStringAsFixed(2),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                if (model.couponDiscount != 0.0)
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(allTranslations.translate('coupon_value')),
                      ),
                      Text(model.couponDiscount.toString()),
                    ],
                  ),
                const SizedBox(height: 4.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(allTranslations.translate('delivery_cost')),
                    ),
                    Text(
                      model.shippingCost.toString(),
                      style: smallAmountStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(allTranslations.translate('total')),
                    ),
                    Text(
                      model.totalCost.toStringAsFixed(2),
                      style: largeAmountStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: _leftColumnWidth),
      ],
    );
  }
}

class ShoppingCartRow extends StatelessWidget {
  const ShoppingCartRow({
    @required this.product,
    @required this.quantity,
    this.remove,
    this.add,
  });

  final Product product;
  final int quantity;
  final VoidCallback remove;
  final VoidCallback add;

  @override
  Widget build(BuildContext context) {
    // final NumberFormat formatter = NumberFormat.simpleCurrency(
    //   decimalDigits: 0,
    //   //locale: Localizations.localeOf(context).toString(),
    // );
    final ThemeData localTheme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        key: ValueKey<int>(product.id),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: product.image,
                        fit: BoxFit.cover,
                        width: 75.0,
                        height: 75.0,
                        progressIndicatorBuilder: (context, text, _) =>
                            const CircularProgressIndicator(),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '${allTranslations.translate('quantity')}: $quantity',
                                  ),
                                ),
                                Text(' ${product.price.toStringAsFixed(2)}x'),
                              ],
                            ),
                            Text(
                              product.name,
                              style: localTheme.textTheme.subtitle1
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(color: primary, height: 10.0),
                ],
              ),
            ),
          ),
          SizedBox(
            width: _leftColumnWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: primary),
                  onPressed: remove,
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: primary),
                  onPressed: add,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
