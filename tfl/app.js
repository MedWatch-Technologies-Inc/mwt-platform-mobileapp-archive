import * as tf from '@tensorflow/tfjs-node';
import * as fs from 'fs'; 
import lowPassFilter  from 'low-pass-filter';
import Fili from 'fili';
import { dct } from '@swnb/dct';
import { idct } from '@swnb/dct';
import { model } from '@tensorflow/tfjs-node';


const SIGNAL_LEN = 3048
const TARGET_LEN = 1500
const Q_THRESHOLD = 4.
const STRIDE = 500
const WINDOW_LEN = 1500
const NUM_ANCHORS = 50
const RESCALED_LEN= 500 

// await tf.loadLayersModel('file://tf_model_in_js/model.json');   // Load Tensorflow Model

async function load_tf_model() {
  const model =  tf.loadLayersModel('file://tf_model_in_js/model.json');
  return model
}



function generateRandomInteger(max) {
  return Math.floor(Math.random() * max) + 1;
}

const filter = Fili.CalcCascades();


var obj = JSON.parse(fs.readFileSync('sample_json.json', 'utf8'));


var iirCalculator = new Fili.CalcCascades();

var high_iirFilterCoeffs  = iirCalculator.highpass({
    order:2, // cascade 3 biquad filters (max: 12)
    characteristic: 'butterworth',
    Fs: 2500, // sampling frequency
    Fc: 15, // cutoff frequency / center frequency for bandpass, bandstop, peak
    //BW: 1, // bandwidth only for bandstop and bandpass filters - optional
    //gain: 0, // gain for peak, lowshelf and highshelf
    //preGain: true // adds one constant multiplication for highpass and lowpass
    // k = (1 + cos(omega)) * 0.5 / k = 1 with preGain == false
  });

var low_iirFilterCoeffs  = iirCalculator.lowpass({
    order: 2, // cascade 3 biquad filters (max: 12)
    characteristic: 'butterworth',
    Fs: 1000, // sampling frequency
    Fc: 100, // cutoff frequency / center frequency for bandpass, bandstop, peak
    //BW: 1, // bandwidth only for bandstop and bandpass filters - optional
    //gain: 0, // gain for peak, lowshelf and highshelf
    //preGain: false // adds one constant multiplication for highpass and lowpass
    // k = (1 + cos(omega)) * 0.5 / k = 1 with preGain == false
  });



const raw_ppg = obj.raw_ppg.map(str => {            // Convert str of numbers to ints for ppgs
  return Number(str);});



var firFilterlow  = new Fili.IirFilter(low_iirFilterCoeffs);
var firFilterhigh  = new Fili.IirFilter(high_iirFilterCoeffs);


var filtered_ppg_high = firFilterhigh.simulate(raw_ppg);                    // Run high pass filter

var ppg_filtered = firFilterlow.simulate(filtered_ppg_high);   // Run low pass filter
var ecg_filtered = obj.raw_ecg.map(str => {            // Convert str of numbers to ints for ecgs
  return Number(str);});


var array_of_signals = new Array();
var array_of_demographics = new Array();
var i =0;

while (WINDOW_LEN+STRIDE*i < SIGNAL_LEN){                                   // Slice into windows and scale signals in the range [0,1]
  var slice_of_ppg = tf.slice(ppg_filtered,i*STRIDE,WINDOW_LEN);
  var slice_of_ecg = tf.slice(ecg_filtered,i*STRIDE,WINDOW_LEN);


  const fcd_transform_ecg = dct([slice_of_ecg.arraySync()]);
  const filtered_ecg = idct([fcd_transform_ecg[0].slice(0,RESCALED_LEN)]);

  const fcd_transform = dct([slice_of_ppg.arraySync()]);
  const filtered_ppg = idct([fcd_transform[0].slice(0,RESCALED_LEN)]);

  const min_in_ppg  = tf.min(filtered_ppg);                        //Scale the ppg from 0-1
  const max_in_ppg = tf.max(filtered_ppg);
  
  const min_array = tf.onesLike(filtered_ppg).mul(min_in_ppg);

  const ppg_minus_min_ppg = tf.sub(filtered_ppg,min_array);
  const dif_max_and_min_ppg = tf.sub(max_in_ppg,min_in_ppg);

  const scaled_ppg = ppg_minus_min_ppg.div(dif_max_and_min_ppg);


  const min_in_ecg = tf.min(filtered_ecg);                        //Scale the ppg from 0-1
  const max_in_ecg = tf.max(filtered_ecg);
  
  const min_array_ecg = tf.onesLike(filtered_ecg).mul(min_in_ecg);

  const ecg_minus_min = tf.sub(filtered_ecg,min_array_ecg);
  const dif_max_and_min_ecg = tf.sub(max_in_ecg,min_in_ppg);

  const scaled_ecg = ecg_minus_min.div(dif_max_and_min_ecg);


  const signal_ppg_ecg = tf.concat([scaled_ppg.reshape([1,500,1]),scaled_ppg.reshape([1,500,1])],-1);
  const signal_dems = tf.tensor([obj.age,obj.height,obj.weight,obj.hr]);
  array_of_signals.push(signal_ppg_ecg);
  array_of_demographics.push(signal_dems.reshape([1,-1]));
  i++;
  //console.log(scaled_ppg.arraySync());
}




//var output = model.predict([array_of_signals[0],array_of_demographics[0],array_of_signals[0],array_of_demographics[0]]);



var anchor = JSON.parse(fs.readFileSync('anchor_signals_json/anchor_'+generateRandomInteger(2777).toString()+'.json', 'utf8'));

const anchor_ppg_ecg = tf.concat([tf.tensor(anchor.ppg).reshape([1,500,1]),tf.tensor(anchor.ecg).reshape([1,500,1])],-1);
const anchor_dems = tf.tensor([anchor.age,anchor.height,anchor.weight,anchor.hr]).reshape([1,4]);
const anchor_bp = tf.tensor([anchor.sys,anchor.dias])


load_tf_model().then((model) => {

var prediction = model.predict([array_of_signals[0],array_of_demographics[0],anchor_ppg_ecg,anchor_dems]);


for (let i = 1; i <= NUM_ANCHORS; i++) {
  var anchor = JSON.parse(fs.readFileSync('anchor_signals_json/anchor_'+generateRandomInteger(2777).toString()+'.json', 'utf8'));

  const anchor_ppg_ecg = tf.concat([tf.tensor(anchor.ppg).reshape([1,500,1]),tf.tensor(anchor.ecg).reshape([1,500,1])],-1);
  const anchor_dems = tf.tensor([anchor.age,anchor.height,anchor.weight,anchor.hr]).reshape([1,4]);
  const anchor_bp = tf.tensor([anchor.sys,anchor.dias])
  
  var output = model.predict([array_of_signals[0],array_of_demographics[0],anchor_ppg_ecg,anchor_dems]);
  const new_prediction = tf.add(anchor_bp,output);
  prediction = tf.add(new_prediction,prediction);
  


  //console.log(output.print())

 
}



console.log(prediction.div(tf.scalar(NUM_ANCHORS+1)).arraySync());});