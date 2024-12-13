package com.HealthGauge.app;

import io.flutter.app.FlutterApplication;

/**
 * 开启并绑定服务
 * 注意！
 * 从SDK1.7开始，需要先重写以下两个方法，并调用“openBleService”方法，才能使用手环相关功能。
 * 如果使用极光推送之类的SDK，需要在Activity内调用该方法，当前Demo在SplashActivity里调用的。
 *
 * Open and bind the service
  note!
  Starting with SDK1.7, you need to override the following two methods and call the "openBleService" method to use the bracelet related functions.
  If you use an SDK such as Aurora Push, you need to call this method in the Activity, the current Demo is called in SplashActivity.
 */
public class MyFlutterApp extends FlutterApplication {
    public static MyApplication myApplication;
    @Override
    public void onCreate() {
        super.onCreate();
         myApplication = new MyApplication();
    }


}
