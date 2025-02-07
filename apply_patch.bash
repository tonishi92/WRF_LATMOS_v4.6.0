#!/bin/bash

###########################################################################
#
#   Description
#   -----------
#   Let's say you have following patches in a directory <patch_dir>
#     - 0001-des0001.patch 
#     - 0002-des0002.patch
#     - 0003-des0003.patch
#       .....
#     - 0070-des0070.patch
#     - 0071-des0071.patch
#       .....
#
#   Patch names start with 4-digit zero-padded numbers, 
#   followed by a short description, e.g. <des0001>.
#   Patches are to be applied in the order of the numbers.
#   Git command used to apply patches is
# 
#   git am -3 patch_file
#
#   HOW TO USE
#   ----------
#
#   $ apply_patch <patch_dir> 
#   or 
#   $ apply_patch <patch_dir> patch_number
#   
#   where
#
#   patch_number: Starting patch number.
#                 If omitted, set to 1
#                 This argument is necessary when there is a conflict 
#                 in a patch application and you need to resume
#                 the patch application after solving it. 
#                 e.g.)
#                 apply_patch <patch_dir> 5
#                 Applies patches in <patch_dir> 
#                 starting with 0005-des0005.patch and later
#      
###########################################################################

echo "# of arguments : $#"

for patch_file in `ls $1/0*.patch`
do
  apply_patch=0
  if [ $# -eq 2 ]
  then
    IFS='/' read -r -a patch_temp <<< "${patch_file}"
    echo ${patch_temp}
    patch_number=${patch_temp[-1]}
    patch_number=${patch_number:0:4}  
    echo ${patch_number}
    ### patch_number=`expr $patch_number \> 3`
    check=`expr $patch_number \>= $2` 
    if [[ $check == 1 ]]
    then
      apply_patch=1
      echo "patch_number is greater than or equal to $2"
    else
      echo "patch_number is smaller than $2"
    fi 
  else
    apply_patch=1
    echo "# of arguments : $#"
  fi 

  if [ $apply_patch -eq 1 ]
  then
    git am -3 ${patch_file}  
    if [[ $? -gt 0 ]]
    then
      echo "patch application failed"
      echo "failed patch : ${patch_file}"
      exit 0
    fi
  fi
 
done


echo "End of patch application"

