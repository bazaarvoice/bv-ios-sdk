appledoc --index-desc ./desc.txt --project-name "Bazaarvoice iOS SDK" --no-repeat-first-par --project-company "Bazaarvoice" --company-id com.bazaarvoice --keep-intermediate-files --no-install-docset Pod/Classes/
rm -rf ./docs
mv docset/Contents/Resources/Documents ./docs
rm -rf docset
rm -rf html