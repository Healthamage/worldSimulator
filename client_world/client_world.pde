import processing.net.*;
 
Client c;

String data = "";

int messageInterval = 50;
int messageAcc = 0;

int previousTime = 0;
int deltaTime = 0;

//String ipAddress = "127.0.0.1";
String ipAddress = "172.22.101.0"; // Linux dans le 1134

int port = 32999;

boolean pause = false;
boolean sent = false;

Console console = new Console(10,100,12);

void setup()
{
      size(500,500);
      c = new Client(this, ipAddress, port);
      console.activate();
}

void draw()
{
    deltaTime = millis() - previousTime;
    previousTime = millis();
    messageAcc += deltaTime;
    background(0);
    console.display();
    
}


void keyPressed()
{
  
        if (keyAnalyzer(key).compareTo("LETTER") == 0 || keyAnalyzer(key).compareTo("NUMBER") == 0 || key == ' ')
        {
            console.addChar(key);
        }
        if (keyCode == BACKSPACE)
        {
            console.deleteChar();
        }
        if(keyCode == ENTER){
          if(messageAcc > messageInterval)
          {
            messageAcc = 0;
            c.write(console.readString() + "\n");
            console.reset();
          }
        }
  
}

String keyAnalyzer(char c)
{
    if (c == '0' || c == '1' || c == '2' || c == '3' || c == '4' || c == '5' || c == '6' || c == '7' || c == '8' || c == '9')
    {
        return "NUMBER";
    }
    else if (c == 'A' || c == 'a' || c == 'B' || c == 'b' || c == 'C' || c == 'c' || c == 'D' || c == 'd' || c == 'E' || c == 'e' ||
             c == 'F' || c == 'f' || c == 'G' || c == 'g' || c == 'H' || c == 'h' || c == 'I' || c == 'i' || c == 'J' || c == 'j' ||
             c == 'K' || c == 'k' || c == 'L' || c == 'l' || c == 'M' || c == 'm' || c == 'N' || c == 'n' || c == 'O' || c == 'o' ||
             c == 'P' || c == 'p' || c == 'Q' || c == 'q' || c == 'R' || c == 'r' || c == 'S' || c == 's' || c == 'T' || c == 't' ||
             c == 'U' || c == 'u' || c == 'V' || c == 'v' || c == 'W' || c == 'w' || c == 'X' || c == 'x' || c == 'Y' || c == 'y' ||
             c == 'Z' || c == 'z')
    {
        return "LETTER";
    }
    else
    {
        return "OTHER";
    }
}

class Console
{
    float x;
    float y;
    String chars;
    int numChars;
    boolean active;
    int font;
    
    Console(float x, float y, int font)
    {
        this.x = x;
        this.y = y;
        active = false;
        this.font = font;
        chars = "";
        numChars = 0;
    }
    
    void display()
    {
        line(x,y,x,y+font);
        textSize(font);
        text(chars,x,y);
    }
    
    void addChar(char c)
    {
        chars += c;
        numChars++;
    }
    
    String readString()
    {
        return chars;
    }
    
    boolean isActive()
    {
        return active;
    }
    
    void activate()
    {
        active = true;
    }
    
    void deactivate()
    {
        active = false;
    }
    
    void reset()
    {
        chars = "";
    }
    
    void deleteChar()
    {
            if (numChars > 0)
            {        
                  chars = chars.substring(0,chars.length()-1);
                  numChars -= 1;
            }
    }
}