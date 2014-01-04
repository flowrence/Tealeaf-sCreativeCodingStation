import processing.pdf.*;
import javax.swing.JFrame;
import java.awt.Font;
import java.awt.GraphicsEnvironment;
import javax.swing.JOptionPane; 
import controlP5.*;
import org.philhosoft.p8g.svg.P8gGraphicsSVG;

ControlP5 controlP5;
Textarea helpDoc;
Slider ang;
Textlabel currentFont;
Textlabel currentInput;

Boolean rot = false;
Boolean anim = false;
Boolean recordPDF = false;
Boolean recordSVG = false;
boolean ranColor = false;
boolean lightOn = false;
boolean multiColor = false;
boolean singleColor = false;
boolean showHelp = false;

PFont cpFont;
PFont font;

String typing = "Tealeaf";
String fontName = "Yuppy SC";
String pFontName = "Yuppy SC";

float rAngle = 0.0;
int angle= 20;
float xOff = 68.0;
float yOff = 68.0;
float alphaValue = 177;
float pAmount;
float min = 0;
float max = 180;

int FontSize = 42;
int pTs;
int amount = 8;
color fontColor = color(255);
color[] ranColorIndex;

void setup() {
  size(1280, 720, OPENGL);
  colorMode(HSB);
  smooth();
  if (year()<2015) {
    initialGUI();
  } 
  font = createFont("Yuppy SC", FontSize, true);
  fontColor = color(255);
}

void draw() {
  //initialGUI();
  ang.setRange(min, max);

  if (pAmount!=amount) {
    fontColor = color(255);
    singleColor = false;
    multiColor=false;
  }
  frame.setTitle("裴茶葉參數化圖形設計工具0.89  微信公眾號：Tealeaf-P5");
  currentFont.setText(fontName);
  currentInput.setText(typing);

  //保存PDF
  if (recordPDF) {
    beginRecord(PDF, typing+".pdf");
  }

  if (recordSVG) {
    beginRecord(P8gGraphicsSVG.SVG, typing+"-######.svg");
  }

  if (FontSize!=pTs) {
    font = createFont(fontName, FontSize, true);
  }

  if (fontName!=pFontName) {
    font = createFont(fontName, FontSize, true);
  }

  textFont(font);
  textAlign(CENTER);

  //开灯
  if (lightOn) {
    filter(DILATE);
    fill(0, 30);
    rect(0, 0, width, height);
  } 
  else {
    background(0);
  }

  textSize(FontSize);
  pushMatrix();
  translate(width/2, height/2);
  if (rot) {
    rAngle+=0.015;
    rotate(rAngle);
  }
  for (int i =0;i<amount;i=i+1)
  {
    if (multiColor && ranColorIndex!=null) {
      fontColor = ranColorIndex[i];
    }
    if (singleColor) {
      fontColor = color(frameCount%500/2, 238, 238);
    }
    fill(fontColor, alphaValue);
    //旋转
    rotate(PI*i/angle);
    if (anim) {
      pushMatrix();
      translate(noise(frameCount/50.0+i/5.0, 0)*25, 
      noise(0, frameCount/50.0+i/5.0)*25);
    }
    text(typing, xOff, yOff);
    //飘动
    if (anim) {
      popMatrix();
    }
  }
  popMatrix();

  //保存PDF
  if (recordPDF) {
    endRecord();
    recordPDF = false;
  }

  if (recordSVG) {
    endRecord();
    recordSVG = false;
  }
  pTs = FontSize;
  pFontName = fontName;
  pAmount = amount;


  helpDoc .setPosition(955, 60)
    .setSize(311, 639)
      .setLineHeight(23)
        .setColor(color(255))
          ;
}


void initialGUI() {
  controlP5 = new ControlP5(this);
  cpFont = createFont("Yuppy SC", 15, true);
  controlP5.setControlFont(cpFont);
  controlP5.setColorBackground(#FF8408);
  controlP5.setColorActive(#ADAFAE);
  controlP5.setColorForeground(#5CD8A1);
  controlP5.setColorLabel(0xffffffff);//GUI字体颜色
  //controlP5.setColorValue(0xffffffff);


  controlP5.addButton("Input", 1, 25, 20, 50, 15);

  currentInput = controlP5.addTextlabel("label1")
    .setText(typing)
      .setPosition(80, 15)
        ;

  controlP5.addButton("Help", 1, width-65, 20, 50, 15);
  helpDoc = controlP5.addTextarea("txt")
    .setPosition(955, 60)
      .setSize(311, 639)
        .setLineHeight(23)
          .setColor(color(255))
            .setColorBackground(color(0))
              .setColorForeground(color(0))
                .setFont(createFont("Yuppy TC", 15, true))
                  .setText("TealeafsParametricGraphicDesignTool 0.88 "
                    +"This is a preety simple app in which texts are used as units to generate Graphics. "
                    +"Parameters of these units and their organic whole can be djusted in GUI. "
                    +"min and max slidera are aimed to polish a good adjusting range for angle attibute. "
                    +"Try savePDF and saveSVG button when you get your satisfied graphics, "
                    +"it will expert PDF and SVG files in the folder which this app stays in. "
                    +"This app is free to use. Welcom to follow my no-profit public account of WeChat: "
                    +"Tealeaf-P5. My Contact: Weibo @裴茶叶 Site www.tealeafpei.com Email tealeafpei@gmail.com"
                    +" 裴茶葉的參數化圖形設計器0.88 輸入文字作為基本圖形單元，每一個單元有角度，位置等屬性作為參數，"
                    +"這些參數都可以在左側的按鈕上調節，即可生成不同圖形。角度參數的調節範圍可以用min和max來設定，"
                    +"方便精確調節。點擊SavePDF和SaveSVG按鈕可以導出矢量文件到程序所在文件夾。本軟件免費，"
                    +"歡迎關注非盈利公益微信公眾號：裴茶叶的创意编程补给站 作者聯繫方式： 新浪微薄@裴茶叶 "
                    +"電子郵箱 tealeafpei@gmail.com 作品集网站 www.tealeafpei.com ")
                    .setVisible(false)
                      ;


  controlP5.addSlider("FontSize")
    .setPosition(25, 50)
      .setSize(100, 10)
        .setRange(5, 300)
          .setValue(42)
            ;

  ang = controlP5.addSlider("angle")
    .setPosition(25, 70)
      .setSize(200, 10)
        .setRange(min, max)
          .setValue(4)
            ;

  controlP5.addSlider("min")
    .setPosition(25, 90)
      .setSize(100, 10)
        .setRange(0, -180)
          .setValue(0)
            ;

  controlP5.addSlider("max")
    .setPosition(161, 90)
      .setSize(100, 10)
        .setRange(0, 180.0)
          .setValue(20)
            ;

  controlP5.addSlider("amount")
    .setPosition(25, 110)
      .setSize(200, 10)
        .setRange(1, 100.0)
          .setValue(8.5)
            ;

  controlP5.addSlider("alphaValue")
    .setPosition(25, 130)
      .setSize(200, 10)
        .setRange(0, 255)
          .setValue(177.0)
            ;

  controlP5.addButton("Rotate", 1, 25, 155, 65, 15);

  controlP5.addButton("MultiColor", 1, 25, 180, 100, 15);

  controlP5.addButton("SingleColor", 1, 150, 180, 120, 15);

  controlP5.addButton("White", 1, 150, 155, 61, 15);

  controlP5.addButton("Flow", 1, 25, 205, 60, 15);

  controlP5.addButton("LightOn", 1, 148, 205, 75, 15);

  controlP5.addButton("Choose Font From List", 1, 25, 230, 199, 15);

  currentFont = controlP5.addTextlabel("label")
    .setText(fontName)
      .setPosition(230, 225)
        ;



  controlP5.addSlider("xOff")
    .setPosition(25, 255)
      .setSize(300, 10)
        .setRange(-width/2, width/2)
          .setValue(68.0)
            ;

  controlP5.addSlider("yOff")
    .setPosition(25, 275)
      .setSize(300, 10)
        .setRange(-height/2, height/2)
          .setValue(68.0)
            ;

  controlP5.addButton("SavePDF", 1, 25, 600, 79, 25);
  controlP5.addButton("SaveSVG", 1, 25, 650, 79, 25);
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isController()) {
    if (theEvent.controller().name()=="Input") {
      String temType = JOptionPane.showInputDialog(null, 
      "Type sth to be an Unit of Graphics: ");
      if (temType!=null) {
        typing = temType;
      }
    }

    if (theEvent.controller().name()=="Help") {
      showHelp = !showHelp;
      if (showHelp) {
        helpDoc.setVisible(true);
      } 
      else {
        helpDoc.setVisible(false);
      }
    }

    if (theEvent.controller().name()=="Rotate") {
      rot=!rot;
    }
    if (theEvent.controller().name()=="MultiColor") {
      multiColor=true;
      singleColor = false;
      ranColorIndex = new color[amount];
      for (int i = 0;i<amount;i++) {
        ranColorIndex[i] = color(random(255), 238, 238);
      }
    }

    if (theEvent.controller().name()=="SingleColor") {

      singleColor = true;
      multiColor=false;
    }

    if (theEvent.controller().name()=="White") {
      fontColor = color(255);
      singleColor = false;
      multiColor=false;
    }

    if (theEvent.controller().name()=="Flow") {
      anim=!anim;
    }

    if (theEvent.controller().name()=="LightOn") {
      lightOn=!lightOn;
    }

    if (theEvent.controller().name()=="Choose Font From List") {

      //String[] fontList = { "Wawati SC", "Yuppy SC", "Yuanti SC", "Monotype Corsiva"};
      String[] fontList =GraphicsEnvironment.getLocalGraphicsEnvironment().getAvailableFontFamilyNames();
      JFrame frame = new JFrame("Font Dialog");
      String temName = (String)JOptionPane.showInputDialog(frame, 
      "Choose a font", 
      "Fonts available", 
      JOptionPane.QUESTION_MESSAGE, 
      null, 
      fontList, 
      fontList[0]);
      if (temName!=null) {
        fontName = temName;
        println(temName);
      }
    }

    if (theEvent.controller().name()=="SavePDF") {
      if (lightOn) {
        JOptionPane.showConfirmDialog(this, "Sorry, PDF and SVG is not available while lightOn", 
        "OK", JOptionPane.WARNING_MESSAGE);
        recordPDF = false;
      }
      else {
        recordPDF=true;
      }
    }

    if (theEvent.controller().name()=="SaveSVG") {
      if (lightOn) {
        JOptionPane.showConfirmDialog(this, "Sorry, PDF and SVG is not available while lightOn", 
        "OK", JOptionPane.WARNING_MESSAGE);
        recordSVG = false;
      }
      else {
        recordSVG=true;
      }
    }
  }
}
