#!/bin/sh

DATE=$(date +%Y-%m-%d-%H%M%S)
FILENAME="../elizabeth-restaurant-${DATE}.zip"
zip -r ${FILENAME} .
