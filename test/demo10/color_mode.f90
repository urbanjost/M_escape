   program direct2
      use M_escape, only : color, color_mode
      use M_escape, only : &
        & fg_red, fg_cyan, fg_magenta, fg_blue, fg_green, fg_yellow, fg_white, fg_ebony, fg_default, &
        & bg_red, bg_cyan, bg_magenta, bg_blue, bg_green, bg_yellow, bg_white, bg_ebony, bg_default, &
        & bold, italic, inverse, underline,  unbold, unitalic, uninverse, ununderline,  reset, &
        & clear
      print *, color('Hello!', fg=fg_red, bg=bg_green, style=bold)
      ! unlike the constants it is easy to turn off the color
      call color_mode(.false.)
      print *, color('Hello!', fg=fg_red, bg=bg_green, style=bold)
   end program direct2
