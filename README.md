# Desmos.jl
Generate Desmos script (JSON) with Julia language.

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
    @color f(x) = sin(a/x) RGB(1,0,0)
    @color g(x) = x*(b/a) RGB(0,1,0.5)
    sin(y)*cos(x) - γ₁₃ = 0
    a*b
end
clipboard(JSON.json(state))
```
![](docs/src/img/screenshot.gif)

Note that this package requires [Desmos Text I/O extension](https://github.com/hyrodium/DesmosTextIO).

* [Chrome Web Store](https://chrome.google.com/webstore/detail/desmos-text-io/ndjdcebpigpfidnilppdpcdkibidfmaa)
* [Firefox ADD-ONS](https://addons.mozilla.org/en-US/firefox/addon/desmos-text-i-o/)
