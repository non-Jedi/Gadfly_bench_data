import Pkg; Pkg.activate(@__DIR__)
_, t1, bytes1, gctime1, memallocs1 = @timed using Gadfly

p = evalfile(ARGS[2])
_, t2, bytes2, gctime2, memallocs2 = @timed draw(SVG("test.svg"), p)

shortname = splitpath(ARGS[2])[end]

open("benchscript-results.csv"; append=true) do f
    write(f, '\n')
    join(f, (ARGS[1], shortname,
             t1, bytes1, gctime1, memallocs1.poolalloc,
             t2, bytes2, gctime2, memallocs2.poolalloc), ',')
end#open

