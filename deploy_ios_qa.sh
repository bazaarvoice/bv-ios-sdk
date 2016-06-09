jekyll clean --config _config_ios.yml
jekyll build --config _config_ios.yml --verbose
aws s3 cp _site_ios/ s3://nexus-private-artifacts/utilitybelt/static_html/github-pages-ios-sdk --recursive