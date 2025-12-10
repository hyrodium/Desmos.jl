# Desmos.jl
Generate Desmos script (JSON) with Julia language.

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://hyrodium.github.io/Desmos.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://hyrodium.github.io/Desmos.jl/dev)
[![Build Status](https://github.com/hyrodium/Desmos.jl/workflows/CI/badge.svg)](https://github.com/hyrodium/Desmos.jl/actions?query=workflow%3ACI+branch%3Amain)
[![codecov](https://codecov.io/gh/hyrodium/Desmos.jl/branch/main/graph/badge.svg?token=dJBiR91dCD)](https://codecov.io/gh/hyrodium/Desmos.jl)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

## First example
```julia
using Desmos, JSON

state = @desmos begin
    @text "Trigonometric functions"
    @expression cos(x) color=RGB(0, 0.5, 1)
    tan(x)
    @expression cot(x) lines=false
    @expression (cosh(t), sinh(t)) parametric_domain=-2..3 color="#f0f"
end
```

![](docs/src/vscode.png)

See [documentation](https://hyrodium.github.io/Desmos.jl/dev/) for more information.

## Desmos Text I/O
You can also use [Desmos Text I/O extension](https://github.com/hyrodium/DesmosTextIO) to import/export the desmos-graph.

[![](https://raw.githubusercontent.com/hyrodium/desmos-text-io/main/logo.svg)](https://github.com/hyrodium/DesmosTextIO)

* [Chrome Web Store](https://chrome.google.com/webstore/detail/desmos-text-io/ndjdcebpigpfidnilppdpcdkibidfmaa)
* [Firefox ADD-ONS](https://addons.mozilla.org/en-US/firefox/addon/desmos-text-i-o/)

## TODO

- [ ] Add support for folders
- [ ] Add support for more fields
- [ ] Add support for actions
- [ ] Add support for 3D plot
- [ ] Add support for tables
- [ ] Add support for ticker
- [ ] Add support for API versioning
