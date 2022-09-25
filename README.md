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
    | Video(Road) | http://www.changedetection.net |
    | Video(Suzie) |  http://trace.eas.asu.edu/yuv/ |
    | Salesman | http://trace.eas.asu.edu/yuv/ |
  - `BSD`: Berkeley Segmentation Dataset
    > Martin D, Fowlkes C, Tal D, et al. A database of human segmented natural images and its application to evaluating segmentation algorithms and measuring ecological statistics[C]//Proceedings Eighth IEEE International Conference on Computer Vision. ICCV 2001. IEEE, 2001, 2: 416-423.
  - `dataset2014`: **download** from [Google Drive](https://drive.google.com/drive/folders/1ksb1tZrCBFUFAMUx-GzSmsDWee2suwzu?usp=sharing) or [ChangeDetection.net(CDNet) dataset2014](http://changedetection.net/).
    > Wang Y, Jodoin P M, Porikli F, et al. CDnet 2014: An expanded change detection benchmark dataset[C]//Proceedings of the IEEE conference on computer vision and pattern recognition workshops. 2014: 387-394.
- `utils` includes some utilities scripts.

## Files
- `demo_TC.m` demo for tensor completion (Section 7.2)
- `demo_TRPCA_image_recovery.m` demo for image recovery (Section 8.1)
- `demo_TRPCA_salient_object_detection.m` demo for salient object detection (Section 8.2)
  - `dataset2014` is required to be downloaded first (from [Google Drive](https://drive.google.com/drive/folders/1ksb1tZrCBFUFAMUx-GzSmsDWee2suwzu?usp=sharing) or [ChangeDetection.net(CDNet) dataset2014](http://changedetection.net/)).
