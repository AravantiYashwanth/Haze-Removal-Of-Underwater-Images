%% Step 1: Display Input Image
rgbImage = imread('15.jpg');
rgbImage = im2double(rgbImage);  % Convert to double precision

figure('Name', 'Step 1: Input Image');
imshow(rgbImage);
title('Input Image');

%% Step 2: Image Preprocessing

% Resize the image (Optional)
resizedImage = imresize(rgbImage, [512, 512]);


preprocessedImage = imbilatfilt(resizedImage, 0.01, 2); 

% Histogram equalization for contrast enhancement (HSV space)
hsvImage = rgb2hsv(preprocessedImage);         % Convert RGB to HSV
hsvImage(:,:,3) = histeq(hsvImage(:,:,3));     % Equalize the 'V' channel (intensity)
preprocessedImage = hsv2rgb(hsvImage);         % Convert back to RGB

% Display the preprocessed image
figure('Name', 'Step 2: Preprocessed Image');
imshow(preprocessedImage);
title('Preprocessed Image');

%% Step 3: Improved White Balancing (using scaling factors)


meanR = mean2(preprocessedImage(:,:,1));
meanG = mean2(preprocessedImage(:,:,2));
meanB = mean2(preprocessedImage(:,:,3));
meanGray = (meanR + meanG + meanB) / 3;  


scaleR = meanGray / meanR;
scaleG = meanGray / meanG;
scaleB = meanGray / meanB;

whiteBalancedImage = preprocessedImage;
whiteBalancedImage(:,:,1) = preprocessedImage(:,:,1) * scaleR;
whiteBalancedImage(:,:,2) = preprocessedImage(:,:,2) * scaleG;
whiteBalancedImage(:,:,3) = preprocessedImage(:,:,3) * scaleB;


whiteBalancedImage = min(whiteBalancedImage, 1);

% Display the white-balanced image
figure('Name', 'Step 3: White Balanced Image');
imshow(whiteBalancedImage);
title('White Balanced Image');

%% Step 4: Adjust Gamma Correction to Avoid Over-lightening

% Apply Gamma correction with a slightly higher value to avoid lightening too much
gammaCorrectedImage = imadjust(whiteBalancedImage, [], [], 0.8);

% Display the gamma-corrected image
figure('Name', 'Step 4: Gamma Corrected Image');
imshow(gammaCorrectedImage);
title('Gamma Corrected Image');

%% Step 5: Sharpen the Image

sharpenedImage = imsharpen(gammaCorrectedImage, 'Radius', 2, 'Amount', 1.5);

% Display the sharpened image
figure('Name', 'Step 5: Sharpened Image');
imshow(sharpenedImage);
title('Sharpened Image');

%% Step 6: Image Fusion using Wavelet Transform


fusedImage = wfusimg(gammaCorrectedImage, sharpenedImage, 'sym4', 3, 'max', 'max');

% Display the fusion result
figure('Name', 'Step 6: Wavelet Fused Image');
imshow(fusedImage);
title('Wavelet Fused Image');

%% Step 7: Segmentation using K-means Clustering

tic;


labImage = rgb2lab(whiteBalancedImage);


ab = labImage(:,:,2:3);  
ab = im2single(ab);      
nrows = size(ab, 1);
ncols = size(ab, 2);
ab = reshape(ab, nrows*ncols, 2);  

% Set the number of clusters (k)
num_clusters = 3;


opts = statset('MaxIter', 500, 'Display', 'final');  
[cluster_idx, ~] = kmeans(ab, num_clusters, 'distance', 'sqEuclidean', 'Replicates', 3, 'Options', opts, 'Start', 'plus');


pixel_labels = reshape(cluster_idx, nrows, ncols);


executionTime = toc;
disp(['Execution Time for K-means Segmentation: ', num2str(executionTime), ' seconds']);


figure('Name', 'Step 7: Segmented Image (K-means)');
imshow(pixel_labels, []);
title('Segmented Image (K-means)');


segmented_images = cell(1, num_clusters);
for k = 1:num_clusters
    color = whiteBalancedImage;
    color(repmat(pixel_labels ~= k, [1, 1, 3])) = 0;  % Set non-cluster pixels to zero
    segmented_images{k} = color;
end

% Display segmented regions
figure('Name', 'Step 7: Segmented Regions');
for k = 1:num_clusters
    subplot(1, num_clusters, k);
    imshow(segmented_images{k});
    title(['Cluster ', num2str(k)]);
end

%% Step 8: Load Ground Truth Image for Accuracy, Sensitivity, and Specificity Calculations


groundTruthImage = imbinarize(rgb2gray(imread('1.jpg')));  
groundTruthImage_resized = imresize(groundTruthImage, [nrows, ncols]);  

% Initialize variables for true positives, true negatives, false positives, and false negatives
TP = 0; TN = 0; FP = 0; FN = 0;

% Calculate true positives, false positives, true negatives, and false negatives
for k = 1:num_clusters
    clusterMask = pixel_labels == k;  % Mask for the current cluster
    TP = TP + sum((clusterMask == 1) & (groundTruthImage_resized == 1));  % True Positive
    TN = TN + sum((clusterMask == 0) & (groundTruthImage_resized == 0));  % True Negative
    FP = FP + sum((clusterMask == 1) & (groundTruthImage_resized == 0));  % False Positive
    FN = FN + sum((clusterMask == 0) & (groundTruthImage_resized == 1));  % False Negative
end

% Calculate accuracy, sensitivity, and specificity
accuracy = (TP + TN) / (TP + TN + FP + FN);
sensitivity = TP / (TP + FN);  % True Positive Rate (Recall)
specificity = TN / (TN + FP);  % True Negative Rate

% Display the calculated metrics
disp(['Accuracy: ', num2str(accuracy)]);
disp(['Sensitivity: ', num2str(sensitivity)]);
disp(['Specificity: ', num2str(specificity)]);

%% Step 9: SSIM and PSNR Calculations


refImage = im2double(imread('1.jpg'));  
refImage_resized = imresize(refImage, [nrows, ncols]);

if size(refImage_resized, 3) == 1
    refImage_resized = cat(3, refImage_resized, refImage_resized, refImage_resized);
end


ssimValue = ssim(fusedImage, refImage_resized);  
psnrValue = psnr(fusedImage, refImage_resized);  


disp(['SSIM: ', num2str(ssimValue)]);
disp(['PSNR: ', num2str(psnrValue)]);

%% Step 10: Display Final Enhanced Image

% Final enhanced image after all steps (gamma correction, sharpening, and wavelet fusion)
finalEnhancedImage = fusedImage;

% Display the final enhanced image
figure('Name', 'Final Enhanced Image');
imshow(finalEnhancedImage);
title('Final Enhanced Image');
