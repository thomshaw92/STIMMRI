import os
import argparse
import nibabel as nib
import numpy as np
from scipy.ndimage import gaussian_filter, binary_dilation, binary_erosion

def main(input_file, labels_file, output_dir):
    # Load input image and labels
    t1w_img = nib.load(input_file)
    labels_img = nib.load(labels_file)
    t1w_data = t1w_img.get_fdata()
    labels_data = labels_img.get_fdata()

    # Define labels of interest
    labels_of_interest = [1020, 2020, 1018, 2018, 1027, 2027, 1003, 2003, 1028, 2028, 1024, 2024]

    # Prepare output data arrays
    thresholded_data_with_other = np.where(np.isin(labels_data, labels_of_interest), labels_data, 10)
    thresholded_data_no_other = np.where(np.isin(labels_data, labels_of_interest), labels_data, 0)
    
    # Create binary masks for each label of interest, smooth them, calculate contours and replace them in the output data
    for label in labels_of_interest:
        binary_mask = labels_data == label
        smoothed_mask = gaussian_filter(binary_mask.astype(float), sigma=0.5) > 0.5
        contours = binary_dilation(smoothed_mask) ^ binary_erosion(smoothed_mask)
        thresholded_data_with_other[contours] = label
        thresholded_data_no_other[contours] = label

    # Create new Nifti images
    thresholded_img_with_other = nib.Nifti1Image(thresholded_data_with_other, t1w_img.affine, t1w_img.header)
    thresholded_img_no_other = nib.Nifti1Image(thresholded_data_no_other, t1w_img.affine, t1w_img.header)
    
    # Save the output images
    nib.save(thresholded_img_with_other, os.path.join(output_dir, 'thresholded_image_with_other_labels.nii.gz'))
    nib.save(thresholded_img_no_other, os.path.join(output_dir, 'thresholded_image_no_other_labels.nii.gz'))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate Nifti images with smoothed segmentations and thresholded labels.')
    parser.add_argument('-i', '--input', required=True, help='Input T1-weighted Nifti image.')
    parser.add_argument('-l', '--labels', required=True, help='Label Nifti image.')
    parser.add_argument('-o', '--output_dir', required=True, help='Output directory for the generated images.')
    
    args = parser.parse_args()
    
    main(args.input, args.labels, args.output_dir)
