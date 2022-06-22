String[] DATA = {};
float[] temp1 = {}, pres = {}, ax = {}, ay = {}, az = {}, gx = {}, gy = {}, gz = {}, temp2 = {}, avgt = {};
float LM;
int XSIZE = 30000, YSIZE = 3000;

void setup()
{
  LM = width/25;
  //LOAD ALL DATA TO ARRAYS
  DATA = loadStrings("flight.txt");
  size(30000, 3000);
  for (int i = 0; i < DATA.length; i++)
  {
    
    String[] templist = split(DATA[i], '\t');
    float ns = float(templist[0]);
    //println(templist[1] + "\t" + templist[2] + "\t" + templist[3] + "\t" + templist[4] + "\t" + templist[5] + "\t" + templist[6] + "\t" + templist[7] + "\t" + templist[8] + "\t" + templist[9] + "\t" + str((float(templist[1])+float(templist[9]))/2));
    temp1 = append(temp1, float(templist[1]));
    pres = append(pres, float(templist[2]));
    ax = append(ax, float(templist[4]));
    ay = append(ay, float(templist[5]));
    az = append(az, float(templist[6]));
    gx = append(gx, float(templist[7]));
    gy = append(gy, float(templist[8]));
    gz = append(gz, float(templist[9]));
    temp2 = append(temp2, float(templist[10]));
    avgt = append(avgt, (float(templist[1])+float(templist[10]))/2);
    //println(DATA.length);
    //println(i);
  }
  //println("DATA DONE");
  //TEMPERATURE GRAPH
  background(255);
  float tempsmax = max(temp1);
  if (max(temp2)>max(temp1))
  {
    tempsmax=max(temp2);
  }

  float tempsmin = min(temp1);
  if (min(temp2)<min(temp1))
  {
    tempsmin=min(temp2);
  }
  float hm, wm;
  //println(tempsmax);
  //println(tempsmin);
  hm = (YSIZE*0.8)/(tempsmax-tempsmin);
  wm = XSIZE/temp1.length;
  //println(wm);
  //println(hm);
  strokeWeight(4);
  stroke(#444444, 90);
  fill(0);
  textSize(80);
  for (float i = floor(tempsmin); i <= ceil(tempsmax); i+=(tempsmax-tempsmin)/10)
  {
    line(0, YSIZE*0.9-(i-tempsmin)*hm, width, YSIZE*0.9-(i-tempsmin)*hm);
    text(str(i)+"C", 50, YSIZE*0.9-(i-tempsmin)*hm);
    //println((i-tempsmin));
    //println((i-tempsmin)*hm);
  }

  for (int i = 0; i < temp1.length-1; i++)
  {

    stroke(#dad600);
    strokeWeight(5);
    float val1 = YSIZE*0.9-(temp1[i]-tempsmin)*hm;
    float val2 = YSIZE*0.9-(temp1[i+1]-tempsmin)*hm;
    //println(str(i) + "\t" + str(i*wm) + "\t" +str(val1) + "\t" +str((i+1)*wm) + "\t" +str(val2));
    line(i*wm, val1, (i+1)*wm, val2);
    if (temp1[i] == tempsmax)
    {
      stroke(#000000, 100);
      line(i*wm, 0, i*wm, val1);
    }
    if (temp1[i] == tempsmin)
    {
      stroke(#000000, 100);
      line(i*wm, val1, i*wm, YSIZE);
    }
  }
  for (int i = 0; i < temp2.length-1; i++)
  {
    stroke(#000dad);
    strokeWeight(5);
    float val1 = YSIZE*0.9-(temp2[i]-tempsmin)*hm;
    float val2 = YSIZE*0.9-(temp2[i+1]-tempsmin)*hm;
    //println(str(i) + "\t" + str(i*wm) + "\t" +str(val1) + "\t" +str((i+1)*wm) + "\t" +str(val2));
    line(i*wm, val1, (i+1)*wm, val2);
    if (temp2[i] == tempsmax)
    {
      stroke(#000000, 100);
      line(i*wm, 0, i*wm, val1);
    }
    if (temp2[i] == tempsmin)
    {
      stroke(#000000, 100);
      line(i*wm, val1, i*wm, YSIZE);
    }
  }
  float[] temptrenda = {};
  float[] temptrend = {};
  float curavg = sum(avgt)/avgt.length;
  for (int i = 0; i < avgt.length-1; i++)
  {
    temptrenda = append(temptrenda, avgt[i]);
    curavg = sum(temptrenda) / temptrenda.length;
    temptrend = append(temptrend, curavg);
    stroke(#dd0000);
    strokeWeight(5);
    float val1 = YSIZE*0.9-(avgt[i]-tempsmin)*hm;
    float val2 = YSIZE*0.9-(avgt[i+1]-tempsmin)*hm;
    //println(str(i) + "\t" + str(i*wm) + "\t" +str(val1) + "\t" +str((i+1)*wm) + "\t" +str(val2));
    line(i*wm, val1, (i+1)*wm, val2);
  }
  for (int i = 0; i < temptrend.length-1; i++)
  {
    stroke(#000000);
    strokeWeight(10);
    float val1 = YSIZE*0.9-(temptrend[i]-tempsmin)*hm;
    float val2 = YSIZE*0.9-(temptrend[i+1]-tempsmin)*hm;
    //println(str(i) + "\t" + str(i*wm) + "\t" +str(val1) + "\t" +str((i+1)*wm) + "\t" +str(val2));
    line(i*wm, val1, (i+1)*wm, val2);
  }
  //println(hm);
  stroke(0);
  fill(0);
  textSize(200);
  text("Min: " + str(tempsmin) + "C         Max: " + str(tempsmax) + "C         Avarage: " + str(int(sum(avgt)/avgt.length*100)/100.0) + "C", 100, 1950);
  saveFrame("graph-temperature.png");
  println("temp done");

  //acceleration GRAPH
  background(255);
  float[] accmaxs = {};
  accmaxs = append(accmaxs, max(ax));
  accmaxs = append(accmaxs, max(ay));
  accmaxs = append(accmaxs, max(az));
  float accsmax = max(accmaxs);

  float[] accmins = {};
  accmins = append(accmins, min(ax));
  accmins = append(accmins, min(ay));
  accmins = append(accmins, min(az));
  float accsmin = min(accmins);
  //println(accsmax);
  //println(accsmin);
  hm = (YSIZE*0.8)/(accsmax-accsmin);
  //print(hm);
  strokeWeight(5);
  float vertmin = -1*(accsmin*hm)+ 200;
  //println(vertmin);
  //println(vertmin+accsmin*hm);
  //println(vertmin+accsmax*hm);

  stroke(0, 80);
  fill(0, 120);
  textSize(80);
  for (float i = floor(accsmin); i <= ceil(accsmax); i+=(accsmax-accsmin)/10)
  {
    if (i!=0)
    {
      line(0, YSIZE-(vertmin+i*hm), width, YSIZE-(vertmin+i*hm));
      text(str(i) + "G", 50, YSIZE+30-(vertmin+i*hm));
    }
  }
  stroke(0);
  fill(0);
  strokeWeight(5);
  line(0, YSIZE-vertmin, width, YSIZE-vertmin);
  text("0G", 50, YSIZE-vertmin);
  for (int i = 0; i < ax.length-1; i++)
  {
    stroke(#dd1111); //AX
    line(i*wm, YSIZE-(vertmin+ax[i]*hm), (i+1)*wm, YSIZE-(vertmin+ax[i+1]*hm));
    stroke(#11dd11); //AY
    line(i*wm, YSIZE-(vertmin+ay[i]*hm), (i+1)*wm, YSIZE-(vertmin+ay[i+1]*hm));
    stroke(#1111dd); //AZ
    line(i*wm, YSIZE-(vertmin+az[i]*hm), (i+1)*wm, YSIZE-(vertmin+az[i+1]*hm));
  }
  textSize(100);
  fill(#dd1111);
  text("Acceleration x", 100, YSIZE-70);
  fill(#11dd11);
  text("Acceleration y", 1000, YSIZE-70);
  fill(#1111dd);
  text("Acceleration z", 1900, YSIZE-70);
  saveFrame("graph-acceleration.png");
  println("acc done");


  //acceleration GRAPH
  background(255);
  float[] gyromaxs = {};
  gyromaxs = append(gyromaxs, max(gx));
  gyromaxs = append(gyromaxs, max(gy));
  gyromaxs = append(gyromaxs, max(gz));
  float gyromax = max(gyromaxs);

  float[] gyromins = {};
  gyromins = append(gyromins, min(gx));
  gyromins = append(gyromins, min(gy));
  gyromins = append(gyromins, min(gz));
  float gyromin = min(gyromins);
  //println(gyromax);
  //println(gyromin);
  hm = (YSIZE*0.8)/(gyromax-gyromin);
  //print(hm);
  strokeWeight(5);
  vertmin = -1*(gyromin*hm)+ 200;
  //println(vertmin);
  //println(vertmin+gyromin*hm);
  //println(vertmin+gyromax*hm);

  stroke(0, 80);
  fill(0, 120);
  textSize(80);
  for (float i = floor(gyromin); i <= ceil(gyromax); i+=(gyromax-gyromin)/10)
  {
    if (i!=0)
    {
      line(0, YSIZE-(vertmin+i*hm), width, YSIZE-(vertmin+i*hm));
      text(str(i) + "dps", 50, YSIZE+30-(vertmin+i*hm));
    }
  }
  stroke(0);
  fill(0);
  strokeWeight(5);
  line(0, YSIZE-vertmin, width, YSIZE-vertmin);
  text("0dps", 50, YSIZE-vertmin);
  for (int i = 0; i < ax.length-1; i++)
  {
    stroke(#dd1111); //AX
    line(i*wm, YSIZE-(vertmin+gx[i]*hm), (i+1)*wm, YSIZE-(vertmin+gx[i+1]*hm));
    stroke(#11dd11); //AY
    line(i*wm, YSIZE-(vertmin+gy[i]*hm), (i+1)*wm, YSIZE-(vertmin+gy[i+1]*hm));
    stroke(#1111dd); //AZ
    line(i*wm, YSIZE-(vertmin+gz[i]*hm), (i+1)*wm, YSIZE-(vertmin+gz[i+1]*hm));
  }
  textSize(100);
  fill(#dd1111);
  text("Gyroscope x", 500, YSIZE-70);
  fill(#11dd11);
  text("Gyroscope y", 1400, YSIZE-70);
  fill(#1111dd);
  text("Gyroscope z", 2300, YSIZE-70);

  saveFrame("graph-gyroscope.png");
  println("gyro done");

  //BAROMETER GRAPH
  background(255);
  float[] baromaxs = {};
  baromaxs = append(baromaxs, max(pres));
  baromaxs = append(baromaxs, max(pres));
  baromaxs = append(baromaxs, max(pres));
  float baromax = max(baromaxs);

  float[] baromins = {};
  baromins = append(baromins, min(pres));
  baromins = append(baromins, min(pres));
  baromins = append(baromins, min(pres));
  float baromin = min(baromins);
  //println(accsmax);
  //println(baromin);
  hm = (YSIZE*0.8)/(baromax-baromin);
  //println(hm);
  strokeWeight(5);
  
  //println(baromin*hm);
  //println(baromax*hm);
  
  stroke(0, 80);
  fill(0, 120);
  textSize(80);
  for (float i = 100*floor(baromin/100); i <= ceil(baromax); i+=(baromax-baromin)/10)
  {
    line(0, YSIZE*0.9-((i-baromin)*hm), width, YSIZE*0.9-((i-baromin)*hm));
    text(str(i) + "hPa", 50, YSIZE*0.9+40-((i-baromin)*hm));
  }
  for (int i = 0; i < ax.length-1; i++)
  {
    stroke(#0dad00); //AX
    line(i*wm, YSIZE*0.9-((pres[i]-baromin)*hm), (i+1)*wm, YSIZE*0.9-((pres[i+1]-baromin)*hm));
  }
  stroke(0);
  fill(0);
  textSize(200);
  text("Min: " + str(baromin) + "C         Max: " + str(baromax) + "C         Avarage: " + str(int(sum(pres)/pres.length*100)/100.0) + "C", 100, 1950);
  saveFrame("graph-pressure.png");
  println("baro done");
  
  
  exit();
}


float sum(float[] arr) {
  float summ = arr[0];
  for (int i = 1; i < arr.length; i++) {
    summ +=arr[i];
  }
  return summ;
}
