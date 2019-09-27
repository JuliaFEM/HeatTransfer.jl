# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/HeatTransfer.jl/blob/master/LICENSE

using Pkg, Documenter, HeatTransfer, Literate, Dates

# automatically generate documentation from tests

"""
    update_datetime(content)

Replace DATETIMEOFTODAY with current datetime.
"""
function update_datetime(content)
    content = replace(content, "DATETIMEOFTODAY" => DateTime(now()))
    return content
end

"""
    add_datetime(content)

Add page generation time to the end of the content.
"""
function add_datetime(content)
    line =  "\n# Page generated at " * string(DateTime(now())) * "."
    content = content * line
    println(content)
    return content
end

"""
    remove_license(content)

Remove licence strings from source file.
"""
function remove_license(content)
    # return replace(content, r"# This file is a part of JuliaFEM.*?\n\n"sm, "")
    lines = split(content, '\n')
    function islicense(line)
        occursin("# This file is a part of JuliaFEM.", line) && return false
        occursin("# License is MIT:", line) && return false
        return true
    end
    content = join(filter(islicense, lines), '\n')
    return content
end

function generate_docs()

    function preprocess(content)
        content = add_datetime(content)
        content = remove_license(content)
    end

    pkg_dir = dirname(dirname(pathof(HeatTransfer)))
    testdir = joinpath(pkg_dir, "test")
    outdir = joinpath(pkg_dir, "docs", "src", "tests")
    test_pages = []
    for test_file in readdir(testdir)
        startswith(test_file, "test_") || continue
        Literate.markdown(joinpath(testdir, test_file), outdir; documenter=true, preprocess=preprocess)
        generated_test_file = joinpath("tests", first(splitext(test_file)) * ".md")
        push!(test_pages, generated_test_file)
    end
    return test_pages

end

test_pages = generate_docs()

makedocs(modules=[HeatTransfer],
         format = Documenter.HTML(),
         checkdocs = :all,
         sitename = "HeatTransfer.jl",
         pages = [
                  "index.md",
                  "Examples" => test_pages
                 ]
        )
