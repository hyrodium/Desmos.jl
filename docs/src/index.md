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
set_desmos_display_config(width=0,height=400,clipboard=false,api_version=10,api_key="dcb31709b452b1cf9dc26972add0fda6") # hide

state = @desmos begin
    @text "First example"
    @expression cos(x) color=RGB(0, 0.5, 1) color="#f0f"
    @expression (cosh(t), sinh(t)) parametric_domain=-2..3
end
```

On vscode, the output plot will be shown in the plot pane.

![](vscode.png)

On Pluto.jl, the output plot will be shown above the code.

![](pluto.png)

On Jupyter, the output plot will be shown in the output cell.

![](jupyter.png)

## Overview of the document

- [Home](index.md)
  - This page introduces Desmos.jl and shows a first example of creating Desmos graphs.
- [Working with Desmos Text I/O](desmos-text-io.md)
  - [Desmos Text I/O](https://github.com/hyrodium/desmos-text-io) browser extension enables importing and exporting Desmos graphs as text/JSON.
  - [`clipboard_desmos_state`](@ref) function allows transferring graphs between Julia and the Desmos web interface.
- [Display Configuration](config.md)
  - Configuration options to customize how graphs are displayed in plot panes.
  - Options include width, height, clipboard export button, API version, and API key.
- [Function Compatibility](function-compatibility.md)
  - How Julia expressions are translated to Desmos LaTeX format.
  - Design principles, function mappings, and common pitfalls.
- [Working with Other Packages](package-integration.md)
  - Integration with LaTeXStrings.jl, Symbolics.jl, QuadraticOptimizer.jl, JuMP.jl, etc.
  - How to extend Desmos.jl to support your own types.
- [Example Gallery](examples.md)
  - Examples including basic functions, variable definitions, and Newton's method visualization.
- [Desmos.jl API](api.md)
  - Complete API reference for public and private functions, macros, etc.
- [License](license.md)
  - MIT License for Desmos.jl and notes about Desmos API usage terms.
