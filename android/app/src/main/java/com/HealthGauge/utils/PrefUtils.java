package com.HealthGauge.utils;

import android.content.Context;
import android.content.SharedPreferences;

import java.util.HashSet;
import java.util.Set;

/**
 * Created by john.francis on 16/12/15.
 */

public class PrefUtils {

    public  SharedPreferences sharedpreferences;// = getSharedPreferences("HealthGauge", Context.MODE_PRIVATE);

    public PrefUtils(Context context) {
        this.sharedpreferences = context.getSharedPreferences("HealthGauge", Context.MODE_PRIVATE);;
    }

    public  void setStringList(String key, Set<String> value){
        SharedPreferences.Editor editor = sharedpreferences.edit();
        editor.putStringSet(key, value);
        editor.apply();
    }
    public  void remove(String key){
        SharedPreferences.Editor editor = sharedpreferences.edit();
        editor.remove(key);
        editor.apply();
    }

    public  void setString(String key,String value){
        SharedPreferences.Editor editor = sharedpreferences.edit();
        editor.putString(key, value);
        editor.apply();
    }
    public  void setInt(String key,int value){
        SharedPreferences.Editor editor = sharedpreferences.edit();
        editor.putInt(key, value);
        editor.apply();
    }

    public  Set getStringList(String key){
        HashSet value  = (HashSet) sharedpreferences.getStringSet(key,null);
        return  value;
    }

    public  String getString(String key){
        String value  =  sharedpreferences.getString(key,null);
        return  value;
    }
    public  int getInt(String key){
        int value  =  sharedpreferences.getInt(key,-1);
        return  value;
    }
}