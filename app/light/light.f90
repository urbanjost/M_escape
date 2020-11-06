program demo_esc
! read stdin and run it through M_escape::esc to display color
use M_escape,  only : esc, update
implicit none
character(len=1024)          :: line
character(len=:),allocatable :: expanded
integer :: ios
   call update('Z',char(27)//'[1m')
   do 
      read(*,'(a)',iostat=ios)line
      expanded = esc(trim(line))
      write(*,'(a)') expanded
      if(ios.ne.0)exit
   enddo
   write(*,'(a)',advance='no') esc('<reset>')
end program demo_esc
