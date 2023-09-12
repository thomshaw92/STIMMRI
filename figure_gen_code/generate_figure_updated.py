import os
import argparse
import nibabel as nib
import numpy as np
from scipy.ndimage import gaussian_filter, binary_dilation, binary_erosion, generate_binary_structure

def main(input_file, labels_file, output_dir, erosion_voxels):
    # Load input image and labels
    print("Loading input image and labels...")
    t1w_img = nib.load(input_file)
    labels_img = nib.load(labels_file)
    t1w_data = t1w_img.get_fdata()
    labels_data = labels_img.get_fdata()
    print(f"Unique labels in the input labels image: {np.unique(labels_data)}")

    # Define labels of interest
    print("Defining labels of interest...")
    labels_of_interest = [1003, 2003, 1012,	2012, 1014, 2014, 1018, 2018, 1019, 2019, 1020, 2020, 1027, 2027, 1028, 2028]

    # Prepare output data arrays
    print("Preparing output data arrays...")
    # filled_segmentations_data = np.zeros_like(labels_data)  # Commented out as we reset the array later
    thresholded_data_with_other = np.where((np.isin(labels_data, labels_of_interest) | (labels_data == 0)), labels_data, 10)
    # Apply erosion if specified
    if erosion_voxels > 0:
        print(f"Applying erosion with {erosion_voxels} voxels...")
        struct = generate_binary_structure(3, 1)
        struct = binary_dilation(struct, iterations=erosion_voxels-1)
        eroded_labels_data = binary_erosion(labels_data, structure=struct)
    else:
        eroded_labels_data = labels_data

    thresholded_data_no_other = np.where(np.isin(eroded_labels_data, labels_of_interest), eroded_labels_data, 0)
    
    # Create binary masks for each label of interest, smooth them, and replace them in the output data
    print("Creating binary masks for each label of interest...")
    filled_segmentations_data = np.zeros_like(labels_data)  # Initializing the array to hold filled-in segmentations
    # filled_segmentations_data = np.zeros_like(labels_data)  # Commented out as we reset the array later  # Resetting the array to start fresh
    for label in labels_of_interest:
        binary_mask = labels_data == label
        smoothed_mask = gaussian_filter(binary_mask.astype(float), sigma=0.5) > 0.5
        contours = binary_dilation(smoothed_mask) ^ binary_erosion(smoothed_mask)
        thresholded_data_with_other[contours] = label
        # thresholded_data_no_other[contours] = label  # Commented out as we don't want outlines
        print(f"Processing label: {label}")  # Debug line to indicate the label being processed
        filled_segmentations_data[smoothed_mask] = label  # Adding only the smoothed masks for filled-in segmentations

    # Create new Nifti images
    print("Creating new Nifti images...")
    thresholded_img_with_other = nib.Nifti1Image(thresholded_data_with_other, t1w_img.affine, t1w_img.header)
    thresholded_img_no_other = nib.Nifti1Image(thresholded_data_no_other, t1w_img.affine, t1w_img.header)
    
    # Save the output images
    print("Saving the output images...")
    filled_segmentations_img = nib.Nifti1Image(filled_segmentations_data, t1w_img.affine, t1w_img.header)
    nib.save(filled_segmentations_img, os.path.join(output_dir, 'filled_segmentations_image.nii.gz'))
    nib.save(thresholded_img_with_other, os.path.join(output_dir, 'thresholded_image_with_other_labels.nii.gz'))
    nib.save(thresholded_img_no_other, os.path.join(output_dir, 'thresholded_image_no_other_labels.nii.gz'))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate Nifti images with smoothed segmentations and thresholded labels.')
    parser.add_argument('-e', '--erosion', type=int, default=0, help='Number of voxels to erode the segmentation image by.')
    parser.add_argument('-i', '--input', required=True, help='Input T1-weighted Nifti image.')
    parser.add_argument('-l', '--labels', required=True, help='Label Nifti image.')
    parser.add_argument('-o', '--output_dir', required=True, help='Output directory for the generated images.')
    
    args = parser.parse_args()
    
    main(args.input, args.labels, args.output_dir, args.erosion)

