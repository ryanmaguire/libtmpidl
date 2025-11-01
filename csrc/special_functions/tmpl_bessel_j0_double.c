/******************************************************************************
 *                                  LICENSE                                   *
 ******************************************************************************
 *  This file is part of libtmpidl.                                           *
 *                                                                            *
 *  libtmpidl is free software: you can redistribute it and/or modify it      *
 *  under the terms of the GNU General Public License as published by         *
 *  the Free Software Foundation, either version 3 of the License, or         *
 *  (at your option) any later version.                                       *
 *                                                                            *
 *  libtmpidl is distributed in the hope that it will be useful,              *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of            *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             *
 *  GNU General Public License for more details.                              *
 *                                                                            *
 *  You should have received a copy of the GNU General Public License         *
 *  along with libtmpidl.  If not, see <https://www.gnu.org/licenses/>.       *
 ******************************************************************************
 *                           tmpl_bessel_j0_double                            *
 ******************************************************************************
 *  Purpose:                                                                  *
 *      Provides an IDL wrapper for double precision J0.                      *
 ******************************************************************************
 *  Author:     Ryan Maguire                                                  *
 *  Date:       November 1, 2025                                              *
 ******************************************************************************/

/*  TMPL_CAST macro found here, provides casting with C vs. C++ compatibility.*/
#include <libtmpl/include/compat/tmpl_cast.h>

/*  uint32_t typedef found here.                                              */
#include <stdint.h>

/*  Forward declaration for the libtmpl function.                             */
extern double tmpl_Double_Bessel_J0(double x);

/*  Forward declaration for the IDL wrapper.                                  */
extern void tmpidl_Double_Bessel_J0(int argc, void *argv[]);

/*  IDL wrapper for the Bessel J0 function.                                   */
void tmpidl_Double_Bessel_J0(int argc, void *argv[])
{
    /*  Declare two double pointers, the input and output for IDL.            */
    double *x, *y;

    /*  Size is the size of the input IDL array.                              */
    uint32_t n, size;

    /*  We're expecting three inputs, so check this.                          */
    if (argc != 3)
        return;

    /*  Get the parameters passed from IDL.                                   */
    size = *TMPL_CAST(argv[0], uint32_t *);
    x = TMPL_CAST(argv[1], double *);
    y = TMPL_CAST(argv[2], double *);

    /*  Loop through each point and compute the function for every value.     */
#ifdef _OPENMP
#pragma omp parallel for
#endif
    for (n = 0; n < size; ++n)
        y[n] = tmpl_Double_Bessel_J0(x[n]);
}
/*  End of tmpidl_Double_Bessel_J0.                                           */
