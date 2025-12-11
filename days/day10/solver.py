import numpy as np
from scipy.optimize import milp, LinearConstraint, Bounds

# opus 4.5 by cursor
def solve(target: list[int], buttons: list[list[int]]) -> int:
    """
    Решаем задачу ILP:
    - x[i] = количество нажатий кнопки i (целое >= 0)
    - Для каждого счётчика j: сумма x[i] для всех кнопок, содержащих j = target[j]
    - Минимизировать сумму x[i]
    """
    n_counters = len(target)
    n_buttons = len(buttons)
    
    # Строим матрицу A[j][i] = 1, если кнопка i влияет на счётчик j
    A = np.zeros((n_counters, n_buttons), dtype=float)
    for i, button in enumerate(buttons):
        for j in button:
            if j < n_counters:  # защита от некорректных данных
                A[j][i] = 1
    
    # Целевая функция: минимизировать сумму x[i]
    c = np.ones(n_buttons)
    
    # Ограничения: A @ x = target
    constraints = LinearConstraint(A, lb=target, ub=target)
    
    # Границы: x[i] >= 0
    bounds = Bounds(lb=0, ub=np.inf)
    
    # Все переменные целочисленные
    integrality = np.ones(n_buttons, dtype=int)
    
    result = milp(c, constraints=constraints, bounds=bounds, integrality=integrality)
    
    if result.success:
        return int(round(result.fun))
    else:
        raise ValueError(f"Не удалось найти решение: {result.message}")


def parse_line(line: str):
    """Парсим строку формата: [.##.] (3) (1,3) (2) {3,5,4,7}"""
    parts = line.strip().split(" ")
    
    # Последний элемент — joltage requirements в {фигурных скобках}
    target = [int(x) for x in parts[-1][1:-1].split(",")]
    
    # Элементы между первым (индикаторы) и последним (target) — кнопки в (скобках)
    buttons = []
    for part in parts[1:-1]:
        button = [int(x) for x in part[1:-1].split(",")]
        buttons.append(button)
    
    return target, buttons


def main():
    # Сначала тест на test_input.txt
    print("=== Test Input ===")
    with open("test_input.txt", "r") as f:
        lines = f.read().splitlines()
    
    test_total = 0
    for i, line in enumerate(lines):
        if not line.strip():
            continue
        target, buttons = parse_line(line)
        result = solve(target, buttons)
        print(f"Machine {i+1}: {result}")
        test_total += result
    
    print(f"Test Total: {test_total} (expected: 33)\n")
    
    # Теперь основной input
    print("=== Main Input ===")
    total = 0
    with open("input.txt", "r") as f:
        lines = f.read().splitlines()
    
    for i, line in enumerate(lines):
        if not line.strip():
            continue
        target, buttons = parse_line(line)
        result = solve(target, buttons)
        total += result
    
    print(f"\nTotal: {total}")


if __name__ == "__main__":
    main()
