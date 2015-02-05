/*
Programmed by Nathan Shaw in Spring 2015 at CalArts
Two instances of this class provide the sound for my WindStick Wii Nunchuck Instrument
The Instrument itself is simply a hacked Wii Nunchuck Controller. 
Each instance of this WindTilt class is mapped to the accelometer and joystick data.
The two puchbuttons cycle through the available samples. 

Once i find the best sample combinations i will most likely remap the buttons to
activate and deactive additional FX
*/
public class WindTilt{
    
    LiSa looper => JCRev reverb => Chorus chorus => Gain master => Gain level => blackhole;
    SndBuf buf => reverb => chorus => master => dac;
    SinOsc tracker => looper;
    Step off => looper;
    
    20 => chorus.modFreq;
    0.2 => chorus.modDepth;
    0.5 => chorus.mix;
    .29 => level.gain;
    0.1 => float trackerGain;
    0 => int gate;
    0.22 => reverb.mix;
    0.0357 => master.gain;
    float average;
    string windSounds[12];
    
    me.dir() + "/audio/wind1.wav" => windSounds[0];
    me.dir() + "/audio/wind2.wav" => windSounds[1];
    me.dir() + "/audio/wind3.wav" => windSounds[2];
    me.dir() + "/audio/laser1.wav" => windSounds[3];
    me.dir() + "/audio/laser2.wav" => windSounds[4];
    me.dir() + "/audio/laser3.wav" => windSounds[5];
    me.dir() + "/audio/newPlayer1.wav" => windSounds[6];
    me.dir() + "/audio/noAmmo1.wav" => windSounds[7];
    me.dir() + "/audio/playerKilled1.wav" => windSounds[8];
    me.dir() + "/audio/explosion1.wav" => windSounds[9];
    me.dir() + "/audio/explosion2.wav" => windSounds[10];
    me.dir() + "/audio/lowEnd.wav" => windSounds[11];
    
    windSounds[2] => buf.read;
    
    fun void tiltData(int accX, int accY){
        //<<<"data Received", accX, accY>>>;
        (Std.abs(accX) + accY) => average;  
        //<<<"Average :", average>>>;
        Std.ftoi(average * 10) => buf.pos;
        Math.pow(accX, 2) /100  => buf.rate;
        0.7 => buf.gain; 
        accY => chorus.modFreq;
        //10::ms => now;
    }
    
    fun void loadSample(int arrayPos){
        <<<"Loaded Sample : ", arrayPos>>>;
        if (arrayPos < windSounds.cap()-1){
            windSounds[arrayPos] => buf.read;
            buf.samples()::samp => looper.duration;  
            for ( 0 => int i; i < buf.samples(); i++){
                looper.valueAt(buf.valueAt(i), i::samp);//puts values into LiSa   
            }
          
        }
        else{
            windSounds[Math.random2(0,windSounds.cap()-1)] => buf.read;
            buf.samples()::samp => looper.duration;  
            for ( 0 => int i; i < buf.samples(); i++){
                looper.valueAt(buf.valueAt(i), i::samp);//puts values into LiSa   
            }
        }   
    }   
}