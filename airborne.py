import serial
import smbus
import smbus2
import bme280
import pynmea2
import string
import os
import threading
from datetime import datetime
from time import time_ns
from time import sleep
#from picamera import PiCamera

MPU_ADR = 0X68
BME_ADR = 0X76

AXH = 0X3B
AYH = 0X3D
AZH = 0X3F
GXH = 0X43
GYH = 0X45
GZH = 0X47
TMH = 0x41

def MPU_Init():
	bus.write_byte_data(MPU_ADR, 0x19, 7)
	bus.write_byte_data(MPU_ADR, 0x6B, 1)
	bus.write_byte_data(MPU_ADR, 0x1A, 0)
	bus.write_byte_data(MPU_ADR, 0x1B, 28)
	bus.write_byte_data(MPU_ADR, 0x1C, 24)
	bus.write_byte_data(MPU_ADR, 0x38, 1)

def mpurrd(addr):
	high = bus.read_byte_data(MPU_ADR, addr)
	low = bus.read_byte_data(MPU_ADR, addr+1)
	val = ((high << 8) | low)
	if val > 32768:
		val -= 65536
	return val
def mpureadall():
	res = []
	res.append(round(8*mpurrd(AXH)/16384.0,2))
	res.append(round(8*mpurrd(AYH)/16384.0,2))
	res.append(round(8*mpurrd(AZH)/16384.0,2))
	res.append(round(mpurrd(GXH)/131.0,2))
	res.append(round(mpurrd(GYH)/131.0,2))
	res.append(round(mpurrd(GZH)/131.0,2))
	res.append(round(mpurrd(TMH)/340 + 36.53,2))
	return(res)

bus = smbus.SMBus(1)
MPU_Init()

calpars = bme280.load_calibration_params(bus,BME_ADR)

gpsp = "/dev/ttyAMA0"
ser = serial.Serial(gpsp, baudrate = 9600)

def bmereadall():
	data = bme280.sample(bus,BME_ADR,calpars)
	res = []
	res.append(round(data.temperature,2))
	res.append(round(data.pressure,2))
	res.append(data.humidity)
#	file = open("/home/LOG/test.txt","a")
#	file.write(str(data.humidity))
#	file.write("\n")
#	file.close()
	return(res)


def readgps(rawop=False):
	val = ser.readline()
	lit = val[0:6]
#	print(str(val).split(","))
	if rawop:
		return(str(val).split(","))
	gpsdat = str(val).split(",")
	if (gpsdat[0]=="b'$GNGLL" and not gpsdat[2].isnumeric) or (gpsdat[0]=="b'$GNRMC" and not gpsdat[3].isnumeric):
		line = val.decode("ascii").split(',')
		if lit == bytes("$GNRMC","ascii"):
			lat = float(line[2])
			op = f"{line[4]};{line[3]}.{str(float(line[3][2:-1])/60)}[2:-1];{line[6]};{line[5][0:3]}.{str(float(line[5][3:-1])/60)[2:-1]}"
			return(["good", op])
		if lit == bytes("$GNGLL","ascii"):
			lat = float(line[2])
			op = f"{line[3]};{line[2]}.{str(float(line[2][2:-1])/60)}[2:-1];{line[5]};{line[4][0:3]}.{str(float(line[4][3:-1])/60)[2:-1]}"
			return(["good",op])
	return(["GPS: N/A",str(val)])


def senddata(text):
	ser.write(bytes(f"{text}\n","ASCII"))


MTP = 15
barmes = []
def sender():
	global mpures
	global gpsdat
	senddata(f"{mpures}\t{bmeres}\t{gpsdat}")
	sleep(5)

def senddatamt():
	global mpures
	global gpsdat
	global bmeres
	while 1:
		DAT = str(time_ns()-lasta) + "\t"
		for i in bmeres:
			DAT += str(i) + "\t"
		for i in mpures:
			DAT += str(i) + "\t"
		barmes.append(bmeres[1])
		#DAT += gpsdat[1]	
		senddata(DAT)
		sleep(0.4)

mpures = mpureadall()
gpsdat = readgps()
prept = threading.Thread(target=sender)

while (mpures[1] > -1.3 and gpsdat[0] == "GPS: N/A"):
	try:
		mpures = mpureadall()
		bmeres = bmereadall()
	except OSError:
		senddata("Check I2C connections")
	gpsdat = readgps()
	print(f"Ay :  {mpures}\t\t{gpsdat[1][2:-1]}",end='\r')
	if not prept.is_alive():
		prept = threading.Thread(target=sender)
		prept.start()

lasta = time_ns()
#mpudc = []

senderthread = threading.Thread(target=senddatamt)
senderthread.start()

while True:
	mpures = mpureadall()
	bmeres = bmereadall()
	gpsdat = readgps()
#	mpudc.append(mpures)
#	if not senderthread.is_alive():
#		senderthread = threading.Thread(target=senddatamt)
#		senderthread.start()
	DAT = str(time_ns()-lasta) + "\t"
	for i in bmeres:
		DAT += str(i) + "\t"
	for i in mpures:
		DAT += str(i) + "\t"
	barmes.append(bmeres[1])
	DAT += gpsdat[1]
	file = open("/home/LOG/flight.txt", 'a')
	file.write(DAT + "\n")
	file.close()

