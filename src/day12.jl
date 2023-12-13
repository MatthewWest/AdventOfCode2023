### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ e2735d97-10fa-47fa-bc68-cc4f50923df8
using Combinatorics

# ╔═╡ df546810-854c-43f2-92bb-cba0e2df8627
using Memoize

# ╔═╡ bd3edbe0-98ad-11ee-18b0-a390fc510f44
INPUT = read(joinpath(@__DIR__, "../data/day12.txt"), String);

# ╔═╡ 3b14e495-eb9a-4134-a6f7-f24d6038425f
struct Row
	springs::String
	counts::Vector{Int}
end

# ╔═╡ 45587c63-62f6-49a0-a427-8b26931ced6d
function parse_input(input)
	rows = Row[]
	for line in eachsplit(strip(input), '\n')
		springs, counts = split(line)
		push!(rows, Row(springs, parse.(Int, split(counts, ','))))
	end
	return rows
end

# ╔═╡ cb870bba-b04f-4a9c-8148-b9faa0fa1069
TEST_INPUT = """
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
""";

# ╔═╡ e07f2b6b-663d-418d-a625-be3f18d15892
TEST_ROWS = parse_input(TEST_INPUT);

# ╔═╡ 40be14a0-2aa8-4ac8-bc8f-e25f575aa1c0
function groups(springs::String)
	length.(split(springs, '.', keepempty=false))
end

# ╔═╡ 3bca9897-cc78-42a4-9803-117218aad309
function possibilities(row::Row)
	n_unknown_broken = sum(row.counts) - count(isequal('#'), row.springs)
	n_unknown_good = count(isequal('?'), row.springs) - n_unknown_broken
	unknowns = vcat(fill('#', n_unknown_broken), fill('.', n_unknown_good))
	idxs = findall(isequal('?'), row.springs)
	n_unknown = length(idxs)
	n = 0
	for arrangement in multiset_permutations(unknowns, n_unknown)
		cs = collect(row.springs)
		for i in 1:n_unknown
			cs[idxs[i]] = arrangement[i]
		end
		if groups(join(cs)) == row.counts
			n += 1
		end
	end
	n
end

# ╔═╡ 57371449-0895-4678-8ed3-34d27da1e92b
function unfold(row::Row)
	springs = (row.springs * '?')^4 * row.springs
	counts = repeat(row.counts, 5)
	Row(springs, counts)
end

# ╔═╡ ff54e3da-3d1d-48d0-8929-e2f15e3b5320
@memoize Dict function fits(springs, i, count)
	area_under_consideration = springs[i:i+count-1]
	before = i-1
	after = i+count

	before_fits = before == 0 || springs[before] != '#'
	after_fits = after == length(springs)+1 || springs[after] != '#'
	range_fits = all(c -> c == '?' || c == '#', area_under_consideration)
	return before_fits && after_fits && range_fits
end

# ╔═╡ 398138fd-e2e9-48e7-8127-cb74bd32be07
@memoize Dict function possibilities(springs, counts)
	if length(counts) == 1
		return length(
			collect(eachmatch(Regex("[#?]{$(only(counts))}"), springs; overlap=true)))
	elseif length(counts) == 0
		return 0
	end
	
	n = 0
	count1, others... = counts
	for i in 1:(length(springs)-sum(others))
		area_under_consideration = springs[i:i+count1-1]
		before = i-1
		after = i+count1
		if !fits(springs, i, count1)
			continue
		end

		@show nrest = possibilities(springs[i+2:end], others)
		n += nrest
	end
	n
end

# ╔═╡ a9846297-62d9-4c91-8624-ead1565befa9
possibilities(TEST_ROWS[2])

# ╔═╡ 786b82aa-2a86-4513-adc8-a6397b02e004
function part1(input = INPUT)
	rows = parse_input(input)
	sum(possibilities.(rows))
end

# ╔═╡ 31e5f8f8-aeea-4791-828b-16238974cd3d
part1()

# ╔═╡ 00f11318-9bed-48e3-955c-533e243cdf32
UNFOLDED_TEST_ROWS = unfold.(TEST_ROWS);

# ╔═╡ 07a32fb6-e5fb-475f-bc7b-eadadd080366
possibilities(TEST_ROWS[3])

# ╔═╡ 2ca5e67e-7da0-4e2f-bb92-77806214cdd1
possibilities(TEST_ROWS[3].springs, TEST_ROWS[3].counts)

# ╔═╡ a7e79eeb-c3f3-4bcf-bd8c-ea5452464004
unfold(TEST_ROWS[1])

# ╔═╡ 0f1a8fdd-8f68-4acc-860d-7167d505cba7
[1, 2, 3, 4][1:1]

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Combinatorics = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
Memoize = "c03570c3-d221-55d1-a50c-7939bbd78826"

[compat]
Combinatorics = "~1.0.2"
Memoize = "~0.4.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.4"
manifest_format = "2.0"
project_hash = "6b3d5321af7afeb242d702c7e42dffba918a94a5"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.Memoize]]
deps = ["MacroTools"]
git-tree-sha1 = "2b1dfcba103de714d31c033b5dacc2e4a12c7caa"
uuid = "c03570c3-d221-55d1-a50c-7939bbd78826"
version = "0.4.4"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
"""

# ╔═╡ Cell order:
# ╠═bd3edbe0-98ad-11ee-18b0-a390fc510f44
# ╠═3b14e495-eb9a-4134-a6f7-f24d6038425f
# ╠═45587c63-62f6-49a0-a427-8b26931ced6d
# ╠═cb870bba-b04f-4a9c-8148-b9faa0fa1069
# ╠═e07f2b6b-663d-418d-a625-be3f18d15892
# ╠═e2735d97-10fa-47fa-bc68-cc4f50923df8
# ╠═40be14a0-2aa8-4ac8-bc8f-e25f575aa1c0
# ╠═3bca9897-cc78-42a4-9803-117218aad309
# ╠═a9846297-62d9-4c91-8624-ead1565befa9
# ╠═786b82aa-2a86-4513-adc8-a6397b02e004
# ╠═31e5f8f8-aeea-4791-828b-16238974cd3d
# ╠═57371449-0895-4678-8ed3-34d27da1e92b
# ╠═df546810-854c-43f2-92bb-cba0e2df8627
# ╠═ff54e3da-3d1d-48d0-8929-e2f15e3b5320
# ╠═398138fd-e2e9-48e7-8127-cb74bd32be07
# ╠═00f11318-9bed-48e3-955c-533e243cdf32
# ╠═07a32fb6-e5fb-475f-bc7b-eadadd080366
# ╠═2ca5e67e-7da0-4e2f-bb92-77806214cdd1
# ╠═a7e79eeb-c3f3-4bcf-bd8c-ea5452464004
# ╠═0f1a8fdd-8f68-4acc-860d-7167d505cba7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
