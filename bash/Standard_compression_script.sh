#!/bin/bash

# New file extension
new_extension="mp4"

# Loop through all .m2ts files in the current directory
for input_video in *.m2ts; do
  # Extract the filename without its extension
  base_name="${input_video%.*}"

  # Construct the output filename with the new extension
  output_video="${base_name}.${new_extension}"

  # Run the FFMPEG command
  ffmpeg -i "$input_video" -vcodec libx264 -crf 28 -preset slow -acodec copy -b:a 128k "$output_video"
done

