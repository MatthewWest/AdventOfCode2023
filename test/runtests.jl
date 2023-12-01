using AdventOfCode2023
using Test

@testset "Day 1" begin
    test_input_1 = """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """
    @test AdventOfCode2023.Day01.part1(test_input_1) == 142
    test_input_2 = """
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    """
    @test AdventOfCode2022.Day01.part2(test_input_2) == 281
end
