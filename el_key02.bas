 '$regfile = "attiny45.dat"
 $regfile = "attiny85.dat"

 Config Pinb.4 = Output  'define tone output port
 Config Pinb.0 = Output :portb.0 = 1 'define keying port - active low level
 config pinb.1 = input: portb.1 = 1  'define dot (".") input port
 config pinb.2 = input: portb.2 = 1  'define dash ("-")input port
 dim speed as word
 dim dot as word      'dot lenght variable
 dim dash as word      'dash lenght variable
 dim kro(15) as word     'dot speed table
 dim kre(15) as word     'dash speed table
 dim cwidx as byte       'speed index
 dim cwidx_old as byte   'speed index helper

 'define tone generator
 Config Timer0 = Timer, Prescale = 64    ', Compare  = Disconnect
 '256-178 = 78
 'freq = 8000000/2/64/(256-178) = abt 801Hz
 timer0 = 176
 on timer0 tim0

 enable interrupts
 disable timer0

'definition speed table -> delay for dot (kro) and dash (kre)
'cwidx = 1 -> speed = abt 6 "paris" groups, 15 -> speed = abt 20 "paris" groups
'********************************
 kro(1)=122: kre(1)=366
 kro(2)=105: kre(2)=315
 kro(3)=92: kre(3)=276
 kro(4)=81: kre(4)=243
 kro(5)=73: kre(5)=219
 kro(6)=67: kre(6)=201
 kro(7)=61: kre(7)=183
 kro(8)=56: kre(8)=168
 kro(9)=52: kre(9)=156
 kro(10)=49: kre(10)=147
 kro(11)=46: kre(11)=138
 kro(12)=43: kre(12)=129
 kro(13)=41: kre(13)=123
 kro(14)=39: kre(14)=117
 kro(15)=37: kre(15)=111

 'start ADC to resolve speed from voltage level on port B.5
 Config Adc = Single , Prescaler = auto , reference = avcc
 start adc
 cwidx = 7
 cwidx_old = cwidx

 Do
   speed = getadc(3)  'reading speed from potentiometr voltage level
   select case speed
      case is < 546: cwidx = 1
      case 547 to 580: cwidx = 2
      case 581 to 614: cwidx = 3
      case 615 to 648: cwidx = 4
      case 649 to 682: cwidx = 5
      case 683 to 716: cwidx = 6
      case 717 to 750: cwidx = 7
      case 751 to 784: cwidx = 8
      case 785 to 818: cwidx = 9
      case 819 to 852: cwidx = 10
      case 853 to 886: cwidx = 11
      case 887 to 920: cwidx = 12
      case 921 to 954: cwidx = 13
      case 955 to 988: cwidx = 14
      case is > 989: cwidx = 15
   end select
   if cwidx <> cwidx_old Then 'change dot/dash lenght if speed changed
      dot = kro(cwidx)
      dash = kre(cwidx)
      cwidx_old = cwidx
   end if
   if pinb.1 = 0 then    'execute dot if B.1 pressed
      portb.0 = 0
      enable timer0
      waitms dot
      portb.0 = 1
      disable timer0
      waitms dot
   end if
   if pinb.2 = 0 Then   'execute dash if B.2 pressed
      portb.0 = 0
      enable timer0
      waitms dash
      portb.0= 1
      disable timer0
      waitms dot
   end if
 loop


'*******************************************************************
'subr for tone 800Hz
'*******************************************************************
   tim0:
      toggle portb.4 'toggle ton signal on B.4
      'define ton freq 180 - abt 800Hz, 200 - 0.5ms, 178 - 0.625ms
      timer0=180
   return
'*******************************************************************