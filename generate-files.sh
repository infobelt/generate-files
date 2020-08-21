#!/bin/bash

# Files to download
FILES=("http://courses.washington.edu/b517/Datasets/SalaryData.txt"
"http://courses.washington.edu/b517/Datasets/Not%20entirely%20straightforward.pdf"
"https://www2.census.gov/programs-surveys/decennial/2020/data/2020map/2020/decennialrr2020.csv"
"http://courses.washington.edu/b517/Datasets/QRS.xlsx"
"https://www.nhlbi.nih.gov/files/docs/500k_budget_tables.doc"
"https://apfs.dhs.gov/static/docs/APFS%20Contracting%20Guide.docx"
"http://courses.washington.edu/b517/Datasets/ColonDescription.rtf"
"https://water.weather.gov/precip/downloads/nws_precip_symbology_arcmap_10_5.zip"
"https://www.spc.noaa.gov/public/state/images/ND_swody1.png"
"https://evs.nci.nih.gov/ftp1/ThesaurusSemantics/TBox.vsd"
"https://www2.census.gov/census_2010/04-Summary_File_1/SF1_Access2007.accdb"
"https://ww3.arb.ca.gov/icons/apache_pb.svg"
"http://www.boulder.doc.gov/gifs/boco_map.jpeg"
"http://www.boulder.doc.gov/gifs/noaa-logo.jpg"
"http://www.boulder.doc.gov/gifs/boco_map_big.gif"
"https://ftp.nifc.gov/public/ctsp/Tools/Transition_Tools/Replace.vbs"
"https://cdaweb.gsfc.nasa.gov/pub/software/cdf/idl_cdf_dlm/windows/install_idl_win.bat"
"https://www.nhc.noaa.gov/video/DOLLY.mp4"
"https://legacy.azdeq.gov/function/compliance/download/scepp.pptm"
"https://www.dshs.wa.gov/data/InterLocal.xml"
"https://gaftp.epa.gov/Storet/modern/dba/v20Database_10g/master/storet/storet-x/master/admin/tnsnames.ora"
"http://canbyoregon.gov/transportation/_derived/WS_FTP.LOG"
"https://lehd.ces.census.gov/data/schema/asciidoc.css"
"https://lehd.ces.census.gov/data/schema/asciidoc.js"
"https://lehd.ces.census.gov/data/schema/VERSIONING.html")

# Download files
for URL in "${FILES[@]}";
do
	echo "Downloading "${URL##*.}" file"
        mkdir "${URL##*.}";
        wget --quiet -P "${URL##*.}" $URL
        cd "${URL##*.}";
        ls > filenames.txt
        cd ..
        echo "Finished downloading '${URL##*.}' file"
done

# Create copies of each file type
dirs=($(find . -mindepth 1 -type d))

for dir in "${dirs[@]}";
do
	cd "$dir"
        while read p;
	do
                if [ "$p" != "filenames.txt" ]; then
                        for (( i=0; i<10000; ++i)); do
                                cp "$p" $i-"$p"
                        done
                else
                        echo "Working on" "$dir"
                fi
        done < filenames.txt
        cd ".."
done
