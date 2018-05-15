using Base.Test
using TimeseriesSurrogates

ts = cumsum(randn(1000))
@testset "Constrained surrogates" begin
    @testset "Random shuffle" begin
        surrogate = randomshuffle(ts)
        @test length(ts) == length(surrogate)
        @test all(ts .!= surrogate)
        @test all(sort(ts) .== sort(surrogate))
    end
end
