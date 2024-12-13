package com.HealthGauge.models;

import java.util.HashMap;
import java.util.List;

public class HeartInfoModel {

    private String date;
    private int sleepMaxHeart;
    private int sleepMinHeart;
    private int sleepAvgHeart;
    private int allMaxHeart;
    private int allMinHeart;
    private int allAvgHeart;
    private int newHeart;
    private List data;

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getSleepMaxHeart() {
        return sleepMaxHeart;
    }

    public void setSleepMaxHeart(int sleepMaxHeart) {
        this.sleepMaxHeart = sleepMaxHeart;
    }

    public int getSleepMinHeart() {
        return sleepMinHeart;
    }

    public void setSleepMinHeart(int sleepMinHeart) {
        this.sleepMinHeart = sleepMinHeart;
    }

    public int getSleepAvgHeart() {
        return sleepAvgHeart;
    }

    public void setSleepAvgHeart(int sleepAvgHeart) {
        this.sleepAvgHeart = sleepAvgHeart;
    }

    public int getAllMaxHeart() {
        return allMaxHeart;
    }

    public void setAllMaxHeart(int allMaxHeart) {
        this.allMaxHeart = allMaxHeart;
    }

    public int getAllMinHeart() {
        return allMinHeart;
    }

    public void setAllMinHeart(int allMinHeart) {
        this.allMinHeart = allMinHeart;
    }

    public int getAllAvgHeart() {
        return allAvgHeart;
    }

    public void setAllAvgHeart(int allAvgHeart) {
        this.allAvgHeart = allAvgHeart;
    }

    public int getNewHeart() {
        return newHeart;
    }

    public void setNewHeart(int newHeart) {
        this.newHeart = newHeart;
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
        hashMap.put("sleepMaxHeart", sleepMaxHeart);
        hashMap.put("sleepMinHeart", sleepMinHeart);
        hashMap.put("sleepAvgHeart", sleepAvgHeart);
        hashMap.put("allMaxHeart", allMaxHeart);
        hashMap.put("allMinHeart", allMinHeart);
        hashMap.put("allAvgHeart", allAvgHeart);
        hashMap.put("newHeart", newHeart);
        hashMap.put("data", data);
        return hashMap;
    }

    @Override
    public String toString() {
        return "HeartInfoModel{" +
                "date='" + date + '\'' +
                ", sleepMaxHeart=" + sleepMaxHeart +
                ", sleepMinHeart=" + sleepMinHeart +
                ", sleepAvgHeart=" + sleepAvgHeart +
                ", allMaxHeart=" + allMaxHeart +
                ", allMinHeart=" + allMinHeart +
                ", allAvgHeart=" + allAvgHeart +
                ", newHeart=" + newHeart +
                ", data=" + data +
                '}';
    }
}
