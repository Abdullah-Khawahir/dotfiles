#!/bin/sh

# /bin/filebot -get-subtitles -r "$1" -non-strict --lang ara 
/bin/filebot -get-subtitles -r "$1" --lang ara eng --output srt --encoding utf8 --conflict skip -non-strict 
