#!/bin/bash

mkdir mydir
curl "https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=zh-CN" | jq .images | jq .[] > mydir/wallpaper.json
jq .urlbase mydir/wallpaper.json -r > mydir/tmp.txt
read -r url < mydir/tmp.txt
jq .copyright mydir/wallpaper.json -r > mydir/tmp.txt
read -r describe < mydir/tmp.txt
jq .copyrightlink mydir/wallpaper.json -r > mydir/tmp.txt
read -r search < mydir/tmp.txt
jq .title mydir/wallpaper.json -r > mydir/tmp.txt
read -r title < mydir/tmp.txt
mkdir output
echo "{\"Title\":\"${title}\",\"Describe\":\"${describe}\",\"UrlIn4k\":\"https://www.bing.com${url}_UHD.jpg\",\"UrlIn1080p\":\"https://www.bing.com${url}_1920x1080.jpg\",\"UrlIn720p\":\"https://www.bing.com${url}_1280x720.jpg\",\"Search\":\"${search}\"}" | jq . > output/all.json
curl "https://www.bing.com${url}_UHD.jpg" -o output/4k.jpg
curl "https://www.bing.com${url}_1920x1080.jpg" -o output/1080p.jpg
curl "https://www.bing.com${url}_1280x720.jpg" -o output/720p.jpg
mkdir temp
cd temp
git init
git remote add origin git@github.com:Tseshongfeeshur/BingWallpaper.git
git fetch
git checkout -b gh-pages
cp -a -f "../output/." "."
git add .
git commit -m "Update"
git push -f origin gh-pages
