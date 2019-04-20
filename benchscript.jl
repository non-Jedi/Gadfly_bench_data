import Pkg; Pkg.activate(@__DIR__)
_, t1, bytes1, gctime1, memallocs1 = @timed using Gadfly

shortname = splitpath(ARGS[2])[end]
fullpath = joinpath(@__DIR__, "Gadfly.jl", ARGS[2])

p = evalfile(fullpath)
_, t2, bytes2, gctime2, memallocs2 = @timed draw(SVG("test.svg"), p)


open(joinpath(@__DIR__, "benchscript-results.csv"); append=true) do f
    write(f, '\n')
    join(f, (ARGS[1], shortname,
             t1, bytes1, gctime1, memallocs1.poolalloc,
             t2, bytes2, gctime2, memallocs2.poolalloc), ',')
end#open

