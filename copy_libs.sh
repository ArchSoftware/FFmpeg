#!/bin/bash

# Script which copies libraries from the FFmpeg build folder to a
# folder within an Android Studio project in the correct structure
# Should be run from the FFmpeg root folder.

# Check that a target directory has been supplied
if [ -z "$1" ]
then
    echo "Usage: copy_to_project.sh <target directory>. Example: copy_to_project.sh \${ANDROID_PROJECT}/app/libs"
	exit 1;
fi

BUILD_DIR=build
LIB_DIR=lib

targetRoot=$1

# Create an array of the ABIs from the source directory names
pushd ${BUILD_DIR}
declare -a abis=(*/)
popd

# Create an array of libraries which we want to copy
declare -a filenames=("libavformat.so" "libavcodec.so" "libavutil.so" "libswresample.so")

# Copy the libraries to the target directory
# Source: build/<arch>/lib/<library>.so
# Target: $1/<arch>/<library>.so
for abi in "${abis[@]}"
do
	# Check if the target directory for this ABI exists
	targetDir=${targetRoot}/${abi}

	if [ ! -d ${targetDir} ];
	then
		echo "${targetDir} does not exist, creating."
		mkdir "${targetDir}"
	fi

	for file in "${filenames[@]}"
	do
		# Check the source file exists
		source=${BUILD_DIR}/${abi}/${LIB_DIR}/${file}

		if [ -f ${source} ]; then
			targetDir=${targetRoot}/${abi}
			echo "Copying ${source} to ${targetDir}"
			cp ${source} ${targetDir}
		else
		   echo "${source} does not exist."
		fi
	done
done
