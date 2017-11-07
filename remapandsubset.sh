#!/bin/bash
for file in item*.nc; do
cdo -sellonlatbox,81,99,24,32 -remapbil,r720x360 ${file} subset_${file}
done
