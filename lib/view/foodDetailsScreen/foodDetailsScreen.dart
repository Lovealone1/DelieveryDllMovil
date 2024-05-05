import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delievery/model/foodModel.dart';
import 'package:food_delievery/utils/colors.dart';
import 'package:food_delievery/utils/textStyles.dart';
import 'package:food_delievery/widgets/commonElevatedButton.dart';
import 'package:sizer/sizer.dart';

class FoodDetailsScreen extends StatefulWidget {
  const FoodDetailsScreen({super.key, required this.foodModel});
  final FoodModel foodModel;

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        quantity = 0;
      });
    });
  }

  int quantity = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: black,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 2.h,
        ),
        children: [
          SizedBox(
            height: 2.h,
          ),
          SizedBox(
            height: 23.h,
            width: 100.w,
            child: Image(
              image: NetworkImage(
                widget.foodModel.foodImageURL,
              ),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            widget.foodModel.name,
            style: AppTextStyles.body16Bold,
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            widget.foodModel.description,
            style: AppTextStyles.body14.copyWith(
              color: grey,
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Container(
            height: 6.h,
            width: 100.w,padding: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: BoxDecoration(
              color: green200,
              borderRadius: BorderRadius.circular(
                5.sp,
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Off ${(((int.parse(widget.foodModel.actualPrice) - int.parse(widget.foodModel.discountedPrice)) / int.parse(widget.foodModel.actualPrice)) * 100).round().toString()}%',
                  style: AppTextStyles.body14Bold.copyWith(color: black),
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
          ),
          SizedBox(
            height: 4.h,
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
                      if (quantity > 0) {
                        setState(() {
                          quantity -= 1;
                        });
                      } else {}
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
                    '\t\t $quantity \t\t',
                    style: AppTextStyles.body14Bold,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        quantity += 1;
                      });
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
              Column(
                children: [
                  Text('COP\$${widget.foodModel.actualPrice}',
                      style: AppTextStyles.body14.copyWith(
                          decoration: TextDecoration.lineThrough, color: grey)),
                  Text('COP\$${widget.foodModel.discountedPrice}',
                      style: AppTextStyles.body16Bold),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 4.h,
          ),
          CommonElevatedButton(
            // ignore: sort_child_properties_last
            child: Text(
              'Agregar al carrito',
              style: AppTextStyles.body14Bold.copyWith(color: black),
            ),
            onPressed: () {},
            color: white,
          ),
          SizedBox(
            height: 2.h,
          ),
          CommonElevatedButton(
            // ignore: sort_child_properties_last
            child: Text(
              'Ordenar ahora',
              style: AppTextStyles.body14Bold.copyWith(color: white),
            ),
            onPressed: () {},
            color: black,
          ),
        ],
      ),
    ));
  }
}
