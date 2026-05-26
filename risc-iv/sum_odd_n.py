import sys


def sum_odd_n(n):
    """Calculate the sum of odd numbers from 1 to n recursively."""
    if n <= 0:
        return -1

    return sum_odd_rec(n)


def sum_odd_rec(k):
    if k <= 0:
        return 0

    if k % 2 == 0:
        return sum_odd_rec(k - 1)

    return k + sum_odd_rec(k - 2)


assert sum_odd_n(5) == 9
assert sum_odd_n(10) == 25
assert sum_odd_n(90000) == 2025000000