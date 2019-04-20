#!/bin/env fish
cd Gadfly.jl
for commit in $argv
    git checkout $commit
    echo "Checked out $commit"
    parallel-rust --eta -v -j3 "julia ../benchscript.jl $commit" ::: test/testscripts/*.jl
end
