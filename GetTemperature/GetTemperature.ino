//declare variables
float tempC;
int tempPin = 0; //Analog pin 0
void setup()
{
Serial.begin(9600); //opens serial port, sets data rate to 9600 bps 
}
void loop()
{
tempC = analogRead(tempPin); //read the value from the sensor
tempC = (5.0 * tempC * 100.0)/1024.0; //convert the analog data to temperature Serial.println((byte)tempC); //send the data to the computer
delay(500); //wait 0.7 seconds before sending new data
}
