String[] DATA = {};
float [] xs = {}, zs = {}, ys = {};

void setup()
{
  DATA = loadStrings("topdownviewstuff.data");
  size(5000, 5000);
  for (int i = 0; i < DATA.length; i++)
  {
    xs = append(xs, float(split(DATA[i], "\t")[0]));
    ys = append(ys, float(split(DATA[i], "\t")[2]));
    zs = append(zs, float(split(DATA[i], "\t")[1]));
  }
  noStroke();
  fill(#11dd22);
  ellipse(width/2+44.598780*3, height/2+11.656163*3, 50, 50);
  strokeWeight(3);
  stroke(122);
  for (int i = 0; i < xs.length; i++)
  {
    ellipse(width/2+xs[i]*3, height/2+zs[i]*3, 50, 50);
  }
  line(width/2+xs[0]*3, height/2+zs[0]*3, width/2+xs[xs.length-1]*3, height/2+zs[zs.length-1]*3);
  float[] movals = {};
  for (int i = 0; i < xs.length-1; i++)
  {
    float xdif = xs[i]-xs[i+1];
    float zdif = zs[i]-zs[i+1];
    PVector mov = new PVector(xdif, zdif);
    float dbtp = sqrt(pow(mov.x, 2)+pow(mov.y, 2));
    movals = append(movals, dbtp);
  }
  float mosu = 0;
  for (int i = 0; i < movals.length; i++)
  {
    mosu += movals[i];
  }
  float ratio = (mosu/abs(ys[0]-ys[ys.length-1]));
  float angle = 90-degrees(atan(ratio));
  float epsilon = 1/ratio;
  
  
  textSize(height/25);
  fill(0);
  text("descent ratio: \t" + str(ratio),width/25,height/25);
  text("glide ratio: \t" + str(epsilon),width/25,2*height/25);
  text("glide angle: \t" + str(angle) + "°",width/25,3*height/25);
  arc(width/2, height/25, width/3, width/3, 0, radians(angle),PIE);
  saveFrame("glide angle.png");
  exit();
}
