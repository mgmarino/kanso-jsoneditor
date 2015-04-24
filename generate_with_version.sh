#!/bin/bash
MODULENAME=jsoneditor
VERSION="4.1.3"
CWD=`pwd`
PUBLISHDIR=${CWD}/publish
URL="http:\/\/jsoneditoronline.org\/"
REPONAME=jsoneditor
DOWNLOAD_URL=https://github.com/josdejong/$REPONAME/archive/v$VERSION.zip
rm -rf node_modules
curl -L -O $DOWNLOAD_URL
unzip v$VERSION.zip
mv $REPONAME-$VERSION $MODULENAME
cd $MODULENAME
npm install
browserify ./index.js -o ./jsoneditor.custom.js -s JSONEditor -x brace -x brace/mode/json -x brace/ext/searchbox
sed \
    -e "/require('brace\/mode/d" \
    -e "/require('brace\/ext/d" \
    -e s/brace/ace/g \
     jsoneditor.custom.js > ../$MODULENAME.js

cd ..
echo $VERSION
for var in README.md kanso.json
do
  sed -e s/@VERSION@/$VERSION/g \
      -e s/@MODULENAME@/$MODULENAME/g \
      -e s/@URL@/$URL/g \
             $var.in > $var 
done
rm -rf ${PUBLISHDIR}
mkdir ${PUBLISHDIR} 
mkdir ${PUBLISHDIR}/css
cp README.md kanso.json $MODULENAME.js ${PUBLISHDIR} 
for i in ${MODULENAME}.css img 
do
  cp -R ${MODULENAME}/dist/$i ${PUBLISHDIR}/css
done
cd ${PUBLISHDIR}
kanso publish
cd ${CWD} 
rm -rf *.zip $MODULENAME $MODULENAME.js
rm -rf ${PUBLISHDIR} 

