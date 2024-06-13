from matplotlib import pyplot as plt
from skimage import io, filters

# Read an image
img = io.imread('GSWA-Regional_geophysical_survey-04.jpg')

# Apply Gaussian filter
gaussian_img = filters.gaussian(img, sigma=2)

# Display the original and processed images
plt.subplot(1, 2, 1)
plt.title('Original Image')
plt.imshow(img)

plt.subplot(1, 2, 2)
plt.title('Gaussian Filtered Image')
plt.imshow(gaussian_img)

plt.show()

