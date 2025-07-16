using BigRiverMakie
using Documenter
using DocumenterVitepress

makedocs(;
    modules = [BigRiverMakie],
    authors = "Abhirath Anand <74202102+theabhirath@users.noreply.github.com> and contributors",
    sitename = "BigRiverMakie.jl",
    format = DocumenterVitepress.MarkdownVitepress(
        repo = "https://github.com/senresearch/BigRiverMakie.jl",
    ),
    pages = [
        "Home" => "index.md",
        "Confidence Interval Plot" => "confidence.md",
        "Dot Plot" => "dotplot.md"
    ]
)

DocumenterVitepress.deploydocs(;
    repo = "github.com/senresearch/BigRiverMakie.jl",
    target = "build",
    devbranch = "main",
    branch = "gh-pages",
    push_preview = true
)
