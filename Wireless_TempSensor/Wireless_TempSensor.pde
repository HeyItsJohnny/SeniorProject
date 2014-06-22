import processing.serial.*;
import controlP5.*;
import javax.swing.JOptionPane;
import java.awt.Frame;
import java.awt.BorderLayout;

ControlP5 cp5;
float n;
ControlFont font;
ControlTimer timer1;
ControlTimer timer2;
//ControlFrame NewWindow;

Serial myPort;        //declar obect as myPort
String inBuffer = ""; 
int dataCount = 1; 
int loopCount = 0; 
int[] Temperature_array = new int[625];    //Temperature array
PrintWriter output;   //.txt file object
PrintWriter ButtonOutput;
int myColor = color(255);
int myColor2 = color(0);
String FileName;

//fahrenheit temperature global variables
int[] FTempArray = new int[625];    //Temperature array
ControlFrame cf;
int def;

 void setup() {
  size(1024, 768);      //set sixe of window
  noStroke();
  myPort = new Serial(this, Serial.list()[0], 9600);      //initialize new serial
  myPort.bufferUntil ('\n');        
  smooth();
  frameRate(15);      //set framerate to 15
  output = createWriter("Temperature_Data.txt");
  // initialize new control frame
 
  
  // Initialize new instances of Buttons
  cp5 = new ControlP5(this);
  timer1 = new ControlTimer();
  timer1.setSpeedOfTime(1);

  
 // NewWindow = addControlFrame("extra",200,200);
 
  
  // Add button attributes
      cp5.addButton("SaveData")
         .setBroadcast(false)
         .setValue(0)
         .setBroadcast(true)
         .setPosition(750,250)
         .setSize(150,75)
         ;
      cp5.addButton("FahrenheitGraph")
         .setBroadcast(false)
         .setValue(0)
         .setBroadcast(true)
         .setPosition(750,370)
         .setSize(150,75)
         ;
      cp5.addButton("ResetTimer")
         .setBroadcast(false)
         .setValue(0)
         .setBroadcast(true)
         .setPosition(750,490)
         .setSize(150,75)
         ;
      cp5.addButton("ResetAll")
         .setBroadcast(false)
         .setValue(0)
         .setBroadcast(true)
         .setPosition(10,70)
         .setSize(50,25)
         ;
      cp5.addButton("Exit")
         .setBroadcast(false)
         .setValue(0)
         .setBroadcast(true)
         .setPosition(750,610)
         .setSize(150,75)
         ;
    
}

//All data is transferred from the Arduino to the computer in this function
void serialEvent(Serial myPort) {
  inBuffer = myPort.readStringUntil('\n');      //inBuffer = string
  inBuffer = inBuffer.substring(0, inBuffer.length()- 1);
  dataCount ++;  
}

void draw() {
background(myColor);    //background is white
fill(0);
//time variables
  int day = day();        // get current day
  int month = month();   // get current month
  int year = year();    // get current year
  int s = second();     //get current second from computer clock
  int m = minute();     //get current minute from computer clock
  int h = hour();       //get current hour from computer clock

//Title of graph
textSize(25);
text("Real Time Temperature Graph", 300, 30); 

//LABELS FOR THE X axis Time in (Seconds)
textSize(18);
text("<---Time (s)--->", 200, 755);

//LABELS FOR THE Y axis (Celisus 0 - 100 by 10's)
textSize(14);
text("0\u00B0", 645, 765);        //0 degrees axis
text("10\u00B0", 627, 705);
text("20\u00B0", 627, 638);
text("30\u00B0", 627, 571);
text("40\u00B0", 627, 504);
text("50\u00B0", 627, 437);
text("60\u00B0", 627, 370);
text("70\u00B0", 627, 304);
text("80\u00B0", 627, 237);
text("90\u00B0", 627, 170);
text("100\u00B0", 627, 103);
text("Y-axis: Temperature (C)", 460, 96);

//Display Temperature in Celsius and Fahrenheit
//float FTemp=float(inBuffer);    //convert 
float FTemp=float(inBuffer);    //convert 
FTemp = (FTemp*1.8) + 32;    //calculate Fahrenehit temp
textSize(15);
text("Display of temperatures (Celsius and Fahrenheit): ", 650, 70);
text("Temperature Celsius:" + " " + inBuffer + "\u00B0C", 730, 130);
text("Temperature Fahrenheit:" + " " + FTemp + "\u00B0F", 730, 160);

textSize(14);
text("Click to save single data entry at current time", 690, 240);
text("Click Button to Access Fahrenheit graph", 690, 360);
text("Click Button to reset Timer1", 690, 480);
text("Click Button to Exit out of entire program", 690, 600);
text("QUICK SAVE FEATURE: Press enter to save all data and exit program.", 680, 730);

String Date = "Date: " +month+ "/" +day+"/" +year+" Time: " + h + " Hour: " + m +  " minutes: " + s + " seconds";

//timer 
textSize(12);
text("Reset Timer1 and Timer2", 10, 65);
textSize(16);
text("Timer: " + timer1.toString(), 150, 95); 

// What to write on file
output.println("Date: " +month+ "/" +day+"/" +year+" Time: " + h + " Hour: " + m +  " minutes: " + s + " seconds");
output.println("Temperature C: " +inBuffer);
output.println("Temperature F:  " + FTemp);
output.println("");

//Draw Grid Lines
for (int i = 0 ;i<=width/18.75;i++)
{
strokeWeight(0);
stroke(0);
line((-frameCount%20)+i*20-450, 100, (-frameCount%20)+i*20-450, height);
line(0, i*20+100, width-400, i*20+100);
}
//Create Temperature Line
float Temperature=float(inBuffer);
float var_scale_t = map(Temperature, 0, 100, 768, 100);
noFill();
stroke(109, 41, 71);
strokeWeight(5);
beginShape();
Temperature_array[Temperature_array.length-1]= int(var_scale_t);
for (int i = 0; i<Temperature_array.length;i++)
{
  vertex(i, Temperature_array[i]);
}
endShape();
for (int i = 1; i<Temperature_array.length;i++)
{
  Temperature_array[i-1] = Temperature_array[i];
}

}

public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName());
  n = 0;
}

//Fahrenheit graph button handler
public void FahrenheitGraph(int theValue){
JOptionPane.showMessageDialog(null,"You have opened the Fahrenheit graph");
cf = addControlFrame("FahrenheitGraph", 600,800);
}

//timer reset button handler
public void ResetTimer(int theValue){
JOptionPane.showMessageDialog(null,"Timer1 is resetting");
timer1.reset();
}
public void ResetAll(int theValue){
JOptionPane.showMessageDialog(null,"Timer1 and Timer2 are resetting");
timer1.reset();
timer2.reset();
}

// function to save data button
public void SaveData(int theValue) {
  //println("a button event from SaveData "+theValue);
  String FileName;
  String Search = ".txt";
  
  FileName = JOptionPane.showInputDialog(null,"Enter File Name: ");
  int StringLength = FileName.length();
  String sub = FileName.substring(StringLength - 4, StringLength);    //get last 4 charaters in string
  
  if (sub.equalsIgnoreCase(Search))
  {
  int day = day();        // get current day
  int month = month();   // get current month
  int year = year();    // get current year
  int s = second();     //get current second from computer clock
  int m = minute();     //get current minute from computer clock
  int h = hour();       //get current hour from computer clock
  
  float FTemp=float(inBuffer);    //convert 
  FTemp = (FTemp*1.8) + 32;    //calculate Fahrenehit temp
  
  ButtonOutput = createWriter(FileName);      //Create data field
  ButtonOutput.println("Date: " +month+ "/" +day+"/" +year+" Time: " + h + " Hour: " + m +  " minutes: " + s + " seconds"); // print current date/time
  ButtonOutput.println("Temperature C: " +inBuffer);    //print current Celsius value
  ButtonOutput.println("Temperature F:  " + FTemp);    // print current Fahrenheit value
  ButtonOutput.println("");                            // add space
  ButtonOutput.flush(); // Writes the remaining data to the file
  ButtonOutput.close(); // Finishes the file 
    }
  else
  { 
   JOptionPane.showMessageDialog(null,"WARNING!! You need to put the file extension (.txt) at the end of your filename ");
   FileName = JOptionPane.showInputDialog(null,"Enter File Name: ");
 
  }
}

private void Exit(int theValue) {
  //println("a button event from SaveData "+theValue);
  JOptionPane.showMessageDialog(null,"**You are exiting program**");
  exit();
}

//Press any key and will save the data 
  void keyPressed() {
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  JOptionPane.showMessageDialog(null,"**You have saved your data in Temperature_data.txt** Program Will Exit");
  exit(); // Stops the program
}

ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
 // String graph = theEvent.getController().getName();
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
 
  return p;
  
}  


// the ControlFrame class extends PApplet, so we 
// are creating a new processing applet inside a
// new frame with a controlP5 object loaded
public class ControlFrame extends PApplet {


  int w, h;

  //int abc = 100;
  
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);
    
    //myPort = new Serial(this, Serial.list()[0], 9600);      //initialize new serial
    //myPort.bufferUntil ('\n');  
  timer2 = new ControlTimer();
  timer1.setSpeedOfTime(1);
  
      cp5.addButton("ExitGraph")
         .setBroadcast(false)
         .setValue(0)
         .setBroadcast(true)
         .setPosition(525,70)
         .setSize(50,25)
         ;
      cp5.addButton("ResetTimer")
         .setBroadcast(false)
         .setValue(0)
         .setBroadcast(true)
         .setPosition(400,70)
         .setSize(50,25)
         ;
    
  }
  
  void serialEvent(Serial myPort) {
  inBuffer = myPort.readStringUntil('\n');      //inBuffer = string
  inBuffer = inBuffer.substring(0, inBuffer.length()- 1);
  dataCount ++;  
}

public void draw() {
float CTemp=float(inBuffer);
float FTemp=(1.8*CTemp) + 32;
    
background(255);
fill(0);
for (int i = 0 ;i<=width/10;i++)
{
strokeWeight(0);
stroke(0);
//line(0, 100,350,100);
line((-frameCount%20)+i*20-450, 100, (-frameCount%20)+i*20-450, height);  // verticle
line(0, i*20+100, width, i*20+100);             // create horizontal lines
}
//create title
textSize(16);
text("Temperature Graph (Fahrenheit)", 200, 30); 

//Create Temperature Line
textSize(12);
text("Temperature Fahrenheit:" + " " + FTemp + "\u00B0F", 15, 70);
text("Timer: " + timer2.toString(), 15, 90);
text("Restart Timer2.", 350, 60);
text("Exit Program. ", 500, 60);

//Draw text Y Axis
textSize(14);
text("32\u00B0F", 555, 765);
text("60\u00B0F", 555, 658);
text("70\u00B0F", 555, 625);
text("80\u00B0F", 555, 590);
text("90\u00B0F", 555, 550);
text("100\u00B0F", 555, 515);
text("110\u00B0F", 555, 478);
text("120\u00B0F", 555, 442);

float var_scale_t = map(FTemp, 32, 212, 760, 100);
noFill();
stroke(109, 41, 71);
strokeWeight(5);
if (FTemp < 311)
{
beginShape();
FTempArray[FTempArray.length-1]= int(var_scale_t);
for (int i = 0; i<FTempArray.length;i++)
{
  vertex(i, FTempArray[i]);
}
endShape();
for (int i = 1; i<FTempArray.length;i++)
{
  FTempArray[i-1] = FTempArray[i];
}
}
  }
  
  public void ExitGraph(int theValue){
JOptionPane.showMessageDialog(null,"You are exiting the Fahrenheit graph window.");
exit();
} 
   public void ResetTimer(int theValue){
JOptionPane.showMessageDialog(null,"Timer2 is resetting.");
timer2.reset();
} 
  
  private ControlFrame() {
  }

  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }


  public ControlP5 control() {
    return cp5;
  }
  
  
  ControlP5 cp5;

  Object parent;

  
}

