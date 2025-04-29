import 'package:task_manager/bloc/task_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/task_bloc.dart';
import 'services/api_service.dart';
import 'views/task_list.dart';
import 'services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await requestNotification();
  NotificationService notificationService = NotificationService();
  await notificationService.initialize();
  runApp(MyApp(notificationService: notificationService,));
}

class MyApp extends StatelessWidget {
  final NotificationService notificationService;
  MyApp({required this.notificationService});

 @override
 Widget build(BuildContext context) {
   return MultiBlocProvider(
     providers: [
       BlocProvider(
         create: (context) => TaskBloc(ApiService())..add(LoadTasks()), // Initialize with LoadTasks event
       ),
     ],
     child: MaterialApp(
       debugShowCheckedModeBanner: false,
       title: "Flutter BLoC CRUD",
       theme: ThemeData(primarySwatch: Colors.blue),
       home: TaskList(notificationService: notificationService,),
     ),
   );
 }
}

Future<void> requestNotification() async {
  var status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
  }
}