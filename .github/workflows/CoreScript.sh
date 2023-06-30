#!/bin/bash

#set -x

# search for core files in the current directory
corefiles=$(find ./ -name "core_*")

for corefile in $corefiles; do
  
  echo $corefiles
  # extract binary name
  binaryname=${corefile#*_}
  echo $binaryname
  binaryname=${binaryname%%.*}
  echo $binaryname
  
  # find the binary
  binary=$binaryname
  echo $binary
  
  if [[ -z $binary ]]; then
    echo "Binary $binaryname not found!"
    continue
  fi

  # use gdb to analyze core file
  gdb --batch --quiet -ex "set interactive-mode off" \
      -ex "echo \nBacktrace for all threads\n==========================" \
      -ex "thread apply all bt" \
      -ex "echo \nRegisters:\n==========================" \
      -ex "info reg" \
      -ex "echo \nDisas:\n==========================" \
      -ex "disas" \
      -ex "quit" \
      "$binary" "$corefile" > "$binaryname.trace" 2>&1
done

#Create a zip to store trace files
zip -r trace_files.zip *.trace

rm *.trace
