          program demo_M_escape
          use M_escape, only : esc, esc_mode, update, print_dictionary
             write(*,'(a)') esc('<clear>TEST CUSTOMIZED:')

             write(*,'(a)',advance='no') esc('<debug>')
             write(*,'(a)',advance='no') esc('<r>RED</r>,')
             write(*,'(a)',advance='no') esc('<b>BLUE</b>,')
             write(*,'(a)',advance='yes') esc('<g>GREEN</g>')
             write(*,'(a)',advance='no') esc('</debug>')
             call print_dictionary()
             
       end program demo_M_escape
