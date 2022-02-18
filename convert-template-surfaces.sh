#!/bin/bash

set -x
set -e

# set configurable inputs
surf_space=`jq -r '.surf_space' config.json`
resamp_space=`jq -r '.resamp_space' config.json`
num_vertices=`jq -r '.num_vertices' config.json`

# set hemispheres
hemispheres="lh rh"

# set path to standard meshes. this can be found at http://brainvis.wustl.edu/workbench/standard_mesh_atlases.zip
atlases='./standard_mesh_atlases'

# variable of important surfaces
import_surfs="pial white sphere.reg"

SUBJECTS_DIR="/usr/local/freesurfer/subjects"

cp -R ${SUBJECTS_DIR}/${surf_space} ./

# make output directory and workdir
[ ! -d ./func ] && mkdir -p ./func
[ ! -d ./tmp ] && mkdir -p ./tmp

# loop through hemispheres
for i in ${hemispheres}
do
  if [ ${i} == "lh" ]; then
    connhem="left"
    wbhem="L"
  else
    connhem="right"
    wbhem="R"
  fi

  # convert freesurfer template data
  for j in ${import_surfs}
  do
    [ ! -f ./tmp/${i}.${j}.surf.gii ] && mris_convert ./${surf_space}/surf/${i}.${j} ./tmp/${i}.${j}.surf.gii

    [ ! -f ./tmp/${i}.${j}.surf.gii ] && echo "something went wrong. check logs" && exit 1
  done
done
