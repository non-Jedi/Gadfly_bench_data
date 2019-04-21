import Pkg; Pkg.activate(@__DIR__)
using CSV, TypedTables, SplitApplyCombine, Gadfly, DataFrames

cd(@__DIR__)

t = open("benchscript-results.csv"; read=true) do f
    Table(CSV.File(f; categorical=true,
                   types=append!([String, String], repeat([Float64], outer=8))))
end#open

function getarrays(xcommit, ycommit)
    predicate1(r) = string(r.commit) == xcommit
    predicate2(r) = string(r.commit) == ycommit
    
    groups = group(getproperty(:testscript), t)
    
    v = collect(values(groups))
    x = map(v) do val
        r = filter(predicate1, val)
        length(r) == 1 ? r.drawtime[1] : missing
    end#map
    y = map(v) do val
        r = filter(predicate2, val)
        length(r) == 1 ? r.drawtime[1] : missing
    end#map
    DataFrame(x=x, y=y)
end#function

c1, c2 = (strip(string(v)) for v in [ARGS[1], ARGS[2]])
df = getarrays(c1, c2)
dropmissing!(df)

p = plot(df, x=:x, y=:y, Geom.point,
         intercept=[0], slope=[1], Geom.abline,
         Guide.xlabel("$c1 draw time"),
         Guide.ylabel("$c2 draw time"))

draw(SVG(joinpath("plots", "compare_$(c1)_$(c2).svg")), p)
