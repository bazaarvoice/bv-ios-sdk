appledoc --index-desc ./misc/desc.txt --project-name "Bazaarvoice iOS SDK" --no-repeat-first-par --project-company "Bazaarvoice" --company-id com.bazaarvoice --keep-intermediate-files --no-install-docset Pod/
rm -rf ./docs
mv docset/Contents/Resources/Documents ./docs
rm -rf docset
rm -rf html
