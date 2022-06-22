import math
file = open("flight.txt",'r')
gpsdats = []
lats = []
lons = []
bardats = []
tempdats = []
altis = []
for i in file:
	gpsdats.append(i.split('\t')[11][3:])
	if("GNGLL" == i.split('\t')[11][3:][0:5]):
		tempdats.append(float(i.split('\t')[1]))
		bardats.append(float(i.split('\t')[2]))
#print(altis)
for i in range(len(gpsdats)):
	thisd = gpsdats[i][0:5]
	if thisd == "GNGLL":
		if gpsdats[i].split(',')[1] != '':
			latd = int(gpsdats[i].split(',')[1][0:2])
			latm = float(gpsdats[i].split(',')[1][2:])
			lond = int(gpsdats[i].split(',')[3][0:3])
			lonm = float(gpsdats[i].split(',')[3][3:])
			latf = latm/60
			latf += latd
			latf = round(latf,6)
			lonf = lonm/60
			lonf += lond
			lonf = round(lonf,6)
			lats.append(float(lonf))
			lons.append(float(latf))
			#print(latf, end = '\t\t')
			#print(lonf)

for i in range(len(bardats)):
	prt = bardats[i] / (287*(tempdats[i]+273.15));
	presdif = 1003.45 - bardats[i]
	altis.append(round(presdif/(prt*9.81)*100)/100.0)


file = open("gps.log","w")
for i in range(len(lats)):
	file.write(f"{lons[i]}° N,{lats[i]}° E\n")
file.close()
#degree to meter constant= 	0.0001113194444
#origo= 					44,59878	11,65616333333
olon = 44.598780
olat = 11.656163
xs = []
ys = []
zs = []
for i in range(len(lats)):
	lodif = olon - lons[i]
	ladif = olat - lats[i]
	#print(lons[i], end = '\t\t\t')
	#print(lats[i], end = '\t\t\t')
	#print(lodif, end = '\t\t\t')
	#print(ladif)
	x = 0.0001113194444 * (lodif * math.pow(10,9))
	y = 0.0001113194444 * (ladif * math.pow(10,9))
	z = altis[i]
	print(f"{x}\t{y}\t{z}")
	xs.append(x)
	ys.append(y)
	zs.append(z)
file = open("topdownviewstuff.data","w")
for i in range(len(xs)):
	file.write(f"{xs[i]}\t{ys[i]}\t{zs[i]}\n")
file.close()
#print(lats)
#print(lons)
