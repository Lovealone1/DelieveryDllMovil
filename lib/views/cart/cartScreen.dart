

import 'package:covefood_users/constant/constant.dart';
import 'package:covefood_users/controller/provider/itemOrderProvider/itemOrderProvider.dart';
import 'package:covefood_users/controller/provider/profileProvider/profileProvider.dart';
import 'package:covefood_users/controller/services/fetchRestaurantsServices/fetchRestaurantServices.dart';
import 'package:covefood_users/controller/services/foodOrderServices/foodOrderServices.dart';
import 'package:covefood_users/model/foodModel.dart';
import 'package:covefood_users/model/foodOrderModel.dart';
import 'package:covefood_users/model/restaurantModel.dart';
import 'package:covefood_users/utils/colors.dart';
import 'package:covefood_users/utils/textStyles.dart';
import 'package:covefood_users/widget/commonElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<ItemOrderProvider>().fetchCartItems();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Items del carrito',
            style: AppTextStyles.body18Bold,
          ),
        ),
        body: Consumer<ItemOrderProvider>(
          builder: (context, itemOrderProvider, child) {
            if (itemOrderProvider.cartItems.isEmpty) {
              return Center(
                child: Text(
                  'Agrega platillos al carrtito',
                  style: AppTextStyles.body14Bold,
                ),
              );
            } else {
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  itemCount: itemOrderProvider.cartItems.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    FoodModel foodData = itemOrderProvider.cartItems[index];
                    return Container(
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
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  FaIcon(
                                    FontAwesomeIcons.tag,
                                    color: success,
                                  )
                                ],
                              ),
                              Text('COP\$${foodData.actualPrice}',
                                  style: AppTextStyles.body14.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: grey)),
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      //if (quantity > 0) {
                                      //setState(() {
                                      //quantity -= 1;
                                      //});
                                      //} else {}
                                      FoodOrderServices.updateQuantity(
                                          foodData.orderID!,
                                          foodData.quantity!,
                                          context,
                                          false);
                                    },
                                    child: Container(
                                      height: 3.h,
                                      width: 3.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          3.sp,
                                        ),
                                        border: Border.all(color: black),
                                      ),
                                      child: FaIcon(
                                        FontAwesomeIcons.minus,
                                        size: 2.h,
                                        color: black,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '\t\t ${foodData.quantity} \t\t',
                                    style: AppTextStyles.body14Bold,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      FoodOrderServices.updateQuantity(
                                          foodData.orderID!,
                                          foodData.quantity!,
                                          context,
                                          true);
                                      //setState(() {
                                      //quantity += 1;
                                      //});
                                    },
                                    child: Container(
                                      height: 3.h,
                                      width: 3.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          3.sp,
                                        ),
                                        border: Border.all(color: black),
                                      ),
                                      child: FaIcon(
                                        FontAwesomeIcons.plus,
                                        size: 2.h,
                                        color: black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                  'COP\$${int.parse(foodData.discountedPrice) * foodData.quantity!}',
                                  style: AppTextStyles.body16Bold),
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          CommonElevatedButton(
                              onPressed: () async {
                                RestaurantModel restaurantData = await RestaurantServices.fetchResturantData(foodData.restaurantUID);
                                String orderID = uuid.v1();
                                FoodOrderModel foodOrderData = FoodOrderModel(
                                  foodDetails: foodData,
                                  restaurantDetails: restaurantData,
                                  userAddress: context.read<ProfileProvider>().activeAddress,
                                  userData: context.read<ProfileProvider>().userData,
                                  orderID: orderID,
                                  orderStatus: FoodOrderServices.orderStatus(0),
                                  orderPlacedAt: DateTime.now(),
                                  //orderDelieveredAt: orderDelieveredAt,
                                );
                                FoodOrderServices.placeFoodOrderRequest(
                                    foodOrderData, context);
                              },
                              color: black,
                              child: Text(
                                'Ordenar Ahora',
                                style: AppTextStyles.body14Bold
                                    .copyWith(color: white),
                              ))
                        ],
                      ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
