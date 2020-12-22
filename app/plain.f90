program demo_esc
! read stdin and run it through M_escape::esc to display without color
use M_escape, only : esc, esc_mode
implicit none
character(len=1024) :: line
integer :: ios
   line=''
   call esc_mode(manner='plain')
   do 
      read(*,'(a)',iostat=ios)line
      write(*,'(a)') esc(trim(line))
      if(ios.ne.0)exit
   enddo
   write(*,'(a)',advance='no') esc('<reset>')
end program demo_esc
