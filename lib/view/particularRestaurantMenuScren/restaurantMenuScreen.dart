import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delievery/controller/provider/restaurantProvider/restaurantProvider.dart';
import 'package:food_delievery/model/foodModel.dart';
import 'package:food_delievery/utils/colors.dart';
import 'package:food_delievery/utils/textStyles.dart';
import 'package:food_delievery/view/foodDetailsScreen/foodDetailsScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ParticularRestaurantMenuScreen extends StatefulWidget {
  const ParticularRestaurantMenuScreen(
      {super.key, required this.restaurantUID, required this.restaurantName});
  final String restaurantUID;
  final String restaurantName;

  @override
  State<ParticularRestaurantMenuScreen> createState() =>
      _ParticularRestaurantMenuScreenState();
}

class _ParticularRestaurantMenuScreenState
    extends State<ParticularRestaurantMenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantProvider>().emptyRestaurantMenu();
      context
          .read<RestaurantProvider>()
          .getRestaurantMenu(widget.restaurantUID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: black,
          ),
        ),
        title: Text(
          widget.restaurantName,
          style: AppTextStyles.body16Bold,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Consumer<RestaurantProvider>(
          builder: (context, restaurantProvider, child) {
        if (restaurantProvider.restaurantMenu.isEmpty) {
          return Center(
            child: Text(
              'No hay platillos para mostrar',
              style: AppTextStyles.body14Bold.copyWith(color: grey),
            ),
          );
        } else {
          return ListView.builder(
              itemCount: restaurantProvider.restaurantMenu.length,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                FoodModel foodData = restaurantProvider.restaurantMenu[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: FoodDetailsScreen(foodModel: foodData),
                            type: PageTransitionType.rightToLeft));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 1.5.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.sp),
                      border: Border.all(
                        color: black,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.sp),
                            image: DecorationImage(
                                image: NetworkImage(
                                  foodData.foodImageURL,
                                ),
                                fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          foodData.name,
                          style: AppTextStyles.body14Bold,
                        ),
                        SizedBox(
                          height: 0.5.h,
                        ),
                        Text(
                          foodData.description,
                          style: AppTextStyles.small12.copyWith(
                            color: grey,
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Off ${(((int.parse(foodData.actualPrice) - int.parse(foodData.discountedPrice)) / int.parse(foodData.actualPrice)) * 100).round().toString()}%',
                                  style: AppTextStyles.body14Bold,
                                ), SizedBox(width: 2.w,), FaIcon(FontAwesomeIcons.tag, color: success,)
                              ],
                            ),
                            Column(
                              children: [
                                Text('COP\$${foodData.actualPrice}',
                                    style: AppTextStyles.body14.copyWith(
                                        decoration: TextDecoration.lineThrough,
                                        color: grey)),
                                Text('COP\$${foodData.discountedPrice}',
                                    style: AppTextStyles.body16Bold),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        }
      }),
    ));
  }
}

class FoodProvider {}
