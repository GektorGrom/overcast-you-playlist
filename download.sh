#!/usr/bin/env bash

playlist="<PLAYLIST_URL_HERE>"

IFS=$'\n'

workFolder="<WORKDIR_HERE>"

nameFormat="$workFolder/%(upload_date)s_%(title)s.%(ext)s"

youtube-dl --download-archive $workFolder/archive.txt --embed-thumbnail --metadata-from-title "%(title)s" --playlist-reverse --playlist-end 2 -x -o $nameFormat $playlist -f m4a

sleep 5

fileNames=$(youtube-dl --playlist-reverse --playlist-end 2 --get-filename --newline -o $nameFormat $playlist -f m4a)

for fileName in $fileNames
do
    if [ -e $fileName ]; then
        filepath=$fileName
        echo Uploading $filepath ...
        $workFolder/upload_to_overcast.sh "$filepath"
        sleep 5
        rm "$filepath"
        sleep 10
        echo $filepath WAS REMOVED
    else
        echo Skip file $fileName. Already uploaded.
    fi
done
