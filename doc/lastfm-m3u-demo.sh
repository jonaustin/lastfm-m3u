#!/bin/bash

if [ -e ~/.config/lastfm-m3u.yml ];
then
  rm ~/.config/lastfm-m3u.yml
fi

clear
sleep 3

clear
echo "$ lastfm-m3u -h"
sleep 2
lastfm-m3u -h
sleep 5

clear
printf "\n\e[00;32mInit the config to access LastFM's API\e[00m\n"
sleep 3

echo; echo
echo "$ lastfm-m3u --init"
lastfm-m3u --init
sleep 5

clear
printf "\n\e[00;32mlastfm-m3u --init creates a blank config you'll need to fill in with your own keys:\e[00m\n\n"
echo "cat ~/.config/lastfm-m3u.yml"
echo
cat ~/.config/lastfm-m3u.yml
sleep 3

printf "\n\e[00;32m..Add your API keys..\e[00m\n"
cp ~/code/lastfm-m3u/config/lastfm.yml ~/.config/lastfm-m3u.yml
echo
printf "\n\e[00;32mLet's see what music files we have...\e[00m\n"
sleep 3

ls */
sleep 6

clear
printf "\n\e[00;32mMessy...\e[00m\n"
sleep 3

clear
printf "\e[00;32mLet's see what can be found just matching against filenames\e[00m\n"
echo '$ lastfm-m3u -a "Biosphere,Brian Eno"'
sleep 3

lastfm-m3u -a "Biosphere,Brian Eno" -l 10
printf "\n\e[00;32mThat was fast, but looks like a few got missed...\e[00m\n"
sleep 6

clear
printf "\n\e[00;32mLet's see what was missed\e[00m\n"
sleep 3

echo
echo '$ lastfm-m3u -a Biosphere -l 10 -f'
lastfm-m3u -a Biosphere -l 10 -f
sleep 7

clear
printf "\n\e[00;32mLet's search id3 song titles as well\e[00m\n"
printf "\n\e[00;33mNote: ruby-mp3info is slow, so this may take a while with more than a few files...\e[00m\n"
echo
echo '$ lastfm-m3u -a Biosphere -l 10 -t both'
lastfm-m3u -a Biosphere -l 10 -d Biosphere -t both
printf "\n\e[00;32mThat's better.\e[00m\n"
sleep 6

# ffmpeg -i lastfm-m3u-demo.mov -pix_fmt rgb24 -s 1024x640 -f gif -r 30 - | gifsicle --optimize=3 --delay=3 > out.gif
