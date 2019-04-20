#!/bin/env fish
for commit in c5a61361 a5394977 9df68de0
    git checkout $commit
    echo "Checked out $commit"
    parallel-rust --eta -v -j3 "julia benchscript.jl $commit" ::: test/testscripts/*.jl
end
