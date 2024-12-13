package com.HealthGauge.models;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;

public class MotionInfoModel implements Serializable {
    String date;
    double calories;
    double distance;
    int step;
    List data;
    List calorieData;
    List distanceData;

    public List getCalorieData() {
        return calorieData;
    }

    public void setCalorieData(List calorieData) {
        this.calorieData = calorieData;
    }

    public List getDistanceData() {
        return distanceData;
    }

    public void setDistanceData(List distanceData) {
        this.distanceData = distanceData;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public double getCalories() {
        return calories;
    }

    public void setCalories(float calories) {
        this.calories = calories;
    }

    public double getDistance() {
        return distance;
    }

    public void setDistance(double distance) {
        this.distance = distance;
    }

    public int getStep() {
        return step;
    }

    public void setStep(int step) {
        this.step = step;
    }

    public List getData() {
        return data;
    }

    public void setData(List data) {
        this.data = data;
    }

    public HashMap toMap() {
        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("date", date);
        hashMap.put("calories", calories);
        hashMap.put("distance", distance);
        hashMap.put("step", step);
        hashMap.put("data", data);
        hashMap.put("caloriesData", calorieData);
        hashMap.put("distanceData", distanceData);
        return hashMap;
    }

    @Override
    public String toString() {
        return "MotionInfoModel{" +
                "date='" + date + '\'' +
                ", calories=" + calories +
                ", distance=" + distance +
                ", step=" + step +
                ", data=" + data +
                '}';
    }
}
