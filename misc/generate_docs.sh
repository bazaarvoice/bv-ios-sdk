cd ..
appledoc --index-desc ./misc/desc.txt --project-name "Bazaarvoice iOS SDK" --no-repeat-first-par --project-company "Bazaarvoice" --company-id com.bazaarvoice --keep-intermediate-files --no-install-docset Pod/
rm -rf ./assets/api_reference
mkdir assets/
mv docset/Contents/Resources/Documents ./assets/api_reference
rm -rf docset
rm -rf html
