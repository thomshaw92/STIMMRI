import numpy as np
import nibabel as nib
from scipy import ndimage
import argparse
import os

def erode_image(input_img, erosion_size):
    img = nib.load(input_img).get_fdata()

    # Binarize the image so all values above 0 are 1
    binary_img = img.copy()
    binary_img[binary_img > 0] = 1

    # Create a spherical structuring element
    structuring_element = ndimage.generate_binary_structure(3, 1)

    # Erode the binary image
    eroded_binary = ndimage.binary_erosion(binary_img, structure=structuring_element, iterations=erosion_size).astype(binary_img.dtype)

    # Apply the binary mask back to the original image
    eroded_img = eroded_binary * img

    return eroded_img

def save_img(img_data, input_img, erosion_size):
    input_img_obj = nib.load(input_img)
    output_img_obj = nib.Nifti1Image(img_data, input_img_obj.affine, input_img_obj.header)

    base_filename, file_extension = os.path.splitext(input_img)
    if file_extension == ".gz":
        base_filename, _ = os.path.splitext(base_filename)

    output_filename = f"{base_filename}_eroded_{erosion_size}.nii.gz"
    nib.save(output_img_obj, output_filename)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--input_img', type=str, required=True, help="Path to input image file")
    parser.add_argument('--erosion_size', type=int, required=True, help="Size of the structuring element for erosion")
    args = parser.parse_args()

    eroded = erode_image(args.input_img, args.erosion_size)
    save_img(eroded, args.input_img, args.erosion_size)
