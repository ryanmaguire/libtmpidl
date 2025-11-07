;******************************************************************************;
;                                   LICENSE                                    ;
;******************************************************************************;
;  This file is part of libtmpidl.                                             ;
;                                                                              ;
;  libtmpidl is free software: you can redistribute it and/or modify           ;
;  it under the terms of the GNU General Public License as published by        ;
;  the Free Software Foundation, either version 3 of the License, or           ;
;  (at your option) any later version.                                         ;
;                                                                              ;
;  libtmpidl is distributed in the hope that it will be useful,                ;
;  but WITHOUT ANY WARRANTY; without even the implied warranty of              ;
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               ;
;  GNU General Public License for more details.                                ;
;                                                                              ;
;  You should have received a copy of the GNU General Public License           ;
;  along with libtmpidl.  If not, see <https://www.gnu.org/licenses/>.         ;
;******************************************************************************;
;                               tmpidl_bessel_i0                               ;
;******************************************************************************;
;   Purpose:                                                                   ;
;       Provide IDL wrappers for libtmpl's Bessel I0 function.                 ;
;   Input:                                                                     ;
;       A real array or scalar.                                                ;
;   Output:                                                                    ;
;       A real array or scalar, the value I_0(x).                              ;
;******************************************************************************;
;  Author:     Ryan Maguire                                                    ;
;  Date:       March 9, 2022                                                   ;
;******************************************************************************;
FUNCTION TMPIDL_BESSEL_I0, X

    ; Tells the compiler that integers should be 32 bits, not 16.
    COMPILE_OPT IDL2

    ; Set error handling.
    ON_ERROR, 2

    ; Location of the IDL wrapper shared object.
    LIBRARY = "/usr/local/lib/libtmpidl.so"

    ; Names of the function at the supported precisions / types.
    DOUBLE_FUNC = "tmpidl_Double_Bessel_I0"
    FLOAT_FUNC = "tmpidl_Float_Bessel_I0"

    ; libtmpl handles real valued inputs for this function.
    INPUT_TYPE = TYPENAME(X)

    ; Get the number of elements in the input array.
    LENGTH = ULONG(N_ELEMENTS(X))

    ; libtmpl wants either a double or a float. Convert if necessary.
    CASE INPUT_TYPE OF

        "DOUBLE": BEGIN

            ; No need to convert the input, libtmpl supports double.
            OUTPUT = DBLARR(LENGTH)

            ; Use 'CALL_EXTERNAL' to pass the IDL parameters to the C code.
            _ = CALL_EXTERNAL(LIBRARY, DOUBLE_FUNC, LENGTH, X, OUTPUT)
        END

        "FLOAT": BEGIN

            ; Again, no need to convert the input. libtmpl supports float.
            OUTPUT = FLTARR(LENGTH)

            ; Call the C function used for single precision.
            _ = CALL_EXTERNAL(LIBRARY, FLOAT_FUNC, LENGTH, X, OUTPUT)
        END

        ELSE: BEGIN

            ; Convert the input to a double array.
            INPUT = DOUBLE(X)
            OUTPUT = DBLARR(LENGTH)

            ; Call the double-precision version of the libtmpl function.
            _ = CALL_EXTERNAL(LIBRARY, DOUBLE_FUNC, LENGTH, INPUT, OUTPUT)
        END
    ENDCASE

    ; The result has been stored in the output array, return this.
    RETURN, OUTPUT
END
