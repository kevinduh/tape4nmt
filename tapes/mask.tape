global {
  masked_data=(DoMasking:
    no=$tokenized_data
    yes=(side:
      src=$src_out@mask
      trg=$trg_out@mask
    )
  )
}

task mask : sockeye_scripts tools
  < src_in=$tokenized_data[side:src]
  < trg_in=$tokenized_data[side:trg]
  > src_out
  > trg_out
  :: masking_add_index=@
  :: masking_pattern_files=@ {

    paste $src_in $trg_in > in
    cmd="cat in | python $sockeye_scripts/masking/mask_terms.py --pattern_files $masking_pattern_files"

    if [[ $masking_add_index -eq "yes" ]]; then
      cmd+=" --add-index"
    fi

    echo $cmd
    $cmd | $tools/bin/unpaste $src_out $trg_out
}
