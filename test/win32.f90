program win32
use M_escape, only: fg_red, bg_default, bold, reset, M_escape_initialize
use, intrinsic :: iso_c_binding, only: c_int
implicit none
integer(kind=c_int) :: i

i = M_escape_initialize()
print *, fg_red, bg_default, bold, 'Hello!', reset

end program
