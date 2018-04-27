#!/bin/sh

echo Starting server
/measure-time &

echo In 5 minutes we will halt
sleep 15s
halt
echo I should have halted
