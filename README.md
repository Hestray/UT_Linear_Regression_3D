# LOG
 
## 22-Oct-2024
-[x] got rid of the redimensioning of the matrix y_approx for the validation dataset and changed it to reshaping the matrices that are involved in the equation
- due to this change, there is a performance issue when calculating the MSE for varying degrees for both the identification and the validation dataset

## 26-Oct-2024
-[x] initialized the MSE vectors with zeros and replaced the zeroes with the actual values so as to avoid concatenation and the performance drop that comes with it (check below for how to run the performance)
-[ ] refactored the appr and phi functions such that we avoid loops, leading to an improvement in the performance of the code

# Performance check
1. Copy the code from the performaces_SI_proj1
2. Uncomment the section you want to test
3. Click on the arrow beneath the _Run_ button (in the _Editor_ tab, _Run_ section) and click _Run and Time_
Now you can visualize the _Profiler_ performance check on concatenation and no prior allocation of space to the vector versus pre-allocation of space and replacing the values in the
When tested, the performance difference was of 0.066 s for arrays of size 100 (Concatenation: 0.206 s; Pre-allocation: 0.14 s). For arrays of size 1e4, the performance difference is 0.056 s (Concatenation: 0.35 s; Pre-allocation: 0.294 s)
