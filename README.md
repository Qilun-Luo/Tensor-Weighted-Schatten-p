# Tensor-Weighted-Schatten-p-Method-for-3D-Array-Image-Data-Recovery
Matlab Implementation for the paper:

Yang, M., Luo, Q., Li, W., & Xiao, M. (2022). Nonconvex 3D array image data recovery and pattern recognition under tensor framework. Pattern Recognition, 122, 108311.

## Folders
- `algs` includes only the proposed method: tensor weighted Schatten-p ( $t\text{-}S_{w,p}$ )
- `data` contains datasets.
  - `tc_data`: 
  
    | Dataset | Sources |
    | ---- | ---- |
    | MRI | http://brainweb.bic.mni.mcgill.ca/brainweb/selection_normal.html |
- `utils` includes some utilities scripts.

## Files
- `demo_TC.m` demo for tensor completion (Section 7.2)
- `demo_TRPCA_image_recovery.m` demo for image recovery (Section 8.1)
- `demo_TRPCA_salient_object_detection.m` demo for salient object detection (Section 8.2)
