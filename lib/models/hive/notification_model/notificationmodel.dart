
import 'package:hive/hive.dart';
part 'notificationmodel.g.dart';

@HiveType(typeId: 0)
class NotificationModel extends HiveObject{


  @HiveField(0)
  String? timestamp;

  @HiveField(1)
  bool? isChecked;

  @HiveField(2)
  String? articleId;

  NotificationModel({this.timestamp, this.isChecked, this.articleId});
}