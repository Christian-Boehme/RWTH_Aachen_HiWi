#!/usr/bin/env python3

import numpy as np


def GETLINDRATECOEFF(TEMP, PRESSURE, K0, KINF, FC, CONCIN):

    # define constant: R [J / kmol K]
    R = 8314.46261815324

    ITROE = 1
    if CONCIN > 0.0:
        CONC = CONCIN
    else:
        CONC = PRESSURE / (R * TEMP)

    # avoid np.log10(0)
    if FC == 0:
        FC = 1.0E-99

    NTMP = 0.75 - 1.27 * np.log10(FC)
    if ITROE == 1:
        CCOEFF = - 0.4 - 0.67 * np.log10(FC)
        DCOEFF = 0.14
        K0 = K0 * CONC / max(KINF, 1.0E-60)
        LGKNULL = np.log10(K0)
        F = (LGKNULL+CCOEFF) / (NTMP-DCOEFF*(LGKNULL+CCOEFF))
        F = FC ** (1.0 / (F * F + 1.0))
        GETLINDRATECOEFF = KINF * F * K0 / (1.0 + K0)
    else:
        K0 = K0 * CONC / KINF
        KL = K0 / (1.0 + K0)
        F = np.log10(K0) / NTMP
        F = FC ** (1.0 / (F * F + 1.0))
        GETLINDRATECOEFF = KINF * F * KL

    return GETLINDRATECOEFF
