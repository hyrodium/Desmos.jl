# Function Compatibility

This page describes how Julia expressions are translated to Desmos LaTeX format, and explains the design principles behind the conversion.

## Design Principles

Desmos.jl converts Julia `Expr` objects to LaTeX strings that Desmos understands. The conversion follows these principles:

1. **Natural Julia Syntax**: Write mathematical expressions using standard Julia syntax, and let Desmos.jl handle the LaTeX conversion automatically.

2. **Standard Library Mapping**: Function names from Julia's standard library and common packages are mapped to their Desmos equivalents. For example:
    - `log(x)` → `\ln(x)` (natural logarithm)
    - `sum(xs)` → `\operatorname{total}(xs)`
    - `length(xs)` → `\operatorname{count}(xs)`

3. **Subscript Convention**: Multi-character identifiers are converted to subscripted notation:
    - `xy` → `x_{y}` (subscript, not multiplication)
    - `x1` → `x_{1}`
    - `θ₁` → `\theta_{1}`

This subscript behavior means that `xy` is treated as a single variable "x with subscript y", not as "x times y". Use `x*y` for multiplication.

## Examples

Here's a practical example demonstrating how Julia expressions are automatically converted to Desmos notation:

```@example
using Desmos
set_desmos_display_config(width=0, height=600, clipboard=false, api_version=10, api_key="dcb31709b452b1cf9dc26972add0fda6") # hide

# Create a graph with various mathematical expressions
@desmos begin
    sin(x)
    a1 = 2
    gradient(sin(a1*x), x)
    sum(n^2 for n in 1:5)
    sum([n^2 for n in 1:5])
end
```

This example shows:
- Function mapping: `sin(x)` → Desmos trigonometric function `\sin(x)`
- Multi-character variables: `a1` → `a_{1}` (subscripted)
- Derivative notation: `gradient(sin(a1*x), x)` → `\frac{d}{dx}\sin(a_{1}x)`
- Summation with generator: `sum(n^2 for n in 1:5)` → `\sum_{n=1}^{5}n^{2}`
- List operations: `sum([...])` → `\operatorname{total}([...])`

## The `desmos_latexify` Function

The [`desmos_latexify`](@ref) function is the core of the conversion system. It takes a Julia expression and returns a `LaTeXString`:

```@repl
using Desmos

# Basic arithmetic
desmos_latexify(:(x + y))
desmos_latexify(:(x * y))
desmos_latexify(:(x / y))
desmos_latexify(:(x^2))

# Functions
desmos_latexify(:(sin(x)))
desmos_latexify(:(log(x)))
desmos_latexify(:(sqrt(x)))

# Multi-character identifiers become subscripts
desmos_latexify(:(x1))
desmos_latexify(:(xy))
desmos_latexify(:(x_max))

# Greek letters
desmos_latexify(:(α + β))
desmos_latexify(:(θ₁))
```

## Common Function Mappings

### Trigonometric Functions

Julia's standard trigonometric functions are mapped to Desmos's LaTeX notation:

```@repl
using Desmos

desmos_latexify(:(sin(x)))
desmos_latexify(:(asin(x)))  # arcsin
desmos_latexify(:(sinh(x)))
```

### Logarithms and Exponents

```@repl
using Desmos

desmos_latexify(:(log(x)))      # Natural log: ln(x)
desmos_latexify(:(log(2, x)))   # Log base 2
desmos_latexify(:(log10(x)))    # Log base 10
desmos_latexify(:(exp(x)))
```

### Statistical Functions

```@repl
using Desmos

desmos_latexify(:(mean(xs)))
desmos_latexify(:(sum(xs)))      # → total(xs)
desmos_latexify(:(length(xs)))   # → count(xs)
```

## Special Desmos.jl Functions

Some functions are specific to Desmos.jl and don't exist in Julia's standard library:

### Derivatives: `gradient`

The `gradient(expr, var)` function creates derivative notation:

```@repl
using Desmos

desmos_latexify(:(gradient(f(x), x)))
desmos_latexify(:(gradient(x^2 + y^2, x)))
```

### Integrals: `integrate`

Use `integrate` with a generator expression for definite integrals:

```@repl
using Desmos

desmos_latexify(:(integrate(x^2 for x in 1..5)))
desmos_latexify(:(integrate(sin(t) for t in 0..π)))
```

### Summation and Products

Generator expressions work with `sum` and `prod`:

```@repl
using Desmos

desmos_latexify(:(sum(n^2 for n in 1:10)))
desmos_latexify(:(prod(n for n in 1:5)))
```

## Probability Distributions

Desmos.jl provides distribution constructors that map to Desmos's distribution functions:

```@repl
using Desmos

desmos_latexify(:(Normal(0, 1)))
desmos_latexify(:(Uniform(0, 1)))
desmos_latexify(:(Binomial(10, 0.5)))
```

These constructors are designed to be compatible with [`Distributions.jl`](https://juliastats.org/Distributions.jl/stable/) naming conventions, but no `using Distributions` is required—Desmos.jl defines its own constructors that generate the appropriate Desmos syntax.

## Common Pitfalls

### 1. Multi-character Variables

```@repl
using Desmos

# This is NOT x times y:
desmos_latexify(:(xy))

# For multiplication, use *:
desmos_latexify(:(x * y))
```

### 2. Division as Fractions

Division is always converted to fraction notation:

```@repl
using Desmos

desmos_latexify(:(a / b))
```

### 3. Unsupported Operators

Some operators are not supported by Desmos:

```@repl
using Desmos

# This will throw an error:
desmos_latexify(:(x != y))  # Error: \ne not supported
```

### 4. Greek Letters in Subscripts

Greek letters are not allowed in subscripts:

```@repl
using Desmos

# This will throw an error:
desmos_latexify(:(xα))  # Error: Greek letters not allowed in subscripts

# Use alphabets or digits for subscripts:
desmos_latexify(:(x1))
```

## List Comprehensions

Julia's list comprehension syntax is converted to Desmos's list comprehension:

```@repl
using Desmos

desmos_latexify(:([x^2 for x in xs]))
desmos_latexify(:([sin(t) for t in 0:10]))
```

## Vectors and Tuples

```@repl
using Desmos

# Vectors use square brackets:
desmos_latexify(:([1, 2, 3]))

# Tuples use parentheses (useful for parametric expressions):
desmos_latexify(:((cos(t), sin(t))))
```

## Conditional Expressions

Use `ifelse` for conditional expressions:

```@repl
using Desmos

desmos_latexify(:(ifelse(x > 0, x, -x)))
```

This generates Desmos's piecewise notation.

## Custom Functions

For functions not in the standard mapping, Desmos.jl generates generic function notation:

```@repl
using Desmos

# Custom function definition:
desmos_latexify(:(f(x) = x^2 + 1))

# Custom function call:
desmos_latexify(:(myFunc(a, b)))
```

## Tips for Effective Usage

1. **Use explicit multiplication**: Write `x * y` instead of relying on implicit multiplication, especially when working with single-letter variables.

2. **Leverage Unicode**: Julia's Unicode support works great with Desmos. Use `α`, `β`, `θ`, etc., and Unicode subscripts like `₁`, `₂`.

3. **Check conversions**: Use `desmos_latexify` directly to verify how your expressions will be converted.

4. **Standard library functions**: Prefer standard Julia functions (e.g., `sum`, `mean`) over custom implementations, as they have proper mappings to Desmos functions.

## Using LaTeX Strings Directly

If you need to input LaTeX expressions directly without conversion, you can use `LaTeXStrings.jl`:

```@example
using Desmos
using LaTeXStrings
set_desmos_display_config(width=0, height=400, clipboard=false, api_version=10, api_key="dcb31709b452b1cf9dc26972add0fda6") # hide

# Direct LaTeX input using the L"..." string macro
myexpression = L"\sin(x)"
@desmos begin
    @expression $myexpression
end
```

This is useful when:
- You need specific LaTeX formatting that differs from the automatic conversion
- You're working with complex expressions that are easier to write directly in LaTeX
- You want to ensure exact control over the rendered output

Note that `desmos_latexify` also accepts `LaTeXString` inputs and will pass them through without modification (after removing the `$` delimiters if present).
