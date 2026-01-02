# Working with other packages

Desmos.jl provides integration with several Julia packages through package extensions. This allows you to visualize mathematical objects from various ecosystems directly in Desmos.

## LaTeXStrings.jl

The [LaTeXStrings.jl](https://github.com/JuliaStrings/LaTeXStrings.jl) package provides an easy way to write LaTeX code in Julia.
Desmos.jl supports `LaTeXString` objects directly, allowing you to pass raw LaTeX to Desmos when Julia's expression syntax is not sufficient.

This is particularly useful for:
- Desmos-specific functions that don't have Julia equivalents (like `tone` for audio)
- Advanced notation that would be cumbersome to express in Julia syntax
- Fine-tuning the exact LaTeX output when needed

```@example latexstrings
using Desmos, LaTeXStrings
set_desmos_display_config(width=0,height=400,clipboard=false,api_version=10,api_key="dcb31709b452b1cf9dc26972add0fda6") # hide

ex1 = L"\sin(x)"
ex2 = L"\frac{d}{dx}\left(x^2\right)"
ex3 = L"\operatorname{tone}\left(440\right)"  # Desmos audio function (no Julia equivalent)

state = @desmos begin
    @text "LaTeXStrings example"
    @expression $ex1
    @expression $ex2 color = RGB(1,0,0)
    @expression $ex3
end
```

## Symbolics.jl

The [Symbolics.jl](https://github.com/JuliaSymbolics/Symbolics.jl) package provides a computer algebra system (CAS) for Julia.
Desmos.jl can convert symbolic expressions to Desmos-compatible LaTeX, enabling you to visualize symbolic computations.

```@example symbolics
using Desmos, Symbolics
set_desmos_display_config(width=0,height=400,clipboard=false,api_version=10,api_key="dcb31709b452b1cf9dc26972add0fda6") # hide

@variables x y
ex1 = sin(7x)^2 + x^2 - 4cos(x)
ex2 = (x + y)^6 / (x - y)^4 == 1
ex3 = Differential(x)(ex1)

state = @desmos begin
    @text "Symbolics.jl integration"
    @expression $ex1 color = "#888800"
    @expression $ex2 color = "#008888"
    @expression $ex3 color = "#880088"
end
```

## QuadraticOptimizer.jl

The [QuadraticOptimizer.jl](https://github.com/hyrodium/QuadraticOptimizer.jl) package provides efficient representations of quadratic functions.
Desmos.jl can visualize these quadratic forms directly.

```@example quadratic
using Desmos, QuadraticOptimizer
set_desmos_display_config(width=0,height=400,clipboard=false,api_version=10,api_key="dcb31709b452b1cf9dc26972add0fda6") # hide

q1 = Quadratic{1}([2.0], [3.0], 1.0)
q2 = Quadratic{2}([1.0, 2.0, 3.0], [4.0, 5.0], 6.0)

state = @desmos begin
    @text "1D Quadratic"
    @expression $(q1) color = "#555555"
    @text "2D Quadratic"
    @expression $(q2) = 0 color = "#bbbbbb"
end
```

## JuMP.jl

!!! warning "Work in Progress"
    JuMP.jl integration is currently under development. The following features may be incomplete or subject to change.

The [JuMP.jl](https://github.com/jump-dev/JuMP.jl) package is a modeling language for mathematical optimization.
Desmos.jl provides basic support for visualizing two-dimensional JuMP optimization problems.

When you create a `DesmosState` from a JuMP model, it visualizes:
- The feasible region defined by the constraints
- Objective function level curve(s)
- Solution point (if the model has been solved)
- Parameters with sliders (if using JuMP parameters)

### Basic usage

To plot a JuMP model in Desmos, first create a model with two decision variables, then pass it to `Desmos.DesmosState`:

```@example jump
using Desmos, IntervalSets
using JuMP
set_desmos_display_config(width=0,height=400,clipboard=false,api_version=10,api_key="dcb31709b452b1cf9dc26972add0fda6") # hide

m = Model()

@variable   m  x₁
@variable   m  x₂

@variable   m  p ∈ Parameter(5/4)
@variable   m  a ∈ Parameter(1/2)
@variable   m  b ∈ Parameter(3/2)

@constraint m       abs(x₁)^p + abs(x₂)^p ≤ 1
@objective  m  Min     a * x₁ + b * x₂

state = Desmos.DesmosState(m)
```

### Parametric solutions
You can also pass closed-form solution expressions in terms of the parameters, so the solution point and objective level updates with the sliders:
```@example jump
q = p / (p - 1)
denom = (abs(a)^q + abs(b)^q)^(1 / q)
solution = Dict(
    x₁ => -sign(a) * (abs(a) / denom)^(q - 1),
    x₂ => -sign(b) * (abs(b) / denom)^(q - 1),
)

state2 = Desmos.DesmosState(m,
    parameter_ranges = Dict(p => 1..3),
    parametric_solution = solution,
)
```

## Your package

You can add Desmos.jl support to your own package by implementing the `desmos_latexify` method.
This allows your custom types to be seamlessly integrated into Desmos visualizations.

### Practical example: `OpenDisks.jl`

Here's a complete example showing how to add Desmos.jl support to a custom package for visualizing open disks in the plane:

```@example OpenDisks
# src/OpenDisks.jl
module OpenDisks

using Desmos

struct OpenDisk
    center_x::Float64
    center_y::Float64
    radius::Float64
end

# This method may live in `ext/OpenDisksDesmosExt.jl`
function Desmos.desmos_latexify(disk::OpenDisks.OpenDisk)
    cx = disk.center_x
    cy = disk.center_y
    r = disk.radius
    return "\\left(x-$cx\\right)^{2}+\\left(y-$cy\\right)^{2}<$r^{2}"
end

end # module
```

With this implementation, users can visualize `OpenDisk` objects directly in Desmos:

```@example OpenDisks
using Desmos
# using OpenDisks

disk_r = OpenDisks.OpenDisk(-√3, -1, 1.5)
disk_g = OpenDisks.OpenDisk(0, 2, 1.5)
disk_p = OpenDisks.OpenDisk(√3, -1, 1.5)

@desmos begin
    @text "Julia logo"
    @expression $disk_r color = "#CB3C33"
    @expression $disk_g color = "#389826"
    @expression $disk_p color = "#9558B2"
end
```

### Guidelines for extension authors

1. **The `oneterm` parameter**: When `oneterm=true`, wrap multi-term expressions in `\left( \right)` to ensure proper precedence in compound expressions (e.g., when used as an exponent base or function argument).

2. **Error handling**: Throw `Desmos.UnsupportedDesmosSyntaxError` for features that cannot be represented in Desmos LaTeX.

3. **Testing**: Add tests to verify your LaTeX output is valid Desmos syntax. See `test/latexify.jl` in Desmos.jl for examples.

4. **Package extensions**: Use package extensions to minimize loading overhead.

See the existing extensions in Desmos.jl's `ext/` directory for complete implementation examples.
