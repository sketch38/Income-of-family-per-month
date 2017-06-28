PImage backgroundPic;
float mapGeoLeft = 97.2547703;
float mapGeoTop = 20.580028;
float mapGeoBottom = 6.078608;
float mapGeoRight = 106.045680;
JSONArray fileData;
float mapScreenWidth, mapScreenHeight, textscreenW, textscreenH, maxCost, minCost, divide,maxGraph,minGraph,textscreenMenu,zoom = 1;
int countY = 0,countMenu=0,countclickmenu=0,mode=0;
PFont roboto;
String[] Nyear = {"2541","2543","2545","2547","2549","2550","2552","2554","2556","2558"};
int[] menuNumber = new int[6];
int[] costYear = new int[9];
int[] distinceX,distinceY,textSize;
int updown = 0,leftright = 0;

void setup() {
  size(800, 700);
  backgroundPic = loadImage("map.png");
  fileData = loadJSONArray("data.json");
  mapScreenWidth = 416;
  mapScreenHeight = height;
  textscreenW = width-mapScreenWidth;
  textscreenH = 250;
  textscreenMenu = 30;
  roboto = createFont("ROBOTO",40,true);
  maxGraph = 110;
  minGraph = 35;
  distinceX = new int[fileData.size()-5];
  distinceY = new int[fileData.size()-5];
  textSize = new int[fileData.size()-5];
}

void draw() {
  background(255);
  pushMatrix();
    scale(zoom);
    translate (leftright,updown);
    image(backgroundPic, 0, 0, mapScreenWidth, mapScreenHeight);
      for (int i = 0; i < fileData.size(); i++) {
        JSONObject data = fileData.getJSONObject(i); 
        String name = data.getString("name");
        String longt = data.getString("long");
        String la = data.getString("la");
        float x = mapScreenWidth*(float(longt)-mapGeoLeft)/(mapGeoRight-mapGeoLeft);
        float y = mapScreenHeight - mapScreenHeight*(float(la)-mapGeoBottom)/(mapGeoTop-mapGeoBottom);
        //keep in array to check when mouse click
        if(i>5){
          distinceX[i-5] = (int)x;
          distinceY[i-5] = (int)y;
          textSize[i-5] = (int) textWidth(name);
          //println(distinceX[31-5]+"====="+distinceY[31-5]+"====="+textSize[31-5]);
          //println(distinceY[31-5]-8);
        }
        textAlign(CENTER);
        textFont(roboto,6);
        text(name,x,y);
      }
  popMatrix();
  Drawbox();
  selectMode(mode);
}
void Drawbox(){
  String text = "Income of family per month in years 41-58";
  JSONObject data = fileData.getJSONObject(mode); 
  String name = data.getString("name");
  String years = data.getString("years");
  String[] year = split(years, ' ');
  costYear = int(split(years,' '));
  //text
  pushMatrix();
    fill(#f5f5f5);
    noStroke();
    rect(416,0,textscreenW,textscreenH);
    fill(255);
    rect(416,40,textscreenW,textscreenH);
    pushMatrix();
      fill(0);
      translate(width-(textscreenW/2),50);
      textAlign(CENTER);
      textFont(roboto,16);
      text(text,0,-25);
      textFont(roboto,24);
      text(name,0,30);
    popMatrix();
    pushMatrix();
      fill(0);
      stroke(0);
      translate(width-textscreenW,80);
      line(50,25,50,130);
      line(50,130,350,130);
      textAlign(LEFT);
      textFont(roboto,10);
      text("Bath",40,20);
      countY =0;
      for(int j=75;j<=340;j+=27){
        
        //line graph
        stroke(#f5f5f5);
        line(j,minGraph,j,maxGraph);
        
        //plot graph
        minCost = ((float) searchMin())/1000;
        maxCost = ((float) searchMax())/1000;
        divide = (maxGraph-minGraph)/(maxCost-minCost);
        
        float yGraph = Float.parseFloat(year[countY]);
        yGraph = maxGraph-(((yGraph/1000)-minCost)*divide);
        noStroke();
        fill(0, 255, 255, 150);
        ellipse(j,yGraph,10,10);
        
        //write text
        fill(0);
        textAlign(CENTER);
        textFont(roboto,8);
        text(year[countY],j,yGraph-10);
        textFont(roboto,10);
        text(Nyear[countY],j,150);
    
        countY++;
      }
    popMatrix();
  popMatrix();
}

void selectMode(int mode){
    //draw Menu
    fill(255);
    rect(416,350,textscreenW,height);
    countMenu = 0;
    for(int k=0;k<=5;k++){
      if(mode!=k){
        JSONObject menu = fileData.getJSONObject(k); 
        String nameMenu = menu.getString("name");
        int id = menu.getInt("id");
        menuNumber[countMenu] = id;
        stroke(#1565C0);
        fill(#E3F2FD);
        rect(416,textscreenH+(textscreenMenu*countMenu),textscreenW,textscreenMenu);
        pushMatrix();
          fill(#424242);
          translate(width-textscreenW,textscreenH+(textscreenMenu*countMenu));
          textAlign(LEFT);
          textFont(roboto,14);
          text(nameMenu,15,20);
        popMatrix();
        countMenu++;
      }
    }
}

int searchMin(){
  costYear = sort(costYear);
  return costYear[0];
}

int searchMax(){
  return costYear[costYear.length-1];
}

void pointMap(int id){
  if(id==0){
    zoom=1;
    updown = 0;
    leftright =0;
  }
  else if(id==1){
    zoom=2;
    updown = -80; 
    leftright=-50;
  }
  else if(id==2){
    zoom=2;
    updown = -80; 
    leftright=-50;
  }
  else if(id==3){
    zoom=2;
    updown = 0;
    leftright=0;
  }
  else if(id==4){
    zoom=1.5;
    updown = 0;
    leftright = -130;
  }
  else if(id==5){
    zoom=1.5;
    leftright=0;
    updown = -235;
  }
}

void mousePressed(){
  println(mouseX,mouseY);
  if(mouseX>416 && mouseX<width && mouseY<textscreenH+(textscreenMenu*1) && mouseY>textscreenH){
     mode=menuNumber[0];
     pointMap(menuNumber[0]);
  }
  else if(mouseX>416 && mouseX<width && mouseY<textscreenH+(textscreenMenu*2) && mouseY>textscreenH+(textscreenMenu*1)){
     mode=menuNumber[1];
     pointMap(menuNumber[1]);
  }
  else if(mouseX>416 && mouseX<width && mouseY<textscreenH+(textscreenMenu*3) && mouseY>textscreenH+(textscreenMenu*2)){
     mode=menuNumber[2];
     pointMap(menuNumber[2]);
  }
  else if(mouseX>416 && mouseX<width && mouseY<textscreenH+(textscreenMenu*4) && mouseY>textscreenH+(textscreenMenu*3)){
     mode=menuNumber[3];
     pointMap(menuNumber[3]);
  }
  else if(mouseX>416 && mouseX<width && mouseY<textscreenH+(textscreenMenu*5) && mouseY>textscreenH+(textscreenMenu*4)){
     mode=menuNumber[4];
     pointMap(menuNumber[4]);
  }
  else if(mouseX>416 && mouseX<width && mouseY<textscreenH+(textscreenMenu*6) && mouseY>textscreenH+(textscreenMenu*5)){
     mode=menuNumber[5];
     pointMap(menuNumber[5]);
  }
  for(int l=0;l<distinceX.length;l++){
    if(mouseX>(distinceX[l]-15+leftright )*zoom &&mouseX<(distinceX[l]+leftright+(textSize[l]/2))*zoom &&mouseY<(distinceY[l]+updown)*zoom && mouseY>(distinceY[l]-10+updown)*zoom){
      mode=l+5;
    }
  }
}

void keyPressed() {
     if (key == CODED) {
       if (keyCode == UP) {
       updown = updown-30; 
   } else 
       if (keyCode == DOWN) {
       updown = updown+30; 
   } else 
       if (keyCode == LEFT) {
       leftright = leftright-30; 
  }  else 
       if (keyCode == RIGHT) {
       leftright = leftright+30; 
     }  
  }
   if(key == '+') {
   zoom = 2; 
   println(zoom);
 } else if (key == '-') {
   zoom = 1; 
   println(zoom);
 }
}