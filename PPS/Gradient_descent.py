# Viết hàm gradient descent trả về giá trị cực tiểu của hàm tại điểm cực tiểu đó
def gradient_descent(function_f, eta, initial_point, max_iterations,epsilon):
    from autograd import grad
    import autograd.numpy as anp
    current_point=anp.array(initial_point, dtype=anp.float64)
    gradient_f = grad(function_f)
    i=0
    while i<= max_iterations:
        next_point= current_point- eta*gradient_f(current_point)
        if abs(gradient_f(next_point)) < epsilon:
            print("Điểm cực tiểu: " + str(next_point))
            return float(function_f(next_point))
        current_point=next_point
        i+=1
    return f"Thuật toán không thành công sau {max_iterations} lần lặp"
