# Examples

## Basic function definitions
```@example
using Desmos, Colors
set_desmos_display_config(width=600,height=400,clipboard=false,api_version=10,api_key="dcb31709b452b1cf9dc26972add0fda6") # hide
state = @desmos begin
    @text "Trigonometric functions"
    @expression cos(x) color = $(RGB(1,0,0))
    @expression sin(x) color = $RGB(0,0,1)
    tan(x)
    @expression cot(x) hidden = true
    @expression (cosh(t), sinh(t)) parametric_domain = -2..3
end
```

## Variable definitions
```@example
using Desmos
set_desmos_display_config(width=600,height=400,clipboard=false,api_version=10,api_key="dcb31709b452b1cf9dc26972add0fda6") # hide
b = 3
state = @desmos begin
    a = 4
    @expression b = 5 slider = 2..6
    @expression c = 5 slider = 1:8
    @expression d = 7
    $(2+2)
    sin($(2b)*a-c*x)
end
```

## Newton's method
This example may not work correctly in Firefox.
Please try running code with [julia-vscode](https://github.com/julia-vscode/julia-vscode) or [desmos-text-io](https://github.com/hyrodium/desmos-text-io) if you encounter any problems.
```@example
using Desmos
set_desmos_display_config(width=600,height=400,clipboard=false,api_version=10,api_key="dcb31709b452b1cf9dc26972add0fda6") # hide
image_url = "https://raw.githubusercontent.com/hyrodium/Visualize2dimNewtonMethod/b3fcb1f935439d671e3ddb3eb3b19fd261f6b067/example1a.png"
state = @desmos begin
    f(x,y) = x^2+y^2-3.9-x/2
    g(x,y) = x^2-y^2-2
    @expression 0 = f(x,y) color = Gray(0.3)
    @expression 0 = g(x,y) color = Gray(0.6)
    f_x(x,y) = gradient(f(x,y), x)
    f_y(x,y) = gradient(f(x,y), y)
    g_x(x,y) = gradient(g(x,y), x)
    g_y(x,y) = gradient(g(x,y), y)
    d(x,y) = f_x(x,y)*g_y(x,y)-f_y(x,y)*g_x(x,y)
    A(x,y) = x-(g_y(x,y)*f(x,y)-f_y(x,y)*g(x,y))/d(x,y)
    B(x,y) = y-(-g_x(x,y)*f(x,y)+f_x(x,y)*g(x,y))/d(x,y)
    a₀ = 1
    b₀ = 1
    a(0) = a₀
    b(0) = b₀
    a(i) = A(a(i-1),b(i-1))
    b(i) = B(a(i-1),b(i-1))
    @expression L"I = [0,...,10]"
    (a₀,b₀)
    @expression (a(I),b(I)) lines = true
    @image image_url = $image_url width = 20 height = 20 name = "regions"
end
```
