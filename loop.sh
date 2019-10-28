#!/bin/bash
for i in $(seq 1 10); do
ping -c 1 192.168.4.$i
done

