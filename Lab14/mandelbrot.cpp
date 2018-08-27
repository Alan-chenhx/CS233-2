#include "mandelbrot.h"
#include <xmmintrin.h>

// cubic_mandelbrot() takes an array of SIZE (x,y) coordinates --- these are
// actually complex numbers x + yi, but we can view them as points on a plane.
// It then executes 200 iterations of f, using the <x,y> point, and checks
// the magnitude of the result; if the magnitude is over 2.0, it assumes
// that the function will diverge to infinity.

// vectorize the code below using SIMD intrinsics
int *
cubic_mandelbrot_vector(float x[SIZE], float y[SIZE]) {
    static int ret[SIZE];
    float temp[4];
    __m128 X,Y,X1,Y1, X1_2, Y1_2,X2,Y2,bar,three,res;
    three = _mm_set1_ps(3.0);
    bar = _mm_set1_ps(M_MAG*M_MAG);
    for (int i = 0; i < SIZE; i += 4) {
        //x1 = y1 = 0.0;
        X = _mm_loadu_ps(&x[i]);
        Y = _mm_loadu_ps(&y[i]);
        X1 = _mm_set1_ps(0.0);
        Y1 = _mm_set1_ps(0.0);

        // Run M_ITER iterations
        for (int j = 0; j < M_ITER; j ++) {
            // Calculate x1^2 and y1^2
            //float x1_squared = x1 * x1;
            //float y1_squared = y1 * y1;

            X1_2 = _mm_mul_ps(X1, X1);
            Y1_2 = _mm_mul_ps(Y1, Y1);
            // Calculate the real piece of (x1 + (y1*i))^3 + (x + (y*i))
            //x2 = x1 * (x1_squared - 3 * y1_squared) + x[i];

            X2 = _mm_add_ps(_mm_mul_ps(_mm_sub_ps(X1_2,_mm_mul_ps(Y1_2,three)),X1),X);
            // Calculate the imaginary portion of (x1 + (y1*i))^3 + (x + (y*i))
            //y2 = y1 * (3 * x1_squared - y1_squared) + y[i];
            Y2 = _mm_add_ps(_mm_mul_ps(_mm_sub_ps(_mm_mul_ps(X1_2,three),Y1_2),Y1),Y);
            // Use the resulting complex number as the input for the next
            // iteration
            X1 = X2;
            Y1 = Y2;
        }

        // caculate the magnitude of the result;
        // we could take the square root, but we instead just
        // compare squares

        //ret[i] = ((x2 * x2) + (y2 * y2)) < (M_MAG * M_MAG);
        res = _mm_cmplt_ps(_mm_add_ps(_mm_mul_ps(X2,X2),_mm_mul_ps(Y2,Y2)),bar);
        _mm_storeu_ps(temp,res);
        ret[i] = temp[0];
        ret[i+1] = temp[1];
        ret[i+2] = temp[2];
        ret[i+3] = temp[3];

    }

    return ret;
}
