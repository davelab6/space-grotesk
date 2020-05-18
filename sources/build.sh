# source venv/bin/activate

mkdir -p ../fonts ../fonts/ttf ../fonts/otf ../fonts/variable

# Generating TTFs
fontmake -g SpaceGrotesk.glyphs -i -o ttf --output-dir ../fonts/ttf/

# Post processing TTFs
ttfs=$(ls ../fonts/ttf/*.ttf)
for ttf in $ttfs
do
	ttfautohint $ttf "$ttf.fix";
	mv "$ttf.fix" $ttf;

    gftools fix-hinting $ttf;
    mv "$ttf.fix" $ttf;

    gftools fix-dsig -f $ttf;
done

# Generating OTFs
fontmake -g SpaceGrotesk.glyphs -i -o otf --output-dir ../fonts/otf/

# Post processing OTFs
otfs=$(ls ../fonts/otf/*.otf)
for otf in $otfs
do
    gftools fix-dsig -f $otf;
done

# Generating VFs
VF_FILE=../fonts/variable/SpaceGrotesk\[wght]\.ttf
fontmake -g SpaceGrotesk.glyphs -o variable --output-path $VF_FILE

rm -rf master_ufo/ instance_ufo/

# Post processing VFs
ttfautohint $VF_FILE $VF_FILE.fix
mv $VF_FILE.fix $VF_FILE

gftools fix-hinting $VF_FILE
mv $VF_FILE.fix $VF_FILE

gftools fix-dsig -f $VF_FILE

gftools fix-unwanted-tables $VF_FILE -t MVAR