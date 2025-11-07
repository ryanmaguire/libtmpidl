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
@../../src/tmpidl_bessel_j0
PRO TEST
    X = DINDGEN(1E7) * 1.0E-4

    T1 = SYSTIME(/SECONDS)
    Y_TMPL = TMPIDL_BESSEL_J0(x)
    T2 = SYSTIME(/SECONDS)

    T3 = SYSTIME(/SECONDS)
    Y_IDL = BESELJ(x, 0, /DOUBLE)
    T4 = SYSTIME(/SECONDS)

    PRINT, "tmpidl Time: ", T2 - T1
    PRINT, "IDL Time:    ", T4 - T3
    PRINT, "Ratio:       ", (T4 - T3) / (T2 - T1)
    PRINT, ""
    PRINT, "Max Errors: ", MAX(ABS(Y_TMPL - Y_IDL))
    PRINT, "RMS Error:  ", SQRT(MEAN((Y_TMPL - Y_IDL)^2))
END
