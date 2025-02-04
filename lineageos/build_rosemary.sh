#!/bin/bash
LINEAGE_VERSION=22.1
rm -rf .repo/local_manifests
mkdir -p .repo/local_manifests
wget "https://raw.githubusercontent.com/LesVu/aosp_buildscript/refs/heads/main/lineageos/rosemary-${LINEAGE_VERSION}.xml" -O .repo/local_manifests/rosemary.xml
/opt/crave/resync.sh || repo sync
source build/envsetup.sh
breakfast rosemary
croot
brunch rosemary
