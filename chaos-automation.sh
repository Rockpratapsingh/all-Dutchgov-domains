#!/bin/bash

JSON_FILE="index.json"

# Check if index.json exists
if [ ! -f "$JSON_FILE" ]; then
    # Download the JSON file
    wget "https://chaos-data.projectdiscovery.io/index.json" -O "$JSON_FILE"
fi

# Process each record in the JSON file
jq -c '.[] | select(.bounty == true and .change > 1) | .URL' "$JSON_FILE" | \
sed 's/"URL": "//;s/",//' | \
#while read -r url; do
#    # Remove double quotes at the beginning and end of the URL
#    url=$(echo "$url" | sed 's/^"\(.*\)"$/\1/')
#    echo "$url"
#done
while read -r url; do
     url=$(echo "$url" | sed 's/^"\(.*\)"$/\1/')
     echo "$url"
     # Download the zip file only if the conditions are met
     zip_file=$(basename "$url")
     wget "$url" -P downloaded_zips
     # Unzip the downloaded file
     unzip "downloaded_zips/$zip_file" -d extracted_files
     # Concatenate text files into alltargets.txt
     cat extracted_files/*.txt >> alltargets.txt
     # Remove downloaded and extracted files
     rm -rf downloaded_zips extracted_files
done

