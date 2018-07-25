using Base.Test
using TimeseriesSurrogates, StateSpaceReconstruction
ENV["GKSwstype"] = "100"

ts = cumsum(randn(1000))

@testset "Constrained surrogates" begin
    @testset "Random shuffle" begin
        surrogate = randomshuffle(ts)
        @test length(ts) == length(surrogate)
        @test all(sort(ts) .== sort(surrogate))
        @test !all(ts .== surrogate)
    end

    @testset "Random phases" begin
        surrogate = randomphases(ts)
        @test length(ts) == length(surrogate)
        @test !all(ts .== surrogate)
    end

    @testset "Random amplitudes" begin
        surrogate = randomphases(ts)
        @test length(ts) == length(surrogate)
        @test all(ts .!= surrogate)
    end

    @testset "AAFT" begin
        surrogate = aaft(ts)
        @test length(ts) == length(surrogate)
        #@test all(ts .!= surrogate)
        @test all(sort(ts) .== sort(surrogate))
    end

    @testset "IAAFT" begin
        # Single realization
        surrogate = iaaft(ts)
        @test length(ts) == length(surrogate)
        #@test all(ts .!= surrogate)
        @test all(sort(ts) .== sort(surrogate))

        # Storing all realizations during iterations (the last vector contains the final
        # surrogate).
        surrogates = iaaft_iters(ts)
        @test length(ts) == length(surrogates[1])
        #@test all(ts .!= surrogates[end])
        @test all(sort(ts) .== sort(surrogates[end]))
    end

    @testset "Twin surrogates" begin

        ts1 = AR1(500, 0.1, 0.4)
        ts2 = AR1(500, 0.1, 0.4)
        ts3 = AR1(500, 0.1, 0.4)
        embedding = [ts1 ts2 ts3].'



        twinsurrogate = twin(embedding, 0.2)
        or, su = embedding[1, :], twinsurrogate[1, :]
        @test length(setdiff(su, or)) == 0
        @test size(embedding) ==  size(twinsurrogate)
    end

    #@testset "WIAAFT" begin
    #    wiaaft(ts)
    #end
end
