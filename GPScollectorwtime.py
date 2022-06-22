import math
file = open("flight.txt",'r')
gpsdats = []
lats = []
lons = []
timestamps = []
for i in file:
	gpsdats.append(i.split('\t')[11][3:])
	if("GNGLL" == i.split('\t')[11][3:][0:5]):
		if i.split('\t')[11][3:].split(',')[1] != '':
			timestamps.append(float(i.split('\t')[0])/1000000000)
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

file = open("gpsts.log","w")
for i in range(len(timestamps)):
	file.write(f"{timestamps[i]}\t{lons[i]}\t{lats[i]}\n")
file.close()