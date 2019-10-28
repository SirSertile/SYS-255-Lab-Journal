#!/bin/bash
for i in $(seq $1 $2); do
ping -c 1 10.0.5.$i &> /dev/null && nslookup 10.0.5.$i
done

