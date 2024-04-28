import 'package:flutter/material.dart';
import 'package:food_delievery/utils/colors.dart';
import 'package:food_delievery/utils/textStyles.dart';
import 'package:sizer/sizer.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  List categories = [
    ['assets/categories/alcohol.png', 'Alcohol'],
    ['assets/categories/american.png', 'FastFood'],
    ['assets/categories/asian.png', 'Asiatica'],
    ['assets/categories/burger.png', 'Burgers'],
    ['assets/categories/carrebian.png', 'Platos típicos'],
    ['assets/categories/chinese.png', 'China'],
    ['assets/categories/convenience.png', 'Aseo'],
    ['assets/categories/dessert.png', 'Postres'],
    ['assets/categories/flower.png', 'Flores'],
    ['assets/categories/french.png', 'Francesa'],
    ['assets/categories/grocery.png', 'Mercado'],
    ['assets/categories/halal.png', 'Italiana'],
    ['assets/categories/icecream.png', 'Helados'],
    ['assets/categories/indian.png', 'India'],
    ['assets/categories/petSupplies.png', 'Mascotas'],
    ['assets/categories/ride.png', 'Viajes'],
    ['assets/categories/takeout.png', 'Domicilios'],
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          children: [
            SizedBox(
              height: 2.h,
            ),
            Text(
              'Todas las categorías',
              style: AppTextStyles.body16,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 3.h,
            ),
            GridView.builder(
                itemCount: categories.length,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.8,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                5.sp,
                              ),
                              color: greyShade3),
                          child: Image(
                            image: AssetImage(
                              categories[index][0],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                        categories[index][1],
                        style: AppTextStyles.small10Bold,
                      )
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}
