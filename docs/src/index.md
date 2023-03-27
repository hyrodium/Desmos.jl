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
    @expression cos(x) color=RGB(1,0,0)
    @expression sin(x) color=RGB(0,0,1)
    tan(x)
end
clipboard(JSON.json(state, 4))
```

```@raw html
<video controls>
  <source src="https://user-images.githubusercontent.com/7488140/227839138-7aabfb64-3be1-4ef6-88f8-543c9fc5421a.mp4" type="video/mp4">
</video>
```

## Desmos Text I/O

Note that this package requires [Desmos Text I/O extension](https://github.com/hyrodium/DesmosTextIO).

* [Chrome Web Store](https://chrome.google.com/webstore/detail/desmos-text-io/ndjdcebpigpfidnilppdpcdkibidfmaa)
* [Firefox ADD-ONS](https://addons.mozilla.org/en-US/firefox/addon/desmos-text-i-o/)
