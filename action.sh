#!/bin/bash

curl "https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=zh-CN" | jq .images | jq .[] >$tmp/wallpaper.json
jq .urlbase $tmp/wallpaper.json -r >$tmp/tmp.txt
read -r url<$tmp/tmp.txt
jq .copyright $tmp/wallpaper.json -r >$tmp/tmp.txt
read -r describe<$tmp/tmp.txt
jq .copyrightlink $tmp/wallpaper.json -r >$tmp/tmp.txt
read -r search<$tmp/tmp.txt
jq .title $tmp/wallpaper.json -r >$tmp/tmp.txt
read -r title<$tmp/tmp.txt
mkdir output
echo {"Title":"$title","Describe":"$describe","UrlIn4k":"https://www.bing.com$url_UHD.jpg","UrlIn1080p":"https://www.bing.com$url_1920x1080.jpg","UrlIn720p":"https://www.bing.com$url_1280x720.jpg","Search":"$search"} | jq . >output/all.json
curl "https://www.bing.com$url_UHD.jpg" -o output/4k.jpg
curl "https://www.bing.com$url_1920x1080.jpg" -o output/1080p.jpg
curl "https://www.bing.com$url_1280x720.jpg" -o output/720p.jpg
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
