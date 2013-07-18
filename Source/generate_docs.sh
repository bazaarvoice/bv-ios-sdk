#!/bin/bash
cd  BVSDK/BVSDK
appledoc --index-desc ../../Misc/desc.txt --project-name "Bazaarvoice iOS SDK" --no-repeat-first-par --project-company "Bazaarvoice" --company-id com.bazaarvoice --output . --no-install-docset .
rm -rf ../../../Docs
mv docset/Contents/Resources/Documents ../../../Docs
