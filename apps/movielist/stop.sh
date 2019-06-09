#!/usr/bin/env bash
#run with sudo
sockstat -4 -l | grep :6012 | awk '{print $3}' | xargs kill -9