import 'dart:io';


import 'package:flutter/material.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/screens/ratchart.dart';


class RatingAndReviewScreen extends StatefulWidget {
  const RatingAndReviewScreen({Key? key}) : super(key: key);

  @override
  State<RatingAndReviewScreen> createState() => _RatingAndReviewScreenState();
}

class _RatingAndReviewScreenState extends State<RatingAndReviewScreen> {
  bool value = false;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey,
     
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 200,),
            Container(
              height: 105,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Text(
                            "4.3",
                            style: TextStyle(
                                color: AppColor.white, fontSize: 44),
                          ),
                          Text(
                            "23 ratings",
                            style: TextStyle(
                                color: AppColor.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(child: RatingChartRow(label: 5, pct: 12)),
                          Expanded(child: RatingChartRow(label: 4, pct: 5)),
                          Expanded(child: RatingChartRow(label: 3, pct: 4)),
                          Expanded(child: RatingChartRow(label: 2, pct: 2)),
                          Expanded(child: RatingChartRow(label: 1, pct: 1)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
         
            
          ],
        ),
      ),
     
    );
  }
}