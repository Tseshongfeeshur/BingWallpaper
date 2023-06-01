set curl=
set curl=curl\bin\curl.exe
%curl% "https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=zh-CN" | jq .images | jq .[] >%tmp%\wallpaper.json
jq .urlbase %tmp%\wallpaper.json -r >%tmp%\tmp.txt
set url=
set /p url=<%tmp%\tmp.txt
jq .copyright %tmp%\wallpaper.json -r >%tmp%\tmp.txt
set describe=
set /p describe=<%tmp%\tmp.txt
jq .copyrightlink %tmp%\wallpaper.json -r >%tmp%\tmp.txt
set search=
set /p search=<%tmp%\tmp.txt
jq .title %tmp%\wallpaper.json -r >%tmp%\tmp.txt
set title=
set /p title=<%tmp%\tmp.txt
echo "https://www.bing.com%url%" >%tmp%\tmp.txt
echo "%search%" >>%tmp%\tmp.txt
md output
echo {"Title":"%title%","Describe":"%describe%","UrlIn4k":"https://www.bing.com%url%_UHD.jpg","UrlIn1080p":"https://www.bing.com%url%_1920x1080.jpg","UrlIn720p":"https://www.bing.com%url%_1280x720.jpg","Search":"%search%"} |  jq . >output\all.json
curl "https://www.bing.com%url%_UHD.jpg" -o output\4k.jpg
curl "https://www.bing.com%url%_1920x1080.jpg" -o output\1080p.jpg
curl "https://www.bing.com%url%_1280x720.jpg" -o output\720p.jpg
mkdir temp
cd temp
git init
git remote add origin git@github.com:Tseshongfeeshur/BingWallpaper.git
git fetch
git checkout -b gh-pages
xcopy "..\output\*" ".\" /E /Y
git add .
git commit -m "Update"
git push -f origin gh-pages
