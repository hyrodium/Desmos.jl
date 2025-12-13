# Desmos.jl
Unofficial Julia package for Desmos.

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://hyrodium.github.io/Desmos.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://hyrodium.github.io/Desmos.jl/dev)
[![Build Status](https://github.com/hyrodium/Desmos.jl/workflows/CI/badge.svg)](https://github.com/hyrodium/Desmos.jl/actions?query=workflow%3ACI+branch%3Amain)
[![codecov](https://codecov.io/gh/hyrodium/Desmos.jl/branch/main/graph/badge.svg?token=dJBiR91dCD)](https://codecov.io/gh/hyrodium/Desmos.jl)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
[![code style: runic](https://img.shields.io/badge/code_style-%E1%9A%B1%E1%9A%A2%E1%9A%BE%E1%9B%81%E1%9A%B2-black)](https://github.com/fredrikekre/Runic.jl)

## First example
```julia
using Desmos

state = @desmos begin
    @text "First example"
    @expression cos(x) color=RGB(0, 0.5, 1) color="#f0f"
    @expression (cosh(t), sinh(t)) parametric_domain=-2..3
end
```

![](docs/src/vscode.png)

See [documentation](https://hyrodium.github.io/Desmos.jl/dev/) for more information.

## Desmos Text I/O
You can also use [Desmos Text I/O extension](https://github.com/hyrodium/DesmosTextIO) to import/export the desmos-graph.

[![](https://raw.githubusercontent.com/hyrodium/desmos-text-io/main/logo.svg)](https://github.com/hyrodium/DesmosTextIO)

* [Chrome Web Store](https://chrome.google.com/webstore/detail/desmos-text-io/ndjdcebpigpfidnilppdpcdkibidfmaa)
* [Firefox ADD-ONS](https://addons.mozilla.org/en-US/firefox/addon/desmos-text-i-o/)
