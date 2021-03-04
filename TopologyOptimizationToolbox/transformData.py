# transformData.py
# Transform Optistruct '.fem' file to coordinates and 
# node-Connectivity text files. Requires filename argument

import sys

filename = sys.argv[1]
file = open(filename)
fcoord = open('coordinates.txt', 'w+')
fconn = open('conectivity.txt', 'w+')

for line in file: 
  if line[0:4] == "GRID":
    x2 = str(float(line[16:32]))
    x3 = str(float(line[32:40]))
    x4 = str(float(line[40:49]))
    fcoord.write( x2 + " " + x3 + " " + x4 + "\n")

  if line[0:6] == "CTETRA":
    x2 = str(int(line[25:33]))
    x3 = str(int(line[33:41]))
    x4 = str(int(line[41:49]))
    x5 = str(int(line[49:57]))
    fconn.write(x2 + " " + x3 + " " + x4 + " " + x5 + "\n")
