program roots
use M_escape,                     only : color,color_mode, bg_blue, fg_white, reset, fg_yellow, bold, clear
! Calculate and print the roots of a quadratic formula even if they are complex
implicit none
integer,parameter               :: dp=kind(0.0d0)
real(kind=dp)                   :: a, b, c, discriminant
real(kind=dp)                   :: x1, x2, x ! Real roots of the equation
real(kind=dp)                   :: x_real    ! Real part of complex root of the equation
REAL(kind=dp)                   :: x_complex ! Imaginary part of complex root of the equation
character(len=:),allocatable    :: line
character(len=256)              :: message
integer                         :: ios
character(len=1)                :: paws
   !call color_mode(isatty(stdout)) ! ISATTY() is an extension, but found in Intel, GNU, PGI, ... compiler
   INFINITE: do
      ! clear screen, set attributes and print messages
      line="Enter the quadratic equation coefficients a, b and c"
      write(*,'(*(a))') color(line,bg=bg_blue,fg=fg_white,style=clear//bold)
      write(*,'(*(a))',advance='no') bg_blue,fg_white,repeat('_',len(line)),fg_yellow,bold, char(13),' ENTER>'
      read(*,*,iostat=ios,iomsg=message)a,b,c
      write(*,'(a)',advance='no') reset
      if(ios.ne.0)then
         write(*,'(*(g0))')ios,' ',trim(message)
      else
         ! Given the equation "A*x**2 + B*x + C = 0"
         ! Use the quadratic formula to determine the root values of the equation.
         ! prompt for new value
      
         WRITE(*,'(*(g0))') 'for ',a,'*x**2 + ',b,'*x + ',c,' = 0'
         discriminant = b**2 - 4*a*c
      
         IF ( discriminant>0 ) THEN
            write(*,*) 'the roots (ie. "x intercepts") are real so the parabola crosses the x-axis at two points:'
            x1 = ( -b + sqrt(discriminant)) / (2 * a)
            x2 = ( -b - sqrt(discriminant)) / (2 * a)
            PRINT *, "Real roots:", x1, x2
         ELSEIF ( discriminant==0 ) THEN
            PRINT *,'the roots (ie. "x intercepts") are repeated (real and equal) so the parabola just touches the x-axis at:'
            x = (-b) / (2 * a)
            PRINT *, "Two identical Real roots", x
         ELSE
            PRINT *, 'the roots(ie. "x intercepts")  are complex:'
            x_real     = (-b)/(2 * a)
            x_complex  = sqrt (abs(discriminant)) / (2 * a)
            PRINT *, x_real, "+i",x_complex , x_real, "-i",x_complex
         ENDIF
            PRINT *, "discriminant =", discriminant
      endif
      write(*,'(*(g0))')'press <return> to continue, <q> to quit'
      read(*,advance='yes',iostat=ios,fmt='(a)',iomsg=message)paws
      if(paws.ne.'')exit INFINITE
   enddo INFINITE
END PROGRAM roots
