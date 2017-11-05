#!/bin/bash
# this script run matlab prediction script based on moved .wav file


fswatch -1 ../../Records/ | xargs -0 -n 1 -I {}
