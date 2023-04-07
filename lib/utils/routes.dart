import 'package:flutter/widgets.dart';
import 'package:solarex/first_phase/FirstHomeScreen/firstHomeScreen.dart';
import 'package:solarex/first_phase/screenUI/confirmation/confirm_meeting_screen.dart';
import 'package:solarex/first_phase/screenUI/feedback/feedback_screen.dart';
import 'package:solarex/first_phase/screenUI/findMeeting/meeting_screen.dart';
import 'package:solarex/first_phase/screenUI/home/home_screen.dart';
import 'package:solarex/first_phase/screenUI/introductionScreen/introduction_screen.dart';
import 'package:solarex/first_phase/screenUI/loader/loader_class.dart';
import 'package:solarex/first_phase/screenUI/profileScreen/profile_screen.dart';
import 'package:solarex/first_phase/screenUI/schedule/schedule_screen.dart';
import 'package:solarex/first_phase/screenUI/secondFeedback/second_feedback_screen.dart';
import 'package:solarex/first_phase/screenUI/secondSchedule/second_schedule_screen.dart';
import 'package:solarex/first_phase/screenUI/shareScreen/share_screen.dart';
import 'package:solarex/first_phase/screenUI/splash/splash_screen.dart';
import 'package:solarex/first_phase/screenUI/thirdSchedule/third_schedule_screen.dart';
import 'package:solarex/first_phase/screenUI/viewShareScreen/view_share_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  LoaderClass.routeName: (context) => LoaderClass(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  ConfirmMeetingScreen.routeName: (context) => const ConfirmMeetingScreen(),
  MeetingScreen.routeName: (context) => const MeetingScreen(),
  ScheduleScreen.routeName: (context) => const ScheduleScreen(),
  SecondScheduleScreen.routeName: (context) => const SecondScheduleScreen(),
  ThirdScheduleScreen.routeName: (context) => const ThirdScheduleScreen(),
  FeedbackScreen.routeName: (context) => const FeedbackScreen(),
  SecondFeedbackScreen.routeName: (context) => const SecondFeedbackScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  ShareScreen.routeName: (context) => const ShareScreen(),
  ViewShareScreen.routeName: (context) => const ViewShareScreen(),
  IntroductionScreen.routeName: (context) => const IntroductionScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  FirstHomeScreen.routeName: (context) => const FirstHomeScreen(),
};
