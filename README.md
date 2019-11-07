# Motion-Detection-based-on-Temporal-Difference
## Smoothing
Apply two box filters with different size and two 2D Gaussian filters to smooth the images and then compare the result images of different filters. The 5*5 box filter works best. 
## Computing Temporal Derivative and Filtering
After that, filter the temporal derivative by using a simple 1D Sobel filter and a 1D derivative of a Gaussian with standard deviation varied from 1 to 1.4. The simple 0.5[-1 0 1] filter has the best results for detecting moving objects. 
## Defining the threshold
For different temporal filters, first define the threshold as the maximum in average image of each image. And then vary the value of threshold to compare the results.
