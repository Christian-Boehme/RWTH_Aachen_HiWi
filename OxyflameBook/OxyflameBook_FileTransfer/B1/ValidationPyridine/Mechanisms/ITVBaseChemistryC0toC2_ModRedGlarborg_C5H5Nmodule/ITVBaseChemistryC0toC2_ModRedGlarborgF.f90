!----------------------------------------------------------
! ======= ITVBaseChemistryC0toC2_ModRedGlarborgF.f90 =======
!----------------------------------------------------------
subroutine PRODRATES( CDOT, W, K, C, M, TEMP, PRESSURE)
!----------------------------------------------------------
!     THIS SUBROUTINE COMPUTES RATES OF PRODUCTION CDOT
!     IN [KMOLE/(M^3S)]. THE PARAMETERS W ( REACTION RATE ),
!     K ( RATE COEFFICIENT ) AND M ( THIRD BODY CONCENTRATIONS ) ARE
!     JUST WORK SPACE FOR THIS FUNCTION.
!     C CONTAINS THE CONCENTRATIONS OF NON STEADY STATE SPECIES IN
!     [KMOLE/M^3] AND IS WORKSPACE FOR THE STEADY STATE 
!     CONCENTRATIONS, WHICH ARE COMPUTED IN THIS FUNCTION.
!     TEMP IS THE TEMPERATURE IN [K] AND
!     PRESSURE IS THE PRESSURE IN [PA].
!     CALLED FUNCTIONS ARE 'GETLINDRATECOEFF', 'COMPSTEADYSTATES',
!     'CTCHZERO'
!----------------------------------------------------------
      implicit none
      include 'ITVBaseChemistryC0toC2_ModRedGlarborgF90.h'
      real(DP) :: CDOT(111), W(1542), K(1542), &
      C(111), M(62), TEMP, PRESSURE
      integer ::  I
      real(DP) :: GETLINDRATECOEFF, LT, RT_inv
      real(DP), parameter ::  RGAS = 8314.46261815324, CONCDEFAULT = -1.0 

      real(DP) ::  KINFTROE, K0TROE
      real(DP) ::  FCTROE

      LT = DLOG( TEMP )
      RT_inv = 1.0_DP / (RGAS * TEMP) 


      M(MM1) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2.5 * C(SH2) + 12 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.9 * C(SCO) &
	    + 3.8 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM1) = M(MM1) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM1) = M(MM1) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM1) = M(MM1) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM2) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2.5 * C(SH2) + 12 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.9 * C(SCO) &
	    + 3.8 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM2) = M(MM2) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM2) = M(MM2) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM2) = M(MM2) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM3) = C(SN2) + 0.75 * C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2.5 * C(SH2) + 12 * C(SH2O) &
	    + 0.75 * C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.9 * C(SCO) &
	    + 3.8 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM3) = M(MM3) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM3) = M(MM3) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM3) = M(MM3) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM4) = 2 * C(SN2) + C(SAR) &
	    + C(SH) + 1.5 * C(SO2) &
	    + C(SO) + C(SOH) &
	    + 3 * C(SH2) + C(SH2O) &
	    + 1.1 * C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.9 * C(SCO) &
	    + 3.8 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM4) = M(MM4) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM4) = M(MM4) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM4) = M(MM4) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM5) = C(SN2) + 0.67 * C(SAR) &
	    + C(SH) + 0.78 * C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 14 * C(SH2O) &
	    + 0.8 * C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.9 * C(SCO) &
	    + 3.8 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM5) = M(MM5) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM5) = M(MM5) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM5) = M(MM5) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM6) = 1.5 * C(SN2) + C(SAR) &
	    + C(SH) + 1.2 * C(SO2) &
	    + C(SO) + C(SOH) &
	    + 3.7 * C(SH2) + 7.5 * C(SH2O) &
	    + 0.65 * C(SHE) + C(SHO2) &
	    + 7.7 * C(SH2O2) + 2.8 * C(SCO) &
	    + 1.6 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM6) = M(MM6) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM6) = M(MM6) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM6) = M(MM6) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM7) = C(SN2) + 0.7 * C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 12 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.75 * C(SCO) &
	    + 3.6 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM7) = M(MM7) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM7) = M(MM7) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM7) = M(MM7) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM8) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.75 * C(SCO) &
	    + 3.6 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + 2 * C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM8) = M(MM8) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + 3 * C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM8) = M(MM8) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM8) = M(MM8) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM9) = C(SN2) + 0.7 * C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 12 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.75 * C(SCO) &
	    + 3.6 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + 2 * C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM9) = M(MM9) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + 3 * C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM9) = M(MM9) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM9) = M(MM9) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM10) = C(SN2) + 0.7 * C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 12 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.75 * C(SCO) &
	    + 3.6 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + 2 * C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM10) = M(MM10) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + 3 * C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM10) = M(MM10) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM10) = M(MM10) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM11) = C(SN2) + 0.7 * C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 12 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.75 * C(SCO) &
	    + 3.6 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + 2 * C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM11) = M(MM11) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + 3 * C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM11) = M(MM11) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM11) = M(MM11) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM12) = C(SN2) + 0.7 * C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 12 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.75 * C(SCO) &
	    + 3.6 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + 2 * C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM12) = M(MM12) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + 3 * C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM12) = M(MM12) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM12) = M(MM12) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM13) = C(SN2) + 0.7 * C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 12 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.75 * C(SCO) &
	    + 3.6 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + 2 * C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM13) = M(MM13) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + 3 * C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM13) = M(MM13) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM13) = M(MM13) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM14) = C(SN2) + 0.7 * C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 12 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.75 * C(SCO) &
	    + 3.6 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + 2 * C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM14) = M(MM14) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + 3 * C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM14) = M(MM14) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM14) = M(MM14) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM15) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM15) = M(MM15) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM15) = M(MM15) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM15) = M(MM15) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM16) = C(SN2) + 0.85 * C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 6 * C(SH2O) &
	    + 0.67 * C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.5 * C(SCO) &
	    + 2 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + 2.5 * C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + 3 * C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + 2 * C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM16) = M(MM16) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + 3 * C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM16) = M(MM16) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM16) = M(MM16) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM17) = C(SN2) + 0.85 * C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 6 * C(SH2O) &
	    + 0.67 * C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.5 * C(SCO) &
	    + 2 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + 3 * C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + 2 * C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM17) = M(MM17) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + 3 * C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM17) = M(MM17) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM17) = M(MM17) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM18) = C(SN2) + 0.7 * C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 6 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.5 * C(SCO) &
	    + 2 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + 5 * C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM18) = M(MM18) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + 3 * C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM18) = M(MM18) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM18) = M(MM18) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM19) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM19) = M(MM19) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM19) = M(MM19) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM19) = M(MM19) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM20) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM20) = M(MM20) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM20) = M(MM20) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM20) = M(MM20) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM21) = C(SN2) + 0.7 * C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 12 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.75 * C(SCO) &
	    + 3.6 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + 2 * C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM21) = M(MM21) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + 3 * C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM21) = M(MM21) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM21) = M(MM21) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM22) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM22) = M(MM22) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM22) = M(MM22) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM22) = M(MM22) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM23) = C(SN2) + 0.7 * C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 6 * C(SH2O) &
	    + 0.7 * C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.5 * C(SCO) &
	    + 2 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + 2 * C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM23) = M(MM23) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + 3 * C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM23) = M(MM23) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM23) = M(MM23) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM24) = C(SN2) + 0.7 * C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 12 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.75 * C(SCO) &
	    + 3.6 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + 2 * C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM24) = M(MM24) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + 3 * C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM24) = M(MM24) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM24) = M(MM24) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM25) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM25) = M(MM25) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM25) = M(MM25) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM25) = M(MM25) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM26) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM26) = M(MM26) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM26) = M(MM26) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM26) = M(MM26) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM27) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM27) = M(MM27) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM27) = M(MM27) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM27) = M(MM27) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM28) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM28) = M(MM28) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM28) = M(MM28) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM28) = M(MM28) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM29) = C(SN2) + 0.7 * C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 6 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.75 * C(SCO) &
	    + 3.6 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + 2 * C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM29) = M(MM29) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + 3 * C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM29) = M(MM29) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM29) = M(MM29) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM30) = C(SN2) + 0.7 * C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 6 * C(SH2O) &
	    + 0.5 * C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.5 * C(SCO) &
	    + 2 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + 2 * C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM30) = M(MM30) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + 3 * C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM30) = M(MM30) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM30) = M(MM30) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM31) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + 5 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + 2 * C(SCO) &
	    + 3 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM31) = M(MM31) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM31) = M(MM31) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM31) = M(MM31) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM32) = C(SN2) + 0.7 * C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 6 * C(SH2O) &
	    + 0.7 * C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.5 * C(SCO) &
	    + 2 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + 2 * C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM32) = M(MM32) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + 3 * C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM32) = M(MM32) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM32) = M(MM32) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM33) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM33) = M(MM33) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM33) = M(MM33) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM33) = M(MM33) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM34) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 6 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + 1.5 * C(SCO) &
	    + 2 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + 2.5 * C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + 2 * C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM34) = M(MM34) + 2.5 * C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + 3 * C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM34) = M(MM34) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM34) = M(MM34) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM35) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM35) = M(MM35) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM35) = M(MM35) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM35) = M(MM35) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM36) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM36) = M(MM36) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM36) = M(MM36) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM36) = M(MM36) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM37) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM37) = M(MM37) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM37) = M(MM37) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM37) = M(MM37) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM38) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM38) = M(MM38) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM38) = M(MM38) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM38) = M(MM38) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM39) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM39) = M(MM39) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM39) = M(MM39) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM39) = M(MM39) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM40) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM40) = M(MM40) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM40) = M(MM40) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM40) = M(MM40) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM41) = 1.26 * C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 5 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + 2 * C(SCO) &
	    + 3 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM41) = M(MM41) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM41) = M(MM41) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM41) = M(MM41) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM42) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + 5 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM42) = M(MM42) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM42) = M(MM42) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM42) = M(MM42) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM43) = 1.26 * C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + 5 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM43) = M(MM43) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM43) = M(MM43) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM43) = M(MM43) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM44) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + 2 * C(SH2) + 5 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + 2 * C(SCO) &
	    + 3 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM44) = M(MM44) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM44) = M(MM44) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM44) = M(MM44) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM45) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM45) = M(MM45) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM45) = M(MM45) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM45) = M(MM45) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM46) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM46) = M(MM46) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM46) = M(MM46) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM46) = M(MM46) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM47) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + 16.25 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM47) = M(MM47) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM47) = M(MM47) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM47) = M(MM47) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM48) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM48) = M(MM48) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM48) = M(MM48) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM48) = M(MM48) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM49) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM49) = M(MM49) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM49) = M(MM49) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM49) = M(MM49) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM50) = 0.4 * C(SN2) + 0.35 * C(SAR) &
	    + C(SH) + 0.45 * C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + 6.4 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM50) = M(MM50) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM50) = M(MM50) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM50) = M(MM50) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM51) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM51) = M(MM51) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM51) = M(MM51) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM51) = M(MM51) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM52) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + 10 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM52) = M(MM52) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM52) = M(MM52) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM52) = M(MM52) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM53) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + 16.25 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM53) = M(MM53) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM53) = M(MM53) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM53) = M(MM53) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM54) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + 7 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM54) = M(MM54) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM54) = M(MM54) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM54) = M(MM54) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM55) = 2 * C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM55) = M(MM55) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM55) = M(MM55) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM55) = M(MM55) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM56) = 1.7 * C(SN2) + C(SAR) &
	    + C(SH) + 1.4 * C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + 12 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM56) = M(MM56) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM56) = M(MM56) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM56) = M(MM56) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM57) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + 7 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + 2 * C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM57) = M(MM57) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM57) = M(MM57) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM57) = M(MM57) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM58) = C(SN2) + C(SAR) &
	    + C(SH) + 1.5 * C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + 10 * C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM58) = M(MM58) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM58) = M(MM58) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM58) = M(MM58) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM59) = 1.5 * C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM59) = M(MM59) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM59) = M(MM59) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM59) = M(MM59) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM60) = 1.5 * C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM60) = M(MM60) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM60) = M(MM60) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM60) = M(MM60) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM61) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM61) = M(MM61) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM61) = M(MM61) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM61) = M(MM61) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)
      M(MM62) = C(SN2) + C(SAR) &
	    + C(SH) + C(SO2) &
	    + C(SO) + C(SOH) &
	    + C(SH2) + C(SH2O) &
	    + C(SHE) + C(SHO2) &
	    + C(SH2O2) + C(SCO) &
	    + C(SCO2) + C(SHCO) &
	    + C(SC) + C(SCH) &
	    + C(STXCH2) + C(SCH3) &
	    + C(SCH2O) + C(SHCCO) &
	    + C(SC2H) + C(SCH2CO) &
	    + C(SC2H2) + C(SSXCH2) &
	    + C(SCH3OH) + C(SCH2OH) &
	    + C(SCH3O) + C(SCH4) &
	    + C(SCH3O2) + C(SC2H3)
      M(MM62) = M(MM62) + C(SC2H4) + C(SC2H5) &
	    + C(SHCCOH) + C(SCH2CHO) &
	    + C(SCH3CHO) + C(SH2C2) &
	    + C(SC2H5O) + C(SC2H6) &
	    + C(SC2O) + C(SC2H5O2H) &
	    + C(SCH3CO3) + C(SCH2O2H) &
	    + C(SHCOH) + C(SCHCHO) &
	    + C(SCHOCHO) + C(SC2H2OH) &
	    + C(SHOCHO) + C(SC2H3OOH) &
	    + C(SC2H3OO) + C(SC2H3OH) &
	    + C(SHOCO) + C(SC2H4O1X2) &
	    + C(SCH2COOH) + C(SCH2CO2) &
	    + C(SCH3COH) + C(SSC2H2OH) &
	    + C(SHOCH2CO) + C(SC2H5OH) &
	    + C(SCH3CHOH) + C(SCH3O2H)
      M(MM62) = M(MM62) + C(SO2CHO) + C(SHO2CHO) &
	    + C(SOCHO) + C(SC2H3O1X2) &
	    + C(SCH3CO) + C(SC2H4O2H) &
	    + C(SC2H5O2) + C(SCH3CO2) &
	    + C(SPC2H4OH) + C(SO2CH2CHO) &
	    + C(SHO2CH2CO) + C(SN2H2) &
	    + C(SNNH) + C(SNH2) &
	    + C(SNH) + C(SHNO) &
	    + C(SHONO) + C(SN) &
	    + C(SH2NO) + C(SN2O) &
	    + C(SNH3) + C(SNO) &
	    + C(SNO2) + C(SN2H3) &
	    + C(SHCN) + C(SHNC) &
	    + C(SCN) + C(SHNCO) &
	    + C(SNCO) + C(SNCN)
      M(MM62) = M(MM62) + C(SCH3NH2) + C(SH2CN) &
	    + C(SC5H5N) + C(SC5H4N) &
	    + C(SC5H5NO) + C(SC5H4NO) &
	    + C(SC5H4NO2) + C(SPYRLYL) &
	    + C(SBNC4H4CO) + C(SC3H3ONCO) &
	    + C(SC4H4CN) + C(SCHCHCN) &
	    + C(SC4H5N) + C(SPYRLNE) &
	    + C(SCH2CHCN) + C(SC2N2) &
	    + C(SHNCN) + C(SHOCN) &
	    + C(SCH3CN) + C(SCH2CN) &
	    + C(SHCNO)


      K(R1F) = 1.0400000000D+11 * exp(-63957000.56 * RT_inv)
      K(R1B) = 2.0822458907D+08 &
	   * exp(0.435709 * LT + 6859777.046 * RT_inv)
      K(R2F) = 3.8180000000D+09 * exp(-33254001.05 * RT_inv)
      K(R2B) = 3.3863517970D+09 &
	   * exp(-0.0991215 * LT - 27465007.13 * RT_inv)
      K(R3F) = 8.7920000000D+11 * exp(-80206999.67 * RT_inv)
      K(R3B) = 7.7980107385D+11 &
	   * exp(-0.0991215 * LT - 74418005.76 * RT_inv)
      K(R4F) = 2.1600000000D+05 &
	   * exp(1.51 * LT - 14350998.66 * RT_inv)
      K(R4B) = 3.5156743657D+06 &
	   * exp(1.34328 * LT - 77696943.19 * RT_inv)
      K(R5F) = 3.3400000000D+01 &
	   * exp(2.42 * LT + 8074998.664 * RT_inv)
      K(R5B) = 6.1292199786D+02 &
	   * exp(2.35241 * LT - 61059939.78 * RT_inv)
      K(R6F) = 4.5770000000D+16 &
	   * exp(-1.4 * LT - 436725999.5 * RT_inv)
      K(R6B) = 2.8923359552D+14 &
	   * exp(-1.8132 * LT - 3924144.183 * RT_inv)
      K(R7F) = 5.8400000000D+15 &
	   * exp(-1.1 * LT - 436725999.5 * RT_inv)
      K(R7B) = 3.6904614329D+13 &
	   * exp(-1.5132 * LT - 3924144.183 * RT_inv)
      K(R8F) = 5.8400000000D+15 &
	   * exp(-1.1 * LT - 436725999.5 * RT_inv)
      K(R8B) = 3.6904614329D+13 &
	   * exp(-1.5132 * LT - 3924144.183 * RT_inv)
      K(R9F) = 6.1650000000D+09 * exp(-0.5 * LT)
      K(R9B) = 4.3217807634D+14 &
	   * exp(-0.621626 * LT - 497829639 * RT_inv)
      K(R10F) = 1.8860000000D+07 * exp(7481000.368 * RT_inv)
      K(R10B) = 1.3221214144D+12 &
	   * exp(-0.121626 * LT - 490348638.6 * RT_inv)
      K(R11F) = 1.8860000000D+07 * exp(7481000.368 * RT_inv)
      K(R11B) = 1.3221214144D+12 &
	   * exp(-0.121626 * LT - 490348638.6 * RT_inv)
      K(R12F) = 4.7140000000D+12 * exp(-1 * LT)
      K(R12B) = 6.6163413575D+14 &
	   * exp(-0.685917 * LT - 427012861.4 * RT_inv)
      K(R13F) = 6.0640000000D+24 &
	   * exp(-3.322 * LT - 505385000.2 * RT_inv)
      K(R13B) = 2.3543559603D+21 &
	   * exp(-3.56849 * LT - 9237200.336 * RT_inv)
      K(R14F) = 1.0060000000D+23 &
	   * exp(-2.44 * LT - 502832998.7 * RT_inv)
      K(R14B) = 3.9058082059D+19 &
	   * exp(-2.68649 * LT - 6685198.824 * RT_inv)
      K0TROE = 6.3660000000D+14 &
	   * exp(-1.72 * LT - 2196001.688 * RT_inv)
      KINFTROE = 4.6510000000D+09 * exp(0.44 * LT)
      FCTROE = 0.5 * EXP( -TEMP / 1e-30 ) &
	   + 0.5 * EXP( -TEMP / 1e+30 )
      K(R15F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM5) )
      K0TROE = 9.1407320625D+17 &
	   * exp(-1.7312 * LT - 207123584.4 * RT_inv)
      KINFTROE = 6.6782194192D+12 &
	   * exp(0.428803 * LT - 204927582.8 * RT_inv)
      K(R15B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM5) )
      K(R16F) = 2.7500000000D+03 &
	   * exp(2.09 * LT + 6071000.736 * RT_inv)
      K(R16B) = 3.0307528712D+02 &
	   * exp(2.5144 * LT - 221803271.8 * RT_inv)
      K(R17F) = 7.0790000000D+10 * exp(-1233999.672 * RT_inv)
      K(R17B) = 1.3854299364D+07 &
	   * exp(0.76099 * LT - 152502500.7 * RT_inv)
      K(R18F) = 2.8500000000D+07 &
	   * exp(1 * LT + 3028998.432 * RT_inv)
      K(R18B) = 2.7858571342D+06 &
	   * exp(1.32528 * LT - 219056280.2 * RT_inv)
      K(R19F) = 1.9300000000D+17 &
	   * exp(-2.49 * LT - 2443999.92 * RT_inv)
      K(R19B) = 3.4620236605D+17 &
	   * exp(-2.23231 * LT - 293664217 * RT_inv)
      K(R20F) = 1.2100000000D+06 &
	   * exp(1.24 * LT + 5470998.4 * RT_inv)
      K(R20B) = 2.1704915177D+06 &
	   * exp(1.49769 * LT - 285749218.7 * RT_inv)
      K(R21F) = 1.2140000000D+07 &
	   * exp(0.422 * LT + 6194001.968 * RT_inv)
      K(R21B) = 5.8654525998D+08 &
	   * exp(0.175831 * LT - 154888495.6 * RT_inv)
      K(R22F) = 1.6880000000D+13 &
	   * exp(-0.681 * LT - 54105998.5 * RT_inv)
      K(R22B) = 8.1555881290D+14 &
	   * exp(-0.927169 * LT - 215188496 * RT_inv)
      K0TROE = 2.4900000000D+21 &
	   * exp(-2.3 * LT - 203970000 * RT_inv)
      KINFTROE = 2.0000000000D+12 &
	   * exp(0.9 * LT - 203966000.1 * RT_inv)
      FCTROE = 0.57 * EXP( -TEMP / 1e-30 ) &
	   + 0.43 * EXP( -TEMP / 1e+30 )
      K(R23F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM6) )
      K0TROE = 7.0244902665D+12 &
	   * exp(-1.28164 * LT + 10771579.24 * RT_inv)
      KINFTROE = 5.6421608566D+03 &
	   * exp(1.91836 * LT + 10775579.15 * RT_inv)
      K(R23B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM6) )
      K(R24F) = 2.4100000000D+10 * exp(-16609998.84 * RT_inv)
      K(R24B) = 1.7511347959D+05 &
	   * exp(1.26484 * LT - 298016219.4 * RT_inv)
      K(R25F) = 4.8200000000D+10 * exp(-33263000.83 * RT_inv)
      K(R25B) = 1.0994665650D+08 &
	   * exp(0.670571 * LT - 100054775.9 * RT_inv)
      K(R26F) = 9.5500000000D+03 &
	   * exp(2 * LT - 16609998.84 * RT_inv)
      K(R26B) = 1.9321218405D+01 &
	   * exp(2.57145 * LT - 77612779.96 * RT_inv)
      K(R27F) = 1.7400000000D+09 * exp(-1331001.528 * RT_inv)
      K(R27B) = 6.4600983250D+07 &
	   * exp(0.503855 * LT - 131468721.1 * RT_inv)
      K(R28F) = 7.5900000000D+10 * exp(-30417997.98 * RT_inv)
      K(R28B) = 2.8179394418D+09 &
	   * exp(0.503855 * LT - 160555717.5 * RT_inv)
      K0TROE = 1.5500000000D+18 &
	   * exp(-2.79 * LT - 17540001.62 * RT_inv)
      KINFTROE = 1.8000000000D+07 * exp(-9979998.968 * RT_inv)
      FCTROE = 1 * EXP( -TEMP / 0 ) &
	   + 1 * EXP( -0 / TEMP )
      K(R29F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM7) )
      K0TROE = 1.1890192554D+27 &
	   * exp(-3.75335 * LT - 552251596.1 * RT_inv)
      KINFTROE = 1.3807965547D+16 &
	   * exp(-0.963346 * LT - 544691593.5 * RT_inv)
      K(R29B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM7) )
      K(R30F) = 8.7000000000D+02 &
	   * exp(1.73 * LT + 2866040 * RT_inv)
      K(R30B) = 4.7549736731D+09 &
	   * exp(0.452571 * LT - 104832693.1 * RT_inv)
      K(R31F) = 1.0500000000D+09 * exp(-199577000.8 * RT_inv)
      K(R31B) = 1.1489915574D+13 &
	   * exp(-0.84172 * LT - 236458956.3 * RT_inv)
      K(R32F) = 1.5700000000D+02 &
	   * exp(2.18 * LT - 75072001.58 * RT_inv)
      K(R32B) = 1.6793498191D+05 &
	   * exp(1.66356 * LT - 334039235.7 * RT_inv)
      K(R33F) = 1.2000000000D+11
      K(R33B) = 3.5794133587D+09 &
	   * exp(0.645916 * LT - 367022697.2 * RT_inv)
      K(R34F) = 3.0200000000D+10
      K(R34B) = 7.9897593932D+08 &
	   * exp(0.546795 * LT - 361233703.2 * RT_inv)
      K(R35F) = 3.0000000000D+10
      K(R35B) = 4.3378734379D+15 &
	   * exp(-0.730634 * LT - 468932436.3 * RT_inv)
      K(R36F) = 3.0110000000D+10
      K(R36B) = 1.4618279297D+10 &
	   * exp(0.4792 * LT - 430368641.7 * RT_inv)
      K(R37F) = 2.6500000000D+10
      K(R37B) = 2.1739887746D+12 &
	   * exp(0.0627383 * LT - 376235244.9 * RT_inv)
      K(R38F) = 2.7000000000D+10
      K(R38B) = 7.1547044629D+11 &
	   * exp(0.133493 * LT - 303836212.5 * RT_inv)
      K(R39F) = 4.7480000000D+08 &
	   * exp(0.659 * LT - 62232000.12 * RT_inv)
      K(R39B) = 8.9497137056D+04 &
	   * exp(0.891712 * LT + 3547158.033 * RT_inv)
      K(R40F) = 1.2000000000D+07 &
	   * exp(0.807 * LT + 3041998.12 * RT_inv)
      K(R40B) = 3.2478354900D+06 &
	   * exp(1.02851 * LT - 136106426.5 * RT_inv)
      K(R41F) = 5.0000000000D+10
      K(R41B) = 1.1467848129D+13 &
	   * exp(-0.253456 * LT - 648069592.4 * RT_inv)
      K(R42F) = 5.8000000000D+10 * exp(-2410000.736 * RT_inv)
      K(R42B) = 2.6634134985D+10 &
	   * exp(0.182253 * LT - 579662815.6 * RT_inv)
      K(R43F) = 1.6500000000D+11
      K(R43B) = 5.6878777267D+10 &
	   * exp(0.29739 * LT - 97097153.57 * RT_inv)
      K(R44F) = 5.7000000000D+10
      K(R44B) = 3.9971389093D+12 &
	   * exp(-0.0551873 * LT - 739377752.1 * RT_inv)
      K(R45F) = 3.0000000000D+10
      K(R45B) = 7.9518628732D+13 &
	   * exp(-0.601982 * LT - 378144048.8 * RT_inv)
      K(R46F) = 1.0800000000D+11 * exp(-13010001.56 * RT_inv)
      K(R46B) = 2.6011477171D+12 &
	   * exp(-0.355438 * LT - 1991376.818 * RT_inv)
      K0TROE = 4.8200000000D+19 &
	   * exp(-2.8 * LT - 2469999.296 * RT_inv)
      KINFTROE = 1.9700000000D+09 &
	   * exp(0.43 * LT + 1550000.456 * RT_inv)
      FCTROE = 0.422 * EXP( -TEMP / 122 ) &
	   + 0.578 * EXP( -TEMP / 2535 ) &
	   + 1 * EXP( -9365 / TEMP )
      K(R47F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM9) )
      K0TROE = 1.1401109951D+26 &
	   * exp(-3.31771 * LT - 455711875.4 * RT_inv)
      KINFTROE = 4.6597897519D+15 &
	   * exp(-0.0877057 * LT - 451691875.6 * RT_inv)
      K(R47B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM9) )
      K(R48F) = 5.7100000000D+09 * exp(3159999.472 * RT_inv)
      K(R48B) = 8.2608772898D+14 &
	   * exp(-0.947689 * LT - 248451620.2 * RT_inv)
      K(R49F) = 6.7100000000D+10
      K(R49B) = 3.5609741582D+11 &
	   * exp(-0.166273 * LT - 307327271.2 * RT_inv)
      K0TROE = 2.6900000000D+22 &
	   * exp(-3.74 * LT - 8099998.064 * RT_inv)
      KINFTROE = 5.0000000000D+10
      FCTROE = 0.4243 * EXP( -TEMP / 237 ) &
	   + 0.5757 * EXP( -TEMP / 1652 ) &
	   + 1 * EXP( -5069 / TEMP )
      K(R50F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM10) )
      K0TROE = 1.2129751204D+32 &
	   * exp(-5.18097 * LT - 320780344.7 * RT_inv)
      KINFTROE = 2.2546005956D+20 &
	   * exp(-1.44097 * LT - 312680346.6 * RT_inv)
      K(R50B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM10) )
      K(R51F) = 1.9000000000D+11 * exp(-66070000.06 * RT_inv)
      K(R51B) = 9.2145125176D+07 &
	   * exp(0.675447 * LT - 336515315.8 * RT_inv)
      K0TROE = 5.0700000000D+21 &
	   * exp(-3.42 * LT - 352919998.3 * RT_inv)
      KINFTROE = 4.3000000000D+04 &
	   * exp(1.5 * LT - 333049998.2 * RT_inv)
      FCTROE = 0.068 * EXP( -TEMP / 197 ) &
	   + 0.932 * EXP( -TEMP / 1540 ) &
	   + 1 * EXP( -10300 / TEMP )
      K(R52F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM11) )
      K0TROE = 2.3894990013D+28 &
	   * exp(-4.16514 * LT - 355512671.9 * RT_inv)
      KINFTROE = 2.0265967861D+11 &
	   * exp(0.754865 * LT - 335642671.8 * RT_inv)
      K(R52B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM11) )
      K0TROE = 2.4700000000D+18 &
	   * exp(-2.57 * LT - 1779999.12 * RT_inv)
      KINFTROE = 1.0900000000D+09 &
	   * exp(0.48 * LT + 1089998.944 * RT_inv)
      FCTROE = 0.2176 * EXP( -TEMP / 271 ) &
	   + 0.7824 * EXP( -TEMP / 2755 ) &
	   + 1 * EXP( -6570 / TEMP )
      K(R53F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM12) )
      K0TROE = 3.4723736809D+23 &
	   * exp(-2.66922 * LT - 371395369.8 * RT_inv)
      KINFTROE = 1.5323430414D+14 &
	   * exp(0.380781 * LT - 368525371.7 * RT_inv)
      K(R53B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM12) )
      K0TROE = 1.0400000000D+20 &
	   * exp(-2.76 * LT - 6689998.432 * RT_inv)
      KINFTROE = 6.0000000000D+11
      FCTROE = 0.438 * EXP( -TEMP / 91 ) &
	   + 0.562 * EXP( -TEMP / 5836 ) &
	   + 1 * EXP( -8552 / TEMP )
      K(R54F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM13) )
      K0TROE = 1.0213913473D+25 &
	   * exp(-2.92227 * LT - 470950499.3 * RT_inv)
      KINFTROE = 5.8926423881D+16 &
	   * exp(-0.162268 * LT - 464260500.8 * RT_inv)
      K(R54B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM13) )
      K(R55F) = 8.0000000000D+10
      K(R55B) = 7.8089475051D+12 &
	   * exp(-0.345666 * LT - 383373679.7 * RT_inv)
      K(R56F) = 2.0000000000D+10
      K(R56B) = 1.9553913470D+15 &
	   * exp(-0.758967 * LT - 325976189 * RT_inv)
      K(R57F) = 1.1300000000D+04 &
	   * exp(2 * LT - 12550000.05 * RT_inv)
      K(R57B) = 7.6364598733D+03 &
	   * exp(2.18872 * LT - 86914569.32 * RT_inv)
      K(R58F) = 5.0000000000D+02 &
	   * exp(2 * LT - 30250002.02 * RT_inv)
      K(R58B) = 3.1031063742D+05 &
	   * exp(1.42453 * LT - 61708647.53 * RT_inv)
      K(R59) = 5.8000000000D+09 * exp(-6279999.904 * RT_inv)
      K(R60F) = 2.4000000000D+09 * exp(-6279999.904 * RT_inv)
      K(R60B) = 4.6980064580D+11 &
	   * exp(-0.323258 * LT - 261439411.3 * RT_inv)
      K(R61) = 5.0000000000D+09 * exp(-6279999.904 * RT_inv)
      K(R62F) = 2.0000000000D+10
      K(R62B) = 3.8268932186D+11 &
	   * exp(0.0020222 * LT - 477244690 * RT_inv)
      K(R63F) = 5.0000000000D+10
      K(R63B) = 6.6957439540D+14 &
	   * exp(-0.96821 * LT - 325613372.5 * RT_inv)
      K0TROE = 2.6900000000D+27 &
	   * exp(-5.11 * LT - 29689998.72 * RT_inv)
      KINFTROE = 8.1000000000D+08 &
	   * exp(0.5 * LT - 18869998.99 * RT_inv)
      FCTROE = 0.4093 * EXP( -TEMP / 275 ) &
	   + 0.5907 * EXP( -TEMP / 1226 ) &
	   + 1 * EXP( -5185 / TEMP )
      K(R64F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM14) )
      K0TROE = 9.7204322635D+38 &
	   * exp(-6.85567 * LT - 364659920.6 * RT_inv)
      KINFTROE = 2.9269703098D+20 &
	   * exp(-1.24567 * LT - 353839920.9 * RT_inv)
      K(R64B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM14) )
      K(R65F) = 4.0000000000D+10
      K(R65B) = 6.0332612347D+17 &
	   * exp(-1.26027 * LT - 548434217.1 * RT_inv)
      K(R66F) = 1.6000000000D+12 * exp(-49970001.53 * RT_inv)
      K(R66B) = 1.0020072433D+18 &
	   * exp(-0.904829 * LT - 609422843.4 * RT_inv)
      K(R67) = 2.0000000000D+11 * exp(-45980001.06 * RT_inv)
      K(R68F) = 1.5000000000D+10 * exp(-2509998.336 * RT_inv)
      K(R68B) = 1.0936408744D+10 &
	   * exp(-0.0622863 * LT - 39813523.8 * RT_inv)
      K(R69F) = 9.0000000000D+09 * exp(-2509998.336 * RT_inv)
      K(R69B) = 6.5618452463D+09 &
	   * exp(-0.0622863 * LT - 39813523.8 * RT_inv)
      K(R70F) = 3.0000000000D+10
      K(R70B) = 9.0816229819D+08 &
	   * exp(0.293152 * LT - 48322150.21 * RT_inv)
      K(R71F) = 1.5000000000D+10
      K(R71B) = 3.1842551386D+10 &
	   * exp(0.237964 * LT - 787699902.3 * RT_inv)
      K(R72F) = 1.5000000000D+10
      K(R72B) = 1.0675230222D+12 &
	   * exp(-0.407952 * LT - 420677205.1 * RT_inv)
      K(R73F) = 3.0000000000D+10
      K(R73B) = 2.1384959025D+15 &
	   * exp(-0.821254 * LT - 363279714.4 * RT_inv)
      K(R74F) = 7.0000000000D+10
      K(R74B) = 3.1674383705D+13 &
	   * exp(-0.637759 * LT - 68762170.99 * RT_inv)
      K(R75F) = 2.8000000000D+10
      K(R75B) = 7.5204032591D+05 &
	   * exp(0.260469 * LT - 284081269.4 * RT_inv)
      K(R76F) = 1.2000000000D+10
      K(R76B) = 8.3014013421D+08 &
	   * exp(0.506957 * LT - 780229069.2 * RT_inv)
      K0TROE = 1.4300000000D+44 &
	   * exp(-8.227 * LT - 415961000 * RT_inv)
      KINFTROE = 3.1210000000D+18 &
	   * exp(-1.017 * LT - 383722999.6 * RT_inv)
      FCTROE = 0.0078 * EXP( -TEMP / 47310 ) &
	   + 0.9922 * EXP( -TEMP / 943 ) &
	   + 1 * EXP( -47110 / TEMP )
      K(R77F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM15) )
      K0TROE = 1.6501889753D+34 &
	   * exp(-6.91711 * LT - 20336651.8 * RT_inv)
      KINFTROE = 3.6015662881D+08 &
	   * exp(0.29289 * LT + 11901348.53 * RT_inv)
      K(R77B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM15) )
      K(R78F) = 3.0000000000D+10
      K(R78B) = 2.1872817488D+10 &
	   * exp(-0.0622863 * LT - 37303525.47 * RT_inv)
      K(R79) = 6.8200000000D+07 &
	   * exp(0.25 * LT + 3909998.208 * RT_inv)
      K(R80F) = 9.0000000000D+09
      K(R80B) = 6.5618452463D+09 &
	   * exp(-0.0622863 * LT - 37303525.47 * RT_inv)
      K(R81F) = 7.0000000000D+09
      K(R81B) = 5.1036574138D+09 &
	   * exp(-0.0622863 * LT - 37303525.47 * RT_inv)
      K(R82F) = 1.4000000000D+10
      K(R82B) = 1.8259393135D+08 &
	   * exp(0.456176 * LT - 255580981.3 * RT_inv)
      K0TROE = 3.5000000000D+18 &
	   * exp(-1.99 * LT - 100416000 * RT_inv)
      KINFTROE = 7.3700000000D+10 &
	   * exp(0.811 * LT - 165623999.8 * RT_inv)
      FCTROE = 0.156 * EXP( -TEMP / 900 ) &
	   + 0.844 * EXP( -TEMP / 1 ) &
	   + 1 * EXP( -3315 / TEMP )
      K(R83F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM16) )
      K0TROE = 3.4986145512D+14 &
	   * exp(-1.60863 * LT + 22353993.93 * RT_inv)
      KINFTROE = 7.3670826407D+06 &
	   * exp(1.19237 * LT - 42854005.9 * RT_inv)
      K(R83B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM16) )
      K0TROE = 6.0220000000D+13 &
	   * exp(-0.547 * LT - 75412001.78 * RT_inv)
      KINFTROE = 1.1300000000D+10 &
	   * exp(1.21 * LT - 100770999.8 * RT_inv)
      FCTROE = 0.659 * EXP( -TEMP / 28 ) &
	   + 0.341 * EXP( -TEMP / 1000 ) &
	   + 1 * EXP( -2339 / TEMP )
      K(R84F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM17) )
      K0TROE = 6.8057823082D+08 &
	   * exp(-0.224708 * LT + 18830127.08 * RT_inv)
      KINFTROE = 1.2770730668D+05 &
	   * exp(1.53229 * LT - 6528870.981 * RT_inv)
      K(R84B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM17) )
      K(R85F) = 5.7400000000D+04 &
	   * exp(1.9 * LT - 11470000.86 * RT_inv)
      K(R85B) = 6.4612205532D+01 &
	   * exp(2.41242 * LT - 74656485.49 * RT_inv)
      K(R86F) = 3.9000000000D+10 * exp(-14810000.2 * RT_inv)
      K(R86B) = 3.8937084533D+07 &
	   * exp(0.413302 * LT - 72207490.91 * RT_inv)
      K(R87F) = 3.4300000000D+06 &
	   * exp(1.18 * LT + 1870001.144 * RT_inv)
      K(R87B) = 6.2842244016D+04 &
	   * exp(1.52571 * LT - 124662428 * RT_inv)
      K(R88F) = 1.0000000000D+11 * exp(-167360000 * RT_inv)
      K(R88B) = 1.0213741029D+09 &
	   * exp(0.0880211 * LT - 2672212.072 * RT_inv)
      K(R89F) = 5.6000000000D+03 &
	   * exp(2 * LT - 50209999.95 * RT_inv)
      K(R89B) = 2.7634760930D+03 &
	   * exp(1.84185 * LT - 46604709.54 * RT_inv)
      K(R90F) = 9.4600000000D+10 * exp(2159998.368 * RT_inv)
      K(R90B) = 1.7468949980D+17 &
	   * exp(-1.35597 * LT - 319198625.2 * RT_inv)
      K0TROE = 3.4700000000D+32 &
	   * exp(-6.3 * LT - 21230000.93 * RT_inv)
      KINFTROE = 6.9200000000D+10 * exp(0.18 * LT)
      FCTROE = 0.217 * EXP( -TEMP / 74 ) &
	   + 0.783 * EXP( -TEMP / 2941 ) &
	   + 1 * EXP( -6964 / TEMP )
      K(R91F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM18) )
      K0TROE = 1.5102278181D+38 &
	   * exp(-6.46997 * LT - 463244403.9 * RT_inv)
      KINFTROE = 3.0117511531D+16 &
	   * exp(0.0100264 * LT - 442014403 * RT_inv)
      K(R91B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM18) )
      K(R92F) = 5.5400000000D+10 &
	   * exp(0.05 * LT + 568998.896 * RT_inv)
      K(R92B) = 7.7407483434D+12 &
	   * exp(-0.232617 * LT - 288159550.6 * RT_inv)
      K(R93F) = 8.3100000000D+09 &
	   * exp(0.05 * LT + 568998.896 * RT_inv)
      K(R93B) = 2.4636290336D+05 &
	   * exp(0.512518 * LT - 285566877.1 * RT_inv)
      K0TROE = 1.5000000000D+40 &
	   * exp(-6.995 * LT - 409999000.8 * RT_inv)
      KINFTROE = 2.0840000000D+18 &
	   * exp(-0.615 * LT - 387190000.1 * RT_inv)
      FCTROE = 0.2344 * EXP( -TEMP / 59.51 ) &
	   + 0.7656 * EXP( -TEMP / 1910 ) &
	   + 1 * EXP( -9374 / TEMP )
      K(R94F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM19) )
      K0TROE = 4.8122052789D+31 &
	   * exp(-6.15615 * LT - 19790879.09 * RT_inv)
      KINFTROE = 6.6857572008D+09 &
	   * exp(0.223847 * LT + 3018121.599 * RT_inv)
      K(R94B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM19) )
      K(R95F) = 4.2930000000D+01 &
	   * exp(2.568 * LT - 16727000.22 * RT_inv)
      K(R95B) = 1.1258722646D+00 &
	   * exp(2.97676 * LT - 48614299.23 * RT_inv)
      K(R96F) = 1.6500000000D+04 &
	   * exp(0.973 * LT + 8409840 * RT_inv)
      K(R96B) = 2.5993273623D+06 &
	   * exp(0.789505 * LT - 286107703.4 * RT_inv)
      K(R97F) = 5.2820000000D+14 &
	   * exp(-1.518 * LT - 7414048 * RT_inv)
      K(R97B) = 1.8999542987D+13 &
	   * exp(-1.04696 * LT - 1997821.541 * RT_inv)
      K(R98F) = 1.5570000000D+08 &
	   * exp(0.156 * LT + 5723712 * RT_inv)
      K(R98B) = 1.2034732765D+17 &
	   * exp(-2.50753 * LT - 89718222.73 * RT_inv)
      K(R99) = 5.0000000000D+09
      K(R100F) = 3.0000000000D+10
      K(R100B) = 3.2431147221D+04 &
	   * exp(2.53081 * LT - 723723696.6 * RT_inv)
      K(R101) = 5.0000000000D+10
      K(R102) = 3.0000000000D+10
      K(R103F) = 2.0000000000D+11
      K(R103B) = 4.0762347913D+04 &
	   * exp(2.48003 * LT - 199075608.7 * RT_inv)
      K(R104F) = 2.0000000000D+10
      K(R104B) = 7.4682140355D+01 &
	   * exp(2.82574 * LT - 325608037.9 * RT_inv)
      K(R105F) = 7.5460000000D+09 * exp(-118491001.3 * RT_inv)
      K(R105B) = 1.3308313754D+12 &
	   * exp(-0.483283 * LT - 3632040.722 * RT_inv)
      K(R106F) = 2.6410000000D-03 &
	   * exp(3.283 * LT - 33911002.02 * RT_inv)
      K(R106B) = 7.3882274912D-04 &
	   * exp(3.43609 * LT - 251822773.9 * RT_inv)
      K0TROE = 6.8500000000D+18 * exp(-3 * LT)
      KINFTROE = 7.8120000000D+06 * exp(0.9 * LT)
      FCTROE = 0.4 * EXP( -TEMP / 1000 ) &
	   + 0.6 * EXP( -TEMP / 70 ) &
	   + 1 * EXP( -1700 / TEMP )
      K(R107F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM20) )
      K0TROE = 2.5238954097D+29 &
	   * exp(-4.74941 * LT - 143802879.4 * RT_inv)
      KINFTROE = 2.8783461227D+17 &
	   * exp(-0.849414 * LT - 143802879.4 * RT_inv)
      K(R107B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM20) )
      K(R108F) = 1.0700000000D+09 &
	   * exp(0.273 * LT + 2900001.528 * RT_inv)
      K(R108B) = 1.8446075798D+10 &
	   * exp(0.114998 * LT - 104326316.5 * RT_inv)
      K(R109F) = 1.2000000000D+02 &
	   * exp(2.227 * LT + 12640002.07 * RT_inv)
      K(R109B) = 3.6373064462D+04 &
	   * exp(2.06822 * LT - 224446818.2 * RT_inv)
      K(R110F) = 2.4500000000D+01 &
	   * exp(2.47 * LT - 21669998.74 * RT_inv)
      K(R110B) = 1.5370283848D+02 &
	   * exp(2.55739 * LT - 97674321.48 * RT_inv)
      K(R111F) = 5.0000000000D+10
      K(R111B) = 3.5250816166D+15 &
	   * exp(-0.982184 * LT - 419878418 * RT_inv)
      K(R112F) = 3.0000000000D+10
      K(R112B) = 2.1184439169D+15 &
	   * exp(-1.06237 * LT - 233487279.5 * RT_inv)
      K(R113F) = 3.3200000000D+00 &
	   * exp(2.81 * LT - 24520001.46 * RT_inv)
      K(R113B) = 1.0278306684D+01 &
	   * exp(2.73924 * LT - 96919033.8 * RT_inv)
      K(R114F) = 2.0000000000D+10
      K(R114B) = 9.2036838042D+16 &
	   * exp(-1.12765 * LT - 276655320.2 * RT_inv)
      K(R115F) = 2.0000000000D+10
      K(R115B) = 6.7103498688D+16 &
	   * exp(-1.18993 * LT - 313958845.7 * RT_inv)
      K(R116F) = 3.1000000000D+11 &
	   * exp(-0.362 * LT - 55950498.16 * RT_inv)
      K(R116B) = 5.2550236869D+16 &
	   * exp(-1.5522 * LT - 18793308.29 * RT_inv)
      K(R117F) = 3.6000000000D+10
      K(R117B) = 1.2079740366D+07 &
	   * exp(1.14451 * LT - 239167799 * RT_inv)
      K(R118F) = 9.6000000000D+10
      K(R118B) = 6.4494845479D+04 &
	   * exp(1.58021 * LT - 168351021.4 * RT_inv)
      K(R119F) = 6.0000000000D+10
      K(R119B) = 5.0759528814D+08 &
	   * exp(0.910567 * LT - 246405242.3 * RT_inv)
      K(R120F) = 4.9400000000D+08 * exp(6569001.336 * RT_inv)
      K(R120B) = 1.8654683478D+10 &
	   * exp(-0.233708 * LT - 147104369 * RT_inv)
      K(R121F) = 2.4100000000D+09 * exp(-41571998.06 * RT_inv)
      K(R121B) = 1.8836279908D+09 &
	   * exp(0.0124616 * LT - 34162870.89 * RT_inv)
      K(R122F) = 5.0800000000D+09 * exp(5904000.56 * RT_inv)
      K(R122B) = 3.0062496402D+08 &
	   * exp(0.661222 * LT - 118404837.9 * RT_inv)
      K(R123) = 3.1100000000D+11 &
	   * exp(-1.61 * LT + 4396999.072 * RT_inv)
      K(R124) = 1.4000000000D+13 &
	   * exp(-1.61 * LT - 7782001.512 * RT_inv)
      K(R125F) = 1.5000000000D+11 * exp(-108910001.2 * RT_inv)
      K(R125B) = 5.1396596790D+13 &
	   * exp(-0.65811 * LT - 34709098.95 * RT_inv)
      K(R126F) = 3.0000000000D+14 * exp(-6276000 * RT_inv)
      K(R126B) = 4.1780664964D+03 &
	   * exp(2.21145 * LT - 137921595.2 * RT_inv)
      K0TROE = 4.6600000000D+35 &
	   * exp(-7.44 * LT - 58910000.35 * RT_inv)
      KINFTROE = 2.4300000000D+09 &
	   * exp(0.52 * LT - 209999.144 * RT_inv)
      FCTROE = 0.3 * EXP( -TEMP / 100 ) &
	   + 0.7 * EXP( -TEMP / 90000 ) &
	   + 1 * EXP( -10000 / TEMP )
      K(R127F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM21) )
      K0TROE = 1.6490182978D+39 &
	   * exp(-7.35986 * LT - 493160305.1 * RT_inv)
      KINFTROE = 8.5989580764D+12 &
	   * exp(0.600144 * LT - 434460303.9 * RT_inv)
      K(R127B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM21) )
      K(R128F) = 4.1500000000D+04 &
	   * exp(1.63 * LT - 8049999.264 * RT_inv)
      K(R128B) = 4.6919928896D+03 &
	   * exp(1.57093 * LT - 36577864.32 * RT_inv)
      K(R129F) = 2.0000000000D+10
      K(R129B) = 3.5768396739D+07 &
	   * exp(0.735497 * LT - 338559726.4 * RT_inv)
      K(R130F) = 1.2300000000D+06 &
	   * exp(1.011 * LT - 49998800 * RT_inv)
      K(R130B) = 1.0834594637D+11 &
	   * exp(0.0920081 * LT - 5956616.992 * RT_inv)
      K(R131F) = 2.6200000000D+11 &
	   * exp(-0.23 * LT - 4480001.264 * RT_inv)
      K(R131B) = 1.0698884353D+05 &
	   * exp(1.16003 * LT - 43105957.81 * RT_inv)
      K(R132F) = 1.0000000000D+10
      K(R132B) = 1.5862280588D+07 &
	   * exp(0.636375 * LT - 332770732.5 * RT_inv)
      K(R133F) = 3.6190000000D-01 &
	   * exp(2.498 * LT - 7904998.56 * RT_inv)
      K(R133B) = 1.0534476355D-02 &
	   * exp(3.06678 * LT - 409810669.5 * RT_inv)
      K(R134F) = 2.1700000000D+07 * exp(-7317000.12 * RT_inv)
      K(R134B) = 3.5213677361D+05 &
	   * exp(0.311095 * LT - 118002454 * RT_inv)
      K0TROE = 3.3900000000D+39 &
	   * exp(-7.244 * LT - 440284002 * RT_inv)
      KINFTROE = 7.8960000000D-03 &
	   * exp(5.038 * LT - 353411999.1 * RT_inv)
      FCTROE = 0.3157 * EXP( -TEMP / 41490 ) &
	   + 0.6843 * EXP( -TEMP / 37050 ) &
	   + 1 * EXP( -3980 / TEMP )
      K(R135F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM22) )
      K0TROE = 1.0831020774D+35 &
	   * exp(-7.38322 * LT - 34561562.32 * RT_inv)
      KINFTROE = 2.5227651928D-07 &
	   * exp(4.89878 * LT + 52310440.57 * RT_inv)
      K(R135B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM22) )
      K(R136F) = 2.0000000000D+10
      K(R136B) = 3.1636630736D+08 &
	   * exp(0.794571 * LT - 310031861.4 * RT_inv)
      K(R137F) = 3.0460000000D+07 &
	   * exp(0.833 * LT - 14936900.92 * RT_inv)
      K(R137B) = 3.0335188888D+11 &
	   * exp(-0.145066 * LT + 577417.0292 * RT_inv)
      K(R138F) = 3.2800000000D+10 &
	   * exp(-0.09 * LT - 2550001.56 * RT_inv)
      K(R138B) = 1.1846820193D+05 &
	   * exp(1.35911 * LT - 12648093.05 * RT_inv)
      K(R139F) = 1.0000000000D+10
      K(R139B) = 1.4029958269D+08 &
	   * exp(0.69545 * LT - 304242867.5 * RT_inv)
      K(R140F) = 5.0000000000D+09
      K(R140B) = 1.2873158761D+09 &
	   * exp(0.627855 * LT - 373377805.9 * RT_inv)
      K(R141F) = 1.8000000000D+10 * exp(-3770001.568 * RT_inv)
      K(R141B) = 2.5835382956D+09 &
	   * exp(0.370169 * LT - 85927590.4 * RT_inv)
      K(R142F) = 6.6000000000D+05 &
	   * exp(1.62 * LT - 45359999.2 * RT_inv)
      K(R142B) = 2.3997340884D+02 &
	   * exp(2.20318 * LT - 36147451.5 * RT_inv)
      K(R143F) = 1.0200000000D+06 &
	   * exp(1.5 * LT - 35979998.38 * RT_inv)
      K(R143B) = 3.2893910502D+02 &
	   * exp(1.98406 * LT - 20978456.76 * RT_inv)
      K(R144F) = 1.0000000000D+05 &
	   * exp(1.6 * LT - 13050000.6 * RT_inv)
      K(R144B) = 5.9179879483D+02 &
	   * exp(2.01646 * LT - 67183397.42 * RT_inv)
      K(R145F) = 6.0000000000D+10
      K(R145B) = 2.4179281447D+15 &
	   * exp(-0.899908 * LT - 256424147.7 * RT_inv)
      K(R146F) = 2.4600000000D+03 &
	   * exp(2 * LT - 34599998.03 * RT_inv)
      K(R146B) = 5.5511242907D+02 &
	   * exp(2.00771 * LT - 56846095.85 * RT_inv)
      K(R147F) = 1.6000000000D+10 * exp(2390001.216 * RT_inv)
      K(R147B) = 2.6323843569D+09 &
	   * exp(-0.0545804 * LT - 57159622.07 * RT_inv)
      K(R148F) = 1.7000000000D+04 &
	   * exp(2.1 * LT - 20380000.41 * RT_inv)
      K(R148B) = 8.5950971136D+01 &
	   * exp(2.37399 * LT - 47459416.07 * RT_inv)
      K(R149F) = 4.2000000000D+03 &
	   * exp(2.1 * LT - 20380000.41 * RT_inv)
      K(R149B) = 1.8782003124D+02 &
	   * exp(2.43306 * LT - 18931551.01 * RT_inv)
      K(R150F) = 3.8800000000D+02 &
	   * exp(2.5 * LT - 12969998.34 * RT_inv)
      K(R150B) = 1.7399218488D+00 &
	   * exp(2.67486 * LT - 34260420.08 * RT_inv)
      K(R151F) = 1.3000000000D+02 &
	   * exp(2.5 * LT - 20920000 * RT_inv)
      K(R151B) = 5.1562280825D+00 &
	   * exp(2.73394 * LT - 13682556.69 * RT_inv)
      K(R152F) = 1.4400000000D+03 &
	   * exp(2 * LT + 3519999.2 * RT_inv)
      K(R152B) = 1.1850024546D+02 &
	   * exp(2.10727 * LT - 86905360.99 * RT_inv)
      K(R153F) = 6.3000000000D+03 &
	   * exp(2 * LT - 6279999.904 * RT_inv)
      K(R153B) = 4.5855143694D+03 &
	   * exp(2.16634 * LT - 68177495.03 * RT_inv)
      K(R154F) = 3.0000000000D+04 &
	   * exp(1.5 * LT - 41590001.82 * RT_inv)
      K(R154B) = 4.1716122698D+05 &
	   * exp(1.19081 * LT - 77881965.18 * RT_inv)
      K(R155F) = 1.0000000000D+04 &
	   * exp(1.5 * LT - 41590001.82 * RT_inv)
      K(R155B) = 1.2299102838D+06 &
	   * exp(1.24988 * LT - 49354100.12 * RT_inv)
      K0TROE = 3.7500000000D+27 &
	   * exp(-4.8 * LT - 7950001.664 * RT_inv)
      KINFTROE = 2.2500000000D+10 * exp(0.32 * LT)
      FCTROE = 0.354 * EXP( -TEMP / 132 ) &
	   + 0.646 * EXP( -TEMP / 1315 ) &
	   + 1 * EXP( -5566 / TEMP )
      K(R156F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM23) )
      K0TROE = 1.9389224613D+33 &
	   * exp(-4.97624 * LT - 566475548 * RT_inv)
      KINFTROE = 1.1633534768D+16 &
	   * exp(0.143758 * LT - 558525546.3 * RT_inv)
      K(R156B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM23) )
      K(R157F) = 5.0000000000D+10
      K(R157B) = 3.1536100302D+07 &
	   * exp(0.971071 * LT - 327685850.7 * RT_inv)
      K(R158F) = 2.0000000000D+10
      K(R158B) = 4.0526515751D+14 &
	   * exp(-0.783978 * LT - 213353335.9 * RT_inv)
      K(R159F) = 3.0000000000D+10 * exp(3159999.472 * RT_inv)
      K(R159B) = 1.0041660646D+08 &
	   * exp(0.804798 * LT - 631853122.5 * RT_inv)
      K(R160F) = 3.6000000000D+09
      K(R160B) = 1.4957171060D+09 &
	   * exp(0.0327032 * LT - 136839914.2 * RT_inv)
      K(R161F) = 9.9700000000D+06 &
	   * exp(1.1 * LT - 2414000.64 * RT_inv)
      K(R161B) = 1.1844352977D+07 &
	   * exp(1.09373 * LT - 118925144 * RT_inv)
      K(R162F) = 1.0100000000D+07 &
	   * exp(1.64 * LT - 126783999 * RT_inv)
      K(R162B) = 3.0911805765D+03 &
	   * exp(2.22945 * LT - 1060307.934 * RT_inv)
      K(R163F) = 9.9700000000D+06 &
	   * exp(1.1 * LT - 2414000.64 * RT_inv)
      K(R163B) = 7.4306558067D+07 &
	   * exp(1.18113 * LT - 194929466.7 * RT_inv)
      K(R164F) = 1.0000000000D+11
      K(R164B) = 1.1592853542D+05 &
	   * exp(1.56102 * LT - 71799358.49 * RT_inv)
      K(R165F) = 1.0000000000D+11
      K(R165B) = 1.5551589084D+03 &
	   * exp(1.38578 * LT - 426697405.5 * RT_inv)
      K(R166F) = 4.2000000000D+07 * exp(-3569998 * RT_inv)
      K(R166B) = 1.3077440034D-03 &
	   * exp(1.82149 * LT - 359450625.9 * RT_inv)
      K(R167F) = 5.0000000000D+10
      K(R167B) = 6.3743508963D+11 &
	   * exp(0.238466 * LT - 657537101.1 * RT_inv)
      K(R168F) = 3.0000000000D+10
      K(R168B) = 4.6139851578D+10 &
	   * exp(0.216324 * LT - 385067433.7 * RT_inv)
      K(R169F) = 1.0000000000D+10
      K(R169B) = 2.8272639105D+01 &
	   * exp(1.67943 * LT - 344856754.5 * RT_inv)
      K0TROE = 6.3400000000D+25 &
	   * exp(-4.66 * LT - 15820001.06 * RT_inv)
      KINFTROE = 1.7090000000D+07 &
	   * exp(1.27 * LT - 11330000.04 * RT_inv)
      FCTROE = 0.7878 * EXP( -TEMP / 1 ) &
	   + 0.2122 * EXP( -TEMP / -10210 )
      K(R170F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM24) )
      K0TROE = 2.9150880050D+28 &
	   * exp(-4.62438 * LT - 165133564.3 * RT_inv)
      KINFTROE = 7.8578634079D+09 &
	   * exp(1.30562 * LT - 160643563.3 * RT_inv)
      K(R170B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM24) )
      K(R171F) = 7.3950000000D+05 &
	   * exp(1.28 * LT - 10342998.62 * RT_inv)
      K(R171B) = 3.4381152042D+00 &
	   * exp(2.48508 * LT - 201286533.6 * RT_inv)
      K(R172F) = 2.9580000000D+06 &
	   * exp(1.28 * LT - 10342998.62 * RT_inv)
      K(R172B) = 1.6270713300D+07 &
	   * exp(0.986346 * LT - 92183649.64 * RT_inv)
      K(R173F) = 1.0000000000D+11
      K(R173B) = 2.4515308022D+11 &
	   * exp(0.258626 * LT - 304848941.6 * RT_inv)
      K(R174) = 4.8000000000D+00 &
	   * exp(2.882 * LT + 6785000.336 * RT_inv)
      K(R175F) = 1.2000000000D+03 &
	   * exp(2.42 * LT - 6722001.848 * RT_inv)
      K(R175B) = 2.6480985896D+07 &
	   * exp(1.58203 * LT - 230083202.3 * RT_inv)
      K(R176F) = 8.0000000000D+55 &
	   * exp(-12.6 * LT - 320966999.5 * RT_inv)
      K(R176B) = 4.8144148153D+42 &
	   * exp(-10.081 * LT - 322644230.2 * RT_inv)
      K(R177) = 6.1000000000D+57 &
	   * exp(-13.1 * LT - 335335002 * RT_inv)
      K(R178F) = 1.9000000000D+57 &
	   * exp(-12.8 * LT - 352799001.2 * RT_inv)
      K(R178B) = 4.3149839610D+42 &
	   * exp(-10.4145 * LT - 50640019.39 * RT_inv)
      K(R179) = 6.1330000000D+01 &
	   * exp(2.65 * LT + 19188999.7 * RT_inv)
      K(R180) = 5.9400000000D+09 * exp(-7816000.696 * RT_inv)
      K(R181) = 1.7000000000D+10 * exp(-68157000.18 * RT_inv)
      K(R182) = 3.3000000000D-07 &
	   * exp(3.995 * LT - 1254999.168 * RT_inv)
      K(R183) = 3.0100000000D+10 * exp(-163804001.7 * RT_inv)
      K(R184F) = 5.4000000000D+10 * exp(-17990999.17 * RT_inv)
      K(R184B) = 1.7240459917D+01 &
	   * exp(2.28629 * LT - 85447388 * RT_inv)
      K(R185F) = 1.1000000000D+31 &
	   * exp(-6.153 * LT - 214985999.2 * RT_inv)
      K(R185B) = 2.8193962192D+27 &
	   * exp(-6.06821 * LT - 50601681.77 * RT_inv)
      K(R186F) = 5.0000000000D+10
      K(R186B) = 3.8111370769D+10 &
	   * exp(0.0784137 * LT - 115092699.6 * RT_inv)
      K(R187F) = 2.4090000000D+10
      K(R187B) = 9.7708512990D+08 &
	   * exp(0.497993 * LT - 268417537.9 * RT_inv)
      K(R188F) = 3.0110000000D+10
      K(R188B) = 1.9877476587D+10 &
	   * exp(0.331277 * LT - 331763482.4 * RT_inv)
      K(R189F) = 5.0000000000D+10
      K(R189B) = 3.0080837985D+14 &
	   * exp(-0.722429 * LT - 377748942.1 * RT_inv)
      K(R190F) = 1.8000000000D+09 * exp(781997.968 * RT_inv)
      K(R190B) = 2.1681588905D+10 &
	   * exp(-0.28672 * LT - 306150166.5 * RT_inv)
      K(R191F) = 1.2780000000D+19 &
	   * exp(-2.871 * LT - 34522999.88 * RT_inv)
      K(R191B) = 1.4054430162D+14 &
	   * exp(-1.29595 * LT - 500183092.7 * RT_inv)
      K(R192F) = 5.8950000000D+12 &
	   * exp(-1.195 * LT - 4981001.792 * RT_inv)
      K(R192B) = 6.4828533496D+07 &
	   * exp(0.380047 * LT - 470641094.6 * RT_inv)
      K(R193) = 1.4350000000D+19 &
	   * exp(-2.528 * LT - 85124998.79 * RT_inv)
      K(R194F) = 5.4000000000D+00 &
	   * exp(2.81 * LT - 24518001.51 * RT_inv)
      K(R194B) = 3.9050920994D+00 &
	   * exp(2.71019 * LT - 128521822.2 * RT_inv)
      K(R195F) = 9.0330000000D+10
      K(R195B) = 1.7310015883D+12 &
	   * exp(0.0336848 * LT - 407840033.3 * RT_inv)
      K(R196F) = 2.0500000000D+10
      K(R196B) = 2.2868110376D+12 &
	   * exp(-0.0851856 * LT - 277630085.6 * RT_inv)
      K0TROE = 4.1000000000D+12 * exp(-221668002 * RT_inv)
      KINFTROE = 7.5000000000D+14 * exp(-287482999.8 * RT_inv)
      FCTROE = 1 * EXP( -TEMP / 0 ) &
	   + 1 * EXP( -0 / TEMP )
      K(R197F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM25) )
      K0TROE = 4.9514358170D+03 &
	   * exp(1.00295 * LT - 191149733.5 * RT_inv)
      KINFTROE = 9.0575045432D+05 &
	   * exp(1.00295 * LT - 256964731.3 * RT_inv)
      K(R197B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM25) )
      K0TROE = 1.7000000000D+12 * exp(-213844001.5 * RT_inv)
      KINFTROE = 4.5000000000D+13 * exp(-285516001 * RT_inv)
      FCTROE = 1 * EXP( -TEMP / 0 ) &
	   + 1 * EXP( -0 / TEMP )
      K(R198F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM26) )
      K0TROE = 6.8939827348D+08 &
	   * exp(-0.107767 * LT - 227678521.6 * RT_inv)
      KINFTROE = 1.8248777827D+10 &
	   * exp(-0.107767 * LT - 299350521.1 * RT_inv)
      K(R198B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM26) )
      K(R199F) = 4.0000000000D+08
      K(R199B) = 1.4006921653D+08 &
	   * exp(0.701575 * LT - 208599742.9 * RT_inv)
      K(R200F) = 3.0000000000D+10 * exp(-263592000 * RT_inv)
      K(R200B) = 1.7653794850D+12 &
	   * exp(-1.20363 * LT - 5499734.077 * RT_inv)
      K(R201F) = 2.3000000000D-01 &
	   * exp(3.272 * LT - 20326001.7 * RT_inv)
      K(R201B) = 7.2387396892D-02 &
	   * exp(2.99483 * LT - 39600531.39 * RT_inv)
      K(R202F) = 4.2000000000D+02 &
	   * exp(2.255 * LT - 58956999.22 * RT_inv)
      K(R202B) = 2.7238547346D+03 &
	   * exp(1.47578 * LT - 28739005.86 * RT_inv)
      K(R203F) = 5.1000000000D-02 &
	   * exp(3.422 * LT - 17639999.22 * RT_inv)
      K(R203B) = 1.4236441534D-02 &
	   * exp(3.04571 * LT - 31125535 * RT_inv)
      K(R204F) = 1.7000000000D+02 &
	   * exp(2.103 * LT - 41337999.5 * RT_inv)
      K(R204B) = 9.7786684863D+02 &
	   * exp(1.22465 * LT - 5331012.213 * RT_inv)
      K(R205F) = 7.8000000000D-09 &
	   * exp(5.57 * LT + 9895001.008 * RT_inv)
      K(R205B) = 3.9956240380D-08 &
	   * exp(5.12611 * LT - 72725473.21 * RT_inv)
      K(R206F) = 9.8000000000D-08 &
	   * exp(4.91 * LT + 21200001.65 * RT_inv)
      K(R206B) = 1.0344645658D-05 &
	   * exp(3.96406 * LT - 11927949.51 * RT_inv)
      K(R207) = 3.9000000000D-10 &
	   * exp(5.8 * LT - 9205000.832 * RT_inv)
      K(R208F) = 4.7000000000D-04 &
	   * exp(3.975 * LT - 70237000.46 * RT_inv)
      K(R208B) = 6.4848209969D-02 &
	   * exp(3.02726 * LT - 22719755.12 * RT_inv)
      K(R209F) = 3.9000000000D-02 &
	   * exp(3.08 * LT - 105462000.2 * RT_inv)
      K(R209B) = 1.1088282205D+02 &
	   * exp(1.6302 * LT - 8452231.829 * RT_inv)
      K(R210F) = 2.6000000000D+17 &
	   * exp(-3.5 * LT - 5476860.184 * RT_inv)
      K(R210B) = 1.1028490295D+27 &
	   * exp(-4.94684 * LT - 118615602.9 * RT_inv)
      K(R211F) = 1.0690000000D+36 &
	   * exp(-8.107 * LT - 121604001.9 * RT_inv)
      K(R211B) = 1.3774119673D+33 &
	   * exp(-7.93759 * LT - 116163992.4 * RT_inv)
      K(R212F) = 3.6000000000D+01 &
	   * exp(2.5 * LT - 119913000.7 * RT_inv)
      K(R212B) = 4.3078511249D+02 &
	   * exp(2.07152 * LT - 18310164.13 * RT_inv)
      K(R213F) = 3.1000000000D+14 &
	   * exp(-1.347 * LT - 2321998.664 * RT_inv)
      K(R213B) = 6.3209159659D+13 &
	   * exp(-0.76439 * LT - 429683844.4 * RT_inv)
      K(R214F) = 6.0000000000D+12 &
	   * exp(-0.525 * LT - 8891000 * RT_inv)
      K(R214B) = 3.6433055909D+06 &
	   * exp(1.16832 * LT - 391900057.2 * RT_inv)
      K(R215F) = 8.6700000000D+09
      K(R215B) = 1.5679549111D+09 &
	   * exp(0.483489 * LT - 421572851.8 * RT_inv)
      K(R216F) = 4.5600000000D+09 * exp(371999.44 * RT_inv)
      K(R216B) = 1.5133453848D+10 &
	   * exp(0.415894 * LT - 490335790.8 * RT_inv)
      K(R217F) = 9.5400000000D+03 &
	   * exp(2 * LT + 371999.44 * RT_inv)
      K(R217B) = 3.1660778444D+04 &
	   * exp(2.41589 * LT - 490335790.8 * RT_inv)
      K(R218F) = 3.9300000000D+10
      K(R218B) = 3.5129816758D+12 &
	   * exp(-0.087961 * LT - 360570070.7 * RT_inv)
      K(R219F) = 4.0000000000D+06 * exp(1 * LT)
      K(R219B) = 7.4004901113D+06 &
	   * exp(1.15821 * LT - 199487573.2 * RT_inv)
      K(R220F) = 1.3600000000D+10
      K(R220B) = 7.6267242764D+12 &
	   * exp(-0.000567869 * LT - 436574393.4 * RT_inv)
      K(R221F) = 2.1300000000D+10
      K(R221B) = 4.7588105578D+10 &
	   * exp(0.109924 * LT - 253718478.2 * RT_inv)
      K0TROE = 2.8700000000D+40 &
	   * exp(-8.12 * LT - 218399001 * RT_inv)
      KINFTROE = 9.6600000000D+23 &
	   * exp(-3.29 * LT - 250988001.2 * RT_inv)
      FCTROE = 0.5 * EXP( -TEMP / 863 ) &
	   + 0.5 * EXP( -TEMP / 320 ) &
	   + 1 * EXP( -100000 / TEMP )
      K(R222F) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM27) )
      K0TROE = 1.0777525666D+39 &
	   * exp(-7.6526 * LT - 266601117.8 * RT_inv)
      KINFTROE = 3.6275574193D+22 &
	   * exp(-2.8226 * LT - 299190118.1 * RT_inv)
      K(R222B) = GETLINDRATECOEFF( TEMP, PRESSURE, K0TROE, KINFTROE &
	   , FCTROE, M(mM27) )
      K(R223F) = 5.3100000000D+08 &
	   * exp(0.21 * LT - 166649000.3 * RT_inv)
      K(R223B) = 5.7164499741D+06 &
	   * exp(0.476243 * LT - 13050091.24 * RT_inv)
      K(R224F) = 1.8750000000D+03 &
	   * exp(1.9 * LT + 3598001.512 * RT_inv)
      K(R224B) = 1.9730911069D+00 &
	   * exp(2.49152 * LT - 64888368.04 * RT_inv)
      K(R225F) = 1.4800000000D+00 &
	   * exp(3.077 * LT - 30207998.84 * RT_inv)
      K(R225B) = 1.7559471196D-03 &
	   * exp(3.76765 * LT - 104483362.3 * RT_inv)
      K(R226F) = 3.3300000000D+06 &
	   * exp(1.1 * LT - 2261000.128 * RT_inv)
      K(R226B) = 6.4305607041D+04 &
	   * exp(1.62393 * LT - 139882308.1 * RT_inv)
      K(R227F) = 2.0300000000D-11 &
	   * exp(5.9 * LT - 4401998.952 * RT_inv)
      K(R227B) = 6.6240952747D-11 &
	   * exp(6.00747 * LT - 87889910.12 * RT_inv)
      K(R228F) = 3.4000000000D+00 &
	   * exp(2.5 * LT - 37329999.46 * RT_inv)
      K(R228B) = 1.3822027059D+00 &
	   * exp(2.53254 * LT - 37404460.71 * RT_inv)
      K(R229F) = 2.4700000000D+04 &
	   * exp(2.03 * LT - 63597000.83 * RT_inv)
      K(R229B) = 3.8446968837D+01 &
	   * exp(2.64223 * LT - 22779664.73 * RT_inv)
      K(R230F) = 3.0100000000D+05 &
	   * exp(1.577 * LT - 15354999.67 * RT_inv)
      K(R230B) = 4.2701233258D+07 &
	   * exp(1.72623 * LT - 136737286.5 * RT_inv)
      K(R231F) = 1.4900000000D+02 &
	   * exp(1.67 * LT - 28492998.16 * RT_inv)
      K(R231B) = 5.5953007812D+00 &
	   * exp(2.1374 * LT - 76695114.99 * RT_inv)
      K(R232F) = 2.0000000000D+35 &
	   * exp(-6.7 * LT - 198531000.8 * RT_inv)
      K(R232B) = 5.0268649512D+23 &
	   * exp(-4.70527 * LT - 105618485.6 * RT_inv)
      K(R233F) = 4.3000000000D+07 * exp(-7782001.512 * RT_inv)
      K(R233B) = 9.0281969876D+03 &
	   * exp(1.06854 * LT - 82849273.37 * RT_inv)
      K(R234F) = 1.2000000000D+07 * exp(-7782001.512 * RT_inv)
      K(R234B) = 7.7684707612D-02 &
	   * exp(2.24121 * LT - 411017286.1 * RT_inv)
      K(R235F) = 8.7000000000D+09 * exp(-19874000 * RT_inv)
      K(R235B) = 1.6201229458D+06 &
	   * exp(0.969414 * LT - 89152277.94 * RT_inv)
      K(R236F) = 1.1000000000D+09 * exp(1827997.968 * RT_inv)
      K(R236B) = 3.7590676991D+06 &
	   * exp(0.90182 * LT - 136585218.4 * RT_inv)
      K(R237F) = 4.1000000000D+01 &
	   * exp(2.5 * LT - 42702000.23 * RT_inv)
      K(R237B) = 3.7738222345D+00 &
	   * exp(2.89796 * LT - 50977497.05 * RT_inv)
      K(R238F) = 9.6000000000D+10
      K(R238B) = 1.8186036585D+05 &
	   * exp(1.33939 * LT - 264822068.2 * RT_inv)
      K(R239F) = 1.6000000000D+10 * exp(606997.984 * RT_inv)
      K(R239B) = 1.5138684415D+07 &
	   * exp(0.903685 * LT - 335031847.8 * RT_inv)
      K(R240F) = 2.0000000000D+12 * exp(-0.6 * LT)
      K(R240B) = 1.7982591616D+12 &
	   * exp(-0.287839 * LT - 267152476.3 * RT_inv)
      K(R241F) = 4.0000000000D+08 * exp(0.6 * LT)
      K(R241B) = 3.8718111253D+06 &
	   * exp(1.1784 * LT - 113553567.2 * RT_inv)
      K(R242F) = 9.0000000000D+10 * exp(-169034001.7 * RT_inv)
      K(R242B) = 1.7145780077D+08 &
	   * exp(0.644134 * LT - 16227000.96 * RT_inv)
      K(R243F) = 1.6000000000D+02 &
	   * exp(2.18 * LT - 75061001.84 * RT_inv)
      K(R243B) = 1.6565924364D+03 &
	   * exp(2.24196 * LT - 447581803.1 * RT_inv)
      K(R244F) = 5.1000000000D+09 * exp(5904000.56 * RT_inv)
      K(R244B) = 8.5102939164D+08 &
	   * exp(0.420402 * LT - 214875884.6 * RT_inv)
      K(R245F) = 4.7000000000D+01 &
	   * exp(2.5 * LT - 87864000 * RT_inv)
      K(R245B) = 8.1392515757D+01 &
	   * exp(2.01464 * LT - 3584180.441 * RT_inv)
      K(R246F) = 4.0000000000D+10 * exp(-81170001.66 * RT_inv)
      K(R246B) = 9.6322841816D+11 &
	   * exp(-0.79455 * LT - 33182145.47 * RT_inv)
      K(R247F) = 4.1000000000D+01 &
	   * exp(2.5 * LT - 42702000.23 * RT_inv)
      K(R247B) = 2.1981329651D+02 &
	   * exp(1.94389 * LT - 30821213 * RT_inv)
      K(R248F) = 8.6000000000D-03 &
	   * exp(3.76 * LT - 71965000.83 * RT_inv)
      K(R248B) = 5.2085380626D-03 &
	   * exp(3.31361 * LT - 8013952.144 * RT_inv)
      K(R249F) = 2.0000000000D+10
      K(R249B) = 6.2486584573D+16 &
	   * exp(-1.28422 * LT - 287124971.3 * RT_inv)
      K(R250F) = 1.0000000000D+11
      K(R250B) = 2.6101746798D+13 &
	   * exp(-0.429551 * LT - 188224375.9 * RT_inv)
      K(R251F) = 6.0000000000D+10
      K(R251B) = 7.9113653603D+07 &
	   * exp(0.807132 * LT - 95263916.21 * RT_inv)
      K(R252F) = 2.3000000000D+05 &
	   * exp(1.61 * LT - 10990999.81 * RT_inv)
      K(R252B) = 6.1526647429D+07 &
	   * exp(1.8991 * LT - 190841250.1 * RT_inv)
      K(R253F) = 2.0000000000D+10
      K(R253B) = 1.1831144443D+10 &
	   * exp(0.124107 * LT - 252951605.1 * RT_inv)
      K(R254F) = 2.0000000000D+10
      K(R254B) = 1.0493561353D+10 &
	   * exp(0.0249853 * LT - 247162611.2 * RT_inv)
      K(R255F) = 5.0000000000D+10
      K(R255B) = 8.1348131135D+13 &
	   * exp(-0.459071 * LT - 262164152.8 * RT_inv)
      K(R256F) = 9.2700000000D+65 &
	   * exp(-18.7 * LT - 69872800 * RT_inv)
      K(R256B) = 1.7807925269D+78 &
	   * exp(-20.8602 * LT - 241069117.5 * RT_inv)
      K(R257F) = 1.6900000000D+02 &
	   * exp(2.044 * LT - 9845998 * RT_inv)
      K(R257B) = 3.9951419112D-01 &
	   * exp(2.64067 * LT - 63532289 * RT_inv)
      K(R258F) = 9.6200000000D+00 &
	   * exp(2.501 * LT - 665000.776 * RT_inv)
      K(R258B) = 2.2741577033D-02 &
	   * exp(3.09767 * LT - 54351291.78 * RT_inv)
      K(R259F) = 2.6500000000D-02 &
	   * exp(3.452 * LT - 24574000.17 * RT_inv)
      K(R259B) = 1.8722584720D-02 &
	   * exp(3.34219 * LT - 52095696.2 * RT_inv)
      K(R260F) = 5.6400000000D-09 &
	   * exp(4.93 * LT - 2625999.736 * RT_inv)
      K(R260B) = 3.9847312384D-09 &
	   * exp(4.82019 * LT - 30147695.77 * RT_inv)
      K(R261F) = 3.0000000000D+04 &
	   * exp(2 * LT - 4184000 * RT_inv)
      K(R261B) = 5.7817273333D-01 &
	   * exp(3.07115 * LT - 118704411.2 * RT_inv)
      K(R262F) = 1.0000000000D+04 &
	   * exp(2 * LT - 4184000 * RT_inv)
      K(R262B) = 3.1368318788D+00 &
	   * exp(2.90443 * LT - 182050355.7 * RT_inv)
      K(R263F) = 3.6300000000D+13 * exp(-239325000.8 * RT_inv)
      K(R263B) = 1.5628341479D+00 &
	   * exp(1.79033 * LT + 10398633.7 * RT_inv)
      K(R264F) = 7.4070000000D+12 * exp(-225098999.2 * RT_inv)
      K(R264B) = 8.8562725723D+10 &
	   * exp(0.212216 * LT - 340719891.5 * RT_inv)
      K(R265F) = 8.0000000000D+10 * exp(-40500998.66 * RT_inv)
      K(R265B) = 1.6760921028D+07 &
	   * exp(0.690988 * LT - 36755003.9 * RT_inv)
      K(R266F) = 1.7800000000D+10 * exp(-15104001.51 * RT_inv)
      K(R266B) = 6.0699174720D+07 &
	   * exp(0.524272 * LT - 74703951.27 * RT_inv)
      K(R267F) = 1.1300000000D+10 * exp(-127318998.7 * RT_inv)
      K(R267B) = 1.0378900480D+09 &
	   * exp(0.0204171 * LT - 56781228.86 * RT_inv)
      K(R268F) = 1.0700000000D+09 * exp(-49497000.33 * RT_inv)
      K(R268B) = 6.1655593879D+08 &
	   * exp(0.10781 * LT - 54963553.27 * RT_inv)
      K(R269F) = 1.2000000000D+08 * exp(-28242000 * RT_inv)
      K(R269B) = 5.6220735231D+05 &
	   * exp(0.357928 * LT - 25944454.63 * RT_inv)
      K(R270F) = 1.1300000000D+10 * exp(-127318998.7 * RT_inv)
      K(R270B) = 8.1120279907D+08 &
	   * exp(0.0328787 * LT - 49372101.69 * RT_inv)
      K(R271F) = 1.1300000000D+10 * exp(-127318998.7 * RT_inv)
      K(R271B) = 8.1306676019D+09 &
	   * exp(-0.130453 * LT - 43336035.27 * RT_inv)
      K(R272F) = 2.0000000000D+09
      K(R272B) = 1.5106166907D+15 &
	   * exp(-0.277784 * LT - 436547850.1 * RT_inv)
      K(R273F) = 1.0000000000D+11
      K(R273B) = 5.0086378080D+14 &
	   * exp(0.189957 * LT - 406728608.7 * RT_inv)
      K(R274F) = 1.0000000000D+11
      K(R274B) = 1.4969043558D+17 &
	   * exp(-0.516521 * LT - 380564013.7 * RT_inv)
      K(R275F) = 1.0300000000D+09 &
	   * exp(0.2 * LT + 1786998.952 * RT_inv)
      K(R275B) = 3.1441491360D+08 &
	   * exp(0.478459 * LT - 275912299.2 * RT_inv)
      K(R276F) = 2.6300000000D+03 &
	   * exp(2.14 * LT - 71379998.14 * RT_inv)
      K(R276B) = 1.3101277384D+01 &
	   * exp(2.56273 * LT - 9002251.645 * RT_inv)
      K(R277F) = 2.4150000000D+03 &
	   * exp(2 * LT - 53178598.16 * RT_inv)
      K(R277B) = 7.7712889453D+08 &
	   * exp(0.734323 * LT - 26287831.88 * RT_inv)
      K(R278F) = 7.5280000000D+03 &
	   * exp(1.55 * LT - 8811499.816 * RT_inv)
      K(R278B) = 9.0108721902D+07 &
	   * exp(0.695329 * LT - 107712095.3 * RT_inv)
      K(R279F) = 1.2770000000D+06 &
	   * exp(0.73 * LT - 10790498.34 * RT_inv)
      K(R279B) = 4.1543554601D+03 &
	   * exp(1.45873 * LT - 238981672.8 * RT_inv)
      K(R280F) = 1.9000000000D+41 &
	   * exp(-11.38 * LT - 26354999.26 * RT_inv)
      K(R280B) = 2.3854268035D+50 &
	   * exp(-12.7305 * LT - 163848550.4 * RT_inv)
      K(R281F) = 2.8020000000D+12 &
	   * exp(-0.171 * LT - 36749000.85 * RT_inv)
      K(R281B) = 1.4517545141D+09 &
	   * exp(0.489139 * LT - 25478050.32 * RT_inv)
      K(R282F) = 7.8000000000D+05 &
	   * exp(1.45 * LT - 11632001.16 * RT_inv)
      K(R282B) = 2.1199232578D-01 &
	   * exp(3.0334 * LT - 140922580.1 * RT_inv)
      K(R283F) = 1.0000000000D+10 * exp(-33470000.05 * RT_inv)
      K(R283B) = 4.5953776074D+06 &
	   * exp(0.561018 * LT - 16410055.61 * RT_inv)
      K(R284F) = 1.7500000000D+09 * exp(-5649998.288 * RT_inv)
      K(R284B) = 3.7150267058D+06 &
	   * exp(0.782321 * LT - 205391670.9 * RT_inv)
      K(R285) = 3.9300000000D+01 &
	   * exp(2.45 * LT - 18928001.78 * RT_inv)
      K(R286) = 2.6000000000D-01 &
	   * exp(2.7 * LT - 5351001.28 * RT_inv)
      K(R287F) = 8.8200000000D+26 &
	   * exp(-5.236 * LT - 21255401.99 * RT_inv)
      K(R287B) = 2.1906752400D+32 &
	   * exp(-5.24351 * LT - 486206673.2 * RT_inv)
      K(R288F) = 3.0000000000D+10
      K(R288B) = 1.0325022773D+10 &
	   * exp(0.37758 * LT - 283488292.1 * RT_inv)
      K(R289F) = 1.0300000000D+10 &
	   * exp(0.21 * LT + 1789998.88 * RT_inv)
      K(R289B) = 3.0088476398D+18 &
	   * exp(-0.783593 * LT - 528495550 * RT_inv)
      K(R290F) = 5.0000000000D+09
      K(R290B) = 2.8008810098D+10 &
	   * exp(0.210864 * LT - 346834236.6 * RT_inv)
      K(R291F) = 3.3400000000D+58 &
	   * exp(-15.79 * LT - 84307600 * RT_inv)
      K(R291B) = 1.0311961571D+70 &
	   * exp(-17.6873 * LT - 278954303.1 * RT_inv)
      K(R292F) = 2.7500000000D+11 &
	   * exp(-1.83 * LT - 19246.4 * RT_inv)
      K(R292B) = 8.2062954018D+11 &
	   * exp(-2.22913 * LT - 953420.8054 * RT_inv)
      K(R293F) = 6.4500000000D+17 &
	   * exp(-2.65 * LT - 27150001.1 * RT_inv)
      K(R293B) = 2.6877757764D+21 &
	   * exp(-3.52197 * LT - 59605911.01 * RT_inv)
      K(R294F) = 2.1500000000D+04 &
	   * exp(1.19 * LT - 14087498.71 * RT_inv)
      K(R294B) = 6.7141399887D+04 &
	   * exp(1.14318 * LT - 69701518.25 * RT_inv)
      K(R295F) = 3.7300000000D+12 &
	   * exp(-1.29 * LT - 6029139.816 * RT_inv)
      K(R295B) = 1.2268105830D+20 &
	   * exp(-2.96281 * LT - 301141292.2 * RT_inv)
      K(R296F) = 1.0600000000D+00 &
	   * exp(2.39 * LT - 25857099.08 * RT_inv)
      K(R296B) = 7.7545691295D+00 &
	   * exp(2.2495 * LT - 331640215.1 * RT_inv)
      K(R297F) = 3.0300000000D+32 &
	   * exp(-7.32 * LT - 49454900.92 * RT_inv)
      K(R297B) = 3.1817525274D+30 &
	   * exp(-6.70651 * LT - 412023442.2 * RT_inv)
      K(R298) = 7.0700000000D+32 &
	   * exp(-7.32 * LT - 49454900.92 * RT_inv)
      K(R299F) = 1.0300000000D+08 &
	   * exp(-0.33 * LT + 3128799.384 * RT_inv)
      K(R299B) = 1.8039401477D+07 &
	   * exp(0.193905 * LT - 387902712.6 * RT_inv)
      K(R300F) = 7.2500000000D+28 &
	   * exp(-6.7 * LT - 43681001.84 * RT_inv)
      K(R300B) = 7.8785122424D+29 &
	   * exp(-6.53453 * LT - 586453429.9 * RT_inv)
      K(R301F) = 3.7900000000D+46 &
	   * exp(-10.72 * LT - 217150001.7 * RT_inv)
      K(R301B) = 3.6631849251D+35 &
	   * exp(-9.22185 * LT - 23437472.97 * RT_inv)
      K(R302F) = 7.6200000000D+81 &
	   * exp(-21.28 * LT - 272295000.3 * RT_inv)
      K(R302B) = 1.0284743696D+74 &
	   * exp(-20.2547 * LT - 110104207.1 * RT_inv)
      K(R303F) = 1.4800000000D+44 &
	   * exp(-10.12 * LT - 170665000.2 * RT_inv)
      K(R303B) = 1.5766510279D+40 &
	   * exp(-9.89553 * LT - 271130449.5 * RT_inv)
      K(R304F) = 1.5100000000D+19 &
	   * exp(-3.61 * LT - 180162998.2 * RT_inv)
      K(R304B) = 3.5779472621D+08 &
	   * exp(-1.85323 * LT - 291299411.1 * RT_inv)
      K(R305F) = 8.6400000000D+33 &
	   * exp(-6.88 * LT - 143804000.5 * RT_inv)
      K(R305B) = 2.9386150108D+20 &
	   * exp(-4.36924 * LT - 311725838.7 * RT_inv)
      K(R306) = 2.0200000000D+34 &
	   * exp(-6.88 * LT - 143804000.5 * RT_inv)
      K(R307F) = 3.8300000000D+33 &
	   * exp(-7.2 * LT - 146857998.3 * RT_inv)
      K(R307B) = 2.1726454199D+21 &
	   * exp(-4.77882 * LT - 343242807.2 * RT_inv)
      K(R308) = 2.7000000000D+22 &
	   * exp(-3.95 * LT - 41789800.37 * RT_inv)
      K(R309) = 7.9900000000D+36 &
	   * exp(-8.61 * LT - 53095001.84 * RT_inv)
