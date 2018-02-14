#!/bin/bash

for DIRECTORY in BVSDK Examples BVSDKTests
do
	echo "Formatting code under $DIRECTORY/"
	find "$DIRECTORY" \( -name '*.h' -or -name '*.m' -or -name '*.mm' \) -print0 | xargs -0 "clang-format" -i
done
