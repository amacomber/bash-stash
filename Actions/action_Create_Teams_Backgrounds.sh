#!/bin/zsh

# Define the input path where the .png images are stored
imagePath="/Library/BG_images"

[ ! -d $imagePath ] $$ mkdir $imagePath

# Define the output path for Teams Background
outputPath="$HOME/Library/Containers/com.microsoft.teams2/Data/Library/Application Support/Microsoft/MSTeams/Backgrounds/Uploads"

# Check if the output directory exists; if not, create it
[[ ! -d "$outputPath" ]] && mkdir -p "$outputPath"

# Loop through all PNG images in the specified directory
for image in $imagePath/*.png; do

# Generate a new GUID
guid=$(uuidgen)

# Resize main image to 1920x1080
echo "Creating Background"
sips -z 1080 1920 "$image" --out "$outputPath/$guid.png"

# Resize thumbnail to 220x158
echo "Creating Background Thumbnail"
thumbName="${guid}_thumb.png"
sips -z 158 220 "$image" --out "$outputPath/$thumbName"

rm -rf ~/Library/Group Containers/UBF8T346G9.com.microsoft.teams
done