# Desmos.jl
Generate Desmos script (JSON) with Julia language.

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://hyrodium.github.io/Desmos.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://hyrodium.github.io/Desmos.jl/dev)
[![Build Status](https://github.com/hyrodium/Desmos.jl/workflows/CI/badge.svg)](https://github.com/hyrodium/Desmos.jl/actions?query=workflow%3ACI+branch%3Amain)
[![codecov](https://codecov.io/gh/hyrodium/Desmos.jl/branch/main/graph/badge.svg?token=dJBiR91dCD)](https://codecov.io/gh/hyrodium/Desmos.jl)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

## First example
```@example
using Desmos

state = @desmos begin
    @text "First example"
    @expression cos(x) color=RGB(0, 0.5, 1) color="#f0f"
    @expression (cosh(t), sinh(t)) parametric_domain=-2..3
end
```

On vscode, the output plot will be shown in the plot pane.

![](vscode.png)
