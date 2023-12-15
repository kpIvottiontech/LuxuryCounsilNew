import 'package:flutter/services.dart';

class ImageShare {

  static const platform = MethodChannel('your_channel_name');

  static Future<void> shareImageToWhatsApp(String path) async {
    try {
      // Invoke the platform method 'shareImageToWhatsApp'
      final bool result = await platform.invokeMethod('shareImageToWhatsApp', {
        // Pass any necessary arguments like image data here if needed
        'imageData': path,
      });

      // Handle the result, if needed
      if (result) {
        // Sharing successful
        print('Image shared successfully');
      } else {
        // Sharing failed
        print('Image sharing failed');
      }
    } on PlatformException catch (e) {
      // Handle exceptions
      print('Error: ${e.message}');
    }
  }
}
