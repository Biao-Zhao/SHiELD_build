#!/bin/csh
#

setenv site "gaea"

#Set 1 to build FMS libraries (needed for coupled model)
setenv BuildFMS 0
#Set 1 to build ww3_grid exec (needed for creating wave model grid)
setenv BuildWW3grid 1
#Set 1 to build ww3_strt exec (optional, needed to initlialize wave model)
setenv BuildWW3strt 1
#Set 1 to build ww3_prnc exec (optional, needed to run wave model from external forcing)
setenv BuildWW3prnc 1
#Set 1 to build ww3_bounc exec (optional, needed to run one-way nested  wave model)
setenv BuildWW3bounc 1
#Set 1 to build ww3_multi exec (optional, needed to run wave model in stand-alone from multi driver)
setenv BuildWW3multi 1
#Set 1 to build ww3_shel exec (optional, needed to run wave model in stand-alone from shel driver)
setenv BuildWW3shel 1
#Set 1 to build WW3 library for coupled model
setenv BuildWW3lib 0
#Set 1 to build ww3_ounf exec (optional, needed to process WW3 fileds output to NetCDF)
setenv BuildWW3ounf 1
#Set 1 to build ww3_ounp exec (optional, needed to process WW3 spectra output to NetCDF)
setenv BuildWW3ounp 1
#Set 1 to build the actual coupled model
setenv BuildMOM6 0

setenv HEADDIR `pwd`
mkdir -p build/intel

# These options correctly set the compiler templates and modules for Gaea or the GFDL workstations.
# Use these as a guide to set-up your own environment, and feel free to add so others may use!
if ( "$site" == "gaea" ) then
    # for intel
    setenv TEMPLATE '/ncrc/home1/Biao.Zhao/SHiELD-MOM6-WW3/SHiELD_build/site/intel.mk'
    setenv TEMPLATE_WW3 '/ncrc/home1/Biao.Zhao/SHiELD-MOM6-WW3/SHiELD_build/site/intel-WW3.mk'
    cat <<EOF > build/intel/env
    module purge
    module load   PrgEnv-intel
    module unload intel intel-oneapi
    module load intel-classic/2023.2.0
    module unload cray-libsci
    module load cray-hdf5/1.12.2.11
    module load cray-netcdf/4.9.0.9
    module load craype-hugepages4M
    module load cmake/3.27.9
    module load libyaml/0.2.5
    setenv FC ftn
    setenv CC cc
    setenv CXX CC
    setenv LD ftn
EOF
else if ( "$site" == "stellar" ) then
    # For intel
    setenv TEMPLATE '/home/bz5265/wave/SHiELD_build/site/intel.mk'
    setenv TEMPLATE_WW3 '/home/bz5265/wave/SHiELD_build/site/intel-WW3.mk'
    cat <<EOF > build/intel/env
      module load intel/2021.1.2
      module load openmpi/intel-2021.1/4.1.2
      module load hdf5/intel-2021.1/1.10.6
      module load netcdf/intel-2021.1/hdf5-1.10.6/4.7.4
      setenv FC mpif90
      setenv CC mpicc
      setenv CXX mpicxx
      setenv LD mpif90
EOF

endif
echo '2'
if ($BuildFMS == 1) then
    echo ''
    echo ''
    echo 'Building FMS'
    echo ''
    echo ''
    #FMS
    mkdir -p build/intel/FMSlib/repro/
    (cd build/intel/FMSlib/repro/; rm -f path_names;\
    ../../../../src/mkmf/bin/list_paths -l ../../../../src/FMS; \
    ../../../../src/mkmf/bin/mkmf -t $TEMPLATE -p libfms.a -c "-Duse_libMPI -Duse_netCDF" path_names)
    (cd build/intel/FMSlib/repro/; source ../../env; make NETCDF=3 REPRO=1 libfms.a -j )
endif

if ($BuildWW3strt == 1) then
    echo ''
    echo ''
    echo 'Building ww3_strt'
    echo ''
    echo ''
    #WW3_strt
    mkdir -p build/intel/air_wave_ice_ocean/ww3_strt/
    (cd build/intel/air_wave_ice_ocean/ww3_strt/; rm -f path_names; \
    ../../../../mkmf/bin/list_paths -l ./ ../../../../WW3/model/ww3_strt)
    (cd build/intel/air_wave_ice_ocean/ww3_strt/; \
    ../../../../mkmf/bin/mkmf -t $TEMPLATE_WW3 -p ww3_strt -c "-Duse_libMPI -Duse_netCDF" path_names)
    (cd build/intel/air_wave_ice_ocean/ww3_strt/; source ../../env; make NETCDF=3 REPRO=1 ww3_strt)
endif

if ($BuildWW3grid == 1) then
    echo ''
    echo ''
    echo 'Building ww3_grid'
    echo ''
    echo ''
    #WW3_grid
    mkdir -p build/intel/air_wave_ice_ocean/ww3_grid/
    (cd build/intel/air_wave_ice_ocean/ww3_grid/; rm -f path_names; \
    ../../../../mkmf/bin/list_paths -l ./ ../../../../WW3/model/ww3_grid)
    (cd build/intel/air_wave_ice_ocean/ww3_grid/; \
    ../../../../mkmf/bin/mkmf -t $TEMPLATE_WW3 -p ww3_grid -c "-Duse_libMPI -Duse_netCDF" path_names)
    (cd build/intel/air_wave_ice_ocean/ww3_grid/; source ../../env; make NETCDF=3 REPRO=1 ww3_grid)
endif

if ($BuildWW3prnc == 1) then
    echo ''
    echo ''
    echo 'Building ww3_prnc'
    echo ''
    echo ''
    #WW3_prnc
    mkdir -p build/intel/air_wave_ice_ocean/ww3_prnc/
    (cd build/intel/air_wave_ice_ocean/ww3_prnc/; rm -f path_names;\
    ../../../../mkmf/bin/list_paths -l ./ ../../../../WW3/model/ww3_prnc)
    (cd build/intel/air_wave_ice_ocean/ww3_prnc/; \
    ../../../../mkmf/bin/mkmf -t $TEMPLATE_WW3 -p ww3_prnc -c "-Duse_libMPI -Duse_netCDF" path_names)
    (cd build/intel/air_wave_ice_ocean/ww3_prnc/; source ../../env; make NETCDF=3 REPRO=1 ww3_prnc)
endif

if ($BuildWW3bounc == 1) then
    echo ''
    echo ''
    echo 'Building ww3_bounc'
    echo ''
    echo ''
    #WW3_bounc
    mkdir -p build/intel/air_wave_ice_ocean/ww3_bounc/
    (cd build/intel/air_wave_ice_ocean/ww3_bounc/; rm -f path_names;\
    ../../../../mkmf/bin/list_paths -l ./ ../../../../WW3/model/ww3_bounc)
    (cd build/intel/air_wave_ice_ocean/ww3_bounc/; \
    ../../../../mkmf/bin/mkmf -t $TEMPLATE_WW3 -p ww3_bounc -c "-Duse_libMPI -Duse_netCDF" path_names)
    (cd build/intel/air_wave_ice_ocean/ww3_bounc/; source ../../env; make NETCDF=3 REPRO=1 ww3_bounc)
endif


if ($BuildWW3multi == 1) then
    echo ''
    echo ''
    echo 'Building ww3_multi'
    echo ''
    echo ''
    #Wave
    #WW3_multi
    mkdir -p build/intel/air_wave_ice_ocean/ww3_multi/
    (cd build/intel/air_wave_ice_ocean/ww3_multi/; rm -f path_names;\
    ../../../../mkmf/bin/list_paths -l ./ ../../../../WW3/model/ww3_multi)
    (cd build/intel/air_wave_ice_ocean/ww3_multi/; \
    ../../../../mkmf/bin/mkmf -t $TEMPLATE_WW3 -p ww3_multi path_names)
    (cd build/intel/air_wave_ice_ocean/ww3_multi/; source ../../env; make NETCDF=3 REPRO=1 ww3_multi)
endif

if ($BuildWW3shel == 1) then
    echo ''
    echo ''
    echo 'Building ww3_multi'
    echo ''
    echo ''
    #Wave
    #WW3_multi
    mkdir -p build/intel/air_wave_ice_ocean/ww3_shel/
    (cd build/intel/air_wave_ice_ocean/ww3_shel/; rm -f path_names;\
    ../../../../mkmf/bin/list_paths -l ./ ../../../../WW3/model/ww3_shel)
    (cd build/intel/air_wave_ice_ocean/ww3_shel/; \
    ../../../../mkmf/bin/mkmf -t $TEMPLATE_WW3 -p ww3_shel -c "-Duse_libMPI -Duse_netCDF" path_names)
    (cd build/intel/air_wave_ice_ocean/ww3_shel/; source ../../env; make NETCDF=3 REPRO=1 ww3_shel)
endif

if ($BuildWW3lib == 1) then
    echo ''
    echo ''
    echo 'Building WW3lib'
    echo ''
    echo ''
    mkdir -p build/intel/WW3lib/repro
    (cd build/intel/WW3lib/repro/; rm -f path_names; \
    ../../../../mkmf/bin/list_paths -l ./ ../../../../WW3/model/ww3_multi)
    (cd build/intel/WW3lib/repro/; \
    ../../../../mkmf/bin/mkmf -t $TEMPLATE_WW3 -p libww3.a -c "-Duse_libMPI -Duse_netCDF -DSPMD " path_names)
    (cd build/intel/WW3lib/repro/; source ../../env; make NETCDF=4 REPRO=1 libww3.a -j)
endif

if ($BuildMOM6 == 1) then
    echo ''
    echo ''
    echo 'Building MOM6'
    echo ''
    echo ''
    #Wave-ice-ocean
    mkdir -p build/intel/wave_ice_ocean/repro/
    (cd build/intel/wave_ice_ocean/repro/; rm -f path_names; \
		../../../../src/mkmf/bin/list_paths -l ./ ../../../../src/MOM6/config_src/{dynamic,coupled_driver} ../../../../src/MOM6/src/{*,*/*}/ ../../../../src/{atmos_null,coupler,land_null,ice_param,icebergs,SIS2,FMS/coupler,FMS/include,WW3/model/CPL}/)
    (cd build/intel/wave_ice_ocean/repro/; \
	../../../../src/mkmf/bin/mkmf -t $TEMPLATE -o '-I../../FMSlib/repro -I../../WW3lib/repro' -p MOM6 -l '-L../../FMSlib/repro -lfms -L../../WW3lib/repro -lww3' -c '-Duse_libMPI -Duse_netCDF -DSPMD -Duse_AM3_physics -D_USE_LEGACY_LAND_ ' path_names )
    (cd build/intel/wave_ice_ocean/repro/; source ../../env; make NETCDF=3 REPRO=1 MOM6 -j)
endif

if ($BuildWW3ounf == 1) then
    echo ''
    echo ''
    echo 'Building ww3_ounf'
    echo ''
    echo ''
    #WW3_ounf
    mkdir -p build/intel/air_wave_ice_ocean/ww3_ounf/
    (cd build/intel/air_wave_ice_ocean/ww3_ounf/; rm -f path_names; \
    ../../../../mkmf/bin/list_paths -l ./ ../../../../WW3/model/ww3_ounf)
    (cd build/intel/air_wave_ice_ocean/ww3_ounf/; \
    ../../../../mkmf/bin/mkmf -t $TEMPLATE_WW3 -p ww3_ounf -c "-Duse_libMPI -Duse_netCDF" path_names)
    (cd build/intel/air_wave_ice_ocean/ww3_ounf/; source ../../env; make NETCDF=3 REPRO=1 ww3_ounf)
endif

if ($BuildWW3ounp == 1) then
    echo ''
    echo ''
    echo 'Building ww3_ounp'
    echo ''
    echo ''
    #WW3_ounp
    mkdir -p build/intel/air_wave_ice_ocean/ww3_ounp/
    (cd build/intel/air_wave_ice_ocean/ww3_ounp/; rm -f path_names; \
    ../../../../mkmf/bin/list_paths -l ./ ../../../../WW3/model/ww3_ounp)
    (cd build/intel/air_wave_ice_ocean/ww3_ounp/; \
    ../../../../mkmf/bin/mkmf -t $TEMPLATE_WW3 -p ww3_ounp -c "-Duse_libMPI -Duse_netCDF" path_names)
    (cd build/intel/air_wave_ice_ocean/ww3_ounp/; source ../../env; make NETCDF=3 REPRO=1 ww3_ounp)
endif

