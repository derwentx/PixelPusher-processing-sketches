class DetectedPusher {
  String port;
  String ver;

  DetectedPusher(String port, String ver) {
    this.port = port;
    this.ver = ver;
  }
}

DetectedPusher DetectPusher() {
  Serial s;
  char lf = '\n';
  Pattern vrx = Pattern.compile("PixelPusher (.*) ready and waiting");
  String pusherPort = null;
  String pusherVersion = null;

  // List all the available serial ports:
  for (String pn : Serial.list()) {
    try {
      //println("Attempting to detect PixelPusher on port " + pn);
      s = new Serial(this, pn, 115200);
      s.write("\r\nReboot");
      s.clear();
      delay(2000);
      while (s.available () > 0) {
        String r = s.readStringUntil(lf);
        if (r != null) {
          Matcher m = vrx.matcher(r);
          if (m.find()) {
            pusherVersion = m.group(1);
            pusherPort = pn;
          }
        }
      }
    } 
    catch (Exception ex) {
      //println("Couldn't open port " + pn);
    }
  }
  if (pusherPort != null) {
    println("PixelPusher found on " + pusherPort + ". Version: " + pusherVersion);
    return new DetectedPusher(pusherPort, pusherVersion);
  } 

  println("No PixelPusher found. Unplug, wait 5 seconds, and plug back in and try again");
  return null;
}
