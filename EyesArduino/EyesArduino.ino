#include <ESP8266WiFi.h>
#include <Adafruit_NeoPixel.h>

const char WiFiAPPSK[] = "esp8266-12e";

WiFiServer server(80);
#define PIN D5

#define NUMPIXELS 16
Adafruit_NeoPixel pixels(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

int val = -1; 

void setupWiFi()
{
  WiFi.mode(WIFI_AP);

  // Do a little work to get a unique-ish name. Append the
  // last two bytes of the MAC (HEX'd) to "ThingDev-":
  uint8_t mac[WL_MAC_ADDR_LENGTH];
  WiFi.softAPmacAddress(mac);
  String macID = String(mac[WL_MAC_ADDR_LENGTH - 2], HEX) +
                 String(mac[WL_MAC_ADDR_LENGTH - 1], HEX);
  macID.toUpperCase();
  String AP_NameString = "LED-" + macID;

  char AP_NameChar[AP_NameString.length() + 1];
  memset(AP_NameChar, 0, AP_NameString.length() + 1);

  for (int i=0; i<AP_NameString.length(); i++)
    AP_NameChar[i] = AP_NameString.charAt(i);

  WiFi.softAP(AP_NameChar, WiFiAPPSK);
}

void initHardware()
{
  Serial.begin(115200);
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);
}

void setup() 
{
  initHardware();
  setupWiFi();
  server.begin();
  pixels.begin(); // INITIALIZE NeoPixel strip object (REQUIRED)
  pixels.clear(); // Set all pixel colors to 'off'
}

void loop() 
{
  WiFiClient client = server.available();
  if (!client) {
    return;
  }

  String req = client.readStringUntil('\r');
  Serial.println(req);
  client.flush();

  
  if (req.indexOf("/led/0") != -1)
    val = 0; 
  else if (req.indexOf("/led/1") != -1)
    val = 1; 
  else if (req.indexOf("/led/2") != -1)
    val = 2;
  else if (req.indexOf("/led/3") != -1)
    val = 3;

  switch (val) {
    case 0:
      Serial.println("0");
      digitalWrite(LED_BUILTIN, HIGH); 
      for(int i=0; i<NUMPIXELS; i++) {
          pixels.setPixelColor(i, pixels.Color(204, 153, 0));
          pixels.setBrightness(0);
          pixels.show();
      }
      break;  
    case 1:
      Serial.println("1");
      digitalWrite(LED_BUILTIN, LOW); 
      for(int i=0; i<NUMPIXELS; i++) {
          pixels.setPixelColor(i, pixels.Color(204, 153, 0));
          pixels.setBrightness(30);
          pixels.show();
      } 
      break; 
    case 2:
      Serial.println("2");
      digitalWrite(LED_BUILTIN, LOW); 
      for(int i=0; i<NUMPIXELS; i++) {
          pixels.setPixelColor(i, pixels.Color(204, 153, 0));
          pixels.setBrightness(60);
          pixels.show();
      }
      break;
    case 3:
      Serial.println("3");
      digitalWrite(LED_BUILTIN, LOW); 
      for(int i=0; i<NUMPIXELS; i++) {
          pixels.setPixelColor(i, pixels.Color(204, 153, 0));
          pixels.setBrightness(90);
          pixels.show();
      }
      break;
    default:
      break;
  }
  

  client.flush();

  String s = "HTTP/1.1 200 OK\r\n";
  s += "Content-Type: text/html\r\n\r\n";
  s += "<!DOCTYPE HTML>\r\n<html>\r\n";
  
  if (val >= 0)
  {
    s += "LED is now ";
    s += (val)?"on":"off";
  }
  else
  {
    s += "Invalid Request.<br> Try /led/1, /led/0, or /read.";
  }
  s += "</html>\n";

  client.print(s);
  delay(1);
  Serial.println("Client disonnected");

}



