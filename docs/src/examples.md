# Examples

## Basic function definitions
```@example
using Desmos, JSON
state = @desmos begin
    @note "Trigonometric functions"
    @expression cos(x) color=RGB(1,0,0)
    @expression sin(x) color=RGB(0,0,1)
    tan(x)
end
json = JSON.json(state)
name = "BasicFunctions"  # hide
dir_src = abspath(joinpath(dirname(@__DIR__), "src"))  # hide
dir_build = abspath(joinpath(dirname(@__DIR__), "build"))  # hide
path_base = joinpath(dir_src, "example_base.html")  # hide
path = joinpath(dir_build, "example_$(name).html")  # hide
script = read(path_base, String)  # hide
script = replace(script, "NAME"=>name, "//STATE"=>json)  # hide
write(path, script)  # hide
nothing  # hide
```

```@raw html
<object type="text/html" data="../example_BasicFunctions.html" style="width:100%;height:420px;"></object>
```

## Variable definitions
```@example
using Desmos, JSON
b = 3
state = @desmos begin
    a = 4
    @variable b = 5 2..6
    @variable c = 5 1:8
    @variable d = 7
    $(2+2)
    sin($(2b)*a-cx)
end
json = JSON.json(state)
name = "VariableDefinitions"  # hide
dir_src = abspath(joinpath(dirname(@__DIR__), "src"))  # hide
dir_build = abspath(joinpath(dirname(@__DIR__), "build"))  # hide
path_base = joinpath(dir_src, "example_base.html")  # hide
path = joinpath(dir_build, "example_$(name).html")  # hide
script = read(path_base, String)  # hide
script = replace(script, "NAME"=>name, "//STATE"=>json)  # hide
write(path, script)  # hide
nothing  # hide
```

```@raw html
<object type="text/html" data="../example_VariableDefinitions.html" style="width:100%;height:420px;"></object>
```

## Newton's method
```@example
using Desmos, JSON
url_img = "https://raw.githubusercontent.com/hyrodium/Visualize2dimNewtonMethod/b3fcb1f935439d671e3ddb3eb3b19fd261f6b067/example1a.png"
state = @desmos begin
    f(x,y) = x^2+y^2-3.9-x/2
    g(x,y) = x^2-y^2-2
    @expression 0=f(x,y) color=Gray(0.3)
    @expression 0=g(x,y) color=Gray(0.6)
    f_x(x,y)=(d/dx)(f(x,y))
    f_y(x,y)=(d/dy)(f(x,y))
    g_x(x,y)=(d/dx)(g(x,y))
    g_y(x,y)=(d/dy)(g(x,y))
    d(x,y)=f_x(x,y)*g_y(x,y)-f_y(x,y)*g_x(x,y)
    A(x,y)=x-(g_y(x,y)*f(x,y)-f_y(x,y)*g(x,y))/d(x,y)
    B(x,y)=y-(-g_x(x,y)*f(x,y)+f_x(x,y)*g(x,y))/d(x,y)
    @folder "Point sequence" begin
        a₀=1
        b₀=1
        a₁=A(a₀,b₀)
        b₁=B(a₀,b₀)
        a₂=A(a₁,b₁)
        b₂=B(a₁,b₁)
        a₃=A(a₂,b₂)
        b₃=B(a₂,b₂)
        a₄=A(a₃,b₃)
        b₄=B(a₃,b₃)
        a₅=A(a₄,b₄)
        b₅=B(a₄,b₄)
        a₆=A(a₅,b₅)
        b₆=B(a₅,b₅)
        @raw_expression L"a = [a_{0},a_{1},a_{2},a_{3},a_{4},a_{5},a_{6}]"
        @raw_expression L"b = [b_{0},b_{1},b_{2},b_{3},b_{4},b_{5},b_{6}]"
        (a₀,b₀)
        (a,b)
    end
    @image $url_img width=20 height=20
end
json = JSON.json(state)
name = "NewtonMethod"  # hide
dir_src = abspath(joinpath(dirname(@__DIR__), "src"))  # hide
dir_build = abspath(joinpath(dirname(@__DIR__), "build"))  # hide
path_base = joinpath(dir_src, "example_base.html")  # hide
path = joinpath(dir_build, "example_$(name).html")  # hide
script = read(path_base, String)  # hide
script = replace(script, "NAME"=>name, "//STATE"=>json)  # hide
write(path, script)  # hide
nothing  # hide
```

```@raw html
<object type="text/html" data="../example_NewtonMethod.html" style="width:100%;height:420px;"></object>
```
