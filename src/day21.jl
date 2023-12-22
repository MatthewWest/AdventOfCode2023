### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 0ba81a34-9fbe-11ee-01e3-1f1ba0a1f13c
INPUT = read(joinpath(@__DIR__, "../data/day21.txt"), String);

# ╔═╡ e3209af1-c6ee-4b13-81b9-12e07877bd74
TEST_INPUT = """
...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........
""";

# ╔═╡ ddd4614e-31bf-4257-8412-526009869e7a
function Base.show(io::IO, mime::MIME"text/plain", m::Matrix{Char})
	(rows, cols) = size(m)
	for row in 1:rows
		for col in 1:cols
			print(io, m[row, col])
		end
		print(io, '\n')
	end
end

# ╔═╡ 79a81c60-dc50-440d-ab26-6e57b240e857
function Base.show(m::Matrix{Char})
	show(stdout, MIME("text/plain"), m)
end

# ╔═╡ 16924265-8479-49ff-b27e-d46f7514d9bc
function parse_input(s)
	s = strip(s)
	lines = split(s, '\n')
	rows, cols = length(lines), length(first(lines))
	m = fill(' ', (rows, cols))
	for (r, line) in enumerate(lines)
		for (c, char) in enumerate(line)
			m[r, c] = char
		end
	end
	start = only(findall(==('S'), m))
	m[start] = '.'
	m, start
end

# ╔═╡ bdb03d48-39d7-4233-af63-f4a6c9dea0c9
parse_input(TEST_INPUT)

# ╔═╡ ffa9ebc8-8c8d-4075-8ef4-c09c60b282f8
const δs = [CartesianIndex(0,1), CartesianIndex(0,-1), CartesianIndex(1,0), CartesianIndex(-1,0)];

# ╔═╡ 3fb75437-2490-4d4c-925d-0c961e001530
function neighbors(m, loc)
	filter(l -> checkbounds(Bool, m, l), [loc + δ for δ in δs])
end

# ╔═╡ fc2dde7e-fa03-431c-a13a-b2ee1052a6d2
function next(m, locs)
	nextLocs = Set(CartesianIndex{2}[])
	for loc in locs
		for n in neighbors(m, loc)
			if m[n] == '.'
				push!(nextLocs, n)
			end
		end
	end
	nextLocs
end

# ╔═╡ 0cbf664d-2ca6-4259-b75d-61e2df90da48
function part1(input = INPUT; n=64)
	m, start = parse_input(input)
	locs = Set([start])
	for i in 1:n
		locs = next(m, locs)
	end
	length(locs)
end

# ╔═╡ 9d2c29c5-3d59-494a-aa11-e17281661e39
part1()

# ╔═╡ 6446d61a-51ef-4708-8358-b8d87937ffcb
function count_steps_to_fill(m, start)
	locs = Set([start])
	ns = Int[]
	cycle_started = 0
	for i in Iterators.countfrom(1)
		locs = next(m, locs)
		push!(ns, length(locs))
		if i > 2 && (ns[i] == ns[i-1] || ns[i] == ns[i-2])
			if cycle_started < 10
				cycle_started += 1
			else
				return ns
			end
		end
	end
end

# ╔═╡ cfaa9616-e50b-4e53-955b-ff3572b10144
function part2(input = INPUT; n=26501365)
	m, start = parse_input(input)
	count_steps_to_fill(m, start)
end

# ╔═╡ d92a4048-7572-41c8-a790-d4c8eb762140
md"""
I'm abandoning this one for now. I think the solution will probably have something to do with finding the speed of the wavefront in different directions and calculating the number of fully populated grids, then simulating the unique edges. I'm not sure of the details.
"""

# ╔═╡ Cell order:
# ╠═0ba81a34-9fbe-11ee-01e3-1f1ba0a1f13c
# ╠═e3209af1-c6ee-4b13-81b9-12e07877bd74
# ╠═ddd4614e-31bf-4257-8412-526009869e7a
# ╠═79a81c60-dc50-440d-ab26-6e57b240e857
# ╠═bdb03d48-39d7-4233-af63-f4a6c9dea0c9
# ╠═16924265-8479-49ff-b27e-d46f7514d9bc
# ╠═ffa9ebc8-8c8d-4075-8ef4-c09c60b282f8
# ╠═3fb75437-2490-4d4c-925d-0c961e001530
# ╠═fc2dde7e-fa03-431c-a13a-b2ee1052a6d2
# ╠═0cbf664d-2ca6-4259-b75d-61e2df90da48
# ╠═9d2c29c5-3d59-494a-aa11-e17281661e39
# ╠═6446d61a-51ef-4708-8358-b8d87937ffcb
# ╠═cfaa9616-e50b-4e53-955b-ff3572b10144
# ╟─d92a4048-7572-41c8-a790-d4c8eb762140
