#!/bin/sh

carthage update --platform ios

rm -rf AppFollow/Firebase/*
mv -f Carthage/Build/iOS/Firebase*.framework AppFollow/Firebase/
mv -f Carthage/Build/iOS/nanopb.framework AppFollow/Firebase/
mv -f Carthage/Build/iOS/GoogleAppMeasurement.framework AppFollow/Firebase/
mv -f Carthage/Build/iOS/GoogleUtilities.framework AppFollow/Firebase/
mv -f Carthage/Build/iOS/Protobuf.framework AppFollow/Firebase/
