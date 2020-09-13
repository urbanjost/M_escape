          program demo_esc_mode
          use M_escape, only : esc, esc_mode
          implicit none
          character(len=1024) :: line
          real :: value

             value=3.4567
             if( (value>0.0) .and. (value<100.0))then
                write(line,fmt='("<w><G>GREAT</G></w>:The new value <Y><b>",f8.4,"</b></Y> is in range")')value
             else
                write(line,fmt='("<R><e>ERROR</e></R>:The new value <Y><b>",g0,"</b></Y> is out of range")')value
             endif

             write(*,'(a)')esc(trim(line))

             ! write as plain text
             call esc_mode(manner='plain')
             write(*,'(a)')esc(trim(line))
             ! write as-is
             call esc_mode(manner='raw')
             write(*,'(a)')esc(trim(line))
             ! return to default mode
             call esc_mode(manner='ansi')
             write(*,'(a)')esc(trim(line))

              end program demo_esc_mode
