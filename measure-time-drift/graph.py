#!/usr/bin/env python

import os

dir = "_results/postprocessed"
all = filter(lambda x:x.startswith("drift."), os.listdir(dir))
if len(all) < 2:
    print >>sys.stderr, "Insufficient results found"
    os.exit(1)

print """
set terminal png
set output 'drift.png'
set title "Clock drift on a freshly booted VM"
set ylabel "clock drift / milliseconds"
set xlabel "Time / seconds"
"""
print "plot '%s/%s' with lines notitle, \\" % (dir, all[0])
for i in all[1:-1]:
  print "     '%s/%s' with lines notitle, \\" % (dir, i)
print "     '%s/%s' with lines notitle" % (dir, all[-1])
