program demo_esc
! read stdin and run it through M_escape::esc to display color
use M_escape, only : esc
implicit none
character(len=1024) :: line
integer :: ios
   do 
      read(*,'(a)',iostat=ios)line
      write(*,'(a)') esc(trim(line))
      if(ios.ne.0)exit
   enddo
   write(*,'(a)',advance='no') esc('<reset>')
end program demo_esc
