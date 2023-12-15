
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../colors.dart';
import '../config/utils.dart';
import '../models/spotlight_listing_model.dart';
import '../widgets/app_loader.dart';

class BottomViewWidget extends StatelessWidget{
  final SpotlightData data;
  const BottomViewWidget({super.key,required this.data});

  @override
  Widget build(BuildContext context) {
   return Container(
     width: MediaQuery.of(context).size.width,
     height: MediaQuery.of(context).size.height / 7,
     decoration: BoxDecoration(
         color: AppColor.black
     ),
     child: GestureDetector(
       onTap: (){
         Get.toNamed("/SpotlightMember", arguments: [
           data.spotlightMemberId
         ]);
       },
       child: Container(
         width: MediaQuery.of(context).size.width,
         margin: EdgeInsets.symmetric(
             horizontal: 10, vertical: 10),
         child: Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             CachedNetworkImage(fit: BoxFit.cover,
               imageUrl:data.spotlightMemberCompanyLogoLink ??'',
               placeholder: (context, url) =>
               const AppLoader(type: LoaderType.activityIndicator),
               errorWidget: (context, url, error) => const Icon(Icons.error),
               width: AspectSize.getWidthSize(
                   context: context, sizeConstant: 115),
               height:AspectSize.getWidthSize(
                   context: context, sizeConstant: 100),
             ),
             SizedBox(width: 18,),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Container(
                   child: Text(
                      data.spotlightMemberContactName??'',
                     style: TextStyle(
                         color: AppColor.white,
                         fontWeight: FontWeight.bold,
                         fontSize: 14),
                   ),
                 ),
                 Container(
                   margin: EdgeInsets.only(top: 5),
                   width: 200,
                   child: Text(data.spotlightMemberCompanyShortDescription??'',
                     maxLines: 2,
                     overflow: TextOverflow.ellipsis,
                     style: TextStyle(
                         color:
                         AppColor.white,
                         fontSize: 12),
                   ),
                 ),
                 Container(
                   height: 25,
                   width: 90,
                   margin: EdgeInsets.only(top: 10),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(15),
                     color: AppColor.primarycolor,
                   ),
                   child: Center(
                     child: GestureDetector(
                       child: Text(
                         'Learn more',
                         style: TextStyle(
                             color: AppColor.black,
                             fontSize: 12),
                       ),
                     ),
                   ),
                 )
               ],
             )
           ],
         ),
       ),
     ),
   );
  }

}