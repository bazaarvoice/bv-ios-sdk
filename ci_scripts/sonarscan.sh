wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
sudo ./llvm.sh 13

wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip
unzip sonar-scanner-cli-4.6.2.2472-linux.zip

./sonar-scanner-4.6.2.2472-linux/bin/sonar-scanner \
  -Dsonar.projectKey=bazaarvoice_bv-ios-sdk-dev \
  -Dsonar.sources=. \
  -Dsonar.cfamily.build-wrapper-output=build_wrapper_output_directory \
  -Dsonar.host.url=$SONAR_URL \
  -Dsonar.login=$SONAR_LOGIN \
  -Dsonar.coverageReportPaths=sonarqube-generic-coverage.xml
