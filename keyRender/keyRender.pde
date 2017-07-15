String saveFolder = "save";
float timeBase = 60;
float fontSize = 22;
float lineHeight = 33;
float letterSpacing = 0.4;
float layoutPadding = 100;
float maxLineWidth = 700;
color fontColor = color(0, 222);
boolean debugView = false;


String validChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890äöüÄÖÜ.,;:-_#'+*~<>|^°!\"§$%&/(){}[]?ß´`\\@ ";

KeySeq keySeq;
PFont f;

void setup() {
  size(900, 1000);
  pixelDensity(displayDensity());
  keySeq = new KeySeq();
  f = createFont("font.ttf", fontSize);
  textFont(f);
  textSize(fontSize);
}

void draw() {
  background(250);
  keySeq.update();
  layout();
}

void layout() {
  stroke(fontColor, 97);
  line(0, layoutPadding, width, layoutPadding);
  line(layoutPadding, 0, layoutPadding, height);
  line(width - layoutPadding, 0, width - layoutPadding, height);
  noStroke();
}

String lineBreak(String lineRaw, float lineWidth, float spacing) {

  String[] words = split(lineRaw, ' ');
  //splitting long String into seperate Words
  for (int i = 0; i < words.length; i++) {
    if (words[i].contains("\n")) {
      String[] broken = split(words[i], '\n');
      for (int j = 0; j < broken.length - 1; j++) {
        broken[j] += "\n";
      }
      words[i] = broken[0];
      for (int j = 1; j < broken.length; j++) {
        if (!broken[j].equals("")) {
          words = splice(words, broken[j], i + j);
        }
      }
    } else {
      words[i] += ' ';
    }
  }
  //doing the new lines
  String currentLine = "";
  String lineBroken = "";
  for (int i = 0; i < words.length; i++) {
    float newLineWidth = textWidth(currentLine) + textWidth(words[i]) + (currentLine.length() + words[i].length()) * spacing;
    if ((newLineWidth > lineWidth) && words[i].contains("\n")) {
      currentLine += "\n";
      currentLine += words[i];
      lineBroken += currentLine;
      currentLine = "";
    } else if (words[i].contains("\n")) {
      currentLine += words[i];
      lineBroken += currentLine;
      currentLine = "";
    } else if (newLineWidth > lineWidth) {
      currentLine += "\n";
      lineBroken += currentLine;
      currentLine = words[i];
    } else {
      currentLine += words[i];
    }
  }
  lineBroken += currentLine;
  return lineBroken;
}

LayoutChar[] textSpacing(String text, float x, float y, float spacing, boolean debug) {
  ArrayList<LayoutChar> layoutChars = new ArrayList<LayoutChar>();
  String layedOut = "";
  for (int i = 0; i < text.length(); i++) {
    if (text.charAt(i) == '\n') {
      layedOut = "";
      y += lineHeight;
      continue;
    }
    float xOff = textWidth(layedOut) + layedOut.length() * spacing;
    if (debug) {
      stroke(fontColor, 48);
      line(x + xOff - spacing, y, x + xOff - spacing, y - fontSize);
      stroke(fontColor, 97);
      line(x + xOff, y, x + xOff, y - fontSize);
      noStroke();
    }
    layoutChars.add(new LayoutChar(text.charAt(i), x + xOff, y));
    layedOut += text.charAt(i);
  }
  LayoutChar[] layoutCharsArray = new LayoutChar[layoutChars.size()];
  for (int i = 0; i < layoutChars.size(); i++) {
    layoutCharsArray[i] = layoutChars.get(i);
  }
  return layoutCharsArray;
}

boolean validChar(char in) {
  if (in == ENTER) return true;
  for (int i = 0; i < validChars.length(); i++) {
    if (in == validChars.charAt(i)) return true;
  }
  return false;
}

class KeySeq {
  String previewWords = "";
  ArrayList<StoredChar> storedChars = new ArrayList<StoredChar>();
  boolean recording = false;
  int recordingTime;

  KeySeq() {
  }

  void addKey(char input) {
    if (!recording) {
      recording = true;
      recordingTime = millis();
    }
    if (input == ESC) stopRecording();
    if (input != BACKSPACE) {
      if (validChar(input)) {
        previewWords += input;
        storedChars.add(new StoredChar(input, millis() - recordingTime));
      }
    } else if (previewWords.length() > 0) {
      previewWords = previewWords.substring(0, previewWords.length() - 1);
      int deleteIndex = storedChars.size() - 1;
      while (storedChars.get(deleteIndex).delete(millis() - recordingTime)) {
        deleteIndex--;
      }
    }
  }

  void update() {
    noStroke();
    fill(fontColor);
    //text(lineBreak(previewWords, maxLineWidth), layoutPadding, layoutPadding);
    LayoutChar[] layoutChars = textSpacing(lineBreak(previewWords, maxLineWidth, letterSpacing), layoutPadding, layoutPadding + fontSize, letterSpacing, debugView);
    for (int i = 0; i < layoutChars.length; i++) {
      text(layoutChars[i].value, layoutChars[i].location.x, layoutChars[i].location.y);
    }
  }

  void stopRecording() {
    recording = false;
    float endTime = millis() - recordingTime;
    float playhead = 0;
    int fileName = 0;
    println("RENDERING");
    PGraphics pg = createGraphics(width, height, JAVA2D);
    while (playhead < endTime) {
      String printWords = "";
      for (int i = 0; i < storedChars.size(); i++) {
        if (storedChars.get(i).writeTime < playhead) {
          if (storedChars.get(i).deleted) {
            if (storedChars.get(i).deleteTime > playhead) {
              printWords += storedChars.get(i).value;
            }
          } else {
            printWords += storedChars.get(i).value;
          }
        }
      }
      pg.beginDraw();
      pg.clear();
      pg.smooth();
      pg.textFont(f);
      pg.textSize(fontSize);
      pg.noStroke();
      pg.fill(fontColor);
      LayoutChar[] layoutChars = textSpacing(lineBreak(printWords, maxLineWidth, letterSpacing), layoutPadding, layoutPadding + fontSize, letterSpacing, true);
      for (int i = 0; i < layoutChars.length; i++) {
        pg.text(layoutChars[i].value, layoutChars[i].location.x, layoutChars[i].location.y);
      }
      pg.save(saveFolder + "/" + nf(fileName, 5) + ".png");
      fileName++;
      playhead += 1000 / timeBase;
    }
    println("DONE");
    exit();
  }
}

void keyPressed() {
  keySeq.addKey(key);
}

class StoredChar {
  public char value;
  public float writeTime;
  public float deleteTime;
  public boolean deleted = false;

  StoredChar(char valueIn, float writeTimeIn) {
    value = valueIn;
    writeTime = writeTimeIn;
  }

  boolean delete(float deleteTimeIn) {
    if (!deleted) {
      deleteTime = deleteTimeIn;
      deleted = true;
      return false;
    } else {
      return true;
    }
  }
}

class LayoutChar {
  public char value;
  public PVector location;
  LayoutChar(char val, float x, float y)
  {
    value = val;
    location = new PVector(x, y);
  }
}