/*
 * Change _WIN32XX to _WIN32 to build this. Causes
 * problems in WSL and so is being changed to an option
 * till a correct combination of conditions can be determined
 */
#if defined(_WIN32XX) 
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
