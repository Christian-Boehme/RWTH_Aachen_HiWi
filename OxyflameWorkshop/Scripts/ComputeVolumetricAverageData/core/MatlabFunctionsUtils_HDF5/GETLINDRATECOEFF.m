function [GETLINDRATECOEFF] = GETLINDRATECOEFF( TEMP, PRESSURE, K0, KINF, FC, CONCIN )


% define constant: R [J / kmol K]
R = 8314.46261815324;

ITROE = 1;
if CONCIN > 0.0
    CONC = CONCIN;
else
    CONC = PRESSURE / ( R * TEMP );
end

NTMP = 0.75 - 1.27 * log10( FC );
if ITROE == 1
    CCOEFF = - 0.4 - 0.67 * log10( FC );
    DCOEFF = 0.14;
    K0 = K0 * CONC / max(KINF, 1.0D-60);
    LGKNULL = log10( K0 );
    F=(LGKNULL+CCOEFF)/(NTMP-DCOEFF*(LGKNULL+CCOEFF));
    F = FC ^ (1.0 / ( F * F + 1.0 ));
    GETLINDRATECOEFF = KINF * F * K0 / ( 1.0 + K0 );
else
    K0 = K0 * CONC / KINF;
    KL = K0 / ( 1.0 + K0 );
    F = log10( K0 ) / NTMP;
    F = FC ^ ( 1.0 / ( F * F + 1.0 ) );
    GETLINDRATECOEFF = KINF * F * KL;
end

end
