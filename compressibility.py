#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Feb 18 12:59:31 2019

@author: greert
"""

import sys
import subprocess
import os
import json
import csv
import math

tmpfile='tmp.mp3'      #Free Lossless Audio Codec

#Get audio duration using ffmpeg
def probe_audio_mp3(wavfile):
    cmd='ffprobe -f mp3 -i %s -show_format -print_format json -v quiet' %(wavfile)
    #cmd='ffprobe -i %s -show_format -print_format json -v quiet' %(wavfile)
    ffmpeg_info=subprocess.check_output(cmd, shell=True)
    ffmpeg_info = json.loads(ffmpeg_info)

    return ffmpeg_info['format']


#Get audio duration using ffmpeg
def probe_audio(wavfile):
    cmd='ffprobe -i %s -show_format -print_format json -v quiet' %(wavfile)
    ffmpeg_info=subprocess.check_output(cmd, shell=True)
    ffmpeg_info = json.loads(ffmpeg_info)

    return ffmpeg_info['format']


ffmpeg_info=probe_audio(sys.argv[1])
dur = float(ffmpeg_info['duration'])
orig_size = float(ffmpeg_info['size'])
size_per_dur = orig_size/dur # this calculation ignores any wav header

#windows in seconds
#win_shift=0.1
#win_len=0.2
win_shift=0.025
win_len=0.05

part_size = size_per_dur * win_len

t=0.
comp=[]

while t < dur-win_len:    
    cmd='ffmpeg -y -v quiet -ss %f -i %s -acodec libmp3lame -qscale:a 3 -f mp3 -t %f %s' %(t, sys.argv[1], win_len, tmpfile)


    os.system(cmd)
    #print(t)

    flac_info=probe_audio_mp3(tmpfile)
    flac_size=float(flac_info['size'])
    comp.append(flac_size/part_size)
    #print(flac_size)

    t+=win_shift


print("Compressibility length :", len(comp))

with open("compressibilities_mp3"+sys.argv[1][:-5]+"_"+str(math.floor(win_shift*100))+".csv", 'w') as myfile:
    for i in range(len(comp)):
        myfile.write(str(comp[i])+"\n")


