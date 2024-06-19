#!/bin/sh

###
# These parameters can be customized for the script.
#
master=Aquaculture_region.hdf
shapes=Aquaculture_polygons.shp
output=sst_processed.pdf
var=sea_surface_temperature
quality=quality_level
units=celsius
range=12/26
palette=HSL256
depths=200/500/1000

###
# Start the data processing
#
inputs="$@"
rm -f reg_*.hdf
n=1
for input in $inputs ; do
  echo "Working on input file $n"
  echo ".. Registering"
  cwregister2 --master $master --match "($var|$quality)" $input reg_$n.hdf
  echo ".. Masking"
  cwmath --template $var --expr "${var}_masked = $quality < 5 ? NaN : $var" reg_$n.hdf
  n=`expr $n + 1`
done

echo "Compositing data files"
rm -f composite.hdf
cwcomposite --method latest --match ${var}_masked reg_*.hdf composite.hdf

echo "Creating output $output"
rm -f $output
cwrender --coast black/gray40 --grid white --shape $shapes/red \
  --bath gray60/$depths --enhance ${var}_masked --palette $palette \
  --units $units --range $range composite.hdf $output

