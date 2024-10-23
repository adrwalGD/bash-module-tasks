#!/bin/bash

for i in {1..100}; do
  out=""
  if [ $((i % 3)) -eq 0 ]; then
    out="Fizz"
  fi
  if [ $((i % 5)) -eq 0 ]; then
    out="${out}Buzz"
  fi
  echo ${out:-$i}
done
