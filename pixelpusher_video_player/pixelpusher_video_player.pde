import javax.swing.*;
import processing.video.*;
import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import java.util.*;

Movie frame = null;
DeviceRegistry registry;
PusherObserver observer;

void setup() {
  selectInput("Select a file to process:", "fileSelected");
  size(640,480);
  registry = new DeviceRegistry();
  observer = new PusherObserver();
  registry.addObserver(observer);

  // set system look and feel
  try {
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  } catch (Exception e) {
    e.printStackTrace();
  }
}

void fileSelected(File selection) {
  String moviePath = null;
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    exit();
  } else {
    moviePath = selection.getAbsolutePath();
    println("User selected " + moviePath);
  }

  frame = new Movie(this, moviePath);

  frame.loop();
  frame.volume(1);
}

void draw() {
  if(frame != null) {
    image(frame, 0, 0, width, height);
    scrape();
  }
}

void movieEvent(Movie m) {
  m.read();
}
