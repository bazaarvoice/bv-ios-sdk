#!/bin/bash

for DIRECTORY in Pod Examples Tests/Tests
do
	echo "Formatting code under $DIRECTORY/"
	find "$DIRECTORY" \( -name '*.h' -or -name '*.m' -or -name '*.mm' \) -print0 | xargs -0 "clang-format" -i
done
