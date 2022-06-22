import processing.serial.*;

Serial myPort;
String[] ports;
int port;
boolean PORTSELECTED = false;
float wm1 = width/24, wm2 = width/24+width/3, wm3 = width/24+2*width/3;
float hm1 = height/24, hm2 = height/24+height/3, hm3 = height/24+2*height/3;

void setup()
{
  fullScreen();
  background(255);
  fill(0);
  ports = Serial.list();
  printArray(ports);
  for (int i = 0; i < ports.length; i++)
  {
    textSize(height/15);
    text(ports[i] + " (" + str(i) + ")", width/10, height/10*(i+1));
  }
  wm1 = width/24;
  wm2 = width/24+width/3;
  wm3 = width/24+2*width/3;
  hm1 = height/24;
  hm2 = height/24+height/3;
  hm3 = height/24+2*height/3;
}

void keyPressed()
{
  if (!PORTSELECTED)
  {
    background(255);
    fill(0);
    for (int i = 0; i < ports.length; i++)
    {
      textSize(height/15);
      text(ports[i] + " (" + str(i) + ")", width/10, height/10*(i+1));
    }
    char[] numchars = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};
    for (int i = 0; i < ports.length; i++)
    {
      if (key == numchars[i])
      {
        port = i;
      }
    }
    fill(0, 200, 0, 100);
    rect(width/10, (height/30)+(port*height)/10, width/10, height/10);
  }
  if (keyCode == ENTER)
  {
    PORTSELECTED = true;
    myPort = new Serial(this, ports[port], 9600);
    background(255);
  }
  if (powered && key == ' ')
  {
    if (stage == 0)
    {
      recovered = true;
      saveStrings("flight.txt", LOG);
      stage--;
    }
    if (stage == 1)
    {
      landtime = turnedon;
      stage--;
    }
    if (stage == 2)
    {
      dettime = turnedon;
      stage--;
    }
    if (stage == 3)
    {
      launchedthesatstrc = true;
      launchtime = turnedon;
      stage--;
    }
  }
}
boolean launchedthesatstrc = false;
int stage = 3;
float launchtime, dettime, landtime;
boolean powered = false;
float powon, turnedon;
boolean recovered = false;
String[] LOG = {};
float[] ax = {}, ay = {}, az = {}, gx = {}, gy = {}, gz = {}, t1 = {}, t2 = {}, baro = {}, gps = {};

void draw()
{
  if (PORTSELECTED && !recovered)
  {
    String msg = myPort.readStringUntil(10);
    if (msg != null)
    {
      //println(msg);
      fill(0);
      //textSize(height/20);
      //text(msg, width/30, height/10);
      String[] data = split(msg, "\t");
      if (data.length == 12 )
      {
        if (!powered)
        {
          powon = 1;
          powered = true;
        }
        background(0);
        if (ax.length >= 40)
        {
          ax = rembi(ax);
          ay = rembi(ay);
          az = rembi(az);
          gx = rembi(gx);
          gy = rembi(gy);
          gz = rembi(gz);
          t1 = rembi(t1);
          t2 = rembi(t2);
          baro = rembi(baro);
          gps = rembi(gps);
        }

        fill(128);
        stroke(255);
        rect(wm1, hm1, width/4, height/4);
        rect(wm2, hm1, width/4, height/4);
        rect(wm3, hm1, width/4, height/4);
        rect(wm1, hm2, width/4, height/4);
        rect(wm2, hm2, width/4, height/4);
        rect(wm3, hm2, width/4, height/4);
        rect(wm1, hm3, width/4, height/4);
        rect(wm2, hm3, width/4, height/4);
        rect(wm3, hm3, width/4, height/4);
        line(wm3+width/8, hm3, wm3+width/8, hm3+height/4);

        textSize(width/9);
        fill(200, 130);
        text("ax", wm1, hm1+height/4);
        text("ay", wm1, hm2+height/4);
        text("az", wm1, hm3+height/4);
        text("gx", wm2, hm1+height/4);
        text("gy", wm2, hm2+height/4);
        text("gz", wm2, hm3+height/4);
        text("tmp", wm3, hm1+height/4);
        text("hPa", wm3, hm2+height/4);
        strokeWeight(3);
        fill(0);
        textSize(height/50);
        String ontime = "Uptime: ";
        turnedon = float(data[0])/1000000000;
        //wm3,hm3 + height/20
        String lautime = "Launched: ";
        String septime = "Separated: ";
        String lantime = "Landed: ";
        if (stage <= 3)
        {
          ontime += str(round(turnedon));
        }
        if (stage <=2)
        {
          lautime += str(round(turnedon-launchtime));
        } else
        {
          lautime = "Waiting for launch";
        }
        if (stage <=1)
        {
          septime += str(round(turnedon-dettime));
        } else
        {
          septime = "Waiting for separation";
        }
        if (stage <=0)
        {
          lantime += str(round(turnedon-landtime));
        } else
        {
          lantime = "Waiting to land";
        }
        float tby1 = hm3 + height / 20;
        float tby2 = hm3 + 2 * height / 20;
        float tby3 = hm3 + 3 * height / 20;
        float tby4 = hm3 + 4 * height / 20;
        text(ontime, wm3, tby1);
        text(lautime, wm3, tby2);
        text(septime, wm3, tby3);
        text(lantime, wm3, tby4);

        ax = append(ax, float(data[4]));
        ay = append(ay, float(data[5]));
        az = append(az, float(data[6]));
        gx = append(gx, float(data[7]));
        gy = append(gy, float(data[8]));
        gz = append(gz, float(data[9]));
        t1 = append(t1, float(data[1]));
        t2 = append(t2, float(data[10]));
        baro = append(baro, float(data[2]));
        gps = append(gps, float(data[11]));
        String thisln = "";
        thisln += ontime + "\t";
        thisln += t1[t1.length-1] + "\t";
        thisln += baro[baro.length-1] + "\t";
        thisln += ax[ax.length-1] + "\t";
        thisln += ay[ay.length-1] + "\t";
        thisln += az[az.length-1] + "\t";
        thisln += gx[gx.length-1] + "\t";
        thisln += gy[gy.length-1] + "\t";
        thisln += gz[gz.length-1] + "\t";
        thisln += t2[t2.length-1] + "\t";
        thisln += gps[gps.length-1] + ";";
        LOG = append(LOG, thisln);

        for (int i = 0; i < ax.length-1; i++)
        {

          stroke(#EE0000);
          float axmax = max(ax);
          float axmin = min(ax);
          float val = hm1 + height/4 - (ax[i]-axmin) * (height/4/(axmax-axmin));
          float val2 = hm1 + height/4 - (ax[i+1]-axmin) * (height/4/(axmax-axmin));
          ////println(val);
          line(wm1+i*width/160, val, wm1+(i+1)*width/160, val2);
          stroke(0, 120);
          float avgval = hm1 + height/4 - (aravg(ax)-axmin) * (height/4/(axmax-axmin));
          line(wm1, avgval, wm1+width/4, avgval);
          avgval = hm1 + height/4 - (aravg(ax)-axmin) * (height/4/(axmax-axmin));
          line(wm1, avgval, wm1+width/4, avgval);
          textSize(height/32);
          text(str(round(aravg(ax)*100)/100.0), wm1-width/32, avgval);
          avgval = hm1 + height/4 - ((aravg(ax)+axmax)/2-axmin) * (height/4/(axmax-axmin));
          stroke(120, 120);
          line(wm1, avgval, wm1+width/4, avgval);
          textSize(height/32);
          text(str(round((aravg(ax)+axmax)/2*100)/100.0), wm1-width/32, avgval);
          avgval = hm1 + height/4 - ((aravg(ax)+axmin)/2-axmin) * (height/4/(axmax-axmin));
          line(wm1, avgval, wm1+width/4, avgval);
          textSize(height/32);
          text(str(round((aravg(ax)+axmin)/2*100)/100.0), wm1-width/32, avgval);

          stroke(#00EE00);
          float aymax = max(ay);
          float aymin = min(ay);
          val = hm2 + height/4 - (ay[i]-aymin) * (height/4/(aymax-aymin));
          val2 = hm2 + height/4 - (ay[i+1]-aymin) * (height/4/(aymax-aymin));
          ////println(val);
          line(wm1+i*width/160, val, wm1+(i+1)*width/160, val2);
          stroke(0, 120);
          avgval = hm2 + height/4 - (aravg(ay)-aymin) * (height/4/(aymax-aymin));
          line(wm1, avgval, wm1+width/4, avgval);
          textSize(height/32);
          text(str(round(aravg(ay)*100)/100.0), wm1-width/32, avgval);
          stroke(120, 120);
          avgval = hm2 + height/4 - ((aravg(ay)+aymax)/2-aymin) * (height/4/(aymax-aymin));
          line(wm1, avgval, wm1+width/4, avgval);
          textSize(height/32);
          text(str(round((aravg(ay)+aymax)/2*100)/100.0), wm1-width/32, avgval);
          avgval = hm2 + height/4 - ((aravg(ay)+aymin)/2-aymin) * (height/4/(aymax-aymin));
          line(wm1, avgval, wm1+width/4, avgval);
          textSize(height/32);
          text(str(round((aravg(ay)+aymin)/2*100)/100.0), wm1-width/32, avgval);

          stroke(#0000EE);
          float azmax = max(az);
          float azmin = min(az);
          val = hm3 + height/4 - (az[i]-azmin) * (height/4/(azmax-azmin));
          val2 = hm3 + height/4 - (az[i+1]-azmin) * (height/4/(azmax-azmin));
          ////println(val);
          line(wm1+i*width/160, val, wm1+(i+1)*width/160, val2);
          stroke(0, 120);
          avgval = hm3 + height/4 - (aravg(az)-azmin) * (height/4/(azmax-azmin));
          line(wm1, avgval, wm1+width/4, avgval);
          textSize(height/32);
          text(str(round(aravg(az)*100)/100.0), wm1-width/32, avgval);
          stroke(120, 120);
          avgval = hm3 + height/4 - ((aravg(az)+azmax)/2-azmin) * (height/4/(azmax-azmin));
          line(wm1, avgval, wm1+width/4, avgval);
          textSize(height/32);
          text(str(round((aravg(az)+azmax)/2*100)/100.0), wm1-width/32, avgval);
          avgval = hm3 + height/4 - ((aravg(az)+azmin)/2-azmin) * (height/4/(azmax-azmin));
          line(wm1, avgval, wm1+width/4, avgval);
          textSize(height/32);
          text(str(round((aravg(az)+azmin)/2*100)/100.0), wm1-width/32, avgval);

          ////println(wm1+i*width/160);
          stroke(#EE00EE);
          float gxmax = max(gx);
          float gxmin = min(gx);
          val = hm1 + height/4 - (gx[i]-gxmin) * (height/4/(gxmax-gxmin));
          val2 = hm1 + height/4 - (gx[i+1]-gxmin) * (height/4/(gxmax-gxmin));
          ////println(val);
          line(wm2+i*width/160, val, wm2+(i+1)*width/160, val2);
          stroke(0, 120);
          avgval = hm1 + height/4 - (aravg(gx)-gxmin) * (height/4/(gxmax-gxmin));
          line(wm2, avgval, wm2+width/4, avgval);
          textSize(height/32);
          text(str(round(aravg(gx)*100)/100.0), wm2-width/32, avgval);
          stroke(120, 120);
          avgval = hm1 + height/4 - ((aravg(gx)+gxmax)/2-gxmin) * (height/4/(gxmax-gxmin));
          line(wm2, avgval, wm2+width/4, avgval);
          textSize(height/32);
          text(str(round((aravg(gx)+gxmax)/2*100)/100.0), wm2-width/32, avgval);
          avgval = hm1 + height/4 - ((aravg(gx)+gxmin)/2-gxmin) * (height/4/(gxmax-gxmin));
          line(wm2, avgval, wm2+width/4, avgval);
          textSize(height/32);
          text(str(round((aravg(gx)+gxmin)/2*100)/100.0), wm2-width/32, avgval);

          stroke(#00EEEE);
          ////println(wm1+i*width/160);
          float gymax = max(gy);
          float gymin = min(gy);
          val = hm2 + height/4 - (gy[i]-gymin) * (height/4/(gymax-gymin));
          val2 = hm2 + height/4 - (gy[i+1]-gymin) * (height/4/(gymax-gymin));
          ////println(val);
          line(wm2+i*width/160, val, wm2+(i+1)*width/160, val2);
          stroke(0, 120);
          avgval = hm2 + height/4 - (aravg(gy)-gymin) * (height/4/(gymax-gymin));
          line(wm2, avgval, wm2+width/4, avgval);
          textSize(height/32);
          text(str(round(aravg(gy)*100)/100.0), wm2-width/32, avgval);
          stroke(120, 120);
          avgval = hm2 + height/4 - ((aravg(gy)+gymax)/2-gymin) * (height/4/(gymax-gymin));
          line(wm2, avgval, wm2+width/4, avgval);
          textSize(height/32);
          text(str(round((aravg(gy)+gymax)/2*100)/100.0), wm2-width/32, avgval);
          avgval = hm2 + height/4 - ((aravg(gy)+gymin)/2-gymin) * (height/4/(gymax-gymin));
          line(wm2, avgval, wm2+width/4, avgval);
          textSize(height/32);
          text(str(round((aravg(gy)+gymin)/2*100)/100.0), wm2-width/32, avgval);

          stroke(#EEEE00);
          ////println(wm1+i*width/160);
          float gzmax = max(gz);
          float gzmin = min(gz);
          val = hm3 + height/4 - (gz[i]-gzmin) * (height/4/(gzmax-gzmin));
          val2 = hm3 + height/4 - (gz[i+1]-gzmin) * (height/4/(gzmax-gzmin));
          ////println(val);
          line(wm2+i*width/160, val, wm2+(i+1)*width/160, val2);
          stroke(0, 120);
          avgval = hm3 + height/4 - (aravg(gz)-gzmin) * (height/4/(gzmax-gzmin));
          line(wm2, avgval, wm2+width/4, avgval);
          textSize(height/32);
          text(str(round(aravg(gz)*100)/100.0), wm2-width/32, avgval);
          stroke(120, 120);
          avgval = hm3 + height/4 - ((aravg(gz)+gzmax)/2-gzmin) * (height/4/(gzmax-gzmin));
          line(wm2, avgval, wm2+width/4, avgval);
          textSize(height/32);
          text(str(round((aravg(gz)+gzmax)/2*100)/100.0), wm2-width/32, avgval);
          avgval = hm3 + height/4 - ((aravg(gz)+gzmin)/2-gzmin) * (height/4/(gzmax-gzmin));
          line(wm2, avgval, wm2+width/4, avgval);
          textSize(height/32);
          text(str(round((aravg(gz)+gzmin)/2*100)/100.0), wm2-width/32, avgval);
          ////println(wm1+i*width/160);

          float tmp1max = max(t1);
          float tmp1min = min(t1);
          float tmp2max = max(t2);
          float tmp2min = min(t2);
          stroke(#EE0000);
          val = hm1 + height/4 - (t1[i]-tmp1min) * (height/4/(tmp1max-tmp1min));
          val2 = hm1 + height/4 - (t1[i+1]-tmp1min) * (height/4/(tmp1max-tmp1min));
          ////println(val);
          line(wm3+i*width/160, val, wm3+(i+1)*width/160, val2);

          ////println(wm1+i*width/160);
          stroke(#0000EE);
          val = hm1 + height/4 - (t2[i]-tmp2min) * (height/4/(tmp2max-tmp2min));
          val2 = hm1 + height/4 - (t2[i+1]-tmp2min) * (height/4/(tmp2max-tmp2min));
          ////println(val);
          line(wm3+i*width/160, val, wm3+(i+1)*width/160, val2);
          float ravg = (asum(t1)+asum(t2))/(t1.length+t2.length);
          avgval = hm1 + height/4 - (ravg - (tmp1min+tmp2min)/2) * (height/4/((tmp1max+tmp2max)/2-(tmp1min+tmp2min)/2));
          stroke(0, 120);
          line(wm3, avgval, wm3+width/4, avgval);
          fill(255);
          textSize(height/32);
          text(str(round(ravg*100)/100.0), wm3-width/32, avgval);
          avgval = hm1 + height/4 - ((ravg+tmp1max+tmp2max)/3 - (tmp1min+tmp2min)/2) * (height/4/((tmp1max+tmp2max)/2-(tmp1min+tmp2min)/2));
          ////println(avgval);
          stroke(120, 120);
          line(wm3, avgval, wm3+width/4, avgval);
          fill(255);
          textSize(height/32);
          text(str(round(((ravg+tmp1max+tmp2max)/3)*100)/100.0), wm3-width/32, avgval);
          avgval = hm1 + height/4 - ((ravg+tmp1min+tmp2min)/3 - (tmp1min+tmp2min)/2) * (height/4/((tmp1max+tmp2max)/2-(tmp1min+tmp2min)/2));
          ////println(avgval);
          stroke(120, 120);
          line(wm3, avgval, wm3+width/4, avgval);
          textSize(height/32);
          text(str(round(((ravg+tmp1min+tmp2min)/3)*100)/100.0), wm3-width/32, avgval);

          float barmax = max(baro);
          float barmin = min(baro);
          stroke(#00EE00);
          val = hm2 + height/4 - (baro[i]-barmin) * (height/4/(barmax-barmin));
          val2 = hm2 + height/4 - (baro[i+1]-barmin) * (height/4/(barmax-barmin));
          ////println(val);
          line(wm3+i*width/160, val, wm3+(i+1)*width/160, val2);
          stroke(0, 120);
          avgval = hm2 + height/4 - (aravg(baro)-barmin) * (height/4/(barmax-barmin));
          line(wm3, avgval, wm3+width/4, avgval);
          textSize(height/32);
          text(str(round(aravg(baro)*100)/100.0), wm3-width/32, avgval);
          stroke(120, 120);
          avgval = hm2 + height/4 - ((aravg(baro)+barmax)/2-barmin) * (height/4/(barmax-barmin));
          line(wm3, avgval, wm3+width/4, avgval);
          textSize(height/32);
          text(str(round((aravg(baro)+barmax)/2*100)/100.0), wm3-width/32, avgval);
          avgval = hm2 + height/4 - ((aravg(baro)+barmin)/2-barmin) * (height/4/(barmax-barmin));
          line(wm3, avgval, wm3+width/4, avgval);

          ////println(wm1+i*width/160);
        }
        if (ay.length>0)
        {
          stroke(0);
          float angle = acos(-10*ay[ay.length-1]/9.81);
          println(degrees(angle));
          float vecx = 20*cos(angle), vecy = 20*sin(angle);
          fill(#4422dd);
          translate(wm3+width/8+width/16, hm3+height/8);
          rotate(angle);
          rectMode(CENTER);
          rect(0, 0, width/24, height/8);
          rectMode(CORNER);

          line(wm3 + width/8 + width/16, hm3 + height/8, wm3 + width/8 + width/16 + vecx, hm3 + height/8 + vecy);
        }
      }
    }
  }
  if (recovered)
  {
    background(#33dd33);
  }
  if (launchedthesatstrc)
  {
    saveFrame("IMG/frame-########.png");
  }
}


float[] rembi(float[] array)
{
  float[] garray = {};
  for (int i = 1; i < array.length; i++)
  {
    garray = append(garray, array[i]);
  }
  return garray;
}
float asum(float[] array)
{
  float val = 0;
  for (int i = 0; i < array.length; i++)
  {
    val += array[i];
  }
  return(val);
}
float aravg(float[] array)
{
  return(asum(array)/array.length);
}
