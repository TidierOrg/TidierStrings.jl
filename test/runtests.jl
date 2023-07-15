module TestTidierStrings

using TidierStrings
using Test
#using Documenter

#DocMeta.setdocmeta!(TidierStrings, :DocTestSetup, :(using TidierStrings); recursive=true)

#doctest(TidierStrings)

@testset "str_detect tests" begin
    @test str_detect("Hello, world", "world") == true
    @test str_detect("Hello, world", "foo") == false
    @test str_detect("Hello, world", r"\w+") == true
end

@testset "str_replace tests" begin
    @test str_replace("Hello, world", "world", "Julia") == "Hello, Julia"
    @test str_replace("Hello, world", r"\w+", "foo") == "foo, foo"
end

@testset "str_replace_all tests" begin
    @test str_replace_all("Hello, world, world", "world", "Julia") == "Hello, Julia, Julia"
    @test str_replace_all("Hello, world, world", r"\w+", "foo") == "foo, foo, foo"
end

@testset "str_remove tests" begin
    @test str_remove("Hello, world", "world") == "Hello, "
    @test str_remove("Hello, world", r"\w+") == ", world"
end

# continue with similar test sets for your other functions

@testset "str_remove_all tests" begin
    @test str_remove_all("Hello, world, world", "world") == "Hello, , "
    @test str_remove_all("Hello, world, world", r"\w+") == ", , "
end

@testset "str_count tests" begin
    @test str_count("Hello, world, world", "world") == 2
    @test str_count("Hello, world, world", r"\w+") == 3
end

@testset "str_detect tests" begin
    @test str_detect("Hello, world", "world") == true
    @test str_detect("Hello, world", "foo") == false
    @test str_detect("Hello, world", r"\w+") == true
end

@testset "str_replace tests" begin
    @test str_replace("Hello, world", "world", "Julia") == "Hello, Julia"
    @test str_replace("Hello, world", r"\w+", "foo") == "foo, foo"
end

@testset "str_replace_all tests" begin
    @test str_replace_all("Hello, world, world", "world", "Julia") == "Hello, Julia, Julia"
    @test str_replace_all("Hello, world, world", r"\w+", "foo") == "foo, foo, foo"
end

@testset "str_remove tests" begin
    @test str_remove("Hello, world", "world") == "Hello, "
    @test str_remove("Hello, world", r"\w+") == ", world"
end

@testset "str_remove_all tests" begin
    @test str_remove_all("Hello, world, world", "world") == "Hello, , "
    @test str_remove_all("Hello, world, world", r"\w+") == ", , "
end

@testset "str_count tests" begin
    @test str_count("Hello, world, world", "world") == 2
    @test str_count("Hello, world, world", r"\w+") == 3
end

@testset "str_squish tests" begin
    @test str_squish("  Hello,   world  ") == "Hello, world"
end

@testset "str_equal tests" begin
    @test str_equal("Hello, world", "Hello, world") == true
    @test str_equal("Hello, world", "Hello, Julia") == false
    @test str_equal("Hello, world", r"^Hello") == true
end

@testset "str_to_lower tests" begin
    @test str_to_lower("Hello, World") == "hello, world"
end

@testset "str_to_upper tests" begin
    @test str_to_upper("Hello, World") == "HELLO, WORLD"
end

@testset "str_split tests" begin
    @test str_split("Hello, world", ",") == ["Hello", " world"]
    @test str_split("Hello, world", r"\s") == ["Hello,", "world"]
end

@testset "str_subset tests" begin
    @test str_subset("Hello, world", "world") == true
    @test str_subset("Hello, world", "foo") == false
    @test str_subset("Hello, world", r"\w+") == true
end