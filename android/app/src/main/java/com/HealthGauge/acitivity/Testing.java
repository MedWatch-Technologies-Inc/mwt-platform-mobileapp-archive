package com.HealthGauge.acitivity;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.fitness.FitnessOptions;
import com.google.android.gms.fitness.data.DataType;
import com.google.android.gms.fitness.data.HealthDataTypes;
import com.HealthGauge.R;
import com.HealthGauge.utils.Constants;

import aicare.net.cn.iweightlibrary.bleprofile.BleProfileServiceReadyActivity;
import aicare.net.cn.iweightlibrary.entity.AlgorithmInfo;
import aicare.net.cn.iweightlibrary.entity.BodyFatData;
import aicare.net.cn.iweightlibrary.entity.BroadData;
import aicare.net.cn.iweightlibrary.entity.DecimalInfo;
import aicare.net.cn.iweightlibrary.entity.WeightData;
import aicare.net.cn.iweightlibrary.wby.WBYService;

import static com.google.android.gms.fitness.data.DataType.TYPE_HEART_RATE_BPM;
import static com.google.android.gms.fitness.data.DataType.TYPE_WEIGHT;
import static com.google.android.gms.fitness.data.HealthDataTypes.TYPE_BLOOD_PRESSURE;

public class Testing extends BleProfileServiceReadyActivity {

    private GoogleSignInAccount account;
    private FitnessOptions fitnessOptions;

    @Override
    protected void onError(String s, int i) {

    }

    @Override
    protected void onGetWeightData(WeightData weightData) {

    }

    @Override
    protected void onGetSettingStatus(int i) {

    }

    @Override
    protected void onGetResult(int i, String s) {

    }

    @Override
    protected void onGetFatData(boolean b, BodyFatData bodyFatData) {

    }

    @Override
    protected void onGetDecimalInfo(DecimalInfo decimalInfo) {

    }

    @Override
    protected void onGetAlgorithmInfo(AlgorithmInfo algorithmInfo) {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_testing);
        googleAuthentication();
    }

    private void googleAuthentication() {
        fitnessOptions = FitnessOptions.builder()
                .addDataType(DataType.TYPE_STEP_COUNT_DELTA, FitnessOptions.ACCESS_READ)
                .addDataType(DataType.TYPE_STEP_COUNT_DELTA, FitnessOptions.ACCESS_WRITE)

                .addDataType(DataType.TYPE_SLEEP_SEGMENT, FitnessOptions.ACCESS_READ)
                .addDataType(DataType.TYPE_SLEEP_SEGMENT, FitnessOptions.ACCESS_WRITE)

                .addDataType(DataType.TYPE_HEART_POINTS, FitnessOptions.ACCESS_READ)
                .addDataType(DataType.TYPE_HEART_POINTS, FitnessOptions.ACCESS_WRITE)

                .addDataType(TYPE_HEART_RATE_BPM, FitnessOptions.ACCESS_READ)
                .addDataType(TYPE_HEART_RATE_BPM, FitnessOptions.ACCESS_WRITE)

                .addDataType(DataType.TYPE_DISTANCE_DELTA, FitnessOptions.ACCESS_READ)
                .addDataType(DataType.TYPE_DISTANCE_DELTA, FitnessOptions.ACCESS_WRITE)

                .addDataType(DataType.TYPE_HEIGHT, FitnessOptions.ACCESS_READ)
                .addDataType(TYPE_WEIGHT, FitnessOptions.ACCESS_WRITE)

                .addDataType(DataType.AGGREGATE_STEP_COUNT_DELTA, FitnessOptions.ACCESS_READ)
                .addDataType(DataType.AGGREGATE_STEP_COUNT_DELTA, FitnessOptions.ACCESS_WRITE)

                .addDataType(DataType.TYPE_NUTRITION, FitnessOptions.ACCESS_READ)
                .addDataType(DataType.TYPE_NUTRITION, FitnessOptions.ACCESS_WRITE)

                .addDataType(DataType.TYPE_ACTIVITY_SEGMENT, FitnessOptions.ACCESS_READ)
                .addDataType(DataType.TYPE_ACTIVITY_SEGMENT, FitnessOptions.ACCESS_WRITE)

                .addDataType(TYPE_BLOOD_PRESSURE, FitnessOptions.ACCESS_READ)
                .addDataType(TYPE_BLOOD_PRESSURE, FitnessOptions.ACCESS_WRITE)

                .addDataType(HealthDataTypes.AGGREGATE_BLOOD_PRESSURE_SUMMARY, FitnessOptions.ACCESS_READ)
                .addDataType(HealthDataTypes.AGGREGATE_BLOOD_PRESSURE_SUMMARY, FitnessOptions.ACCESS_WRITE)

                .addDataType(HealthDataTypes.TYPE_BLOOD_GLUCOSE, FitnessOptions.ACCESS_READ)
                .addDataType(HealthDataTypes.TYPE_BLOOD_GLUCOSE, FitnessOptions.ACCESS_WRITE)

                .addDataType(HealthDataTypes.AGGREGATE_BLOOD_GLUCOSE_SUMMARY, FitnessOptions.ACCESS_READ)
                .addDataType(HealthDataTypes.AGGREGATE_BLOOD_GLUCOSE_SUMMARY, FitnessOptions.ACCESS_WRITE)
                .build();

        try {
            GoogleSignInOptions gso = new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN).requestEmail()
                    .addExtension(fitnessOptions)
                    .build();
            GoogleSignInClient mGoogleSignInClient = GoogleSignIn.getClient(this, gso);

            Intent signInIntent = mGoogleSignInClient.getSignInIntent();
            startActivityForResult(signInIntent, Constants.googleFitSignInRequestCode);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void onServiceBinded(WBYService.WBYBinder wbyBinder) {

    }

    @Override
    protected void onServiceUnbinded() {

    }

    @Override
    protected void getAicareDevice(BroadData broadData) {

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constants.googleFitSignInRequestCode) {
            Toast.makeText(this, "ahj", Toast.LENGTH_SHORT).show();
        }
    }

}