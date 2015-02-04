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
    string windSounds[9];
    
    me.dir() + "/audio/wind1.wav" => windSounds[0];
    me.dir() + "/audio/wind2.wav" => windSounds[1];
    me.dir() + "/audio/wind3.wav" => windSounds[2];
    me.dir() + "/audio/laser1.wav" => windSounds[3];
    me.dir() + "/audio/laser2.wav" => windSounds[4];
    me.dir() + "/audio/laser3.wav" => windSounds[5];
    me.dir() + "/audio/woosh1.wav" => windSounds[6];
    me.dir() + "/audio/woosh2.wav" => windSounds[7];
    me.dir() + "/audio/woosh3.wav" => windSounds[8];
        me.dir() + "/audio/noAmmo1.wav" => windSounds[9];
    me.dir() + "/audio/noAmmo2.wav" => windSounds[10];
    me.dir() + "/audio/noAmmo3.wav" => windSounds[11];
    me.dir() + "/audio/playerKilled1.wav" => windSounds[12];
    me.dir() + "/audio/playerKilled2.wav" => windSounds[13];
    me.dir() + "/audio/playerkilled3.wav" => windSounds[14];
    me.dir() + "/audio/newPlayer1.wav" => windSounds[15];
    me.dir() + "/audio/newPlayer2.wav" => windSounds[16];
    me.dir() + "/audio/newPlayer3.wav" => windSounds[17];
    
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
        <<<"New SAmple LOaded">>>;
        if (arrayPos < windSounds.cap()){
            windSounds[arrayPos] => buf.read;
            buf.samples()::samp => looper.duration;  
            for ( 0 => int i; i < buf.samples(); i++){
                looper.valueAt(buf.valueAt(i), i::samp);//puts values into LiSa   
            }
            /*
            while(true){
                1 => looper.sync;
                trackerGain => tracker.freq;
                0.5 => tracker.gain;
                //0.5 => off.next; 
                1 => looper.play;
                trackerGain => looper.gain;
                buf.samples()::samp => now;
            }
            */
        }
        else{
            windSounds[Math.random2(0,windSounds.cap()-1)] => buf.read;
            buf.samples()::samp => looper.duration;  
            for ( 0 => int i; i < buf.samples(); i++){
                looper.valueAt(buf.valueAt(i), i::samp);//puts values into LiSa   
            }
            /*
            while(true){
                1 => looper.sync;
                0.025 => tracker.freq;
                trackerGain => tracker.gain;
                0.0 => off.next; 
                1 => looper.play;
                1.0 => looper.gain;
                buf.samples()::samp => now;     
            }
            */
        }   
    }   
}