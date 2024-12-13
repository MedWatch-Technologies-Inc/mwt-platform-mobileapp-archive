package com.HealthGauge.models;

import java.util.ArrayList;
import java.util.HashMap;

public class E80AlarmModel {
    int oldHr;
    int oldMin;
    int hour;
    int minute;
    int delayTime;
    int type;
    ArrayList<Integer> days;
    int repeatBits;

    public int getRepeatBits() {
        return repeatBits;
    }

    public void setRepeatBits(int repeatBits) {
        this.repeatBits = repeatBits;
    }

    public int getOldHr() {
        return oldHr;
    }

    public void setOldHr(int oldHr) {
        this.oldHr = oldHr;
    }

    public int getOldMin() {
        return oldMin;
    }

    public void setOldMin(int oldMin) {
        this.oldMin = oldMin;
    }

    public int getHour() {
        return hour;
    }

    public void setHour(int hour) {
        this.hour = hour;
    }

    public int getMinute() {
        return minute;
    }

    public void setMinute(int minute) {
        this.minute = minute;
    }

    public int getDelayTime() {
        return delayTime;
    }

    public void setDelayTime(int delayTime) {
        this.delayTime = delayTime;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }
    
    public ArrayList<Integer> getDays() {
        return days;
    }

    public void setDays(ArrayList<Integer> days) {
        this.days = days;
    }

    public E80AlarmModel fromMap(HashMap hashMap) {
        if (hashMap.containsKey("oldHour") && (hashMap.get("oldHour") instanceof Integer)) {
            oldHr = (int) hashMap.get("oldHour");
        }else{
            oldHr = -1;
        }
        if (hashMap.containsKey("oldMinute") && hashMap.get("oldMinute") instanceof Integer) {
            oldMin = (int) hashMap.get("oldMinute");
        }else{
            oldMin = -1;
        }
        if (hashMap.containsKey("startHour") && hashMap.get("startHour") instanceof Integer) {
            hour = (int) hashMap.get("startHour");
        }else{
            hour = -1;
        }
        if (hashMap.containsKey("startMinute") && hashMap.get("startMinute") instanceof Integer) {
            minute = (int) hashMap.get("startMinute");
        }else{
            minute = -1;
        }
        if (hashMap.containsKey("delay") && hashMap.get("delay") instanceof Integer) {
            delayTime = (int) hashMap.get("delay");
        }else{
            delayTime = -1;
        }
        if (hashMap.containsKey("type") && hashMap.get("type") instanceof Integer) {
            type = (int) hashMap.get("type");
        }else{
            type = 0x07;
        }
        if (hashMap.containsKey("repeat") && hashMap.get("repeat") instanceof Integer) {
            repeatBits = (Integer) hashMap.get("repeat");
        }else{
            repeatBits = -1;
        }
        return this;
    }

    public HashMap<String,Object> toMap() {
        HashMap<String,Object> map = new HashMap<String , Object>();
        map.put("oldHour", oldHr);
        map.put("oldMinute", oldMin);
        map.put("startHour", oldMin);
        map.put("startMinute", minute);
        map.put("delay", delayTime);
        map.put("type", type);
        map.put("repeat", repeatBits);
        return map;
    }

    public HashMap<String,Object> toMapForList() {
        HashMap<String,Object> map = new HashMap<String , Object>();
        map.put("keyAlarmHour", hour);
        map.put("keyAlarmMin", minute);
        map.put("keyAlarmRepeat", repeatBits);
        map.put("keyAlarmType", type);
        map.put("keyAlarmDelayTime", delayTime);
        return map;
    }
}
