#!/bin/bash

set -x
set -e

# set configurable inputs
left_data=`jq -r '.left' config.json`
right_data=`jq -r '.right' config.json`
surf_space=`jq -r '.surf_space' config.json`
resamp_space=`jq -r '.resamp_space' config.json`
num_vertices=`jq -r '.num_vertices' config.json`

# set hemispheres
hemispheres="lh rh"

# set path to standard meshes. this can be found at http://brainvis.wustl.edu/workbench/standard_mesh_atlases.zip
atlases='./standard_mesh_atlases'

# variable of important surfaces
import_surfs="pial white sphere.reg"

# make output directory and workdir
[ ! -d ./func ] && mkdir -p ./func
[ ! -d ./tmp ] && mkdir -p ./tmp

# loop through hemispheres
for i in ${hemispheres}
do
  if [[ ${i} == "lh" ]]; then
    connhem="left"
    wbhem="L"
  else
    connhem="right"
    wbhem="R"
  fi

  data=$(eval "echo \$${connhem}_data")

  # copy over data from input
  [ ! -f ./tmp/${i}.data.func.gii ] && cp ${data} ./tmp/${i}.data.func.gii

  # create midthickness surface of template
  [ ! -f ./tmp/${i}.midthickness.surf.gii ] && wb_command -surface-average -surf ./tmp/${i}.pial.surf.gii -surf ./tmp/${i}.white.surf.gii ./tmp/${i}.midthickness.surf.gii

  # resample midthickness to output space/resolution
  [ ! -f ./tmp/${i}.midthickness.${resamp_space}.${num_vertices}.surf.gii ] && wb_command -surface-resample ./tmp/${i}.midthickness.surf.gii ./tmp/${i}.sphere.reg.surf.gii ${atlases}/resample_fsaverage/${resamp_space}.${wbhem}.sphere.${num_vertices}_fs_LR.surf.gii BARYCENTRIC ./tmp/${i}.midthickness.${resamp_space}.${num_vertices}.surf.gii

  # resample input data
  [ ! -f ./tmp/${i}.resampled.data.func.gii ] && wb_command -metric-resample ./tmp/${i}.data.func.gii ./tmp/${i}.sphere.reg.surf.gii ${atlases}/resample_fsaverage/${resamp_space}.${wbhem}.sphere.${num_vertices}_fs_LR.surf.gii ADAP_BARY_AREA ./tmp/${i}.resampled.data.func.gii -area-surfs ./tmp/${i}.midthickness.surf.gii ./tmp/${i}.midthickness.${resamp_space}.${num_vertices}.surf.gii

  if [ ! -f ./tmp/${i}.resampled.data.func.gii ]; then
    echo "something went wrong. check logs"
    exit 1
  else
    [ ! -f ./func/${connhem}.gii ] && cp ./tmp/${i}.resampled.data.func.gii ./func/${connhem}.gii
  fi
done

# add resample vertices as datatype tag
product=""
product="\"tags\": [ \"$resamp_space\","\"$num_vertices"\" ]"
cat << EOF > product.json
{
    $product
}
EOF
