var documenterSearchIndex = {"docs":
[{"location":"examples/#Examples","page":"Examples","title":"Examples","text":"","category":"section"},{"location":"examples/#Basic-function-definitions","page":"Examples","title":"Basic function definitions","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"using Desmos, JSON\nstate = @desmos begin\n    @note \"Trigonometric functions\"\n    @expression cos(x) color=RGB(1,0,0)\n    @expression sin(x) color=RGB(0,0,1)\n    tan(x)\n    @expression cot(x) lines=false\nend\njson = JSON.json(state)\nname = \"BasicFunctions\"  # hide\ndir_src = abspath(joinpath(dirname(@__DIR__), \"src\"))  # hide\ndir_build = abspath(joinpath(dirname(@__DIR__), \"build\"))  # hide\npath_base = joinpath(dir_src, \"example_base.html\")  # hide\npath = joinpath(dir_build, \"example_$(name).html\")  # hide\nscript = read(path_base, String)  # hide\nscript = replace(script, \"NAME\"=>name, \"//STATE\"=>json)  # hide\nwrite(path, script)  # hide\nnothing  # hide","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"<object type=\"text/html\" data=\"../example_BasicFunctions.html\" style=\"width:100%;height:420px;\"></object>","category":"page"},{"location":"examples/#Variable-definitions","page":"Examples","title":"Variable definitions","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"using Desmos, JSON\nb = 3\nstate = @desmos begin\n    a = 4\n    @variable b = 5 2..6\n    @variable c = 5 1:8\n    @variable d = 7\n    $(2+2)\n    sin($(2b)*a-cx)\nend\njson = JSON.json(state)\nname = \"VariableDefinitions\"  # hide\ndir_src = abspath(joinpath(dirname(@__DIR__), \"src\"))  # hide\ndir_build = abspath(joinpath(dirname(@__DIR__), \"build\"))  # hide\npath_base = joinpath(dir_src, \"example_base.html\")  # hide\npath = joinpath(dir_build, \"example_$(name).html\")  # hide\nscript = read(path_base, String)  # hide\nscript = replace(script, \"NAME\"=>name, \"//STATE\"=>json)  # hide\nwrite(path, script)  # hide\nnothing  # hide","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"<object type=\"text/html\" data=\"../example_VariableDefinitions.html\" style=\"width:100%;height:420px;\"></object>","category":"page"},{"location":"examples/#Newton's-method","page":"Examples","title":"Newton's method","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"using Desmos, JSON\nurl_img = \"https://raw.githubusercontent.com/hyrodium/Visualize2dimNewtonMethod/b3fcb1f935439d671e3ddb3eb3b19fd261f6b067/example1a.png\"\nstate = @desmos begin\n    f(x,y) = x^2+y^2-3.9-x/2\n    g(x,y) = x^2-y^2-2\n    @expression 0=f(x,y) color=Gray(0.3)\n    @expression 0=g(x,y) color=Gray(0.6)\n    f_x(x,y)=(d/dx)(f(x,y))\n    f_y(x,y)=(d/dy)(f(x,y))\n    g_x(x,y)=(d/dx)(g(x,y))\n    g_y(x,y)=(d/dy)(g(x,y))\n    d(x,y)=f_x(x,y)*g_y(x,y)-f_y(x,y)*g_x(x,y)\n    A(x,y)=x-(g_y(x,y)*f(x,y)-f_y(x,y)*g(x,y))/d(x,y)\n    B(x,y)=y-(-g_x(x,y)*f(x,y)+f_x(x,y)*g(x,y))/d(x,y)\n    @folder \"Point sequence\" begin\n        a₀=1\n        b₀=1\n        a₁=A(a₀,b₀)\n        b₁=B(a₀,b₀)\n        a₂=A(a₁,b₁)\n        b₂=B(a₁,b₁)\n        a₃=A(a₂,b₂)\n        b₃=B(a₂,b₂)\n        a₄=A(a₃,b₃)\n        b₄=B(a₃,b₃)\n        a₅=A(a₄,b₄)\n        b₅=B(a₄,b₄)\n        a₆=A(a₅,b₅)\n        b₆=B(a₅,b₅)\n        @expression L\"a = [a_{0},a_{1},a_{2},a_{3},a_{4},a_{5},a_{6}]\"\n        @expression L\"b = [b_{0},b_{1},b_{2},b_{3},b_{4},b_{5},b_{6}]\"\n        (a₀,b₀)\n        (a,b)\n    end\n    @image $url_img width=20 height=20\nend\njson = JSON.json(state)\nname = \"NewtonMethod\"  # hide\ndir_src = abspath(joinpath(dirname(@__DIR__), \"src\"))  # hide\ndir_build = abspath(joinpath(dirname(@__DIR__), \"build\"))  # hide\npath_base = joinpath(dir_src, \"example_base.html\")  # hide\npath = joinpath(dir_build, \"example_$(name).html\")  # hide\nscript = read(path_base, String)  # hide\nscript = replace(script, \"NAME\"=>name, \"//STATE\"=>json)  # hide\nwrite(path, script)  # hide\nnothing  # hide","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"<object type=\"text/html\" data=\"../example_NewtonMethod.html\" style=\"width:100%;height:420px;\"></object>","category":"page"},{"location":"#Desmos.jl","page":"Home","title":"Desmos.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Generate Desmos script (JSON) with Julia language.","category":"page"},{"location":"","page":"Home","title":"Home","text":"(Image: Stable) (Image: Dev) (Image: Build Status) (Image: codecov) (Image: Aqua QA)","category":"page"},{"location":"#First-example","page":"Home","title":"First example","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"using Desmos, JSON\nstate = @desmos begin\n    @expression cos(x) color=RGB(1,0,0)\n    @expression sin(x) color=RGB(0,0,1)\n    tan(x)\nend\nclipboard(JSON.json(state, 4))","category":"page"},{"location":"","page":"Home","title":"Home","text":"<video controls>\n  <source src=\"https://user-images.githubusercontent.com/7488140/227839138-7aabfb64-3be1-4ef6-88f8-543c9fc5421a.mp4\" type=\"video/mp4\">\n</video>","category":"page"},{"location":"#Desmos-Text-I/O","page":"Home","title":"Desmos Text I/O","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Note that this package requires Desmos Text I/O extension.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Chrome Web Store\nFirefox ADD-ONS","category":"page"}]
}
