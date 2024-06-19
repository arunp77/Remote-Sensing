@echo off

:: These parameters can be customized for the script.
::
set "master=Aquaculture_region.hdf"
set "shapes=Aquaculture_polygons.shp"
set "output=sst_processed.pdf"
set "var=sea_surface_temperature"
set "quality=quality_level"
set "units=celsius"
set "range=12/26"
set "palette=HSL256"
set "depths=200/500/1000"

:: Start the data processing
::
set "inputs=%*"
del reg_*.hdf /q
set "n=1"
set "files="
for %%i in (%inputs%) do (
  echo Working on input file %n%
  echo .. Registering
  cwregister2 --master %master% --match "%var%|%quality%" "%%i" reg_%n%.hdf
  echo .. Masking
  cwmath --template %var% --expr "%var%_masked = %quality% < 5 ? NaN : %var%" reg_%n%.hdf
  set /a "n+=1"
  set "files=%files% reg_%n%.hdf"
)

echo Compositing data files
del composite.hdf 2> nul
cwcomposite --method latest --match %var%_masked %files% composite.hdf

echo Creating output %output%
del %output% 2> nul
cwrender --coast black/gray40 --grid white --shape %shapes%/red ^
  --bath gray60/%depths% --enhance %var%_masked --palette %palette% ^
  --units %units% --range %range% composite.hdf %output%


