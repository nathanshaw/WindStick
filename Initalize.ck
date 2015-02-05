//Lets get it started in here!
me.dir() + "/windTilt.ck" => string windTiltPath;
me.dir() + "/serialRouter.ck" => string serialPath;

Machine.add(windTiltPath) => int windTilt;
Machine.add(serialPath) => int serial;

1::week => now;

Machine.remove(windTilt);
Machine.remove(serial);