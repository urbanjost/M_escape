#if defined(_WIN32)
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

int M_escape_initialize(void)
{
    HANDLE h_stdout;
    DWORD mode;

    h_stdout = GetStdHandle(STD_OUTPUT_HANDLE);
    if (h_stdout == INVALID_HANDLE_VALUE)
        return -1;

    if (! GetConsoleMode(h_stdout, &mode))
        return -2;

    mode |= ENABLE_VIRTUAL_TERMINAL_PROCESSING;
    if (! SetConsoleMode(h_stdout, mode))
        return -3;

    return 0;
}

#else

int M_escape_initialize(void)
{
    return 0;
}

#endif
