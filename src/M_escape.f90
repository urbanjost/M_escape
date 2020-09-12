module M_escape
use M_list, only : insert, locate, replace, remove
use, intrinsic :: iso_fortran_env, only : stderr=>ERROR_UNIT,stdin=>INPUT_UNIT    ! access computing environment
implicit none
private
public esc
public esc_mode
public update
public print_dictionary

logical,save :: debug=.false.

character(len=:),allocatable,save :: keywords(:)
character(len=:),allocatable,save :: values(:)
integer,allocatable,save :: counts(:)

character(len=:),allocatable,save :: mode

! mnemonics
character(len=*),parameter  :: NL=new_line('a')                     ! New line character.
character(len=*),parameter  :: ESCAPE=achar(27)                     ! "\" character.
! codes
character(len=*),parameter  :: CODE_START=ESCAPE//'['               ! Start ANSI code, "\[".
character(len=*),parameter  :: CODE_END='m'                         ! End ANSI code, "m".
character(len=*),parameter  :: CODE_CLEAR=CODE_START//'0'//CODE_END ! Clear all styles, "\[0m".

character(len=*),parameter  :: CLEAR_DISPLAY=CODE_START//'2J'

character(len=*),parameter  :: BLACK='30', RED='31', GREEN='32', YELLOW='33', BLUE='34', MAGENTA='35', CYAN='36', WHITE='37'
character(len=*),parameter  :: DEFAULT='39'
character(len=*),parameter  :: BOLD_ON='1',   ITALIC_ON='3',   UNDERLINE_ON='4',   INVERSE_ON='7'
character(len=*),parameter  :: BOLD_OFF='22', ITALIC_OFF='23', UNDERLINE_OFF='24', INVERSE_OFF='27'

character(len=*),parameter  :: BLACK_INTENSE='90',     RED_INTENSE='91',         GREEN_INTENSE='92',     YELLOW_INTENSE='93'
character(len=*),parameter  :: BLUE_INTENSE='94',      MAGENTA_INTENSE='95',     CYAN_INTENSE='96',      WHITE_INTENSE='97'

character(len=*),parameter  :: BG_BLACK='40',          BG_RED='41',              BG_GREEN='42',          BG_YELLOW='43'
character(len=*),parameter  :: BG_BLUE='44',           BG_MAGENTA='45',          BG_CYAN='46',           BG_WHITE='47'

character(len=*),parameter  :: BG_DEFAULT='49'

character(len=*),parameter  :: BG_BLACK_INTENSE='100', BG_RED_INTENSE='101',     BG_GREEN_INTENSE='102', BG_YELLOW_INTENSE='103'
character(len=*),parameter  :: BG_BLUE_INTENSE='104',  BG_MAGENTA_INTENSE='105', BG_CYAN_INTENSE='106',  BG_WHITE_INTENSE='107'
contains
!===================================================================================================================================
!()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()=
!===================================================================================================================================
!>
!!##NAME
!!    esc(3f) - [M_escape] substitute escape sequences for XML-like syntax (prototype) in strings
!!
!!##SYNOPSIS
!!
!!     function esc(string) result (expanded)
!!
!!       character(len=*),intent(in) :: string
!!       character(len=:),allocatable :: expanded
!!
!!##DESCRIPTION
!!    This is a prototype exploring using XML-like syntax to add attributes
!!    to terminal output such as color.
!!    ANSI escape sequences
!!    ANSI escape sequences are not universally supported by all terminal
!!    emulators; and normally should be suppressed when not going to a tty
!!    device. This routine provides the basic structure to support such
!!    behaviors. or to perhaps generate a CSS style sheet and HTML instead
!!    of text, ...
!!
!!    The original concept was to allow formatting by using an existing
!!    XML library to allow the user to write HTML and to format it on
!!    a terminal like w3m, lynx, and link do and in some ways this is an
!!    opposite approach in that it is directly formatting the text by using
!!    a similar syntax to directly generate text attributes; but it is a
!!    much simpler approach programmatically.
!!
!!    Typically, you would use M_system::system_istty to set the default
!!    to "plain" instead of "vt102" when the output file is not a terminal.
!!
!!
!!       ANSI  HTML        Markdown
!!             <h1></h1>   #
!!             <h2></h2>   ##
!!             <b></b>     ** and **
!!             <i></i>     __ and __
!!
!!    Apparently have to make a stack of colors to allow nesting colors
!!
!!    How common are extensions like xterm-256 has to set RGB values for
!!    colors and so on?
!!
!!##OPTIONS
!!    string  input string  of form
!!
!!                "<attribute_name>string</attribute_name> ...".
!!            where the current attributes are color names, color=name,
!!            color=#rgb, bold, italic, ...
!!##KEYWORDS
!!    current keywords
!!
!!       r,red
!!       g,green
!!       b,blue
!!       m,magenta
!!       c,cyan
!!       y,yellow
!!       e,ebony
!!       w,white
!!       it,italic
!!       bo,bold
!!       un,underline
!!       clear
!!       esc,esc
!!
!!    you can add, delete, and replace what strings are produced using UPDATE(3f).
!!##LIMITATIONS
!!      o colors are not nestable, keywords are case-sensitive,
!!      o not all terminals obey the sequences. On Windows, it is best if
!!        you use Windows 10+ and/or the Linux mode; although it has worked
!!        with all CygWin and MinGW and Putty windows and mintty.
!!
!!##MANNERS
!!    The current manners or modes supported via the ESC_MODE(3f) procedure are
!!
!!        plain          suppress the output associated with keywords
!!        ansi(default)  commonly supported escape sequences
!!        raw            echo the input to ESC(3f) as its output
!!
!!##EXAMPLE
!!
!!   Sample program
!!
!!    program demo_M_escape
!!    use M_escape, only : esc, esc_mode, update
!!       write(*,'(a)') esc('<clear>TEST DEFAULTS:')
!!       call printstuff()
!!
!!       write(*,'(a)') esc('TEST MANNER=PLAIN:')
!!       call esc_mode(manner='plain')
!!       call printstuff()
!!
!!       write(*,'(a)') esc('TEST MANNER=RAW:')
!!       call esc_mode(manner='raw')
!!       call printstuff()
!!
!!       write(*,'(a)') esc('TEST MANNER=VT102:')
!!       call esc_mode(manner='vt102')
!!       call printstuff()
!!
!!       write(*,'(a)') esc('TEST ADDING A CUSTOM SEQUENCE:')
!!       call update('blink',char(27)//'[5m')
!!       call update('/blink',char(27)//'[38m')
!!       write(*,'(a)') esc('<blink>Items for Friday<blink/>')
!!
!!    contains
!!    subroutine printstuff()
!!
!!       write(*,'(a)') esc('<r>RED</r>,<g>GREEN</g>,<b>BLUE</b>')
!!       write(*,'(a)') esc('<c>CYAN</c>,<m>MAGENTA</g>,<y>YELLOW</y>')
!!       write(*,'(a)') esc('<w>WHITE</w> and <e>EBONY</e>')
!!
!!       write(*,'(a)') esc('Adding <bo>bold</bo>')
!!       write(*,'(a)') esc('<bo><r>RED</r>,<g>GREEN</g>,<b>BLUE</b></bo>')
!!       write(*,'(a)') esc('<bo><c>CYAN</c>,<m>MAGENTA</g>,<y>YELLOW</y></bo>')
!!       write(*,'(a)') esc('<bo><w>WHITE</w> and <e>EBONY</e></bo>')
!!
!!       write(*,'(a)') esc('Adding <ul>underline</ul>')
!!       write(*,'(a)') esc('<bo><ul><r>RED</r>,<g>GREEN</g>,<b>BLUE</b></ul></bo>')
!!       write(*,'(a)') esc('<bo><ul><c>CYAN</c>,<m>MAGENTA</g>,<y>YELLOW</y></ul></bo>')
!!       write(*,'(a)') esc('<bo><ul><w>WHITE</w> and <e>EBONY</e></ul></bo>')
!!
!!       write(*,'(a)') esc('Adding <ul>italic</ul>')
!!       write(*,'(a)') esc('<bo><ul><it><r>RED</r>,<g>GREEN</g>,<b>BLUE</b></it></ul></bo>')
!!       write(*,'(a)') esc('<bo><ul><it><c>CYAN</c>,<m>MAGENTA</g>,<y>YELLOW</it></y></ul></bo>')
!!       write(*,'(a)') esc('<bo><ul><it><w>WHITE</w> and <e>EBONY</e></ul></bo>')
!!
!!       write(*,'(a)') esc('Adding <in>inverse</in>')
!!       write(*,'(a)') esc('<in><bo><ul><it><r>RED</r>,<g>GREEN</g>,<b>BLUE</b></it></ul></bo></in>')
!!       write(*,'(a)') esc('<in><bo><ul><it><c>CYAN</c>,<m>MAGENTA</g>,<y>YELLOW</it></y></ul></bo></in>')
!!       write(*,'(a)') esc('<in><bo><ul><it><w>WHITE</w> and <e>EBONY</e></ul></bo></in>')
!!    end subroutine printstuff
!!
!!    end program demo_M_escape
function esc(string) result (expanded)
character(len=*),intent(in)  :: string
character(len=:),allocatable :: padded
character(len=:),allocatable :: expanded
character(len=:),allocatable :: name
integer                      :: i
integer                      :: ii
integer                      :: maxlen
if(.not.allocated(mode))then  ! set substitution mode
   mode='vt102' !'raw', 'xterm', 'dummy'|'plain'
   call vt102()
endif

if(mode=='raw')then
   expanded=string
   return
endif

maxlen=len(string)
padded=string//' '
i=1
expanded=''
do
   if(debug)write(*,*)'DEBUG:*esc*: processing',padded(i:i),' from',string(i:),' EXPANDED=',expanded
   select case(padded(i:i))
   case('>')  ! should not get here unless unmatched
      i=i+1
      expanded=expanded//'>'
   case('<')  ! assuming not nested for now
      ii=index(padded(i+1:),'>')
      if(ii.eq.0)then
         expanded=expanded//'<'
         i=i+1
      else
         name=padded(i+1:i+ii-1)
         name=trim(adjustl(name))
         if(debug)write(*,*)'DEBUG:*esc* 1: NAME=',name,get(name)
         i=ii+i+1
         if(mode.eq.'plain')then
         else
            expanded=expanded//get(name)
         endif
         if(name.eq.'debug')debug=.true.   !! developement version
         if(name.eq.'/debug')debug=.false. !! developement version
      endif
   case('\')
      i=i+1
      expanded=expanded//padded(i:i)
   case default
      expanded=expanded//padded(i:i)
      i=i+1
   end select
   if(i >= maxlen+1)exit
enddo
expanded=expanded//CODE_CLEAR                                   ! Clear all styles
end function esc
!===================================================================================================================================
!()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()=
!===================================================================================================================================
subroutine vt102()
! create a dictionary with character keywords, values, and value lengths
! using the routines for maintaining a list


   call wipe_dictionary()
   ! insert and replace entries

   call update('bold',CODE_START//BOLD_ON//CODE_END)
   call update('/bold',CODE_START//BOLD_OFF//CODE_END)
   call update('bo',CODE_START//BOLD_ON//CODE_END)
   call update('/bo',CODE_START//BOLD_OFF//CODE_END)
   call update('livid',CODE_START//BOLD_ON//CODE_END)
   call update('/livid',CODE_START//BOLD_OFF//CODE_END)
   call update('li',CODE_START//BOLD_ON//CODE_END)
   call update('/li',CODE_START//BOLD_OFF//CODE_END)

   call update('italic',CODE_START//ITALIC_ON//CODE_END)
   call update('/italic',CODE_START//ITALIC_OFF//CODE_END)
   call update('it',CODE_START//ITALIC_ON//CODE_END)
   call update('/it',CODE_START//ITALIC_OFF//CODE_END)

   call update('inverse',CODE_START//INVERSE_ON//CODE_END)
   call update('/inverse',CODE_START//INVERSE_OFF//CODE_END)
   call update('in',CODE_START//INVERSE_ON//CODE_END)
   call update('/in',CODE_START//INVERSE_OFF//CODE_END)

   call update('underline',CODE_START//UNDERLINE_ON//CODE_END)
   call update('/underline',CODE_START//UNDERLINE_OFF//CODE_END)
   call update('un',CODE_START//UNDERLINE_ON//CODE_END)
   call update('/un',CODE_START//UNDERLINE_OFF//CODE_END)

   call update('esc',ESCAPE)
   call update('escape',ESCAPE)

   call update('clear',CLEAR_DISPLAY)

   ! foreground colors
   call update('r',CODE_START//RED//CODE_END)
   call update('/r',CODE_START//DEFAULT//CODE_END)
   call update('red',CODE_START//RED//CODE_END)
   call update('/red',CODE_START//DEFAULT//CODE_END)

   call update('c',CODE_START//CYAN//CODE_END)
   call update('/c',CODE_START//DEFAULT//CODE_END)
   call update('cyan',CODE_START//CYAN//CODE_END)
   call update('/cyan',CODE_START//DEFAULT//CODE_END)

   call update('m',CODE_START//MAGENTA//CODE_END)
   call update('/m',CODE_START//DEFAULT//CODE_END)
   call update('magenta',CODE_START//MAGENTA//CODE_END)
   call update('/magenta',CODE_START//DEFAULT//CODE_END)

   call update('b',CODE_START//BLUE//CODE_END)
   call update('/b',CODE_START//DEFAULT//CODE_END)
   call update('blue',CODE_START//BLUE//CODE_END)
   call update('/blue',CODE_START//DEFAULT//CODE_END)

   call update('g',CODE_START//GREEN//CODE_END)
   call update('green',CODE_START//GREEN//CODE_END)
   call update('/g',CODE_START//DEFAULT//CODE_END)
   call update('/green',CODE_START//DEFAULT//CODE_END)

   call update('yellow',CODE_START//YELLOW//CODE_END)
   call update('/yellow',CODE_START//DEFAULT//CODE_END)
   call update('y',CODE_START//YELLOW//CODE_END)
   call update('/y',CODE_START//DEFAULT//CODE_END)

   call update('white',CODE_START//WHITE//CODE_END)
   call update('/white',CODE_START//DEFAULT//CODE_END)
   call update('w',CODE_START//WHITE//CODE_END)
   call update('/w',CODE_START//DEFAULT//CODE_END)

   call update('ebony',CODE_START//BLACK//CODE_END)
   call update('/ebony',CODE_START//DEFAULT//CODE_END)
   call update('e',CODE_START//BLACK//CODE_END)
   call update('/e',CODE_START//DEFAULT//CODE_END)

   ! background colors
   call update('R',CODE_START//BG_RED//CODE_END)
   call update('/R',CODE_START//BG_DEFAULT//CODE_END)
   call update('RED',CODE_START//BG_RED//CODE_END)
   call update('/RED',CODE_START//BG_DEFAULT//CODE_END)

   call update('C',CODE_START//BG_CYAN//CODE_END)
   call update('/C',CODE_START//BG_DEFAULT//CODE_END)
   call update('CYAN',CODE_START//BG_CYAN//CODE_END)
   call update('/CYAN',CODE_START//BG_DEFAULT//CODE_END)

   call update('M',CODE_START//BG_MAGENTA//CODE_END)
   call update('/M',CODE_START//BG_DEFAULT//CODE_END)
   call update('MAGENTA',CODE_START//BG_MAGENTA//CODE_END)
   call update('/MAGENTA',CODE_START//BG_DEFAULT//CODE_END)

   call update('B',CODE_START//BG_BLUE//CODE_END)
   call update('/B',CODE_START//BG_DEFAULT//CODE_END)
   call update('BLUE',CODE_START//BG_BLUE//CODE_END)
   call update('/BLUE',CODE_START//BG_DEFAULT//CODE_END)

   call update('G',CODE_START//BG_GREEN//CODE_END)
   call update('GREEN',CODE_START//BG_GREEN//CODE_END)
   call update('/G',CODE_START//BG_DEFAULT//CODE_END)
   call update('/GREEN',CODE_START//BG_DEFAULT//CODE_END)

   call update('YELLOW',CODE_START//BG_YELLOW//CODE_END)
   call update('/YELLOW',CODE_START//BG_DEFAULT//CODE_END)
   call update('Y',CODE_START//BG_YELLOW//CODE_END)
   call update('/Y',CODE_START//BG_DEFAULT//CODE_END)

   call update('WHITE',CODE_START//BG_WHITE//CODE_END)
   call update('/WHITE',CODE_START//BG_DEFAULT//CODE_END)
   call update('W',CODE_START//BG_WHITE//CODE_END)
   call update('/W',CODE_START//BG_DEFAULT//CODE_END)

   call update('EBONY',CODE_START//BG_BLACK//CODE_END)
   call update('/EBONY',CODE_START//BG_DEFAULT//CODE_END)
   call update('E',CODE_START//BG_BLACK//CODE_END)
   call update('/E',CODE_START//BG_DEFAULT//CODE_END)

   ! show array
   !write(*,'(*(a,"==>","[",a,"]",/))')(trim(keywords(i)),values(i)(:counts(i)),i=1,size(keywords))
   ! remove some entries
   !call update('a')
   !call update('c')
   !write(*,'(*(a,"==>","[",a,"]",/))')(trim(keywords(i)),values(i)(:counts(i)),i=1,size(keywords))
   !! get some values
   !write(*,*)'get b=>',get('b')
   !write(*,*)'get d=>',get('d')
   !write(*,*)'get notthere=>',get('notthere')
   !call print_dictionary('')
end subroutine vt102
!===================================================================================================================================
!()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()=
!===================================================================================================================================
subroutine esc_mode(manner)
character(len=*),intent(in) :: manner
   select case(manner)
   case('vt102')
      call vt102()
      mode=manner
   case('xterm')
      mode=manner
   case('raw')
      mode=manner
   case('dummy','plain','ANSI','ansi')
      mode='plain'
   case default
   end select
end subroutine esc_mode
!===================================================================================================================================
!()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()=
!===================================================================================================================================
subroutine wipe_dictionary()
   if(allocated(keywords))deallocate(keywords)
   allocate(character(len=0) :: keywords(0))
   if(allocated(values))deallocate(values)
   allocate(character(len=0) :: values(0))
   if(allocated(counts))deallocate(counts)
   allocate(counts(0))
end subroutine wipe_dictionary
!===================================================================================================================================
!()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()=
!===================================================================================================================================
subroutine update(key,valin)
character(len=*),intent(in)           :: key
character(len=*),intent(in),optional  :: valin
integer                               :: place
integer                               :: ilen
character(len=:),allocatable          :: val
if(present(valin))then
   val=valin
   ilen=len_trim(val)
   ! find where string is or should be
   call locate(keywords,key,place)
   ! if string was not found insert it
   if(place.lt.1)then
      call insert(keywords,key,iabs(place))
      call insert(values,val,iabs(place))
      call insert(counts,ilen,iabs(place))
   else
      call replace(values,val,place)
      call replace(counts,ilen,place)
   endif
else
   call locate(keywords,key,place)
   if(place.gt.0)then
      call remove(keywords,place)
      call remove(values,place)
      call remove(counts,place)
   endif
endif
end subroutine update
!===================================================================================================================================
!()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()=
!===================================================================================================================================
function get(key) result(valout)
character(len=*),intent(in)   :: key
character(len=:),allocatable  :: valout
integer                       :: place
   ! find where string is or should be
   call locate(keywords,key,place)
   if(place.lt.1)then
      valout=''
   else
      valout=values(place)(:counts(place))
   endif
end function get
!===================================================================================================================================
!()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()=
!===================================================================================================================================
!>
!!##NAME
!!     print_dictionary(3f) - [ARGUMENTS:M_CLI2] print internal dictionary created by calls to set_args(3f)
!!     (LICENSE:PD)
!!##SYNOPSIS
!!
!!
!!
!!     subroutine print_dictionary(header)
!!
!!      character(len=*),intent(in),optional :: header
!!##DESCRIPTION
!!    Print the internal dictionary created by calls to set_args(3f).
!!    This routine is intended to print the state of the argument list
!!    if an error occurs in using the set_args(3f) procedure.
!!##OPTIONS
!!     HEADER  label to print before printing the state of the command
!!             argument list.
!!##EXAMPLE
!!
!!
!!
!! Typical usage:
!!
!!       program demo_print_dictionary
!!       use M_CLI2,  only : set_args, get_args
!!       implicit none
!!       real :: x, y, z
!!          call set_args('-x 10 -y 20 -z 30')
!!          call get_args('x',x,'y',y,'z',z)
!!          ! all done cracking the command line; use the values in your program.
!!          write(*,*)x,y,z
!!       end program demo_print_dictionary
!!
!!      Sample output
!!
!!      Calling the sample program with an unknown parameter or the --usage
!!      switch produces the following:
!!
!!         $ ./demo_print_dictionary -A
!!         UNKNOWN SHORT KEYWORD: -A
!!         KEYWORD             PRESENT  VALUE
!!         z                   F        [3]
!!         y                   F        [2]
!!         x                   F        [1]
!!         help                F        [F]
!!         version             F        [F]
!!         usage               F        [F]
!!
!!##AUTHOR
!!      John S. Urban, 2019
!!##LICENSE
!!      Public Domain
!===================================================================================================================================
subroutine print_dictionary(header)
character(len=*),intent(in),optional :: header
integer          :: i
   if(present(header))then
      if(header.ne.'')then
         write(stderr,'(a)')header
      endif
   endif
   if(allocated(keywords))then
      if(size(keywords).gt.0)then
         write(stderr,'(*(a,t30,a))')'KEYWORD','VALUE'
         write(stderr,'(*(a,t30,"[",a,"]",/))')(trim(keywords(i)),values(i)(:counts(i)),i=1,size(keywords))
      endif
   endif
end subroutine print_dictionary
!===================================================================================================================================
!()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()=
!===================================================================================================================================
end module M_escape
!===================================================================================================================================
!()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()=
!===================================================================================================================================
