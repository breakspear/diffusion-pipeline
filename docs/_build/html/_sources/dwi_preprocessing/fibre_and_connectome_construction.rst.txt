.. _fibre_and_connectome_construction

Fibre and connectome construction
================================

This pipeline provides the connectome and tractography given the patient anatomical image and diffusion images.

Fibre construction
------------------

  1) Computing the response function for each tissue type (GM, WM, CSF), passed to the deconvolution algorithm (described in more detail at http://mrtrix.readthedocs.io/en/latest/constrained_spherical_deconvolution/response_function_estimation.html) Note: If the acquisition is single shell (i.e. ismultishell=0 in advfulldiffsetup), the "Dhollander" algorithm is used, while the multi-shell, multi-tissue (msmt_5tt) is used if multi-shell (i.e. ismultishell=1) is set.

  2) This response function is passed to the fibre orientation distribution function (fODF) -  multi-shell, multi-tissue constrained spherical deconvolution (msmt_csd). This outputs fibre orientation distribution images (FODs) that are then used to provide seeding for the tractography algorithm. Additionally, a WM FOD-based DEC map (weighted by the integral of the FOD) are computed.

  3) The tracking algorithm, provided the WM FOD image, computes a number of streamlines (set by the "numfibers" option in advfulldiffsetup, default 25 million). This is done by the second-order integration over FOD, where short curved "arcs" are drawn and underlying (trilinear-interpolated) FOD amplitudes along the arcs are sampled. These arcs are seeded randomly, provided by the WM FOD image, and the FOD amplitudes inform where the arcs are most likely to go. These arcs, or streamlines, have a number of parameters (e.g. termination, step size, cutoff threshold, etc), that are given by default as given by (cds.ismrm.org/protected/10MProceedings/files/1670_4298.pdf). The fibres are further refined by selection based on anatomical constraints (https://doi.org/10.1016/j.neuroimage.2012.06.005), given by the 5TT image.

  4) Spurious fibres are pruned by determining an appropriate cross-sectional area multiplier for each streamline, as described by (https://doi.org/10.1016/j.neuroimage.2015.06.092), otherwise known as the SIFT2 algorithm. These cross-sectional area multiplers are output as weights for each streamline in a text file - this is used for connectome weighting, allowing cross-subject analysis and normalisation.


Connectome construction
---------------------

Streamlines can be used as connectome "edges" for each of the parcellated regions, or "nodes" and presented as a matrix (with nodes being the index for each value in the matrix, and edges being the values in that matrix). This is provided by the diffusion pipeline, currently in four formats all in upper triangular form with 148 columns and rows (square matrix corresponding to the number of regions in the parcellation step). Note that there are no self-self edges (i.e. the diagonal is zero):

  1) Edges are weighted by the SIFT2 algorithm cross-sectional areas for each streamline, and simply correspond to the number of streamlines that connect to other regions (based on index).

  2) Edges correspond to mean fiber lengths from node to node, weighted by SIFT2.

  3) The above matrices are inverted as well to provide an inverse streamline count and inverse length, again weighted by SIFT2.
