// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// const int _notificationChannelId = 77777;

// final service = FlutterBackgroundService();
Future<void> initializeService() async {
  /// OPTIONAL, using custom notification channel id
  // const AndroidNotificationChannel channel = AndroidNotificationChannel(
  //   'ava_navigator_foreground', // id
  //   'AVA Navigator Foreground Service', // title
  //   description:
  //       'This channel is used for important notifications.', // description
  //   importance: Importance.low, // importance must be at low or higher level
  // );

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  if (Platform.isIOS) {
    // await flutterLocalNotificationsPlugin.initialize(
    //   const InitializationSettings(
    //       // iOS: IOSInitializationSettings(),
    //       ),
    // );
  }

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // await service.configure(
  //   androidConfiguration: AndroidConfiguration(
  //     // this will be executed when app is in foreground or background in separated isolate
  //     onStart: onStart,
  //
  //     // auto start service
  //     autoStart: true,
  //     isForegroundMode: true,
  //
  //     notificationChannelId: 'ava_navigator_foreground',
  //     initialNotificationTitle: 'AVA Navigator Foreground Service',
  //     initialNotificationContent: 'Initializing',
  //     foregroundServiceNotificationId: _notificationChannelId,
  //   ),
  //   iosConfiguration: IosConfiguration(
  //     // auto start service
  //     autoStart: true,
  //
  //     // this will be executed when app is in foreground in separated isolate
  //     onForeground: onStart,
  //
  //     // you have to enable background fetch capability on xcode project
  //     onBackground: onIosBackground,
  //   ),
  // );

  // service.startService();
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();
//
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   await preferences.reload();
//   final log = preferences.getStringList('log') ?? <String>[];
//   log.add(DateTime.now().toIso8601String());
//   await preferences.setStringList('log', log);
//
//   return true;
// }

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   await preferences.setString("hello", "world");
//
//   /// OPTIONAL when use custom notification
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });
//
//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }
//
//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });
//
//   // bring to foreground
//   Timer.periodic(const Duration(seconds: 10), (timer) async {
//     if (service is AndroidServiceInstance) {
//       if (await service.isForegroundService()) {
//         /// OPTIONAL for use custom notification
//         /// the notification id must be equals with AndroidConfiguration when you call configure() method.
//         flutterLocalNotificationsPlugin.show(
//           _notificationChannelId,
//           'AVA Walk Navigator',
//           publicWaypointDescription,
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//               'ava_navigator_foreground',
//               'AVA Navigator Foreground Service',
//               icon: 'ic_bg_service_small',
//               ongoing: true,
//             ),
//           ),
//         );
//
//         // if you aren't using custom notification, uncomment this
//         // service.setForegroundNotificationInfo(
//         //   title: "AVA Walk Navigator",
//         //   content: publicWaypointDescription,
//         // );
//       }
//     }
//
//     /// you can see this log in logcat
//     // print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
//
//     // test using external plugin
//     final deviceInfo = DeviceInfoPlugin();
//     String? device;
//     if (Platform.isAndroid) {
//       final androidInfo = await deviceInfo.androidInfo;
//       device = androidInfo.model;
//     }
//
//     if (Platform.isIOS) {
//       final iosInfo = await deviceInfo.iosInfo;
//       device = iosInfo.model;
//     }
//
//     service.invoke(
//       'update',
//       {
//         "current_date": DateTime.now().toIso8601String(),
//         "device": device,
//       },
//     );
//   });
// }

