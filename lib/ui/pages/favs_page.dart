import 'package:Bra7tk/services/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:Bra7tk/models/app_state_model.dart';

import 'package:Bra7tk/services/user_repository.dart';
import 'package:Bra7tk/ui/res/colors.dart';
import 'package:Bra7tk/ui/widgets/product_card.dart';
import 'package:provider/provider.dart';

class Favouritespage extends StatefulWidget {
  @override
  _FavouritespageState createState() => _FavouritespageState();
}

class _FavouritespageState extends State<Favouritespage> {
  AppStateModel model;

  @override
  void initState() {
    // Init super.
    super.initState();
    // Init the app state model.
    model = Provider.of<AppStateModel>(context, listen: false);
    // Get user favs.
    final repo = Provider.of<UserRepository>(context, listen: false);
    repo.loadFavs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        title: Text(allTranslations.translate('fav')),
        centerTitle: true,
        leading: const SizedBox(),
      ),
      body: Consumer<UserRepository>(
        builder: (context, userRepo, _) {
          if (userRepo.favs == null || userRepo.favs.isEmpty) {
            return Center(
              child: userRepo.favs == null
                  ? const CircularProgressIndicator()
                  : Text(allTranslations.translate('no_favs_yet')),
            );
          }
          return GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            cacheExtent: 50,
            childAspectRatio: 8 / 15,
            children: userRepo.favs
                .map((productID) => Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      child: ProductCard(model.getProductById(productID)),
                    ))
                .toList(),
          );
        },
      ),
    );
  }

  // Widget _buildListItem(Product p) {
  //   return ListTile(
  //     leading: Container(
  //       width: 100,
  //       height: 100,
  //       decoration: BoxDecoration(
  //         image: DecorationImage(
  //           image: AssetImage(p.assetName),
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     ),
  //     title: Text(p.name),
  //     subtitle: Text(p.price.toString()),
  //     trailing: IconButton(
  //       icon: Icon(Icons.delete),
  //       onPressed: () {},
  //     ),
  //   );
  // return Row(
  //   children: [
  //     Container(
  //       width: 100,
  //       height: 100,
  //       decoration: BoxDecoration(
  //         image: DecorationImage(image: AssetImage(p.assetName), fit: BoxFit.cover,),

  //       ),

  //     ),
  //     Column(
  //       children: [
  //         Text(p.name),
  //         Text(p.price.toString()),
  //       ],

  //     ),

  //   ],
  // );
  //}
}
