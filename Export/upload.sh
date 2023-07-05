#!/bin/bash

NAME="name"
LINK="link"

cd "${0%/*}" #must change to own directory for bash
cp "./${NAME}_HTML5/${NAME}.html" "./${NAME}_HTML5/index.html"
make
butler push "${NAME}_HTML5"        "Norodix/$LINK:html"
butler push "${NAME}_Windows.zip"  "Norodix/$LINK:windows"
butler push "${NAME}_Linux.zip"    "Norodix/$LINK:linux"
