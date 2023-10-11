#!/bin/bash
# Requires verilator
if [ -z "$1" ]
then
    echo "simulate.sh needs the name of a toplevel testbench from the rtl directory!"
else
    toplevel=$(basename -- "${1%.*}")
    mypath=$(pwd)
    tmp="$mypath/../tmp"
    mkdir -p $tmp
    rm -rf $tmp/*
    verilator_version=$(verilator --version)
    echo ==$verilator_version==
    { echo -e "#include \"obj_dir/V$toplevel.h\""; cat simulate.cpp; } > $tmp/simulate.cpp
    cd $tmp/
    cp ../image.mem .
    rtl="../rtl"
    toplevelfile="$(find $rtl/ -name $1)"
    incdirlist=$(find $rtl/ -not -path */testbench -and -type d -exec bash -c 'echo "-I $1"' bash "{}" \; )
    libdirlist=$(find $rtl/ -not -path */testbench -and -type d -exec bash -c 'echo "-y $1"' bash "{}" \; )
    no_warn_list="-Wno-fatal"
    sv_std="--default-language 1800-2005"
    echo verilator --binary -j 0 -CFLAGS "-DTARGET_TB=V$toplevel" -DSIM_DEBUG --trace --trace-structs --report-unoptflat -cc $sv_std $no_warn_list $libdirlist $toplevelfile --exe simulate.cpp
    verilator -j 0 -CFLAGS "-DTARGET_TB=V$toplevel" -DSIM_DEBUG --trace --trace-structs --report-unoptflat -cc $sv_std $no_warn_list $libdirlist $toplevelfile --timing --build --exe simulate.cpp
    echo ==simulation==
    ./obj_dir/V$toplevel
    echo finished
    open -a gtkwave sim.vcd
fi