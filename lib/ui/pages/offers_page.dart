import 'package:Bra7tk/services/all_translations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:Bra7tk/models/app_state_model.dart';
import 'package:Bra7tk/models/product.dart';
import 'package:Bra7tk/ui/res/colors.dart';
import 'package:Bra7tk/ui/widgets/product_card.dart';
import 'package:provider/provider.dart';

class OffersPage extends StatefulWidget {
  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  AppStateModel model;
  List<Product> seeAlso = [];
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    model = Provider.of<AppStateModel>(context, listen: false);
    if (model.offers == null || model.offers.isEmpty) {
      model.loadOffers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400], 
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        title: Text(
          allTranslations.translate('offers'),
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        leading: SizedBox(),
      ),
      body: RefreshIndicator(
        onRefresh: () async => model.loadOffers(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 50),
              Container(
                //color: primary,
                margin: const EdgeInsets.symmetric(vertical: 16),
                //width: double.infinity,
                //height: 400, //MediaQuery.of(context).size.width*1.2,
                child: Consumer<AppStateModel>(
                    builder: (BuildContext context, model, _) {
                  final List<dynamic> offers = model.offers;
                  if (offers == null || offers.isEmpty) {
                    return Container(
                      width: double.infinity,
                      height: 300,
                      child: Center(
                        child: offers == null
                            ? CircularProgressIndicator()
                            : Text(allTranslations.translate('offers_soon')),
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CarouselSlider(
                        items: offers
                            .take(5)
                            .map((e) => _buildCarouselItem(context, e))
                            .toList(),
                        options: CarouselOptions(
                            enlargeCenterPage: true,
                            aspectRatio: 8 / 9,
                            enableInfiniteScroll: false,
                            autoPlay: false,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (i, _) {
                              setState(() {
                                _selectedIndex = i;
                              });
                            }),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 150),
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: offers
                                .take(5)
                                .map((e) => offers.indexOf(e))
                                .map((i) => Container(
                                      margin: const EdgeInsets.only(
                                          top: 16, left: 4),
                                      width: 8,
                                      height: 8,
                                      child: SizedBox(),
                                      decoration: BoxDecoration(
                                        color: i == _selectedIndex
                                            ? primary
                                            : Colors.grey[200],
                                        shape: BoxShape.circle,
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  allTranslations.translate('see_also'),
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Builder(
                builder: (context) {
                  List<Product> listToShow = [];
                  if ((model.offers?.length ?? 0) > 5) {
                    listToShow.addAll(model.offers.sublist(5));
                    listToShow.addAll(model.products.take(10));
                  } else {
                    listToShow.addAll(model.products.take(10));
                  }
                  return Center(
                    //padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      direction: Axis.horizontal,
                      runAlignment: WrapAlignment.center,
                      runSpacing: 16,
                      spacing: 16,
                      children: listToShow.map((e) => ProductCard(e)).toList(),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 24,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, Product p) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ProductCard(p),
    );
  }
}
