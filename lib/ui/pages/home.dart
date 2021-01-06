import 'package:Bra7tk/services/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import 'package:Bra7tk/models/app_state_model.dart';
import 'package:Bra7tk/models/category.dart';
import 'package:Bra7tk/services/user_repository.dart';
import 'package:Bra7tk/ui/pages/addresses_page.dart';
import 'package:Bra7tk/ui/pages/favs_page.dart';
import 'package:Bra7tk/ui/pages/login_to_continue.dart';
import 'package:Bra7tk/ui/pages/offers_page.dart';
import 'package:Bra7tk/ui/pages/products_page.dart';
import 'package:Bra7tk/ui/pages/profile.dart';
import 'package:Bra7tk/ui/pages/shopping_cart_page.dart';
import 'package:Bra7tk/ui/res/colors.dart';
import 'package:Bra7tk/ui/widgets/drawer.dart';
import 'package:Bra7tk/ui/widgets/product_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  AppStateModel model;
  List<Widget> pages = [
    // home
    Home(),
    // offers
    OffersPage(),
    // favs
    Favouritespage(),
    // cart
    //ShoppingCartPage(),
    // addresses
    AddressesPage(),
    // profile
    ProfilePage(),
  ];

  int _selectedIndex = 0;
  // bool _searchIconClicked = false;

  // void _onItemTapped(int index) {
  //   if (index != _selectedIndex) {
  //     setState(() {
  //       _selectedIndex = index;
  //     });
  //   }
  // }

  @override
  void initState() {
    // Init super.
    super.initState();
    // Init tha app state model.
    model = Provider.of<AppStateModel>(context, listen: false);
    final products = model.products;
    // Get the products from the api if not yet exist.
    if (!model.requestingProducts && (products == null || products.isEmpty)) {
      model.loadProducts();
    }
    // Init the default selected index to be 0.
    _selectedIndex = 0;
    // Init user repository and load the user favs asyncroneously.
    final userRepo = Provider.of<UserRepository>(context, listen: false);
    if (userRepo.user != null &&
        (!userRepo.requestFavs || userRepo.favs.isEmpty)) {
      userRepo.loadFavs();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size.
    final screenSize = MediaQuery.of(context).size;
    // Set the width of the product card.
    final productCardWidth = screenSize.width * 0.40;

    return Scaffold(
      key: _key,
      backgroundColor: Colors.grey[200],
      // Drawer Settings
      drawer: HomeDrawer(),
      drawerEdgeDragWidth: screenSize.width / 5,
      drawerEnableOpenDragGesture: true,
      // AppBar stuff.
      appBar: AppBar(
        title: Text(
          allTranslations.translate('go_shopping'),
          style: const TextStyle(color: kTextColor, fontSize: 22.0),
        ),
        // _searchIconClicked
        //     // Search Text Field
        //     ? Container(
        //         margin: const EdgeInsets.symmetric(horizontal: 16.0),
        //         decoration: BoxDecoration(
        //           boxShadow: [
        //             BoxShadow(
        //               color: Colors.grey[400],
        //               blurRadius: 32.0,
        //               spreadRadius: 2.0,
        //             )
        //           ],
        //         ),
        //         width: double.infinity,
        //         height: 30, //screenSize.height * 0.08,
        //         child: TextField(
        //           autofocus: true,
        //           style: TextStyle(
        //             color: kTextColor,
        //             fontSize: 22,
        //           ),
        //           controller: null,
        //           textAlignVertical: TextAlignVertical(y: 0),
        //           decoration: InputDecoration(
        //             contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
        //             hintText: SEARCH_HERE,
        //             border: OutlineInputBorder(
        //               borderRadius: BorderRadius.circular(25.0),
        //               borderSide: BorderSide(
        //                 width: 0,
        //                 style: BorderStyle.none,
        //               ),
        //             ),
        //             fillColor: kSearchBarColor,
        //             filled: true,
        //           ),
        //           onChanged: (text) {}, //onTextChanged,
        //         ),
        //       )
        //     // App Title
        //     : Text(
        //         APP_TITLE,
        //         style: TextStyle(
        //           color: kTextColor,
        //           fontSize: 22.0,
        //         ),
        //       ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: kTextColor),
          onPressed: () {
            _key.currentState.openDrawer();
          },
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Consumer<AppStateModel>(
                builder: (context, model, _) {
                  if (model.totalCartQuantity > 0) {
                    return Container(
                      width: 24,
                      height: 24,
                      //padding: const EdgeInsets.all(8),
                      child: Center(
                          child: Text(
                        '${model.totalCartQuantity}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.black),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ShoppingCartPage();
                  }));
                },
              ),
            ],
          ),
        ],
      ),

      /* ---------- Main Body ------------ */
      body: RefreshIndicator(
        onRefresh: () async => model.loadProducts(),
        child: Consumer<AppStateModel>(builder: (context, model, _) {
          if (model.products == null || model.products.isEmpty) {
            return SingleChildScrollView(
              child: Container(
                width: screenSize.width,
                height: screenSize.height,
                child: Center(
                  child: model.products == null
                      ? const CircularProgressIndicator()
                      : Text(allTranslations.translate('no_products_now')),
                ),
              ),
            );
          }

          // if (model.products.isEmpty) {
          //   return SingleChildScrollView(
          //     child: Container(
          //       width: screenSize.width,
          //       height: screenSize.height,
          //       child: Center(
          //         child: Text('لا يوجد منتجات فى الوقت الحالى'),
          //       ),
          //     ),
          //   );
          // }

          return SingleChildScrollView(
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Horizontal Listview container
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 24.0,
                        left: 24.0,
                        top: 8.0,
                      ),
                      child: Text(
                        allTranslations.translate('recommended_for_you'),
                        style:
                            const TextStyle(color: kTextColor, fontSize: 20.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    // The Horizontal ListView
                    Container(
                      //margin: const EdgeInsets.only(top: 24.0),
                      height: productCardWidth * 2,
                      width: double.infinity,
                      child: model.featuredProducts == null
                          ? Center(child: CircularProgressIndicator())
                          : model.featuredProducts.isEmpty
                              ? Center(
                                  child: Text(
                                    allTranslations.translate('products_soon'),
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: model.featuredProducts.length,
                                  separatorBuilder: (context, i) =>
                                      const SizedBox(width: 8),
                                  itemBuilder: (context, i) =>
                                      ProductCard(model.featuredProducts[i]),
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.all(8.0),
                                ),
                    ),
                  ],
                ),

                // Categories Section
                Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  child: Text(
                    allTranslations.translate('categories'),
                    style: const TextStyle(color: kTextColor, fontSize: 22),
                    textAlign: TextAlign.start,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: model.availableCategories
                          ?.map((c) =>
                              _buildCategorySection(c, screenSize.height / 3))
                          ?.toList() ??
                      [
                        Container(
                          height: 300,
                          child: const Center(
                            child: const CircularProgressIndicator(),
                          ),
                        ),
                      ],
                ),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.ltr,
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedItemColor: primary,
          unselectedItemColor: kTextColor2,
          items: [
            // Home
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: allTranslations.translate('home'),
            ),

            // Offers
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/offer.png',
                alignment: Alignment.center,
                scale: 20,
                color: Colors.grey[700],
              ),
              // Icon(
              //   Icons.wb_sunny,
              //   // color: primary,
              // ),
              label: allTranslations.translate('offers'),
            ),

            // Favs
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite),
              // Stack(
              //   children: [
              //     Icon(
              //       Icons.favorite,
              //       // color: primary,
              //     ),
              //     Consumer<AppStateModel>(
              //       builder: (conrext, model, _) {
              //         if (model.productsInCart.isEmpty) {
              //           return SizedBox();
              //         }
              //         return Align(
              //           alignment: Alignment.topCenter,
              //           child: Container(
              //             padding: const EdgeInsets.all(2),
              //             color: Colors.white,
              //             child: model.totalCartQuantity > 99
              //                 ? Text(
              //                     '+99',
              //                     style: TextStyle(color: primary),
              //                   )
              //                 : Text(
              //                     model.totalCartQuantity.toString(),
              //                     style: TextStyle(color: primary),
              //                   ),
              //           ),
              //         );
              //       },
              //     ),
              //   ],
              // ),
              //title: Text('Cart'),
              label: allTranslations.translate('fav'),
            ),

            // Addresses
            BottomNavigationBarItem(
              icon: const Icon(Icons.library_books),
              label: allTranslations.translate('addresses'),
            ),

            // Profile
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: allTranslations.translate('profile'),
            ),
          ],

          //backgroundColor: Colors.black,
          elevation: 4.0,
          currentIndex: _selectedIndex,
          onTap: (index) {
            if (index != _selectedIndex) {
              navigateTo(pages[index], force: index == 1);
            }
          },
        ),
      ),
    );
  }

  void navigateTo(Widget page, {force = false}) {
    if (force) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              Provider.of<UserRepository>(context).user == null
                  ? LoginToContinue()
                  : page,
        ),
      );
    }
  }

  // List<Widget> _buildItems(List<Product> products, double width) {
  //   if (products == null || products.isEmpty) {
  //     return [
  //       Center(
  //         child: CircularProgressIndicator(),
  //       )
  //     ];
  //   }
  //   return products
  //       .map((product) => Container(
  //             width: width,
  //             height: double.infinity,
  //             color: Colors.grey[200],
  //             child: ProductCard(product),
  //           ))
  //       .toList();
  // }

  Container _buildCategorySection(Category category, double height) {
    return Container(
      width: double.infinity,
      height: height,
      margin: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 16.0),
      child: Material(
        animationDuration: Duration(milliseconds: 200),
        elevation: 4.0,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderOnForeground: true,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: kBackgroundColor2,
          autofocus: true,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductsPage(category: category),
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: category.image.toString(),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    repeat: ImageRepeat.noRepeat,
                    // imageBuilder: (context, imageProvider) => Container(
                    //   decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //       image: imageProvider,
                    //       fit: BoxFit.cover,
                    //       alignment: Alignment.center,
                    //       repeat: ImageRepeat.noRepeat,
                    //     ),
                    //   ),
                    // ),
                    placeholder: (context, url) => Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  category.name,
                  style: const TextStyle(color: kTextColor2, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
