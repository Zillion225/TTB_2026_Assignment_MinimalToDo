from PIL import Image

class PyImageUtility:
    def is_image_dark(self, image_path, threshold=100):
        """
        Determines if an image is considered 'dark' based on its average brightness.

        The method converts the image to grayscale and calculates the mean pixel intensity.
        If the mean is below the specified threshold, the image is classified as dark.

        Args:
            image_path (str): The file path to the image.
            threshold (int, optional): The brightness cutoff (0-255). Lower values 
                require the image to be darker to return True. Defaults to 100.

        Returns:
            bool: True if the average brightness is below the threshold, False otherwise.
        """
        # convert image to grayscale
        img = Image.open(image_path).convert('L')
        pixels = list(img.getdata())
        avg_brightness = sum(pixels) / len(pixels)
        return avg_brightness < threshold
