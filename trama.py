import serial as rs, time as ti, random as ra

def Make_Data(nId):
    nEMA = nId
    nMP01 = ra.randint(5,100)
    nMP25 = ra.randint(5,100)
    nMP10 = ra.randint(5,100)
    nHi03 = ra.randint(10,10000)
    nHi05 = ra.randint(10,10000)
    nHi01 = ra.randint(10,10000)
    nHi25 = ra.randint(10,10000)
    nHi50 = ra.randint(10,10000)
    nHi10 = ra.randint(10,10000)
    nTE = ra.randint(15,25)
    nHR = ra.randint(20,35)
    sLine = str(nEMA)  + ',' + \
            str(nMP01) + ',' + str(nMP25) + ',' + str(nMP10) + ',' + \
            str(nHi03) + ',' + str(nHi05) + ',' + str(nHi01) + ',' + \
            str(nHi25) + ',' + str(nHi50) + ',' + str(nHi10) + ',' + \
            str(nTE  ) + ',' + str(nHR )
    return sLine

MyCnx = rs.Serial('COM2'); MyCnx.baudrate = 9600
nId = 1
while 1:
 sAux = Make_Data(nId)
 print(sAux)
 MyCnx.write(sAux.encode())
 ti.sleep(.1)
 nId += 1
 if nId == 6: nId = 1
MyCnx.close()