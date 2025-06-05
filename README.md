# Haze Removal and Enhancement of Underwater Images

This project implements a comprehensive MATLAB-based image processing pipeline for enhancing underwater images by removing haze, correcting colors, and improving contrast and sharpness. The final output is validated using segmentation and image quality metrics such as SSIM and PSNR.

## 🔍 Features

- Preprocessing with bilateral filtering and histogram equalization
- Improved white balancing using channel scaling
- Gamma correction to maintain brightness balance
- Image sharpening and wavelet-based image fusion
- K-means clustering for image segmentation
- Accuracy, sensitivity, and specificity evaluation
- SSIM and PSNR calculation for quality assessment

## 🖼️ Sample Input

- Underwater image (e.g., `15.jpg`)
- Ground truth reference image (e.g., `1.jpg`)

> Ensure both images are placed in the working directory.

## 🚀 Steps Involved

1. **Input & Preprocessing**: Resizing, bilateral filtering, and histogram equalization in HSV space.
2. **White Balancing**: Adjusting each RGB channel to equalize the average intensity.
3. **Gamma Correction**: Controlled enhancement to avoid over-lightening.
4. **Sharpening**: Image detail enhancement using MATLAB's `imsharpen`.
5. **Wavelet Fusion**: Combine enhanced features using Symlet-4 wavelet decomposition.
6. **Segmentation**: K-means clustering in LAB space to separate image regions.
7. **Evaluation**: Compare segmented output with ground truth using metrics:
   - Accuracy
   - Sensitivity
   - Specificity
   - SSIM (Structural Similarity Index)
   - PSNR (Peak Signal-to-Noise Ratio)

## 📊 Output

- Segmented clusters visualized
- Final enhanced image displayed
- Console output with evaluation metrics


## ▶️ How to Run the Project

## 🛠 Requirements

- MATLAB R2021a or later (recommended)
- Image Processing Toolbox
- Statistics and Machine Learning Toolbox
- Wavelet Toolbox

You can run this project entirely in **[MATLAB Online](https://matlab.mathworks.com/)** — no installation required!

### ✅ Steps to Run

1. **Go to**: [https://matlab.mathworks.com](https://matlab.mathworks.com)

2. **Login** using your MathWorks account (create one if needed — it’s free for students).

3. **Create a new folder** (e.g., `UnderwaterHazeRemoval`).

4. **Upload the following files** into that folder:
   - `15.jpg` → Input underwater image  
   - `1.jpg` → Ground truth image for evaluation  
   - `your_script_name.m` → The MATLAB code file you wrote

5. **Open the script** in the MATLAB Online editor.

6. **Click the “Run” button** at the top of the editor or type this in the Command Window:
   ```matlab
   run('your_script_name.m')




