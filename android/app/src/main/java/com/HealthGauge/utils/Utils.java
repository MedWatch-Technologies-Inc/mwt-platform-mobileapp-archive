package com.HealthGauge.utils;

import android.content.Context;
import android.content.pm.PackageManager;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;

import java.math.RoundingMode;
import java.text.DecimalFormat;


public class Utils {


    public static void MyLog(String tag, String msg) {
        System.out.println("MyLog:" + tag + "->" + msg);
    }

    public static String GetFormat(int length, float value) {

        DecimalFormat df = new DecimalFormat();
        df.setMaximumFractionDigits(length);
        df.setGroupingSize(0);
        df.setRoundingMode(RoundingMode.FLOOR);
        return df.format(value);

    }

    public static String item_sport_target[] = {
            "1000",
            "2000",
            "3000",
            "4000",
            "5000",
            "6000",
            "7000",
            "8000",
            "9000",
            "10000",
            "11000",
            "12000",
            "13000",
            "14000"};

    public static boolean hasPermissions(@NonNull Context context, @NonNull String... permissions) {
        for (String permission : permissions) {
            if (ActivityCompat.checkSelfPermission(context, permission) != PackageManager.PERMISSION_GRANTED) {
                return false;
            }
        }
        return true;
    }

    public static boolean isAllPermissionGranted(int[] grantResults) {
        if (grantResults.length != 0) {
            for (int element : grantResults) {
                if (element != PackageManager.PERMISSION_GRANTED) {
                    return false;
                }
            }
        }
        return true;
    }
}
