<h1 align="center">Resample surface data from fsaverage space</h1>

<p align="center">
  Left and right hemisphere surface data moved from an fsaverage mesh to the fs_LR mesh at 32k, 59k or 164k vertices, with FreeSurfer and Connectome Workbench.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.604"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.604-blue.svg" alt="Run on brainlife.io"></a>
  <a href="https://github.com/brainlife/app-resample-surface-data/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

> **This branch, `app-v1.0-freesurfer-7.1.1-wb-1.5.0`, is the brainlife.io App Resample surface data from fsaverage space** ([doi:10.25663/brainlife.app.604](https://doi.org/10.25663/brainlife.app.604)).

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Resamples left and right hemisphere surface data from an fsaverage template mesh to fs_LR (deformed to fsaverage) at 32k, 59k or 164k vertices with FreeSurfer and Connectome Workbench.**

Converts the chosen fsaverage template's pial, white and sphere.reg surfaces to GIFTI (mris_convert), builds midthickness surfaces, and resamples each hemisphere's data with wb_command -metric-resample (ADAP_BARY_AREA). Use it to bring fsaverage-space surface data onto a standard fs_LR mesh.

| | |
|---|---|
| **Inputs** | `neuro/surface/data` |
| **Outputs** | `neuro/surface/data` |
| **Container** | `brainlife/freesurfer:7.1.1` |
| **Resources** | 1 CPUs · 0.5 h walltime |
| **Requires** | `FREESURFER_LICENSE` |
| **Run it** | [doi.org/10.25663/brainlife.app.604](https://doi.org/10.25663/brainlife.app.604) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `surfaces` | `neuro/surface/data` | yes | Left and right hemisphere surface data (GIFTI) with labels. Data must be on the fsaverage mesh selected by surf_space. |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `func` | `neuro/surface/data` | Resampled left.gii and right.gii surface data on the chosen fs_LR mesh. |

<details>
<summary><b>Parameters</b> (3)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `resamp_space` | enum | `fs_LR-deformed_to-fsaverage` | space you would like to resample your data to Options: `fs_LR-deformed_to-fsaverage`. |
| `num_vertices` | enum | `32k` | number of vertices to resample to Options: `32k`, `59k`, `164k`. |
| `surf_space` | enum | `fsaverage5` | FreeSurfer fsaverage template (fsaverage3-7) the input data are on; its sphere.reg is the source sphere for resampling. Options: `fsaverage3`, `fsaverage4`, `fsaverage5`, `fsaverage6`, `fsaverage7`. |

</details>

<!-- brainlife-app:end -->

## Running the App

### On brainlife.io

Open the App at [doi.org/10.25663/brainlife.app.604](https://doi.org/10.25663/brainlife.app.604), choose a `neuro/surface/data` dataset whose data are on an fsaverage mesh, pick the fsaverage template the data are on (`surf_space`, fsaverage3–7) and the number of output vertices (`num_vertices`: 32k, 59k or 164k), and press **Execute**. The resampled data are archived to your project as a `neuro/surface/data` dataset tagged `resampled`, with the target space and vertex count added as tags.

For each hemisphere the App converts the chosen fsaverage template's pial, white and `sphere.reg` surfaces to GIFTI (`mris_convert`), builds a midthickness surface, and resamples the data onto the `fs_LR-deformed_to-fsaverage` sphere with `wb_command -metric-resample` (adaptive barycentric, area-corrected). The standard spheres from the HCP `standard_mesh_atlases` are included in this repository.

### Locally

You need [Singularity/Apptainer](https://apptainer.org/), [`jq`](https://jqlang.github.io/jq/) and a [FreeSurfer license](https://surfer.nmr.mgh.harvard.edu/registration.html).

1. Clone this repository and check out the branch used on brainlife.io: `git checkout app-v1.0-freesurfer-7.1.1-wb-1.5.0`.
2. Create `config.json` with the paths to the left and right hemisphere data and the options you want:

   ```json
   {
       "left": "/input/surfaces/left.gii",
       "right": "/input/surfaces/right.gii",
       "surf_space": "fsaverage5",
       "resamp_space": "fs_LR-deformed_to-fsaverage",
       "num_vertices": "32k"
   }
   ```

   The scripts read `left`, `right`, `surf_space`, `resamp_space` and `num_vertices`; `config.json.sample` still shows an older single `surfaces` key, which the scripts do not use.

3. Export your license and run the App:

   ```bash
   export FREESURFER_LICENSE="$(cat ~/freesurfer/license.txt)"
   ./main
   ```

## Outputs

```text
func/
├── left.gii    left hemisphere data on the fs_LR mesh
└── right.gii   right hemisphere data on the fs_LR mesh
product.json    tags with the target space and vertex count
```

## Troubleshooting

- **`something went wrong. check logs`**: a template conversion or the resampling step failed. Check that `surf_space` is the fsaverage template the input data are on (its vertex count must match the data).
- **`Please set FREESURFER_LICENSE in .bashrc`**: export the `FREESURFER_LICENSE` environment variable before running `./main` (brainlife.io provides it automatically).

## Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Resample surface data from fsaverage space. brainlife.io App. [doi:10.25663/brainlife.app.604](https://doi.org/10.25663/brainlife.app.604)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. Sci Data 6, 69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)
- Fischl. FreeSurfer. *NeuroImage* 62:774-781 (2012). [doi:10.1016/j.neuroimage.2012.01.021](https://doi.org/10.1016/j.neuroimage.2012.01.021)
- Marcus et al. Informatics and Data Mining Tools and Strategies for the Human Connectome Project. *Frontiers in Neuroinformatics* 5 (2011). [doi:10.3389/fninf.2011.00004](https://doi.org/10.3389/fninf.2011.00004)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)

## Authors

- Brad Caron

**Contributors:** Soichi Hayashi

## Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## License

[MIT](https://github.com/brainlife/app-resample-surface-data/blob/main/LICENSE). Copyright (c) 2020 brainlife.io, The University of Texas at Austin and Indiana University. FreeSurfer and Connectome Workbench are distributed under their own licenses.
