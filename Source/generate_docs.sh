#!/bin/bash
cd  BVSDK/BVSDK
appledoc --index-desc ../../Misc/desc.txt --project-name "Bazaarvoice iOS SDK" --no-repeat-first-par --project-company "Bazaarvoice" --company-id com.bazaarvoice --keep-intermediate-files --no-install-docset .
rm -rf ../../../Docs
mv docset/Contents/Resources/Documents ../../../Docs
rm -rf docset
rm -rf html