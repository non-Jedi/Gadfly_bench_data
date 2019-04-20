using Gadfly, DataFrames, CSV

const mastercommit = Symbol("9df68de0")
const commit1 = :a5394977
const commit2 = :c5a61361

df = CSV.read(joinpath(@__DIR__, "benchscript-results.csv"))

p = Dict{Symbol,Plot}()
for i in (:drawtime, :drawallocs, :usingtime)
    widedf = unstack(df, :testscript, :commit, i)
    p[Symbol(commit1, :_, i)] = plot(widedf, x=mastercommit, y=commit1, Geom.point,
                                     intercept=[0], slope=[1], Geom.abline,
                                     Guide.xlabel("$mastercommit $i"),
                                     Guide.ylabel("$commit1 $i"))
    p[Symbol(commit2, :_, i)] = plot(widedf, x=mastercommit, y=commit2, Geom.point,
                                     intercept=[0], slope=[1], Geom.abline,
                                     Guide.xlabel("$mastercommit $i"),
                                     Guide.ylabel("$commit2 $i"))
    widedf = copy(widedf)
    widedf[commit1] = 100(widedf[commit1] .- widedf[mastercommit]) ./ widedf[mastercommit]
    widedf[commit2] = 100(widedf[commit2] .- widedf[mastercommit]) ./ widedf[mastercommit]
    stackeddf = stack(widedf, [commit1, commit2])
    p[i] = plot(stackeddf, y=:value, x=:variable, Geom.boxplot,
                Guide.xlabel("commit"), Guide.ylabel("Change from master (%)"),
                Guide.title(string(i)))
end#for
p
