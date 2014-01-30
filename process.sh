#!/bin/sh

rm component-*/*  2> /dev/null
rm -rf thumbnails/* 2> /dev/null

cp index.html.1 index.html

for COMPONENT in $(ls -l | egrep '^d' | grep 'component' | sed 's/.*component/component/')
do
  echo $COMPONENT
  curl http://mozilla-appmaker.github.io/$COMPONENT/component.html > $COMPONENT/component.html 2> /dev/null
  curl http://mozilla-appmaker.github.io/$COMPONENT/component.css > $COMPONENT/component.css 2> /dev/null
  mkdir -p thumbnails/$COMPONENT/
  curl http://mozilla-appmaker.github.io/$COMPONENT/thumbnail.png > thumbnails/$COMPONENT/thumbnail.png 2> /dev/null
  # curl http://mozilla-appmaker.github.io/$COMPONENT/thumbnail.png > thumbnails/$COMPONENT.png 2> /dev/null
  # sed "s/thumbnail\.png/$COMPONENT.png/" $COMPONENT/component.html > ./tmpfile.html
  # mv tmpfile.html $COMPONENT/component.html
  echo "<link rel=\"import\" href=\"$COMPONENT/component.html\">"  >> index.html
done

cat index.html.2 >> index.html

vulcanize index.html 2> /dev/null

mkdir -p ~/projects/mozilla-appmaker/appmaker/public/bundles/components
rm -rf ~/projects/mozilla-appmaker/appmaker/public/bundles/components/*
mv thumbnails/* ~/projects/mozilla-appmaker/appmaker/public/bundles/components/
cp vulcanized.html ~/projects/mozilla-appmaker/appmaker/public/bundles/components/mozilla-appmaker.html
echo "Copied bundle to ~/projects/mozilla-appmaker/appmaker/public/bundles/components/mozilla-appmaker.html"

