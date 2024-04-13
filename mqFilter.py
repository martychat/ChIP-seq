import sys

#file = open("B2.k3.test.sam", 'r')
#out = open("B2.k3.test.highscore.sam", 'w')

INPUT = sys.argv[1]
HEADER = sys.argv[2]
M_LIMIT = sys.argv[3]
Q_LIMIT = sys.argv[4]

def mFilter(file, out):
	template = ''
	count = 0
	lines = []
	while 1:
		new = file.readline()
		if not new:
			break
		else:
			if '@SQ' in new:
				out.write(new)
			elif '@HD' in new:
				out.write(new)
			elif '@PG' in new:
				out.write(new)
			else:
				if template == '':
					template = new.split('\t')[0]
					lines.append(new)
					count += 1
					continue
				elif new.split('\t')[0] == template:
					lines.append(new)
					count += 1
					continue
				else:
					if len(lines) >= int(M_LIMIT):
						template = new.split('\t')[0]
						lines = []
						lines.append(new)
						count = 0
						continue
					else:
						if len(lines) > 1:
							out.write(lines[0])
							out.write(lines[1])
							template = new.split('\t')[0]
							count = 0
							lines = []
							lines.append(new)
						else:
							out.write(lines[0])
							template = new.split('\t')[0]
							count = 0
							lines = []
							lines.append(new)
	  
def qFilter(file, out):	  
	for line in file:
		if '@SQ' in line:
			out.write(line)
		elif '@HD' in line:
			out.write(line)
		elif '@PG' in line:
			out.write(line)
		else:
			check = line.split('\t')		
			if int(check[4]) > int(Q_LIMIT):
				out.write(line)
			else:
				continue
			
inFile = open(INPUT, 'r')			
tmpOut = open(HEADER + '.prefil.sam', 'w')
mFilter(inFile, tmpOut)
inFile.close()
tmpOut.close()
tmpOut = open(HEADER + '.prefil.sam', 'r')
outFile = open(HEADER +'.filtered.sam', 'w')
qFilter(tmpOut, outFile)
tmpOut.close()
outFile.close()
