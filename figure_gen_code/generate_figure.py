import os
import numpy as np
import matplotlib.pyplot as plt
import nibabel as nib
import argparse
from matplotlib.colors import ListedColormap

def main(input_file, label_file, output_dir):
    # Load input and label images
    t1w_img = nib.load(input_file)
    t1w_data = t1w_img.get_fdata()

    label_img = nib.load(label_file)
    labels_data = label_img.get_fdata()

    # Threshold label map
    labels_data[labels_data < 1000] = 0  # Set voxels with value < 1000 to zero
    thresholded_img = nib.Nifti1Image(labels_data, label_img.affine, label_img.header)
    nib.save(thresholded_img, os.path.join(output_dir, 'jlf_thresholdedlabels.nii.gz'))

    # Custom colour map
    colors = [(251/255, 180/255, 174/255),
              (179/255, 205/255, 227/255),
              (204/255, 235/255, 197/255),
              (222/255, 203/255, 228/255),
              (254/255, 217/255, 166/255),
              (255/255, 255/255, 204/255)]
    cmap = ListedColormap(colors)

    # Create directories
    os.makedirs(os.path.join(output_dir, '2D_images_sag'), exist_ok=True)
    os.makedirs(os.path.join(output_dir, '2D_images_cor'), exist_ok=True)
    os.makedirs(os.path.join(output_dir, '2D_images_axi'), exist_ok=True)

    # Determine which slices to display (central 85%)
    num_slices_sag = t1w_data.shape[0]
    num_slices_cor = t1w_data.shape[1]
    num_slices_axi = t1w_data.shape[2]

    start_sag = int(num_slices_sag * 0.075)
    end_sag = int(num_slices_sag * 0.925)
    slices_sag = np.arange(start_sag, end_sag)

    start_cor = int(num_slices_cor * 0.075)
    end_cor = int(num_slices_cor * 0.925)
    slices_cor = np.arange(start_cor, end_cor)

    start_axi = int(num_slices_axi * 0.075)
    end_axi = int(num_slices_axi * 0.925)
    slices_axi = np.arange(start_axi, end_axi)

    # Generate 2D images in each orientation
    # Sagittal
    for s in slices_sag:
        fig, ax = plt.subplots(1, 1, figsize=(10, 10))
        ax.imshow(t1w_data[s, :, :], cmap='gray', alpha=1)
        ax.imshow(cmap(labels_data[s, :, :]), alpha=0.6)
        plt.axis('off')
        plt.savefig(os.path.join(output_dir, '2D_images_sag', f'sag_{s}.png'))
        plt.close()

    # Coronal
    for s in slices_cor:
        fig, ax = plt.subplots(1, 1, figsize=(10, 10))
        ax.imshow(t1w_data[:, s, :], cmap='gray', alpha=1)
        ax.imshow(cmap(labels_data[:, s, :]), alpha=0.6)
        plt.axis('off')
        plt.savefig(os.path.join(output_dir, '2D_images_cor', f'cor_{s}.png'))
        plt.close()

    # Axial
    for s in slices_axi:
        fig, ax = plt.subplots(1, 1, figsize=(10, 10))
        ax.imshow(t1w_data[:, :, s], cmap='gray', alpha=1)
        ax.imshow(cmap(labels_data[:, :, s]), alpha=0.6)
        plt.axis('off')
        plt.savefig(os.path.join(output_dir, '2D_images_axi', f'axi_{s}.png'))
        plt.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate 2D images from 3D T1w MRI and label maps.')
    parser.add_argument('-i', '--input', type=str, required=True, help='Path to input T1w image.')
    parser.add_argument('-l', '--labels', type=str, required=True, help='Path to label image.')
    parser.add_argument('-o', '--output_dir', type=str, required=True, help='Path to output directory.')
    args = parser.parse_args()

    main(args.input, args.labels, args.output_dir)
