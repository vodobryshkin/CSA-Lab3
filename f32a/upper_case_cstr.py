BUFFER_SIZE = 0x20
overflow_error_value = "OVERFLOW"


def upper_case_cstr(s):
    mem = [0x5F] * BUFFER_SIZE
    pos = 0
    i = 0

    while i < len(s) and s[i] != '\n':
        if pos >= BUFFER_SIZE - 1:
            return [overflow_error_value], s[i:], mem

        ch = s[i]
        if 'a' <= ch <= 'z':
            ch = chr(ord(ch) - 32)

        mem[pos] = ord(ch)
        pos += 1
        i += 1

    if i < len(s) and s[i] == '\n':
        rest = s[i + 1:]
    else:
        rest = ""

    mem[pos] = 0x00
    result = "".join(chr(x) for x in mem[:pos])
    return result, rest, mem

assert upper_case_cstr('Hello\n') == ('HELLO', '')
assert upper_case_cstr('world\n') == ('WORLD', '')