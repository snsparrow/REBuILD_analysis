#!/bin/bash

OUT_DIR=/gpfs/projects/cpdn/scratch/Khaled/

TMP_DIR=/gpfs/projects/cpdn/scratch/Khaled/tmp/

function emean {
  echo "Calculating ensemble mean for batch " ${1}
  cd /gpfs/projects/cpdn/scratch/Khaled/batch_${1}/region_E82_N31_E98_N25/${2}/
#  ncea subset_${2}*.nc emean_${2}_${3}.nc
  ncea ${2}*.nc ${TMP_DIR}/emean_${2}_${3}.nc
  echo emean_${2}_${3}.nc
}

function process { 
mkdir -p $TMP_DIR

item=${1}

case ${2} in
actual) batches=(633 530 591);;
natural) batches=(617 531 592);;
esac

echo ${batches[*]}
# Ensemble means
i=0
for batch in "${batches[@]}"; do
  echo "Batch " ${batch}
  ((i++))
  emean ${batch} ${item} ${i}
done

# Chop
echo "Chopping files for " ${item}
ls ${TMP_DIR}

cdo seldate,2016-01-01,2016-12-30 ${TMP_DIR}/emean_${item}_2.nc ${TMP_DIR}/emean_${item}_2_chop.nc
cdo seldate,2017-01-01,2017-06-30 ${TMP_DIR}/emean_${item}_3.nc ${TMP_DIR}/emean_${item}_3_chop.nc


# Stitchecho "Stiching files"
echo "Stiching files"
ls ${TMP_DIR}
cdo cat ${TMP_DIR}/emean_${item}_1.nc ${TMP_DIR}/emean_${item}_2_chop.nc ${TMP_DIR}/emean_${item}_3_chop.nc ${OUT_DIR}/emean_${item}_${2}_final.nc
rm -fr $TMP_DIR
}


# Batches
declare -a items=('item3236_daily_maximum' 'item3236_daily_minimum' 'item5216_daily_mean')
echo ${items[*]}
for item in "${items[@]}";
do
    echo ${item}
    process ${item} actual
    process ${item} natural
done

