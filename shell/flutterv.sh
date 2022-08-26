#!/bin/sh
path1="$HOME/env/flutter_"
path2="/"
rm -rf ~/env/flutter
cd ~/env || exit

if [ ! -d "flutter" ]; then
  mkdir flutter
else
  echo dir exist
  exit
fi

cp -r "${path1}${1}${path2}" ~/env/flutter/