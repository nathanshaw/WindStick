/*
The Brains of the Program, orchestrates the data comming in from the Arduino
*/

SerialIO serial;
string line;//the data comming in

2 => int serialPort;

SerialIO.list() @=> string list[];
for( int i; i< list.cap(); i++ )
{
    chout <= i <= ": " <= list[i] <= IO.newline();
}

//opens serial ports
serial.open(serialPort, SerialIO.B9600, SerialIO.ASCII);
/////////////////////////////////////////

Walking walking;
WindTilt windTilt;
WindTilt secondTilt;

//////////////////////////////////////////////////////////
int xDiff, yDiff;
float aDiff;
//string and int values for data from nunchuck
0 => int runState;
0 => int firstTime;
0 => int x_axis;
0 => int y_axis;
0 => int x_acc;
0 => int y_acc;
0 => int z_acc;
0 => int z_button;
0 => int c_button;
string x_axisS, y_axisS ,x_accS ,y_accS, z_accS,z_buttonS,c_buttonS;
//lists serial ports

1::second => now;//to make sure program does not initalize in the middle of a message
spork ~ serialPoller();
spork ~ sendJoyData();
spork ~ sendAccData();

while (true) {
    0.5::second => now;
    if (runState < 1){//to avoid false triggers and uneeded noise
        1 => runState;
    }
}

//////////     **********OUTGOING COMMUNICATION FUNCTIONS*********     \\\\\\\\\\

fun void sendJoyData(){
    while(1){
        if (runState == 1){
            aDif();
            secondTilt.tiltData(xDiff, yDiff);
            1::ms => now;
        }
    }
}

fun void sendAccData(){
    while(true){
        if(runState==1){
            windTilt.tiltData(x_acc, y_acc);
            3::ms => now;
        }
        1::ms => now;
    }
}

fun void sendCButtonData(){
    if (runState == 1){
        windTilt.loadSample(Math.random2(0,11));
        <<<"Changing Sample for Accel">>>;    
    }
}

fun void sendZButtonData(){
    if(runState == 1){
        secondTilt.loadSample(Math.random2(0,11));
        <<<"Changing Sample for Joystick">>>;
    }
}

//////////     **********POLLING FUNCTION*********     \\\\\\\\\\

fun void serialPoller(){
    while( true )
    {
        serial.onLine() => now;
        serial.getLine() => line;
        if( line$Object == null ) continue;
        if (line.length() > 22){ 
            line.substring(0,3) => x_axisS;
            Std.atoi(x_axisS) - 200 => x_axis; 
            line.substring(4,3) => y_axisS;
            Std.atoi(y_axisS) - 200 => y_axis;
            line.substring(8,3) => x_accS;
            Std.atoi(x_accS) - 500 => x_acc;
            line.substring(12,3) => y_accS;
            Std.atoi(y_accS) - 500 => y_acc;
            line.substring(16,3) => z_accS;
            Std.atoi(z_accS) - 500 => z_acc;
            line.substring(20,1) => z_buttonS;
            Std.atoi(z_buttonS) => z_button ;
            if ( z_button > 0){
                if (runState ==1){
                    spork ~ sendZButtonData();  
                }
            }
            line.substring(22,1) => c_buttonS;
            Std.atoi(c_buttonS) => c_button;
            if( c_button > 0)
            { 
                if (runState == 1){
                    spork ~ sendCButtonData();
                }
            }
        }
        else{
            <<<"Error, Serial Message too short">>>;   
        }
    }
}

//////////     **********UTILITY FUNCTIONS*********     \\\\\\\\\\

fun void aDif(){
    Std.abs(125 - x_axis) => xDiff;
    Std.abs(125 - y_axis) => yDiff;
    (xDiff + yDiff)/2 => aDiff;  
}