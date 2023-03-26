# Desmos.jl
Generate Desmos script (JSON) with Julia language.


[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://hyrodium.github.io/Desmos.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://hyrodium.github.io/Desmos.jl/dev)
[![Build Status](https://github.com/hyrodium/Desmos.jl/workflows/CI/badge.svg)](https://github.com/hyrodium/Desmos.jl/actions?query=workflow%3ACI+branch%3Amain)
[![codecov](https://codecov.io/gh/hyrodium/Desmos.jl/branch/main/graph/badge.svg?token=dJBiR91dCD)](https://codecov.io/gh/hyrodium/Desmos.jl)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

# Example
```julia
using Desmos
using JSON

state = @desmos begin
    a = 5
    @variable b = 1.5 -4:0.5:2
    @variable γ₁₃ = 0.2 -0.5..1
    3
    (a,b)
    @expression f(x) = sin(a/x) color=RGB(1,0,0)
    @expression g(x) = x*(b/a) color=RGB(0,1,0.5)
    sin(y)*cos(x) - γ₁₃ = 0
    a*b
end
clipboard(JSON.json(state))
```
![](docs/src/img/screenshot.gif)

Note that this package requires [Desmos Text I/O extension](https://github.com/hyrodium/DesmosTextIO).

* [Chrome Web Store](https://chrome.google.com/webstore/detail/desmos-text-io/ndjdcebpigpfidnilppdpcdkibidfmaa)
* [Firefox ADD-ONS](https://addons.mozilla.org/en-US/firefox/addon/desmos-text-i-o/)
