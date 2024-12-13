package com.HealthGauge.models;

import java.util.HashMap;

public class DeviceInfoModel {
    int power;
    int type;
    String device_number;
    String device_name;

    public int getPower() {
        return power;
    }

    public void setPower(int power) {
        this.power = power;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getDevice_number() {
        return device_number;
    }

    public void setDevice_number(String device_number) {
        this.device_number = device_number;
    }

    public String getDevice_name() {
        return device_name;
    }

    public void setDevice_name(String device_name) {
        this.device_name = device_name;
    }

    @Override
    public String toString() {
        return "DeviceInfoModel{" +
                "power=" + power +
                ", type=" + type +
                ", device_number='" + device_number + '\'' +
                ", device_name='" + device_name + '\'' +
                '}';
    }

    public HashMap toMap(){
        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("power",power);
        hashMap.put("type",type);
        hashMap.put("device_number",device_number);
        hashMap.put("device_name",device_name);
        return  hashMap;
    }
}
