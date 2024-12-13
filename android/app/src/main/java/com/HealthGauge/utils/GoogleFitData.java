package com.HealthGauge.utils;

import android.content.Context;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.fitness.Fitness;
import com.google.android.gms.fitness.FitnessActivities;
import com.google.android.gms.fitness.HistoryClient;
import com.google.android.gms.fitness.data.Bucket;
import com.google.android.gms.fitness.data.DataPoint;
import com.google.android.gms.fitness.data.DataSet;
import com.google.android.gms.fitness.data.DataSource;
import com.google.android.gms.fitness.data.DataType;
import com.google.android.gms.fitness.data.Field;
import com.google.android.gms.fitness.data.HealthDataTypes;
import com.google.android.gms.fitness.data.Session;
import com.google.android.gms.fitness.data.SleepStages;
import com.google.android.gms.fitness.data.Value;
import com.google.android.gms.fitness.request.DataReadRequest;
import com.google.android.gms.fitness.request.SessionInsertRequest;
import com.google.android.gms.fitness.request.SessionReadRequest;
import com.google.android.gms.fitness.result.DataReadResponse;
import com.google.android.gms.fitness.result.SessionReadResponse;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;
import java.util.concurrent.TimeUnit;
import java.util.function.Predicate;
import java.util.stream.Collectors;

import io.flutter.plugin.common.MethodChannel;

import static com.google.android.gms.fitness.data.DataType.TYPE_WEIGHT;
import static com.google.android.gms.fitness.data.HealthDataTypes.TYPE_BLOOD_PRESSURE;
import static com.google.android.gms.fitness.data.HealthFields.BLOOD_PRESSURE_MEASUREMENT_LOCATION_LEFT_WRIST;
import static com.google.android.gms.fitness.data.HealthFields.BODY_POSITION_SITTING;
import static com.google.android.gms.fitness.data.HealthFields.FIELD_BLOOD_PRESSURE_DIASTOLIC;
import static com.google.android.gms.fitness.data.HealthFields.FIELD_BLOOD_PRESSURE_MEASUREMENT_LOCATION;
import static com.google.android.gms.fitness.data.HealthFields.FIELD_BLOOD_PRESSURE_SYSTOLIC;
import static com.google.android.gms.fitness.data.HealthFields.FIELD_BODY_POSITION;
import static java.text.DateFormat.getDateTimeInstance;

public class GoogleFitData {

    String packageName = getClass().getPackage().getName();
    private GoogleSignInAccount account;
    private final Context context;
    private final String TAG = getClass().getName();

    public GoogleFitData(Context context, GoogleSignInAccount account) {
        this.context = context;
        this.account = account;
    }

    public void setAccount(GoogleSignInAccount account) {
        this.account = account;
    }

    public void writeWeightData(long startDate, long endDate, float weight, MethodChannel.Result writeWeightDataResult) {
        if (account == null) {
            return;
        }
        DataSource dataSource = new DataSource.Builder()
                .setAppPackageName(packageName)
                .setDataType(TYPE_WEIGHT)
                .setType(DataSource.TYPE_RAW)
                .build();

        DataPoint dataPoint = DataPoint.builder(dataSource).setTimeInterval(startDate, endDate, TimeUnit.MILLISECONDS).setFloatValues(weight).build();

        DataSet dataSet = DataSet.builder(dataSource).add(dataPoint).build();

        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Fitness.getHistoryClient(context, account)
                            .insertData(dataSet)
                            .addOnSuccessListener(new OnSuccessListener<Void>() {
                                @Override
                                public void onSuccess(Void aVoid) {
                                    System.out.println("success");
                                    try {
                                        if (writeWeightDataResult != null) {
                                            writeWeightDataResult.success(true);
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                }
                            })
                            .addOnFailureListener(new OnFailureListener() {
                                @Override
                                public void onFailure(@NonNull Exception e) {
                                    System.out.println("failed");
                                }
                            });
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }).start();

    }

    public void writeBloodPressureData(long startDate, float sbp, float dbp, MethodChannel.Result writeBloodPressureDataResult) {
        if (account == null) {
            return;
        }
        DataSource dataSource = new DataSource.Builder()
                .setAppPackageName(packageName)
                .setDataType(TYPE_BLOOD_PRESSURE)
                .setType(DataSource.TYPE_RAW)
                .build();


        DataPoint dataPoint = DataPoint.builder(dataSource)
                .setTimestamp(startDate, TimeUnit.MILLISECONDS)
                .setField(FIELD_BLOOD_PRESSURE_SYSTOLIC, sbp)
                .setField(FIELD_BLOOD_PRESSURE_DIASTOLIC, dbp)
                .setField(FIELD_BODY_POSITION, BODY_POSITION_SITTING)
                .setField(FIELD_BLOOD_PRESSURE_MEASUREMENT_LOCATION, BLOOD_PRESSURE_MEASUREMENT_LOCATION_LEFT_WRIST)
                .build();

        DataSet dataSet = DataSet.builder(dataSource).add(dataPoint).build();

        new Thread(new Runnable() {
            @Override
            public void run() {
                Fitness.getHistoryClient(context, account)
                        .insertData(dataSet)
                        .addOnSuccessListener(new OnSuccessListener<Void>() {
                            @Override
                            public void onSuccess(Void aVoid) {
                                System.out.println("success");
                                try {
                                    if (writeBloodPressureDataResult != null) {
                                        writeBloodPressureDataResult.success(true);
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            }
                        })
                        .addOnFailureListener(new OnFailureListener() {
                            @Override
                            public void onFailure(@NonNull Exception e) {
                                System.out.println("failed");
                            }
                        });
            }
        }).start();

    }

    public void writeStepData(long startDate, long endDate, Object value, MethodChannel.Result writeStepsDataResult) throws ParseException {
        if (account == null) {
            return;
        }
        try {
            DataSource dataSource = new DataSource.Builder()
                    .setAppPackageName(packageName)
                    .setDataType(DataType.TYPE_STEP_COUNT_DELTA)
                    .setStreamName(TAG + " - step count")
                    .setType(DataSource.TYPE_RAW)
                    .build();


            int stepCountDelta = (int) value;

            DataSet dataSet = DataSet.create(dataSource);
            DataPoint dataPoint = dataSet.createDataPoint().setTimeInterval(startDate, endDate, TimeUnit.MILLISECONDS);
            dataPoint.getValue(Field.FIELD_STEPS).setInt(stepCountDelta);
            dataSet.add(dataPoint);


            new Thread(new Runnable() {
                @Override
                public void run() {
                    Task<Void> response = Fitness.getHistoryClient(context, account).insertData(dataSet);
                    response.addOnSuccessListener(new OnSuccessListener<Void>() {
                        @Override
                        public void onSuccess(Void aVoid) {
                            Log.i(TAG, "onSuccess: Data inserted Successfully " + value);
                            try {
                                if (writeStepsDataResult != null) {
                                    writeStepsDataResult.success(true);
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    });
                    response.addOnFailureListener(new OnFailureListener() {
                        @Override
                        public void onFailure(@NonNull Exception e) {
                            Log.i(TAG, "onSuccess: Data inserted Failed " + e.toString());
                            try {
                                if (writeStepsDataResult != null) {
                                    writeStepsDataResult.success(false);
                                }
                            } catch (Exception exception) {
                                exception.printStackTrace();
                            }
                        }
                    });
                    response.addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull Task<Void> task) {
                            Log.i(TAG, "onComplete: ");
                        }
                    });
                    response.addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull Task<Void> task) {
                            Log.i(TAG, "onComplete: ");
                        }
                    });
                }
            }).start();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void writeHeartRateData(long startDate, long endDate, Object value, MethodChannel.Result writeHeartRateResult) throws ParseException {
        if (account == null) {
            return;
        }


        try {
            DataSource dataSource = new DataSource.Builder()
                    .setAppPackageName(packageName)
                    .setDataType(DataType.TYPE_HEART_POINTS)
                    .setStreamName(TAG + " - heart rate")
                    .setType(DataSource.TYPE_RAW)
                    .build();


            float hrCountDelta = Float.parseFloat(value.toString());


            DataPoint dataPoint = DataPoint.builder(dataSource)
                    .setTimestamp(startDate, TimeUnit.MILLISECONDS)
                    .setFloatValues(hrCountDelta)
                    .setField(Field.FIELD_BPM, hrCountDelta)
                    .build();

            DataSet dataSet = DataSet.create(dataSource);
            dataSet.add(dataPoint);

            new Thread(new Runnable() {
                @Override
                public void run() {

                    Task<Void> response = Fitness.getHistoryClient(context, account).insertData(dataSet);
                    response.addOnSuccessListener(new OnSuccessListener<Void>() {
                        @Override
                        public void onSuccess(Void aVoid) {
                            Log.i(TAG, "onSuccess: Data inserted Successfully " + value);
                            try {
                                if (writeHeartRateResult != null) {
                                    writeHeartRateResult.success(true);
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    });
                    response.addOnFailureListener(new OnFailureListener() {
                        @Override
                        public void onFailure(@NonNull Exception e) {
                            Log.i(TAG, "onSuccess: Data inserted Failed " + e.toString());
                            try {
                                if (writeHeartRateResult != null) {
                                    writeHeartRateResult.success(false);
                                }
                            } catch (Exception exception) {
                                exception.printStackTrace();
                            }
                        }
                    });
                    response.addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull Task<Void> task) {
                            Log.i(TAG, "onComplete: ");
                        }
                    });
                    response.addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull Task<Void> task) {
                            Log.i(TAG, "onComplete: ");
                        }
                    });
                }
            }).start();
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

    }

    public void writeSleepDataInBunch(ArrayList listOfSleep, MethodChannel.Result writeSleepDataResult) {
        if (account == null) {
            return;
        }
        try {
            long startTimestamp = 0;
            long endTimestamp = 0;
            ArrayList listOfDataPoint = new ArrayList();
            DataSource dataSource = new DataSource.Builder().setType(DataSource.TYPE_RAW).setDataType(DataType.TYPE_SLEEP_SEGMENT).setAppPackageName(packageName).setStreamName(TAG + "-sleepData").build();
            try {
                for (int i = 0; i < listOfSleep.size(); i++) {
                    HashMap map = (HashMap) listOfSleep.get(i);
                    if (map.containsKey("startDate") && map.containsKey("endDate") && map.get("startDate") != null && map.get("endDate") != null) {
                        String sleepType = (String) map.get("sleepTypeForAndroid");
                        int field = SleepStages.SLEEP_LIGHT;

                        if (sleepType.equals("3")) {
                            field = SleepStages.SLEEP_DEEP;
                        }

                        DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        long startDate = 0;
                        long endDate = 0;

                        String strStart = String.valueOf(map.get("startDate"));
                        startDate = formatter.parse(strStart).getTime();

                        String strEnd = String.valueOf(map.get("endDate"));
                        endDate = formatter.parse(strEnd).getTime();

                        if (startTimestamp == 0) {
                            startTimestamp = startDate;
                        }

                        endTimestamp = endDate;

//                        Log.i(TAG, "writeSleepDataInBunch: " + startDate + " > " + endDate + " == " + (startDate > endDate));
//                        Log.i(TAG, "writeSleepDataInBunch: " + strStart + " > " + strEnd + " == " + (startDate > endDate));

                        DataPoint dataPoint = DataPoint.builder(dataSource)
                                .setTimeInterval(startDate, endDate, TimeUnit.MILLISECONDS)
                                .setField(Field.FIELD_SLEEP_SEGMENT_TYPE, field)
                                .build();
                        listOfDataPoint.add(dataPoint);
                    }
                }
            } catch (ParseException e) {
                e.printStackTrace();
            }

            DataSet dataSet = DataSet.builder(dataSource).addAll(listOfDataPoint).build();

            if (startTimestamp != 0 && endTimestamp != 0) {// Create the sleep session
                Session session = new Session.Builder()
                        .setName(TAG)
                        .setIdentifier("startDate-endDate")
                        .setDescription("test data")
                        .setStartTime(startTimestamp, TimeUnit.MILLISECONDS)
                        .setEndTime(endTimestamp, TimeUnit.MILLISECONDS)
                        .setActivity(FitnessActivities.SLEEP)
                        .build();

                // Build the request to insert the session.
                SessionInsertRequest request = new SessionInsertRequest.Builder()
                        .setSession(session)
                        .addDataSet(dataSet)
                        .build();

                // Insert the session into Fit platform
                Log.i(TAG, "Inserting the session in the Sessions API");
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        Task<Void> task = Fitness.getSessionsClient(context, account).insertSession(request);

                        task.addOnSuccessListener(new OnSuccessListener<Void>() {
                            @Override
                            public void onSuccess(Void aVoid) {
                                try {
                                    if (writeSleepDataResult != null) {
                                        writeSleepDataResult.success(true);
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            }
                        });

                        task.addOnFailureListener(new OnFailureListener() {
                            @Override
                            public void onFailure(@NonNull Exception e) {
                                try {
                                    if (writeSleepDataResult != null) {
                                        writeSleepDataResult.success(false);
                                    }
                                } catch (Exception exception) {
                                    exception.printStackTrace();
                                }
                            }
                        });
                    }
                }).start();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void readHR(long startDate, long endDate, MethodChannel.Result result) {
        if (account == null) {
            return;
        }

        /// Added by: Chaitanya
        /// Added on: Oct/8/2021
        /// heart rate method changes as per new google fit upadte document
        try {
            DataReadRequest readRequest = new DataReadRequest.Builder()
                    .read(DataType.TYPE_HEART_RATE_BPM)
                    .read(DataType.AGGREGATE_HEART_RATE_SUMMARY)
                    .read(DataType.AGGREGATE_HEART_POINTS)
                    .enableServerQueries()
                    .setTimeRange(startDate, endDate, TimeUnit.MILLISECONDS)
                    .bucketByTime(365, TimeUnit.DAYS)
                    .build();

            new Thread(new Runnable() {
                @Override
                public void run() {
                    Fitness.getHistoryClient(context, account)
                            .readData(readRequest)
                            .addOnSuccessListener(new OnSuccessListener<DataReadResponse>() {
                                @Override
                                public void onSuccess(DataReadResponse dataReadResponse) {
                                    Log.d(TAG, "onSuccess()");
                                    ArrayList<HashMap> mapList = new ArrayList<>();
                                    for (Bucket bucket : dataReadResponse.getBuckets()) {
                                        Log.e("History", "Data returned for Data type: " + bucket.getDataSets());

                                        List<DataSet> dataSets = bucket.getDataSets();
                                        for (DataSet dataSet : dataSets) {
                                            DateFormat dateFormat = getDateTimeInstance();

                                            for (DataPoint dp : dataSet.getDataPoints()) {
                                                String type = dp.getDataType().getName();
                                                long startTime = dp.getStartTime(TimeUnit.MILLISECONDS);
                                                long endTime = dp.getEndTime(TimeUnit.MILLISECONDS);
                                                for (Field field : dp.getDataType().getFields()) {
                                                    try {
                                                        String fieldName = field.getName();
                                                        Value fieldValue = dp.getValue(field);
                                                        float value = fieldValue.asFloat();
                                                        Log.i(TAG, "start : " + startTime + " end : " + endTime);
                                                        Log.i(TAG, "type : " + type + " fieldName : " + fieldName + " value : " + value);
                                                        if (!dp.getDataSource().getAppPackageName().contains(context.getPackageName())) {
                                                            HashMap<String, Object> map = new HashMap<String, Object>();
                                                            map.put("value", value);
                                                            map.put("startTime", getDate(startTime));
                                                            map.put("endTime", getDate(endTime));
                                                            map.put("valueId", "HeartRate-" + startTime + "-" + endTime);
                                                            mapList.add(map);
                                                        }
                                                    } catch (Exception e) {
                                                        e.printStackTrace();
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    try {
                                        if (result != null) {
                                            result.success(mapList);
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                }
                            })
                            .addOnFailureListener(new OnFailureListener() {
                                @Override
                                public void onFailure(@NonNull Exception e) {
                                    Log.e(TAG, "onFailure()", e);
                                }
                            })
                            .addOnCompleteListener(new OnCompleteListener<DataReadResponse>() {
                                @Override
                                public void onComplete(@NonNull Task<DataReadResponse> task) {
                                    Log.d(TAG, "onComplete()");
                                }
                            });
                }
            }).start();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void readBloodPressure(long startDate, long endDate, boolean isForSystolic, MethodChannel.Result result) {
        if (account == null) {
            return;
        }

        try {
            DataReadRequest readRequest = new DataReadRequest.Builder()
                    .read(TYPE_BLOOD_PRESSURE)
                    .read(HealthDataTypes.AGGREGATE_BLOOD_PRESSURE_SUMMARY)
                    .enableServerQueries()
                    .setTimeRange(startDate, endDate, TimeUnit.MILLISECONDS)
                    .bucketByTime(365, TimeUnit.DAYS)
                    .build();

            new Thread(new Runnable() {
                @Override
                public void run() {
                    Fitness.getHistoryClient(context, account)
                            .readData(readRequest)
                            .addOnSuccessListener(new OnSuccessListener<DataReadResponse>() {
                                @Override
                                public void onSuccess(DataReadResponse dataReadResponse) {
                                    Log.d(TAG, "onSuccess()");
                                    ArrayList<HashMap> mapList = new ArrayList<>();
                                    for (Bucket bucket : dataReadResponse.getBuckets()) {
                                        Log.e("History", "Data returned for Data type: " + bucket.getDataSets());

                                        List<DataSet> dataSets = bucket.getDataSets();
                                        for (DataSet dataSet : dataSets) {
                                            DateFormat dateFormat = getDateTimeInstance();

                                            for (DataPoint dp : dataSet.getDataPoints()) {
                                                String type = dp.getDataType().getName();
                                                long startTime = dp.getStartTime(TimeUnit.MILLISECONDS);
                                                long endTime = dp.getEndTime(TimeUnit.MILLISECONDS);
                                                for (Field field : dp.getDataType().getFields()) {
                                                    try {
                                                        String fieldName = field.getName();
                                                        Value fieldValue = dp.getValue(field);
                                                        float value = fieldValue.asFloat();
                                                        Log.i(TAG, "start : " + startTime + " end : " + endTime);
                                                        Log.i(TAG, "type : " + type + " fieldName : " + fieldName + " value : " + value);
                                                        if (!dp.getDataSource().getAppPackageName().contains(context.getPackageName())) {
                                                            HashMap<String, Object> map = new HashMap<String, Object>();
                                                            map.put("value", value);
                                                            map.put("startTime", getDate(startTime));
                                                            map.put("endTime", getDate(endTime));
                                                            /// Added by: Chaitanya
                                                            /// Added on: Oct/8/2021
                                                            /// add some uniques value id for DiaBp and SysBp
                                                            if (isForSystolic && fieldName.equals("blood_pressure_systolic")) {
                                                                map.put("valueId", "BloodPressure-" + startTime);
                                                            } else if (!isForSystolic && fieldName.equals("blood_pressure_diastolic")) {
                                                                map.put("valueId", "BloodPressure-dia" + endTime);
                                                            }

                                                            if (isForSystolic && fieldName.equals("blood_pressure_systolic")) {
                                                                mapList.add(map);
                                                            } else if (!isForSystolic && fieldName.equals("blood_pressure_diastolic")) {
                                                                mapList.add(map);
                                                            }
                                                        }
                                                    } catch (Exception e) {
                                                        e.printStackTrace();
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    try {
                                        if (result != null) {
                                            result.success(mapList);
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                }
                            })
                            .addOnFailureListener(new OnFailureListener() {
                                @Override
                                public void onFailure(@NonNull Exception e) {
                                    Log.e(TAG, "onFailure()", e);
                                }
                            })
                            .addOnCompleteListener(new OnCompleteListener<DataReadResponse>() {
                                @Override
                                public void onComplete(@NonNull Task<DataReadResponse> task) {
                                    Log.d(TAG, "onComplete()");
                                }
                            });
                }
            }).start();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /// Added by: Chaitanya
    /// Added on: Oct/8/2021
    /// Changes in blood glucose method to get proper data
    public void readBloodGlucose(long startDate, long endDate, MethodChannel.Result result) {
        if (account == null) {
            return;
        }

        try {
            DataReadRequest readRequest = new DataReadRequest.Builder()
                    .read(HealthDataTypes.TYPE_BLOOD_GLUCOSE)
                    .read(HealthDataTypes.AGGREGATE_BLOOD_GLUCOSE_SUMMARY)
                    .enableServerQueries()
                    .setTimeRange(startDate, endDate, TimeUnit.MILLISECONDS)
                    .bucketByTime(365, TimeUnit.DAYS)
                    .build();

            new Thread(new Runnable() {
                @Override
                public void run() {
                    Fitness.getHistoryClient(context, account)
                            .readData(readRequest)
                            .addOnSuccessListener(new OnSuccessListener<DataReadResponse>() {
                                @Override
                                public void onSuccess(DataReadResponse dataReadResponse) {
                                    Log.d(TAG, "onSuccess()");
                                    ArrayList<HashMap> mapList = new ArrayList<>();
                                    for (Bucket bucket : dataReadResponse.getBuckets()) {
                                        Log.e("History", "Data returned for Data type: " + bucket.getDataSets());

                                        List<DataSet> dataSets = bucket.getDataSets();
                                        for (DataSet dataSet : dataSets) {
                                            DateFormat dateFormat = getDateTimeInstance();

                                            for (DataPoint dp : dataSet.getDataPoints()) {
                                                String type = dp.getDataType().getName();
                                                long startTime = dp.getStartTime(TimeUnit.MILLISECONDS);
                                                long endTime = dp.getEndTime(TimeUnit.MILLISECONDS);
                                                for (Field field : dp.getDataType().getFields()) {
                                                    try {
                                                        String fieldName = field.getName();
                                                        Value fieldValue = dp.getValue(field);
                                                        float value = 0;
                                                        try {
                                                            value = fieldValue.asFloat();
                                                        } catch (Exception e) {
                                                            value = 0.F;
                                                        }
                                                        Log.i(TAG, "start : " + startTime + " end : " + endTime);
                                                        Log.i(TAG, "type : " + type + " fieldName : " + fieldName + " value : " + value);

                                                        HashMap<String, Object> map = new HashMap<String, Object>();
                                                        map.put("value", value);
                                                        map.put("startTime", getDate(startTime));
                                                        map.put("endTime", getDate(endTime));
                                                        map.put("valueId", "BloodGlucose-" + startTime + "-" + endTime);
                                                        mapList.add(map);
                                                        //                                            if(isForSystolic && fieldName.equals("blood_pressure_systolic")) {
                                                        //                                                mapList.add(map);
                                                        //                                            }else if(!isForSystolic && fieldName.equals("blood_pressure_diastolic")){
                                                        //                                                mapList.add(map);
                                                        //                                            }
                                                    } catch (Exception e) {
                                                        e.printStackTrace();
                                                    }
                                                }
                                            }
                                        }
                                        try {
                                            if (result != null) {
                                                result.success(mapList);
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    }
                                }
                            })
                            .addOnFailureListener(new OnFailureListener() {
                                @Override
                                public void onFailure(@NonNull Exception e) {
                                    Log.e(TAG, "onFailure()", e);
                                }
                            })
                            .addOnCompleteListener(new OnCompleteListener<DataReadResponse>() {
                                @Override
                                public void onComplete(@NonNull Task<DataReadResponse> task) {
                                    Log.d(TAG, "onComplete()");
                                }
                            });
                }
            }).start();
        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    /// Added by: Chaitanya
    /// Added on: Oct/8/2021
    /// method add for Respiratory rate
    public void readRespiratoryRate(long startDate, long endDate, MethodChannel.Result result) {
        if (account == null) {
            return;
        }

        try {
            DataReadRequest readRequest = new DataReadRequest.Builder()
                    .read(HealthDataTypes.TYPE_BODY_TEMPERATURE)
                    .read(HealthDataTypes.AGGREGATE_BODY_TEMPERATURE_SUMMARY)
                    .enableServerQueries()
                    .setTimeRange(startDate, endDate, TimeUnit.MILLISECONDS)
                    .bucketByTime(365, TimeUnit.DAYS)
                    .build();

            new Thread(new Runnable() {
                @Override
                public void run() {
                    Fitness.getHistoryClient(context, account)
                            .readData(readRequest)
                            .addOnSuccessListener(new OnSuccessListener<DataReadResponse>() {
                                @Override
                                public void onSuccess(DataReadResponse dataReadResponse) {
                                    Log.d(TAG, "onSuccess()");
                                    ArrayList<HashMap> mapList = new ArrayList<>();
                                    for (Bucket bucket : dataReadResponse.getBuckets()) {
                                        Log.e("History", "Data returned for Data type: " + bucket.getDataSets());

                                        List<DataSet> dataSets = bucket.getDataSets();
                                        for (DataSet dataSet : dataSets) {
                                            DateFormat dateFormat = getDateTimeInstance();

                                            for (DataPoint dp : dataSet.getDataPoints()) {
                                                String type = dp.getDataType().getName();
                                                long startTime = dp.getStartTime(TimeUnit.MILLISECONDS);
                                                long endTime = dp.getEndTime(TimeUnit.MILLISECONDS);
                                                for (Field field : dp.getDataType().getFields()) {
                                                    try {
                                                        String fieldName = field.getName();
                                                        Value fieldValue = dp.getValue(field);
                                                        float value = fieldValue.asFloat();
                                                        Log.i(TAG, "start : " + startTime + " end : " + endTime);
                                                        Log.i(TAG, "type : " + type + " fieldName : " + fieldName + " value : " + value);

                                                        HashMap<String, Object> map = new HashMap<String, Object>();
                                                        map.put("value", value);
                                                        map.put("startTime", getDate(startTime));
                                                        map.put("endTime", getDate(endTime));
                                                        map.put("valueId", "BodyTemperature-" + startTime + "-" + endTime);
                                                        mapList.add(map);
                                                        //                                            if(isForSystolic && fieldName.equals("blood_pressure_systolic")) {
                                                        //                                                mapList.add(map);
                                                        //                                            }else if(!isForSystolic && fieldName.equals("blood_pressure_diastolic")){
                                                        //                                                mapList.add(map);
                                                        //                                            }
                                                    } catch (Exception e) {
                                                        e.printStackTrace();
                                                    }
                                                }
                                            }
                                        }
                                        try {
                                            if (result != null) {
                                                result.success(mapList);
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    }
                                }
                            })
                            .addOnFailureListener(new OnFailureListener() {
                                @Override
                                public void onFailure(@NonNull Exception e) {
                                    Log.e(TAG, "onFailure()", e);
                                }
                            })
                            .addOnCompleteListener(new OnCompleteListener<DataReadResponse>() {
                                @Override
                                public void onComplete(@NonNull Task<DataReadResponse> task) {
                                    Log.d(TAG, "onComplete()");
                                }
                            });
                }
            }).start();
        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    /// Added by: Chaitanya
    /// Added on: Oct/8/2021
    /// method add for Body temp data read from google fit
    public void readBodyTemperature(long startDate, long endDate, MethodChannel.Result result) {
        if (account == null) {
            return;
        }

        try {
            DataReadRequest readRequest = new DataReadRequest.Builder()
                    .read(HealthDataTypes.TYPE_BODY_TEMPERATURE)
                    .read(HealthDataTypes.AGGREGATE_BODY_TEMPERATURE_SUMMARY)
                    .enableServerQueries()
                    .setTimeRange(startDate, endDate, TimeUnit.MILLISECONDS)
                    .bucketByTime(365, TimeUnit.DAYS)
                    .build();

            new Thread(new Runnable() {
                @Override
                public void run() {
                    Fitness.getHistoryClient(context, account)
                            .readData(readRequest)
                            .addOnSuccessListener(new OnSuccessListener<DataReadResponse>() {
                                @Override
                                public void onSuccess(DataReadResponse dataReadResponse) {
                                    Log.d(TAG, "onSuccess()");
                                    ArrayList<HashMap> mapList = new ArrayList<>();
                                    for (Bucket bucket : dataReadResponse.getBuckets()) {
                                        Log.e("History", "Data returned for Data type: " + bucket.getDataSets());

                                        List<DataSet> dataSets = bucket.getDataSets();
                                        for (DataSet dataSet : dataSets) {
                                            DateFormat dateFormat = getDateTimeInstance();

                                            for (DataPoint dp : dataSet.getDataPoints()) {
                                                String type = dp.getDataType().getName();
                                                long startTime = dp.getStartTime(TimeUnit.MILLISECONDS);
                                                long endTime = dp.getEndTime(TimeUnit.MILLISECONDS);
                                                for (Field field : dp.getDataType().getFields()) {
                                                    try {
                                                        String fieldName = field.getName();
                                                        Value fieldValue = dp.getValue(field);
                                                        float value = fieldValue.asFloat();
                                                        Log.i(TAG, "start : " + startTime + " end : " + endTime);
                                                        Log.i(TAG, "type : " + type + " fieldName : " + fieldName + " value : " + value);

                                                        HashMap<String, Object> map = new HashMap<String, Object>();
                                                        map.put("value", value);
                                                        map.put("startTime", getDate(startTime));
                                                        map.put("endTime", getDate(endTime));
                                                        map.put("valueId", "BodyTemperature-" + startTime + "-" + endTime);
                                                        mapList.add(map);
                                                        //                                            if(isForSystolic && fieldName.equals("blood_pressure_systolic")) {
                                                        //                                                mapList.add(map);
                                                        //                                            }else if(!isForSystolic && fieldName.equals("blood_pressure_diastolic")){
                                                        //                                                mapList.add(map);
                                                        //                                            }
                                                    } catch (Exception e) {
                                                        e.printStackTrace();
                                                    }
                                                }
                                            }
                                        }
                                        try {
                                            if (result != null) {
                                                result.success(mapList);
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    }
                                }
                            })
                            .addOnFailureListener(new OnFailureListener() {
                                @Override
                                public void onFailure(@NonNull Exception e) {
                                    Log.e(TAG, "onFailure()", e);
                                }
                            })
                            .addOnCompleteListener(new OnCompleteListener<DataReadResponse>() {
                                @Override
                                public void onComplete(@NonNull Task<DataReadResponse> task) {
                                    Log.d(TAG, "onComplete()");
                                }
                            });
                }
            }).start();
        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    /// Added by: Chaitanya
    /// Added on: Oct/8/2021
    /// method add for oxygen data read from google fit
    public void readOxygen(long startDate, long endDate, MethodChannel.Result result) {
        if (account == null) {
            return;
        }

        try {
            DataReadRequest readRequest = new DataReadRequest.Builder()
                    .read(HealthDataTypes.TYPE_OXYGEN_SATURATION)
                    .read(HealthDataTypes.AGGREGATE_OXYGEN_SATURATION_SUMMARY)
                    .enableServerQueries()
                    .setTimeRange(startDate, endDate, TimeUnit.MILLISECONDS)
                    .bucketByTime(365, TimeUnit.DAYS)
                    .build();

            new Thread(new Runnable() {
                @Override
                public void run() {
                    Fitness.getHistoryClient(context, account)
                            .readData(readRequest)
                            .addOnSuccessListener(new OnSuccessListener<DataReadResponse>() {
                                @Override
                                public void onSuccess(DataReadResponse dataReadResponse) {
                                    Log.d(TAG, "onSuccess()");
                                    ArrayList<HashMap> mapList = new ArrayList<>();
                                    for (Bucket bucket : dataReadResponse.getBuckets()) {
                                        Log.e("History", "Data returned for Data type: " + bucket.getDataSets());

                                        List<DataSet> dataSets = bucket.getDataSets();
                                        for (DataSet dataSet : dataSets) {
                                            DateFormat dateFormat = getDateTimeInstance();

                                            for (DataPoint dp : dataSet.getDataPoints()) {
                                                String type = dp.getDataType().getName();
                                                long startTime = dp.getStartTime(TimeUnit.MILLISECONDS);
                                                long endTime = dp.getEndTime(TimeUnit.MILLISECONDS);
                                                for (Field field : dp.getDataType().getFields()) {
                                                    try {
                                                        String fieldName = field.getName();
                                                        Value fieldValue = dp.getValue(field);
                                                        float value = fieldValue.asFloat();
                                                        Log.i(TAG, "start : " + startTime + " end : " + endTime);
                                                        Log.i(TAG, "type : " + type + " fieldName : " + fieldName + " value : " + value);

                                                        HashMap<String, Object> map = new HashMap<String, Object>();
                                                        map.put("value", value);
                                                        map.put("startTime", getDate(startTime));
                                                        map.put("endTime", getDate(endTime));
                                                        map.put("valueId", "OxygenSaturation-" + startTime + "-" + endTime);
                                                        mapList.add(map);
                                                        //                                            if(isForSystolic && fieldName.equals("blood_pressure_systolic")) {
                                                        //                                                mapList.add(map);
                                                        //                                            }else if(!isForSystolic && fieldName.equals("blood_pressure_diastolic")){
                                                        //                                                mapList.add(map);
                                                        //                                            }
                                                    } catch (Exception e) {
                                                        e.printStackTrace();
                                                    }
                                                }
                                            }
                                        }
                                        try {
                                            if (result != null) {
                                                result.success(mapList);
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    }
                                }
                            })
                            .addOnFailureListener(new OnFailureListener() {
                                @Override
                                public void onFailure(@NonNull Exception e) {
                                    Log.e(TAG, "onFailure()", e);
                                }
                            })
                            .addOnCompleteListener(new OnCompleteListener<DataReadResponse>() {
                                @Override
                                public void onComplete(@NonNull Task<DataReadResponse> task) {
                                    Log.d(TAG, "onComplete()");
                                }
                            });
                }
            }).start();
        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    public void readSteps(long startDate, long endDate, MethodChannel.Result result) {
        Log.d(TAG, "readSteps: " + account);
        if (account == null) {
            return;
        }

        try {
            HistoryClient historyClient = Fitness.getHistoryClient(context, account);

            DataReadRequest readRequest = new DataReadRequest.Builder()
                    .read(DataType.TYPE_STEP_COUNT_DELTA)
                    .enableServerQueries()
                    .setTimeRange(startDate, endDate, TimeUnit.MILLISECONDS)
                    .bucketByTime(365, TimeUnit.DAYS)
                    .build();

            new Thread(new Runnable() {
                @Override
                public void run() {
                    historyClient.readData(readRequest)
                            .addOnSuccessListener(new OnSuccessListener<DataReadResponse>() {
                                @Override
                                public void onSuccess(DataReadResponse dataReadResponse) {
                                    ArrayList<HashMap> mapList = new ArrayList<>();
                                    Log.d(TAG, "onSuccess()");
                                    for (Bucket bucket : dataReadResponse.getBuckets()) {
                                        Log.e("History", "Data returned for Data type: " + bucket.getDataSets());

                                        List<DataSet> dataSets = bucket.getDataSets();
                                        for (DataSet dataSet : dataSets) {
                                            DateFormat dateFormat = getDateTimeInstance();

                                            for (DataPoint dp : dataSet.getDataPoints()) {
                                                String type = dp.getDataType().getName();
                                                long startTime = dp.getStartTime(TimeUnit.MILLISECONDS);
                                                long endTime = dp.getEndTime(TimeUnit.MILLISECONDS);
                                                for (Field field : dp.getDataType().getFields()) {
                                                    try {
                                                        String fieldName = field.getName();
                                                        Value fieldValue = dp.getValue(field);
                                                        int value = fieldValue.asInt();
                                                        Log.i(TAG, "start : " + startTime + " end : " + endTime);
                                                        Log.i(TAG, "type : " + type + " fieldName : " + fieldName + " value : " + value + " start : " + getDate(startTime) + " end : " + getDate(startTime) + " package : " + dp.getDataSource().getAppPackageName());
                                                        if (!dp.getDataSource().getAppPackageName().contains(context.getPackageName())) {
                                                            HashMap<String, Object> map = new HashMap<String, Object>();
                                                            map.put("value", value);
                                                            map.put("startTime", getDate(startTime));
                                                            map.put("endTime", getDate(endTime));
                                                            map.put("valueId", "Steps-" + startTime + "-" + endTime);
                                                            mapList.add(map);
                                                        }
                                                    } catch (Exception e) {
                                                        e.printStackTrace();
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    try {
                                        if (result != null) {
                                            result.success(mapList);
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }

                                }
                            })
                            .addOnFailureListener(new OnFailureListener() {
                                @Override
                                public void onFailure(@NonNull Exception e) {
                                    Log.e(TAG, "onFailure()", e);
                                }
                            })
                            .addOnCompleteListener(new OnCompleteListener<DataReadResponse>() {
                                @Override
                                public void onComplete(@NonNull Task<DataReadResponse> task) {
                                    Log.d(TAG, "onComplete()");
                                }
                            });
                }
            }).start();
        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    public void readDistance(long startDate, long endDate, MethodChannel.Result result) {
        if (account == null) {
            return;
        }


        try {
            new Thread(new Runnable() {
                @Override
                public void run() {

                    DataReadRequest readRequest = null;
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.GINGERBREAD) {
                        readRequest = new DataReadRequest.Builder()
                                .read(DataType.TYPE_DISTANCE_DELTA)
                                .enableServerQueries()
                                .setTimeRange(startDate, endDate, TimeUnit.MILLISECONDS)
                                .bucketByTime(365, TimeUnit.DAYS)
                                .build();
                    }

                    Fitness.getHistoryClient(context, account)
                            .readData(readRequest)
                            .addOnSuccessListener(new OnSuccessListener<DataReadResponse>() {
                                @Override
                                public void onSuccess(DataReadResponse dataReadResponse) {
                                    Log.d(TAG, "onSuccess()");
                                    ArrayList<HashMap> mapList = new ArrayList<>();
                                    for (Bucket bucket : dataReadResponse.getBuckets()) {
                                        Log.e("History", "Data returned for Data type: " + bucket.getDataSets());

                                        List<DataSet> dataSets = bucket.getDataSets();
                                        for (DataSet dataSet : dataSets) {
                                            DateFormat dateFormat = getDateTimeInstance();

                                            for (DataPoint dp : dataSet.getDataPoints()) {
                                                String type = dp.getDataType().getName();
                                                long startTime = dp.getStartTime(TimeUnit.MILLISECONDS);
                                                long endTime = dp.getEndTime(TimeUnit.MILLISECONDS);
                                                for (Field field : dp.getDataType().getFields()) {
                                                    try {
                                                        String fieldName = field.getName();
                                                        Value fieldValue = dp.getValue(field);
                                                        float value = fieldValue.asFloat();
                                                        Log.i(TAG, "start : " + startTime + " end : " + endTime);
                                                        Log.i(TAG, "type : " + type + " fieldName : " + fieldName + " value : " + value);

                                                        if (!dp.getDataSource().getAppPackageName().contains(context.getPackageName())) {
                                                            HashMap<String, Object> map = new HashMap<String, Object>();
                                                            /// Added by: Chaitanya
                                                            /// Added on: Oct/8/2021
                                                            /// add logic to get data in specific unit type
                                                            map.put("value", value / 1000);
                                                            map.put("startTime", getDate(startTime));
                                                            map.put("endTime", getDate(endTime));
                                                            map.put("valueId", "Distance-" + startTime + "-" + endTime);
                                                            mapList.add(map);
                                                        }
                                                    } catch (Exception e) {
                                                        e.printStackTrace();
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    try {
                                        if (result != null) {
                                            result.success(mapList);
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                }
                            })
                            .addOnFailureListener(new OnFailureListener() {
                                @Override
                                public void onFailure(@NonNull Exception e) {
                                    Log.e(TAG, "onFailure()", e);
                                }
                            })
                            .addOnCompleteListener(new OnCompleteListener<DataReadResponse>() {
                                @Override
                                public void onComplete(@NonNull Task<DataReadResponse> task) {
                                    Log.d(TAG, "onComplete()");
                                }
                            });
                }
            }).start();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void readHeight(long startDate, long endDate, MethodChannel.Result result) {
        if (account == null) {
            return;
        }

        try {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    DataReadRequest readRequest = new DataReadRequest.Builder()
                            .read(DataType.TYPE_HEIGHT)
                            .enableServerQueries()
                            .setTimeRange(startDate, endDate, TimeUnit.MILLISECONDS)
                            .bucketByTime(365, TimeUnit.DAYS)
                            .build();


                    Fitness.getHistoryClient(context, account)
                            .readData(readRequest)
                            .addOnSuccessListener(new OnSuccessListener<DataReadResponse>() {
                                @Override
                                public void onSuccess(DataReadResponse dataReadResponse) {
                                    Log.d(TAG, "onSuccess()");
                                    ArrayList<HashMap> mapList = new ArrayList<>();
                                    for (Bucket bucket : dataReadResponse.getBuckets()) {
                                        Log.e("History", "Data returned for Data type: " + bucket.getDataSets());

                                        List<DataSet> dataSets = bucket.getDataSets();
                                        for (DataSet dataSet : dataSets) {
                                            DateFormat dateFormat = getDateTimeInstance();

                                            for (DataPoint dp : dataSet.getDataPoints()) {
                                                String type = dp.getDataType().getName();
                                                long startTime = dp.getStartTime(TimeUnit.MILLISECONDS);
                                                long endTime = dp.getEndTime(TimeUnit.MILLISECONDS);
                                                for (Field field : dp.getDataType().getFields()) {
                                                    try {
                                                        String fieldName = field.getName();
                                                        Value fieldValue = dp.getValue(field);
                                                        float value = fieldValue.asFloat();
                                                        Log.i(TAG, "start : " + startTime + " end : " + endTime);
                                                        Log.i(TAG, "type : " + type + " fieldName : " + fieldName + " value : " + value);

                                                        if (!dp.getDataSource().getAppPackageName().contains(context.getPackageName())) {
                                                            HashMap<String, Object> map = new HashMap<String, Object>();
                                                            map.put("value", value);
                                                            map.put("startTime", getDate(startTime));
                                                            map.put("endTime", getDate(endTime));
                                                            map.put("valueId", "Height-" + startTime + "-" + endTime);
                                                            mapList.add(map);
                                                        }
                                                    } catch (Exception e) {
                                                        e.printStackTrace();
                                                    }
                                                }
                                            }

                                        }
                                    }
                                    try {
                                        if (result != null) {
                                            result.success(mapList);
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                }
                            })
                            .addOnFailureListener(new OnFailureListener() {
                                @Override
                                public void onFailure(@NonNull Exception e) {
                                    Log.e(TAG, "onFailure()", e);
                                }
                            })
                            .addOnCompleteListener(new OnCompleteListener<DataReadResponse>() {
                                @Override
                                public void onComplete(@NonNull Task<DataReadResponse> task) {
                                    Log.d(TAG, "onComplete()");
                                }
                            });
                }
            }).start();
        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    public void readWeight(long startDate, long endDate, MethodChannel.Result result) {
        Log.d(TAG, "readWeight: " + account);
        if (account == null) {
            return;
        }


        try {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    DataReadRequest readRequest = new DataReadRequest.Builder()
                            .read(DataType.TYPE_WEIGHT)
                            .enableServerQueries()
                            .setTimeRange(startDate, endDate, TimeUnit.MILLISECONDS)
                            .bucketByTime(365, TimeUnit.DAYS)
                            .build();

                    Fitness.getHistoryClient(context, account)
                            .readData(readRequest)
                            .addOnSuccessListener(new OnSuccessListener<DataReadResponse>() {
                                @Override
                                public void onSuccess(DataReadResponse dataReadResponse) {
                                    Log.d(TAG, "onSuccess()");
                                    ArrayList<HashMap> mapList = new ArrayList<>();
                                    for (Bucket bucket : dataReadResponse.getBuckets()) {
                                        Log.e("History", "Data returned for Data type: " + bucket.getDataSets());

                                        List<DataSet> dataSets = bucket.getDataSets();
                                        for (DataSet dataSet : dataSets) {
                                            DateFormat dateFormat = getDateTimeInstance();

                                            for (DataPoint dp : dataSet.getDataPoints()) {
                                                String type = dp.getDataType().getName();
                                                long startTime = dp.getStartTime(TimeUnit.MILLISECONDS);
                                                long endTime = dp.getEndTime(TimeUnit.MILLISECONDS);
                                                for (Field field : dp.getDataType().getFields()) {
                                                    try {
                                                        String fieldName = field.getName();
                                                        Value fieldValue = dp.getValue(field);
                                                        float value = fieldValue.asFloat();
                                                        Log.i(TAG, "start : " + startTime + " end : " + endTime);
                                                        Log.i(TAG, "type : " + type + " fieldName : " + fieldName + " value : " + value);

                                                        if (!dp.getDataSource().getAppPackageName().contains(context.getPackageName())) {
                                                            HashMap<String, Object> map = new HashMap<String, Object>();
                                                            map.put("value", value);
                                                            map.put("startTime", getDate(startTime));
                                                            map.put("endTime", getDate(endTime));
                                                            map.put("valueId", "weight-" + startTime + "-" + endTime);
                                                            mapList.add(map);
                                                        }
                                                    } catch (Exception e) {
                                                        e.printStackTrace();
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    try {
                                        if (result != null) {
                                            result.success(mapList);
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                }
                            })
                            .addOnFailureListener(new OnFailureListener() {
                                @Override
                                public void onFailure(@NonNull Exception e) {
                                    Log.e(TAG, "onFailure()", e);
                                }
                            })
                            .addOnCompleteListener(new OnCompleteListener<DataReadResponse>() {
                                @Override
                                public void onComplete(@NonNull Task<DataReadResponse> task) {
                                    Log.d(TAG, "onComplete()");
                                }
                            });
                }
            }).start();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public void readSleep(long startDate, long endDate, MethodChannel.Result result) {
        if (account == null) {
            return;
        }

        try {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    SessionReadRequest request = new SessionReadRequest.Builder()
                            .readSessionsFromAllApps()
                            /// Added by: Chaitanya
                            /// Added on: Oct/8/2021
                            /// data type change for getting sleep data
                            .includeSleepSessions()
                            .read(DataType.TYPE_SLEEP_SEGMENT)
                            .setTimeInterval(startDate, endDate, TimeUnit.MILLISECONDS)
                            .build();

                    Task<SessionReadResponse> task = Fitness.getSessionsClient(context, account).readSession(request);
                    task.addOnSuccessListener(new OnSuccessListener<SessionReadResponse>() {
                        @RequiresApi(api = Build.VERSION_CODES.N)
                        @Override
                        public void onSuccess(SessionReadResponse response) {
                            ArrayList<HashMap> mapList = new ArrayList<>();
                            Log.i(TAG, "onSuccess: ");
                            List<Session> sleepSessions = response.getSessions();
//                            sleepSessions.stream()
//                                    .filter(new Predicate<Session>() {
//                                        @Override
//                                        public boolean test(Session s) {
//                                            return s.getActivity().equals(FitnessActivities.SLEEP);
//                                        }
//                                    }).collect(Collectors.toList());

                            /// Added by: Chaitanya
                            /// Added on: Oct/8/2021
                            /// Sleep data has some differenet method to get proper data
                            for (Session session : sleepSessions) {
                                long sleepStartTime = session.getStartTime(TimeUnit.MILLISECONDS);
                                long sleepEndTime = session.getEndTime(TimeUnit.MILLISECONDS);
                                String fieldName = session.getName();
                                HashMap<String, Object> map = new HashMap<String, Object>();

                                if (!session.getAppPackageName().contains(context.getPackageName())) {
                                    map.put("value", (TimeUnit.MILLISECONDS.toMinutes(sleepEndTime) - TimeUnit.MILLISECONDS.toMinutes(sleepStartTime)) / 60 + "." + (TimeUnit.MILLISECONDS.toMinutes(sleepEndTime) - TimeUnit.MILLISECONDS.toMinutes(sleepStartTime)) % 60);
                                    map.put("startTime", getDate(sleepStartTime));
                                    map.put("endTime", getDate(sleepEndTime));
                                    map.put("valueId", "Sleep-" + sleepStartTime + "-" + sleepEndTime);
                                    mapList.add(map);
                                }
                                Log.i(TAG, "onSuccess: sleepStartTime " + sleepStartTime + " sleepEndTime " + sleepEndTime);

//                                List<DataSet> dataSets = response.getDataSet(session);
//                                for (DataSet dataSet : dataSets) {
//                                    for (DataPoint dp : dataSet.getDataPoints()) {
//                                        map.put("value", dp.getValue(Field.FIELD_SLEEP_SEGMENT_TYPE).asInt());
//                                        map.put("startTime", getDate(sleepStartTime));
//                                        map.put("endTime", getDate(sleepEndTime));
//                                        map.put("valueId", "Sleep-"+ sleepStartTime + "-" + sleepEndTime);
//                                        mapList.add(map);
//                                        Log.i(TAG, "onSuccess: sleepStartTime "+sleepStartTime+" sleepEndTime "+sleepEndTime);
//                                    }
//                                }
                            }

                                /*List<DataSet> dataSets = response.getDataSet(session);

                                for (DataSet dataSet : dataSets) {
                                    for (DataPoint dp : dataSet.getDataPoints()) {
                                            if(!session.getAppPackageName().contains(context.getPackageName())) {
                                                map.put("value", dp.getValue(Field.FIELD_SLEEP_SEGMENT_TYPE).asInt());
                                                Log.i(TAG, "onSuccess: Sleep Data "+dp.getValue(Field.FIELD_SLEEP_SEGMENT_TYPE).asInt());


//                                            LogUtil.d("google fit Start: " +
//                                                    dateFormat.format(dp.getStartTime(TimeUnit.MILLISECONDS)) + " " +
//                                                    timeFormat.format(dp.getStartTime(TimeUnit.MILLISECONDS)) + " End: " +
//                                                    dateFormat.format(dp.getEndTime(TimeUnit.MILLISECONDS)) + " " +
//                                                    timeFormat.format(dp.getEndTime(TimeUnit.MILLISECONDS)) + " type: " +
//                                                    showDataType(dp.getValue(field)));
                                        }
                                    }
                                }*/

                                /*for (dataSet in dataSets) {
                                    for (point in dataSet.dataPoints) {
                                        val sleepStageVal = point.getValue(Field.FIELD_SLEEP_SEGMENT_TYPE).asInt()
                                        val sleepStage = SLEEP_STAGE_NAMES[sleepStageVal]
                                        val segmentStart = point.getStartTime(TimeUnit.MILLISECONDS)
                                        val segmentEnd = point.getEndTime(TimeUnit.MILLISECONDS)
                                        Log.i(TAG, "\t* Type $sleepStage between $segmentStart and $segmentEnd")
                                    }
                                }*/

//                                if(!session.getAppPackageName().contains(context.getPackageName())) {
//                                    map.put("value", (sleepEndTime-sleepStartTime)/3600000);
//                                    map.put("startTime", getDate(sleepStartTime));
//                                    map.put("endTime", getDate(sleepEndTime));
//                                    map.put("valueId", "Sleep-"+ sleepStartTime + "-" + sleepEndTime);
//                                    mapList.add(map);
//                                }
//                                Log.i(TAG, "onSuccess: sleepStartTime "+sleepStartTime+" sleepEndTime "+sleepEndTime);

                            // If the sleep session has finer granularity sub-components, extract them:
                     /*   List<DataSet> dataSets = response.getDataSet(session);
                        for (DataSet dataSet : dataSets) {
                            for (DataPoint point : dataSet.getDataPoints()) {
                                // The Activity defines whether this segment is light, deep, REM or awake.
                                String sleepStage = point.getValue(Field.FIELD_ACTIVITY).asActivity();
                                long start = point.getStartTime(TimeUnit.SECONDS);
                                long end = point.getEndTime(TimeUnit.SECONDS);
                                Log.d("AppName", String.format("\t* %s between %d and %d", sleepStage, start, end));
                            }
                        }*/
//                            }

                            try {
                                if (result != null) {
                                    result.success(mapList);
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    });
                    task.addOnFailureListener(new OnFailureListener() {
                        @Override
                        public void onFailure(@NonNull Exception e) {
                            Log.i(TAG, "onFailure: ");
                        }
                    });
                    task.addOnCompleteListener(new OnCompleteListener<SessionReadResponse>() {
                        @Override
                        public void onComplete(@NonNull Task<SessionReadResponse> task) {
                            Log.i(TAG, "onComplete: ");
                        }
                    });
                }
            }).start();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public void readActiveCalories(long startDate, long endDate, MethodChannel.Result result) {
        if (account == null) {
            return;
        }
        try {
            DataReadRequest readRequest = new DataReadRequest.Builder()
                    .read(DataType.TYPE_CALORIES_EXPENDED)
                    .enableServerQueries()
                    .setTimeRange(startDate, endDate, TimeUnit.MILLISECONDS)
                    .bucketByTime(365, TimeUnit.DAYS)
                    .build();

            new Thread(new Runnable() {
                @Override
                public void run() {
                    Fitness.getHistoryClient(context, account)
                            .readData(readRequest)
                            .addOnSuccessListener(new OnSuccessListener<DataReadResponse>() {
                                @Override
                                public void onSuccess(DataReadResponse dataReadResponse) {
                                    Log.d(TAG, "onSuccess()");
                                    ArrayList<HashMap> mapList = new ArrayList<>();
                                    for (Bucket bucket : dataReadResponse.getBuckets()) {
                                        Log.e("History", "Data returned for Data type: " + bucket.getDataSets());

                                        List<DataSet> dataSets = bucket.getDataSets();
                                        for (DataSet dataSet : dataSets) {
                                            DateFormat dateFormat = getDateTimeInstance();

                                            for (DataPoint dp : dataSet.getDataPoints()) {
                                                String type = dp.getDataType().getName();
                                                long startTime = dp.getStartTime(TimeUnit.MILLISECONDS);
                                                long endTime = dp.getEndTime(TimeUnit.MILLISECONDS);
                                                for (Field field : dp.getDataType().getFields()) {
                                                    try {
                                                        String fieldName = field.getName();
                                                        Value fieldValue = dp.getValue(field);
                                                        float value = fieldValue.asFloat();
                                                        Log.i(TAG, "start : " + startTime + " end : " + endTime);
                                                        Log.i(TAG, "type : " + type + " fieldName : " + fieldName + " value : " + value);
                                                        if (!dp.getDataSource().getAppPackageName().contains(context.getPackageName())) {
                                                            HashMap<String, Object> map = new HashMap<String, Object>();
                                                            map.put("value", value);
                                                            map.put("startTime", getDate(startTime));
                                                            map.put("endTime", getDate(endTime));
                                                            map.put("valueId", "HeartRate-" + startTime + "-" + endTime);
                                                            mapList.add(map);
                                                        }
                                                    } catch (Exception e) {
                                                        e.printStackTrace();
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    try {
                                        if (result != null) {
                                            result.success(mapList);
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                }
                            })
                            .addOnFailureListener(new OnFailureListener() {
                                @Override
                                public void onFailure(@NonNull Exception e) {
                                    Log.e(TAG, "onFailure()", e);
                                }
                            })
                            .addOnCompleteListener(new OnCompleteListener<DataReadResponse>() {
                                @Override
                                public void onComplete(@NonNull Task<DataReadResponse> task) {
                                    Log.d(TAG, "onComplete()");
                                }
                            });
                }
            }).start();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public void readRestingCalories(long startDate, long endDate, MethodChannel.Result result) {
        if (account == null) {
            return;
        }
        try {
            DataReadRequest readRequest = new DataReadRequest.Builder()
                    .read(DataType.TYPE_BASAL_METABOLIC_RATE)
                    .enableServerQueries()
                    .setTimeRange(startDate, endDate, TimeUnit.MILLISECONDS)
                    .bucketByTime(365, TimeUnit.DAYS)
                    .build();

            new Thread(new Runnable() {
                @Override
                public void run() {
                    Fitness.getHistoryClient(context, account)
                            .readData(readRequest)
                            .addOnSuccessListener(new OnSuccessListener<DataReadResponse>() {
                                @Override
                                public void onSuccess(DataReadResponse dataReadResponse) {
                                    Log.d(TAG, "onSuccess()");
                                    ArrayList<HashMap> mapList = new ArrayList<>();
                                    for (Bucket bucket : dataReadResponse.getBuckets()) {
                                        Log.e("History", "Data returned for Data type: " + bucket.getDataSets());

                                        List<DataSet> dataSets = bucket.getDataSets();
                                        for (DataSet dataSet : dataSets) {
                                            DateFormat dateFormat = getDateTimeInstance();

                                            for (DataPoint dp : dataSet.getDataPoints()) {
                                                String type = dp.getDataType().getName();
                                                long startTime = dp.getStartTime(TimeUnit.MILLISECONDS);
                                                long endTime = dp.getEndTime(TimeUnit.MILLISECONDS);
                                                for (Field field : dp.getDataType().getFields()) {
                                                    try {
                                                        String fieldName = field.getName();
                                                        Value fieldValue = dp.getValue(field);
                                                        float value = fieldValue.asFloat();
                                                        Log.i(TAG, "start : " + startTime + " end : " + endTime);
                                                        Log.i(TAG, "type : " + type + " fieldName : " + fieldName + " value : " + value);
                                                        if (!dp.getDataSource().getAppPackageName().contains(context.getPackageName())) {
                                                            HashMap<String, Object> map = new HashMap<String, Object>();
                                                            map.put("value", value);
                                                            map.put("startTime", getDate(startTime));
                                                            map.put("endTime", getDate(endTime));
                                                            map.put("valueId", "HeartRate-" + startTime + "-" + endTime);
                                                            mapList.add(map);
                                                        }
                                                    } catch (Exception e) {
                                                        e.printStackTrace();
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    try {
                                        if (result != null) {
                                            result.success(mapList);
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                }
                            })
                            .addOnFailureListener(new OnFailureListener() {
                                @Override
                                public void onFailure(@NonNull Exception e) {
                                    Log.e(TAG, "onFailure()", e);
                                }
                            })
                            .addOnCompleteListener(new OnCompleteListener<DataReadResponse>() {
                                @Override
                                public void onComplete(@NonNull Task<DataReadResponse> task) {
                                    Log.d(TAG, "onComplete()");
                                }
                            });
                }
            }).start();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /// Added by: Chaitanya
    /// Added on: Oct/8/2021
    /// conver date in proper format
    public String getDate(long time) {
        Date date = new Date(time);
        TimeZone tz = Calendar.getInstance().getTimeZone();
        // *1000 is to convert seconds to milliseconds
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH); // the format of your date
        sdf.setTimeZone(tz);
        return sdf.format(date);
    }

    /// Added by: Chaitanya
    /// Added on: Oct/8/2021
    /// found time difference from end date to start date.
    public String getTimeDifference(long endTime, long startTime) {

        long endMinutes = TimeUnit.MILLISECONDS.toHours(endTime);
        Date dateEnd = new Date(endTime);
        Date dateStart = new Date(startTime);

        int time = dateEnd.compareTo(dateStart);


        int hours = dateEnd.getHours() - dateStart.getHours();
        int minutes = dateEnd.getMinutes() - dateStart.getMinutes();

        String result = hours + ":" + minutes;

        return result;
    }

    /// Added by: Chaitanya
    /// Added on: Oct/8/2021
    /// get time difference
    public String getTime(long time) {
        Date date = new Date(time);// *1000 is to convert seconds to milliseconds
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm", Locale.ENGLISH); // the format of your date
        return sdf.format(date);
    }

    public long getTimestampFromString(String date, String format) throws ParseException {
        DateFormat formatter = new SimpleDateFormat(format);
        return formatter.parse(date).getTime();
    }

}
