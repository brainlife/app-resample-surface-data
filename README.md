[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-brainlife.app.604-blue.svg)](https://doi.org/10.25663/brainlife.app.604)

# Resample surface data from fsaverage space

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

**Resamples left and right hemisphere surface data from an fsaverage template mesh to fs_LR (deformed to fsaverage) at 32k, 59k or 164k vertices with FreeSurfer and Connectome Workbench.**

Converts the chosen fsaverage template's pial, white and sphere.reg surfaces to GIFTI (mris_convert), builds midthickness surfaces, and resamples each hemisphere's data with wb_command -metric-resample (ADAP_BARY_AREA). Use it to bring fsaverage-space surface data onto a standard fs_LR mesh.

Run it on brainlife.io: [https://doi.org/10.25663/brainlife.app.604](https://doi.org/10.25663/brainlife.app.604)

| Input | Datatype | Required | Description |
|---|---|---|---|
| `surfaces` | `neuro/surface/data` | yes | Left and right hemisphere surface data (GIFTI) with labels. Data must be on the fsaverage mesh selected by surf_space. |

| Output | Datatype | Description |
|---|---|---|
| `func` | `neuro/surface/data` | Resampled left.gii and right.gii surface data on the chosen fs_LR mesh. |

| Parameter | Type | Default | Description |
|---|---|---|---|
| `resamp_space` | enum | `fs_LR-deformed_to-fsaverage` | space you would like to resample your data to Options: `fs_LR-deformed_to-fsaverage`. |
| `num_vertices` | enum | `32k` | number of vertices to resample to Options: `32k`, `59k`, `164k`. |
| `surf_space` | enum | `fsaverage5` | FreeSurfer fsaverage template (fsaverage3-7) the input data are on; its sphere.reg is the source sphere for resampling. Options: `fsaverage3`, `fsaverage4`, `fsaverage5`, `fsaverage6`, `fsaverage7`. |

Runtime: container `brainlife/freesurfer:7.1.1`; 1 CPUs; 0.5 h walltime; needs `FREESURFER_LICENSE`.

Please cite:
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. Sci Data 6, 69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

<!-- brainlife-app:end -->

This app will will resample surface data to fsaverage space and a user-input number of vertices.

### Authors

- Brad Caron (bacaron@utexas.edu)

### Contributors

- Soichi Hayashi (shayashi@iu.edu)

### Funding Acknowledgement

brainlife.io is publicly funded and for the sustainability of the project it is helpful to Acknowledge the use of the platform. We kindly ask that you acknowledge the funding below in your publications and code reusing this code.

[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-ACI-1916518](https://img.shields.io/badge/NSF_ACI-1916518-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1916518)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://grantome.com/grant/NIH/R01-EB029272-01)

### Citations

We kindly ask that you cite the following articles when publishing papers and code using this code.

1. Avesani, P., McPherson, B., Hayashi, S. et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. Sci Data 6, 69 (2019). https://doi.org/10.1038/s41597-019-0073-y

#### MIT Copyright (c) 2020 brainlife.io The University of Texas at Austin and Indiana University

## Running the App

### On Brainlife.io

You can submit this App online at [https://doi.org/10.25663/brainlife.app.604](https://doi.org/10.25663/brainlife.app.604) via the 'Execute' tab.

### Running Locally (on your machine)

1. git clone this repo

2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files.

```json
{
    "left": "/input/surfaces/left.nii.gz",
    "right": "/input/surfaces/right.nii.gz",
    "label": "/input/surfaces/label.nii.gz",
    "resamp_space": "fs_LR-deformed_to-fsaverage",
    "num_vertices": "32k",
    "surf_space": "fsaverage3"
}
```

### Sample Datasets

You can download sample datasets from Brainlife using [Brainlife CLI](https://github.com/brain-life/cli).

```
npm install -g brainlife
bl login
mkdir input
bl dataset download
```

3. Launch the App by executing 'main'

```bash
./main
```

## Output

The main output of this App is a resampled surface/data datatype.

#### Product.json

The secondary output of this app is `product.json`. This file allows web interfaces, DB and API calls on the results of the processing.

### Dependencies

This App only requires [singularity](https://www.sylabs.io/singularity/) to run. If you don't have singularity, you will need to install following dependencies.   

- Connectome Workbench: https://www.humanconnectome.org/software/connectome-workbench
- Freesurfer: https://surfer.nmr.mgh.harvard.edu/

#### MIT Copyright (c) 2020 brainlife.io The University of Texas at Austin and Indiana University
