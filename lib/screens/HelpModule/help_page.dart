import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/HelpModule/help_item.dart';
import 'package:health_gauge/screens/HelpModule/help_item_model.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class HelpPage extends StatelessWidget {
  HelpPage({super.key});

  final List<HelpItemModel> helpItems = [
    HelpItemModel(
      title: 'Login',
      detail:
          'Login into the application. Normally users log into the mobile application and stay logged in unless they log out or stop the application.',
      image: 'asset/HelpImages/help_login.png',
    ),
    HelpItemModel(
      title: 'Sign Up',
      detail:
          'Users can use this page to register for an account. Once an account is created, the profile information for the account is stored locally but synchronized with the Health Gauge server. Note that the application can still be used without an account, but no data will be saved.',
      image: 'asset/HelpImages/help_sign_up.png',
    ),
    HelpItemModel(
      title: 'Reset Password',
      detail: 'Users can request a password reset.',
      image: 'asset/HelpImages/help_reset_password.png',
    ),
    HelpItemModel(
      title: 'Home',
      detail:
          'The Home page is consisted of a navigation bar (at the bottom), a hamburger menu as well as a simple dashboard displaying the top metrics of the day. The bottom navigation bar remains visible for most activities. The navigation bar supports immediate access to Home, AI PrecisionPulse Measurements and Graphs. The home page also allows users to access their Profile, Settings, Measurements, Terms and conditions and log out functionality from the hamburger menu. In the graphical section of the home dashboard users can see their health and wellness metrics including AI PrecisionPulse Measurements, Heart Rate, Heart Rate Variability and their Weight information.',
      image: 'asset/HelpImages/help_home.jpg',
    ),
    HelpItemModel(
      title: 'Profile',
      detail:
          'User profile data stores the user’s picture, name, id, birthdate, height, weight, gender and skin color. This data is synchronized with the web server. Valid data is essential for the AI PrecisionPulse estimates since this data is used by the AI models to generate a personalized estimate.',
      image: 'asset/HelpImages/help_profile.png',
    ),
    HelpItemModel(
      title: 'Settings',
      detail:
          'The settings page allows the user to access unit settings, device settings, Researchers profile (used for activating the AI PrecisionPulse functionality), synchronization (to synchronize the users data from the servers in case it does not happen automatically), and language setting.',
      image: 'asset/HelpImages/help_settings.jpg',
    ),
    HelpItemModel(
      title: 'AI PrecisionPulse',
      detail:
          'This page allows users to take an AI PrecisionPulse measurement using Health Gauge\'s Phoenix+Fit smartwatch. Once the START MEASUREMENT button is pressed, users have to hold their finger on the ECG sensor located on the lower right corner of the watch for the duration of the measurement, then remove their finger once the measurement is finished and wait for an estimates. (NOTE: All the data provided by AI Precision Pulse Measurements are intended for information purposes only, is not medical data or intended for medical use or purposes and shall not be treated that way, Users should always consult with a medical professional before taking any action).',
      image: 'asset/HelpImages/help_ai_precision_pulse.png',
    ),
    HelpItemModel(
      title: 'Graph',
      detail:
          'The Graph page is consisted of three graphs that provide users information about their systolic/diastolic readings captured from the AI PrecisionPulse measurement, the number of AI PrecisionPulse Measurements taken, the average Systolic and Diastolic values based on daily measurements and Heart Rate information including their Heart Rate captured at the time of measurements, Resting Heart Rate, Lowest Resting Heart Rate and their Heart Rate Variability.',
      image: 'asset/HelpImages/help_graph.png',
    ),
    HelpItemModel(
      title: 'Measurements',
      detail:
          'This section is available in the hamburger menu located on the top left corner of the home page. Users can view their AI PrecisionPulse measurements, Heart Rate and BP Trend Estimates in day, week, or month groupings.',
      image: 'asset/HelpImages/help_measurements.png',
    ),
    HelpItemModel(
      title: 'Heart Rate',
      detail:
          'This section is available in the hamburger menu located on the top left corner of the home page. Users can view their Heart Rate data captured every 5 minutes by the smartwatch in a list or graphical format. List view can be accessed using the clock icon located on the top right corner of the Heart Rate page.',
      image: 'asset/HelpImages/help_heart_rate.jpeg',
    ),
    HelpItemModel(
      title: 'BP Trend Estimates',
      detail:
          'This section is available in the hamburger menu located on the top left corner of the home page. Users can view their BP Trend Estimates captured every 5 minutes by the smartwatch in a list format.',
      image: 'asset/HelpImages/help_bp_trend_estimate.png',
    ),
    HelpItemModel(
      title: 'More Functions',
      detail: '',
      image: '',
      listInfo: [
        HelpItemModel(
          title: 'Find Bracelet',
          detail:
              'This functionality is located within the Bluetooth page that can be found on the top right corner of the Home dashboard. It can be used to locate the smartwatch and confirm Bluetooth connection.',
          image: 'asset/HelpImages/help_find_bracelet.png',
        ),
        HelpItemModel(
          title: 'Lift the wrist to brighten screen',
          detail:
              'Switch off or on the ability for the device to light up when the device is raised.',
          image: 'asset/HelpImages/help_lift_wrist.png',
        ),
        HelpItemModel(
          title: 'Time Format',
          detail: 'Time can be displayed on the device in 12 or 24 hour time format.',
          image: 'asset/HelpImages/help_time_format.png',
        ),
        HelpItemModel(
          title: 'Wearing Method',
          detail:
              'Indicates whether to wear the device on the left or right hand. Functionality is the same, however, the ECG signals are inverted on the right wrist.',
          image: 'asset/HelpImages/help_wearing_method.png',
        ),
        HelpItemModel(
          title: 'Smartwatch Factory Reset',
          detail: 'Will revert the watch back to its original factory settings.',
          image: 'asset/HelpImages/help_factory_reset.png',
        ),
        HelpItemModel(
          title: 'Smartwatch Shutdown',
          detail: 'Will switch the smartwatch off.',
          image: 'asset/HelpImages/help_factory_shutdown.png',
        ),
        HelpItemModel(
          title: 'Calibration',
          detail:
              'This functionality is used to Calibrate the smartwatch ensuring a more accurate AI PrecisionPulse estimate, it is important to provide valid callibration data as it has a direct impact on the AI PrecisionPulse estimate. Calibration can be done using the button located on the top right corner of the AI PrecisionPulse page.',
          image: 'asset/HelpImages/help_calibration.jpeg',
        ),
        HelpItemModel(
          title: 'Passive data monitoring',
          detail:
              'The smartwatch captures passive Heart Rate and BP Trend estimates every 5 minutes by default. This functionality can be disabled at any time using the device settings menu and then deactivating the toggles for HR and BP Monitoring located in that page.',
          image: 'asset/HelpImages/help_passive_tracking.jpeg',
          showDivider: false,
        ),
      ],
      showDivider: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.5)
                    : HexColor.fromHex('#384341').withOpacity(0.2),
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              ),
            ],
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColor.darkBackgroundColor
                : AppColor.backgroundColor,
            title: TitleText(
              text: StringLocalization.of(context).getText(StringLocalization.help),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HexColor.fromHex('62CBC9'),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20.0.h,
          ),
          Center(
            child: TitleText(
              text: 'Health Gauge Overview',
              fontSize: 18.0,
              color: AppColor.primaryColor,
              fontWeight: FontWeight.w900,
              align: TextAlign.left,
              maxLine: 1,
            ),
          ),
          SizedBox(
            height: 5.0.h,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10.0.h,
              left: 10.0.h,
              right: 10.0.h,
            ),
            child: Text(
              'Health Gauge is a platform for health and wellness monitoring. Users of the platform include the general public interested in health and wellness, care providers working with users, researchers that access the data in order to develop and deliver analytics, and business partners the provide goods and services to the Health Gauge community of users.\n\nThe components of Health Gauge mobile application include the following:',
              style: TextStyle(
                fontSize: 13.0,
                color: AppColor.primaryColor,
              ),
              maxLines: 17,
              textAlign: TextAlign.justify,
            ),
          ),
          ListView.builder(
            itemCount: helpItems.length,
            padding: EdgeInsets.symmetric(vertical: 15.0.h, horizontal: 10.0.h),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              var helpItem = helpItems.elementAt(index);
              return HelpItem(
                helpItemModel: helpItem,
                indexNumber: '${index + 1}',
              );
            },
          ),
        ],
      ),
    );
  }
}
