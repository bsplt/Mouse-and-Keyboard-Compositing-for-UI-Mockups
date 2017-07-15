String mockupFolder = "mockups";
String outputFolder = "output";
String saveFolder = "save";
float timeBase = 60;
String mouseImage = "mouse.png";

ImgSeq imgSeq;
MouseRec mouseRec;
PImage mouse;

void settings() {
  String firstFile = new File(sketchPath() + "/" + mockupFolder).list()[0];
  firstFile = sketchPath() + "/" + mockupFolder + "/" + firstFile;
  PImage firstImage = loadImage(firstFile);
  size(firstImage.width, firstImage.height);
}

void setup() {
  mouse = loadImage(mouseImage);
  imgSeq = new ImgSeq();
  mouseRec = new MouseRec();
  pixelDensity(displayDensity());
}

void draw() {
  imgSeq.update();
  mouseRec.update();
}

void mouseReleased() {
  imgSeq.next();
  mouseRec.clicked();
}

void keyReleased() {
  mouseRec.register(key);
}


class ImgSeq {
  ArrayList<PImage> images = new ArrayList<PImage>();
  int state = 0;
  PImage currentImage;

  ImgSeq() {
    File file = new File(sketchPath() + "/" + mockupFolder);
    if (file.isDirectory()) {
      String[] files = file.list();
      for (int i = 0; i < files.length; i++) {
        images.add(loadImage(sketchPath() + "/" + mockupFolder + "/" + files[i]));
      }
      currentImage = images.get(state);
      println("setup successful");
    } else {
      println(mockupFolder + " is not a folder in your sketch directory.");
    }
  }

  void next() {
    state++;
    currentImage = images.get(state % images.size());
  }

  void update() {
    image(currentImage, 0, 0);
  }
}

class MouseRec {
  ArrayList<PVector> recData = new ArrayList<PVector>();
  ArrayList<Float> clickData = new ArrayList<Float>();
  boolean recording = false;
  int recordingTime;

  MouseRec() {
  }

  void update() {
    if (recording) {
      noStroke();
      fill(255, 0, 0, 127);
      ellipse(width - 50, 50, 25, 25);
      recData.add(new PVector(mouseX, mouseY, millis() - recordingTime));
    }
  }

  void startRecording() {
    recording = true;
    recData.clear();
    println("started recording");
    recordingTime = millis();
  }

  void stopRecording() {
    recording = false;
    float duration = recData.get(recData.size() - 1).z;
    int nextIndex = 1;
    int nextClickIndex = 0;
    int lastIndex = recData.size() - 1;
    int fileName = 0;
    println("stopped, clip length: " + floor(duration) + " ms");
    println("now rendering");
    float playhead = 0;
    PGraphics pg = createGraphics(width, height);
    PrintWriter clickTimes = createWriter(saveFolder + "/mouseclicks.txt");
    clickTimes.println("frames corresponding to mouse releases:");
    while (nextIndex < lastIndex) {
      while (playhead > recData.get(nextIndex).z) {
        nextIndex++;
      }
      float interpol = 1 - ((recData.get(nextIndex).z - playhead) / (recData.get(nextIndex).z - recData.get(nextIndex - 1).z));
      println("ph: " + playhead + "\tip: " + interpol + "\tni-1: " + recData.get(nextIndex-1).z + "\tni: " + recData.get(nextIndex).z);
      playhead += 1000 / timeBase;
      if ((interpol > 1) || (interpol < 0)) continue;
      pg.beginDraw();
      pg.clear();
      pg.image(mouse, ip(interpol, recData.get(nextIndex - 1).x, recData.get(nextIndex).x), ip(interpol, recData.get(nextIndex - 1).y, recData.get(nextIndex).y));
      pg.endDraw();
      pg.save(saveFolder + "/" + nf(fileName, 5) + ".png");
      if (nextClickIndex < clickData.size()) {
        if (clickData.get(nextClickIndex) < playhead) {
          nextClickIndex++;
          clickTimes.println(fileName);
        }
      }
      fileName++;
    }
    clickTimes.flush();
    clickTimes.close();
    exit();
  }

  void clicked() {
    if (recording) clickData.add((float) millis() - recordingTime);
  }

  void register(char input) {
    if (input == 'r' || input == 'R') {
      if (!recording) {
        startRecording();
      } else {
        stopRecording();
      }
    }
  }
}

float ip(float interpol, float val1, float val2) {
  return (val2 - val1) * interpol + val1;
}