#!/usr/bin/env bash
#run with sudo
sockstat -4 -l | grep :5051 | awk '{print $3}' | xargs kill -9