#!/bin/bash

# Loop through all .m2ts files in the current directory
for input_video in *.m2ts; do
  base_name="${input_video%.*}"
  output_video="${base_name}.mp4"
  subtitle_file="${base_name}.srt"

  if [ -f "$subtitle_file" ]; then
    ffmpeg -i "$input_video" -filter_complex "[0:v]scale=478x850,setdar=478:850[vscaled];[vscaled]subtitles='${subtitle_file}'[vfinal]" -map "[vfinal]" -map 0:a? -c:v libx264 -crf 23 -r 30 -c:a aac -ac 2 -ar 48000 -b:a 128k "$output_video"
  else
    ffmpeg -i "$input_video" -vf "scale=478x850,setdar=478:850" -c:v libx264 -crf 23 -r 30 -c:a aac -ac 2 -ar 48000 -b:a 128k "$output_video"
  fi
done

