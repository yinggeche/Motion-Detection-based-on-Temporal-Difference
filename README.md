# Motion-Detection-based-on-Temporal-Difference
## Algorithm
### Smoothing
1.  Apply two box filters with different size and two 2D Gaussian filters to smooth the images
2.  Compare the result images of different filters. 
3.  The 5*5 box filter works best. 
### Computing Temporal Derivative and Filtering
1.  Filter the temporal derivative by using a simple 1D Sobel filter and a 1D derivative of a Gaussian with standard deviation varied from 1 to 1.4. 
2.  The simple 0.5[-1 0 1] filter has the best results for detecting moving objects. 
### Defining the threshold
1.  First define the threshold as the maximum in average image of each image. 
2.  Vary the value of threshold to compare the results.

## Language
MATLAB
