#include <ESP8266WiFi.h>
#include <WiFiClient.h> 
#include <ESP8266WebServer.h>
#include <ESP8266HTTPClient.h>
#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BME280.h>
#include <BH1750.h>
#define SEALEVELPRESSURE_HPA (1013.25)
BH1750 lightMeter (0x23);
Adafruit_BME280 bme;
float temperature, humidity, pressure, altitude;
/* Set these to your desired credentials. */
const char *ssid = "VT538";  //ENTER YOUR WIFI SETTINGS
const char *password = "12345678";
//Web/Server address to read/write from 
const char *host = "192.168.43.128";   //https://circuits4you.com website or IP address of server
 
//=======================================================================
//                    Power on setup
//=======================================================================

void setup() {
  delay(1000);
  Serial.begin(115200);
  bme.begin(0x76);   
  WiFi.mode(WIFI_OFF);        //Prevents reconnection issue (taking too long to connect)
  delay(1000);
  WiFi.mode(WIFI_STA);        //This line hides the viewing of ESP as wifi hotspot
  
  WiFi.begin(ssid, password);     //Connect to your WiFi router
  Serial.println("");
 
  Serial.print("Connecting");
  // Wait for connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
 
  //If connection successful show IP address in serial monitor
  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());  //IP address assigned to your ESP
}
 
//=======================================================================
//                    Main Program Loop
//=======================================================================
void readSensorData() {
  temperature = bme.readTemperature();
  humidity = bme.readHumidity();
  pressure = bme.readPressure() / 100.0F;
  altitude = bme.readAltitude(SEALEVELPRESSURE_HPA);
}
void loop() {
  readSensorData();
  delay(500);
  if (WiFi.status() == WL_CONNECTED) {
  HTTPClient http;    //Declare object of class HTTPClient
 
  String ADCData, station, postData;
  int adcvalue=analogRead(A0);  //Read Analog value of LDR
  ADCData = String(adcvalue);   //String to interger conversion
  station = "A";
  postData = "status=" + ADCData + "&station=" + station ;
  //Post Data Humidity
 //---------------------------------------------------------------------------------------------------
  String req_humidity = "http://13.53.149.166:8000/20Node_MCU19?id=";
  req_humidity+="2&value=";
  req_humidity+=humidity;
  http.begin(req_humidity);              //Specify request destination
  http.addHeader("Content-Type", "application/x-www-form-urlencoded");    //Specify content-type header
  int httpCode = http.GET();   //Send the request
  String payload = http.getString();    //Get the response payload
  Serial.println(httpCode);   //Print HTTP return code
  Serial.println(payload);    //Print request response payload
  http.end();
  delay(100);
  //--------------------------------------------------------------------------------------------------
   String req_temperature = "http://13.53.149.166:8000/20Node_MCU19?id=";
  req_temperature+="1&value=";
  req_temperature+=temperature;
  http.begin(req_temperature);              //Specify request destination
  http.addHeader("Content-Type", "application/x-www-form-urlencoded");    //Specify content-type header
  int httpCodeT = http.GET();   //Send the request
  String payloadT = http.getString();    //Get the response payload
  Serial.println(httpCodeT);   //Print HTTP return code
  Serial.println(payloadT);    //Print request response payload
  http.end();
  delay(100);
   //--------------------------------------------------------------------------------------------------
  String req_pressure = "http://13.53.149.166:8000/20Node_MCU19?id=";
  req_pressure+="3&value=";
  req_pressure+=pressure;
  http.begin(req_pressure);              //Specify request destination
  http.addHeader("Content-Type", "application/x-www-form-urlencoded");    //Specify content-type header
  int httpCodeP = http.GET();   //Send the request
  String payloadP = http.getString();    //Get the response payload
  Serial.println(httpCodeP);   //Print HTTP return code
  Serial.println(payloadP);    //Print request response payload
  http.end();
  delay(100);
    //--------------------------------------------------------------------------------------------------
      String req_altitude = "http://13.53.149.166:8000/20Node_MCU19?id=";
  req_altitude+="4&value=";
  req_altitude+=altitude;
  http.begin(req_altitude);              //Specify request destination
  http.addHeader("Content-Type", "application/x-www-form-urlencoded");    //Specify content-type header
  int httpCodeA = http.GET();   //Send the request
  String payloadA = http.getString();    //Get the response payload
  Serial.println(httpCodeA);   //Print HTTP return code
  Serial.println(payloadA);    //Print request response payload
  http.end();
  delay(100);
  }
   //Close connection
  
  delay(900000);  //Post Data at every 5 seconds
}
