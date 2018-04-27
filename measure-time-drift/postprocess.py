#!/usr/bin/env python

import sys, os


def one(input, output):
	# title line
	line = input.readline().strip()
	print >>output, line

	# first data point
	line = input.readline().strip()
	bits = line.split()
	first = int(bits[1])
	print >>output, bits[0], "0"

	while True:
		line = input.readline().strip()
		if line == "":
			return
		bits = line.split()
		bits[1] = str((int(bits[1]) - first) / 1000)
        	if len(bits) > 2:
            		bits[2] = str(int(bits[2]) / 1000)
		print >>output, " ".join(bits)

indir=sys.argv[1]
outdir=sys.argv[2]

for i in os.listdir(indir):
	if not i.startswith("drift."):
		continue
	input = open(os.path.join(indir, i), "r")
	output = open(os.path.join(outdir, i), "w")
	one(input, output)
	input.close()
	output.close()
