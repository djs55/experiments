#!/bin/bash

mkdir _results
rm -f_results/drift.*.dat
cd _results && ../client/client&
CLIENT_PID=$!

function finish {
  kill "${CLIENT_PID}"
}
trap finish EXIT

while true
do
  make run
done
