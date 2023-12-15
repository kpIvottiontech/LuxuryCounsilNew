

import 'package:shared_preferences/shared_preferences.dart';

import '../models/spotlight_listing_model.dart';

class GlobalData{
  static final GlobalData _instance = GlobalData._internal();

  factory GlobalData() {
    return _instance;
  }

  GlobalData._internal() {
    // initialization logic
  }

  int userId = 0;
  String firstName = '';
  String lastName = '';
  int subscriptionId = 0;
  int groupSubscriptionId = 0;
  List<SpotlightData> spotlightListing = [];

  Future<void> retrieveLoggedInUserDetail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getInt('app_user_id') ?? 0 ;
    subscriptionId = pref.getInt('subscription_id') ?? 0 ;
    groupSubscriptionId = pref.getInt('grp_subscription_id') ?? 0 ;
    print('groupSubscriptionId>>>>> ${groupSubscriptionId}');
    firstName = pref.getString('first_name') ?? '' ;
    lastName = pref.getString('last_name') ?? '' ;
    print('userId>>>>> ${userId} >> $firstName>>>> $lastName >>>> $subscriptionId >>>>> $groupSubscriptionId');
  }
}