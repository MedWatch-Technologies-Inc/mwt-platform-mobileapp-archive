package com.HealthGauge.models;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.ArrayList;
import java.util.HashMap;

public class AlarmModel implements Parcelable {
    private int id;
    private int startHour;
    private int startMinute;
    private int previousStartHour;
    private int previousStartMinute;
    private int endHour;
    private int endMinute;
    private int interval;
    private ArrayList<Integer> days = new ArrayList<>();
    boolean isEnable;
    boolean isRepeat;

    public AlarmModel() {
        this.id = 0;
        this.startHour = 0;
        this.startMinute = 0;
        this.endHour = 0;
        this.endMinute = 0;
        this.days = new ArrayList<>();
        this.isEnable = false;
        this.interval = 0;
    }

    public AlarmModel(int id, int startHour, int startMinute, int previousStartHour, int previousStartMinute, int endHour, int endMinute, ArrayList<Integer> days, boolean isEnable, int interval) {
        this.id = id;
        this.startHour = startHour;
        this.startMinute = startMinute;
        this.previousStartHour = previousStartHour;
        this.previousStartMinute = previousStartMinute;
        this.endHour = endHour;
        this.endMinute = endMinute;
        this.days = days;
        this.isEnable = isEnable;
        this.interval = interval;
    }

    public AlarmModel fromMap(HashMap hashMap){

        if(hashMap.containsKey("id")){
            id = (int) hashMap.get("id");
        }
        if(hashMap.containsKey("startHour")){
            startHour = (int) hashMap.get("startHour");
        }
        if(hashMap.containsKey("startMinute")){
            startMinute = (int)  hashMap.get("startMinute");
        }
        if(hashMap.containsKey("endHour")){
            endHour = (int) hashMap.get("endHour");
        }
        if(hashMap.containsKey("endMinute")){
            endMinute = (int)  hashMap.get("endMinute");
        }
        if(hashMap.containsKey("interval")){
            interval = (int)  hashMap.get("interval");
        }
        if(hashMap.containsKey("isEnable")){
            try {
                isEnable = (boolean) hashMap.get("isEnable");
            } catch (Exception e) {
                e.printStackTrace();
            }try {
                isEnable = ((int) hashMap.get("isEnable")) == 1;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if(hashMap.containsKey("days")){
            days = (ArrayList<Integer>) hashMap.get("days");
        }


        if(hashMap.containsKey("startHour")){
            startHour = (int) hashMap.get("startHour");
        }
        if(hashMap.containsKey("alarmMin")){
            startMinute = (int) hashMap.get("alarmMin");
        }
        if(hashMap.containsKey("repeat")){
            isRepeat = (boolean) hashMap.get("repeat");
        }
        
        
        if(hashMap.containsKey("previousStartHour")){
            previousStartHour = (int) hashMap.get("previousStartHour");
        }
        if(hashMap.containsKey("previousStartMinute")){
            previousStartMinute = (int) hashMap.get("previousStartMinute");
        }
        
        return  this;
    }

    public HashMap toMap(){
        HashMap hashMap = new HashMap();
        hashMap.put("id",id);
        hashMap.put("startHour",startHour);
        hashMap.put("startMinute",startMinute);
        hashMap.put("endHour",endHour);
        hashMap.put("endMinute",endMinute);
        hashMap.put("interval",interval);
        hashMap.put("isEnable",isEnable);
        return  hashMap;
    }

    public int getPreviousStartHour() {
        return previousStartHour;
    }

    public void setPreviousStartHour(int previousStartHour) {
        this.previousStartHour = previousStartHour;
    }

    public int getPreviousStartMinute() {
        return previousStartMinute;
    }

    public void setPreviousStartMinute(int previousStartMinute) {
        this.previousStartMinute = previousStartMinute;
    }

    public boolean isRepeat() {
        return isRepeat;
    }
    
    public void setId(int id) {
        this.id = id;
    }

    public void setStartHour(int startHour) {
        this.startHour = startHour;
    }

    public void setStartMinute(int startMinute) {
        this.startMinute = startMinute;
    }

    public void setEndHour(int endHour) {
        this.endHour = endHour;
    }

    public void setEndMinute(int endMinute) {
        this.endMinute = endMinute;
    }

    public void setInterval(int interval) {
        this.interval = interval;
    }

    public void setDays(ArrayList<Integer> days) {
        this.days = days;
    }

    public void setEnable(boolean enable) {
        isEnable = enable;
    }

    public void setRepeat(boolean repeat) {
        isRepeat = repeat;
    }

    public int getId() {
        return id;
    }

    public int getStartHour() {
        return startHour;
    }

    public int getStartMinute() {
        return startMinute;
    }

    public int getEndHour() {
        return endHour;
    }

    public int getEndMinute() {
        return endMinute;
    }

    public int getInterval() {
        return interval;
    }

    public ArrayList<Integer> getDays() {
        return days;
    }

    public ArrayList<String> getDaysString() {
        ArrayList<String> list = new ArrayList<>();
        for (int i = 0; i < days.size(); i++) {
            list.add(days.get(i).toString());
        }
        return list;
    }

    public boolean isEnable() {
        return isEnable;
    }

    @Override
    public String toString() {
        return "AlarmModel{" +
                "id=" + id +
                ", startHour=" + startHour +
                ", startMinute=" + startMinute +
                ", endHour=" + endHour +
                ", endMinute=" + endMinute +
                ", interval=" + interval +
                ", days=" + days +
                ", isEnable=" + isEnable +
                '}';
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {

        dest.writeInt(id);
        dest.writeInt(startHour);
        dest.writeInt(startMinute);
        dest.writeInt(endHour);
        dest.writeInt(endMinute);
        dest.writeInt(interval);
        dest.writeByte((byte) (isEnable ? 1 : 0));
    }
}
