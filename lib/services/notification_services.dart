import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices{

  final notification = FlutterLocalNotificationsPlugin();
  bool _isInitilized = false;

  bool get isInitialized => _isInitilized;

  //Initializing the notification services
  Future<void> initializeNotification() async{

    const initializeAndroid = AndroidInitializationSettings('tasks');
    const initializeIos = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
        android: initializeAndroid,
        iOS: initializeIos
    );

    await notification.initialize(initializationSettings);
  }


  NotificationDetails notifictiondetails(){
    return const NotificationDetails(
        android: AndroidNotificationDetails('default_channel_Task', 'Notification Tasks ',
            importance: Importance.max,
            priority:Priority.high,
          playSound: true
        ),

        iOS: DarwinNotificationDetails()
    );
  }

  Future<void> showNotifications({
    int id = 0,
    String? title,
    String? body,

  }) async{
    return notification.show(id, title, body, notifictiondetails());
  }



  //ALARM NOTIFICATION
  Future<void> showAlarmNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'alarm_channel_id',
      'Alarm Channel',
      importance: Importance.max,
      priority: Priority.high,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('accept_action', 'Accept'),
        AndroidNotificationAction('reject_action', 'Reject'),
      ],
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await notification.show(
      1, // Unique ID for Alarm
      'Alarm Alert',
      'You have a scheduled alarm.',
      platformDetails,
      payload: 'alarm',
    );
  }

}