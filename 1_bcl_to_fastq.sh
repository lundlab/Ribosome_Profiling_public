echo "Convert bcl files to fastq"
nice bcl2fastq -R $path_to_seq_files -o $output_path --sample-sheet $sample_sheet_location --processing-threads 10 --barcode-mismatches 1 --create-fastq-for-index-reads --no-lane-splitting > "$experiment_name"_bcl2fastq.log 2>&1
