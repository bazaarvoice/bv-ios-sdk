jekyll clean --config _config_android.yml
jekyll build --config _config_android.yml --verbose
aws s3 cp _site_android/ s3://nexus-private-artifacts/utilitybelt/static_html/github-pages-android-sdk --recursive