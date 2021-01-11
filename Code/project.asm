include Macros.inc

.model HUGE
.Stack 64

BackgroundData Segment
	;-------------------Clear Area Data----------
	ClearHorizontalOffset dw ?
	ClearVerticalOffset   dw ?
	ClearAreaWidth        dw ?
	ClearAreaHeight       dw ?
	EXTRN BackGroundImg:BYTE
	;-----------------------------------------
BackgroundData ENDS
;  ________________
; |   __________   \
; |  |          \   \
; |  |           |  |
; |  |           |  |
; |  |           |  |
; |  |           |  |
; |  |__________/   /
; |________________/

.data
	IP_Pointer_Temp         dw  ?
	BGC                     db  0
	WindowsWidth            EQU 320
	WindowsHeight           EQU 200
	Exit                    db  0
	MAX_Score               EQU 2
	Last_Winner             db  1
	PointFinished           db  0
	;BackGround Color
	;---------------Initial/Final screen
	initial_msg_warning     db  "*The username shouldn't exceed 15 characters and should start with a letter.$"
	initial_msg_1           db  'please enter your username : $'
	initial_msg_2           db  'please enter the username of the second player: $'
	dashedline              db  80 dup('-'),'$'


	final_msg_1             db  "'s final score is  $"
	final_msg_2             db  " is the Winner :) $"
	final_msg_3             db  "It's a TIE :| $"

	final_msg_4             db  "*press F2 to return to main menu $"
	final_msg_5             db  "*press Esc to return to main menu too :D. $"
	username1               db  16,?,17 dup('$')
	username2               db  16,?,17 dup('$')

	score_1                 db  0
	score_ascii_1           db  30h,'$','$'

	score_2                 db  0
	score_ascii_2           db  30h,'$','$'
	;---------------DrawScores
	DrawScores_msg          db  ":$"
	;---------------MAINMENU screen
	MAINMENU_mesg1          db  "*To start chatting press F1",'$'
	MAINMENU_mesg2          db  "*To start volleyball game press F2",'$'
	MAINMENU_mesg3          db  "*To end the program press F3",'$'
	play_again              db  1
	;---------------chat_mode screen
	chat_msg1               db  "*The chat mode is currently unavailable (please try again later).$"
	chat_msg2               db  "*To start volleyball game press F2",'$'
	chat_msg3               db  "*To end the program press ESC",'$'
	current_video_mode      db  ?




	sendind_colors          equ 07fh
	recieving_colors        equ 3fh
	counter                 db  1
	counter_x               db  1
	counter_y1              db  0
	counter_y2              db  13
	sends                   db  ?,'$'
	recieves                db  ?,'$'
	s_cursor                db  0,0
	r_cursor                db  0,13
	;---------------Phisics
	g                       EQU 1
	HorizontalResistance    EQU 1                                                                                                                                                                                    	;Gravity
	T                       dw  0
	deltaT                  EQU 1
	CollisionConstant       EQU 2
	DivisionConstant        EQU 10
	JumpVelocity            EQU 24
	;---------------------Ball Data-----------------
	BallSize                EQU 12
	Ball_X                  dw  ?
	Ball_Y                  dw  ?
	Ball_Center             dw  ?
	BallVerticalVelocity    dw  ?
	BallHorizontalVelocity  dw  ?
	EXTRN BallImg:BYTE
	;------------------Background Data---------
	BackGroundHeigh         EQU 200
	BackGroundWidth         EQU 320
	;-------------------DrawImage/Clear Area Data----------
	HorizontalOffset        dw  ?
	VerticalOffset          dw  ?
	AreaWidth               dw  ?
	AreaHeight              dw  ?
	;---------------------Playground Data----------
	NetWidth                EQU 10
	NetStartX               EQU (WindowsWidth/2)-(NetWidth/2)
	NetEndX                 EQU (WindowsWidth/2)+(NetWidth/2)
	NetHeight               EQU 107
	NetStartY               EQU WindowsHeight - NetHeight
	GroundStartY            EQU 200
	;--------------Player1 DAta
	Player1Left             EQU 30                                                                                                                                                                                   	;scan codes
	Player1Right            EQU 32
	Player1Up               EQU 17
	;Player1Down EQU
	Player1Movement         EQU 3
	Player1Height           EQU 61
	Player1Width            EQU 50
	Player1_X               dw  ?
	Player1_Y               dw  ?
	Player1_Center          dw  ?
	Player1VerticalVelocity dw  ?
	EXTRN Player1Img:BYTE

	;;--------------Player2 Data
	Player2Left             EQU 4bh                                                                                                                                                                                  	;scan codes
	Player2Right            EQU 4dh
	Player2Up               EQU 48h
	;Player1Down EQU
	Player2Movement         EQU 3
	Player2Height           EQU 61
	Player2Width            EQU 50
	Player2_X               dw  ?
	Player2_Y               dw  ?
	Player2_Center          dw  ?
	Player2VerticalVelocity dw  ?
	EXTRN Player2Img:BYTE
	;----------------------------------
	;----------Arrow
	ArrowConstant           EQU 6
	ArrowH                  EQU 15
	ArrowW                  EQU 12
	EXTRN ArrowImg:BYTE
	;----------------------Communication
	Char_Sent               db  ?
	Char_Received           db  ?
	F1                      EQU 3bh
	F2                      EQU 3ch
	F3                      EQU 3dh
	ESC_                    EQU 1
	Controller_Player       db  ?
	mes_choose_level        db  'Please choose game lever. click 1 for level 1, 2 for level 2..',10,13,'$'
	mes_wair_for_level      db  'Please wait while other player choose game level',10,13,'$'
	GameLevel               db  ?
	Delay_A                 dw  ?
	Delay_B                 dw  ?
	cleanmsg                db  '                                                                            $'
	wantstochat             db  'wants to chat','$'
	wantstoplay             db  'wants to play','$'
	waiting                 db  'waiting','$'
	responsetochat          db  'response to chat','$'
	responsetoplay          db  'response to play','$'
	abbassend               db  'abbas send','$'
	abbasre                 db  'abbas receive','$'
	Move_Player_2_Temp      db  ?
	Player2_Old_Ball_X      dw  ?
	Player2_Old_Ball_Y      dw  ?
	Player2_Old_Player1_X   dw  ?
	Player2_Old_Player2_X   dw  ?
	Player2_Old_Player1_Y   dw  ?
	Player2_Old_Player2_Y   dw  ?
	gotochat                db 0
	PressESCtoExitChat      db   'Press Escape to get out of chat mode','$'

	ingamechatnote1         db  'pres escape during the game','$'
	ingamechatnote2         db  'in order to move to chat mode','$'
.CODE
	;  ___               ___
	; |   \             /   |
	; |    \           /    |
	; |     \         /     |
	; |  |\  \       /  /|  |
	; |  | \  \     /  / |  |
	; |  |  \  \___/  /  |  |
	; |  |   \       /   |  |
	; |_ |    \_____/    |__|

MAIN PROC FAR

	                                  mov                   ax, @data
	                                  mov                   DS, ax
	                                  mov                   ES,ax
	;serial port configuration
	                                  CALL                  ConfigureCommunication
	;Initial Screen
	                                  CALL                  initial_screen
	;EXCHAGE USERNAMES
	                                  CALL                  USERNAMES
	;MAIN Menu Screen
	                                  CALL                  MAINMENU
	;wait for players to choose


	;end program
	                                  mov                   ax,3
	                                  int                   10h
	                                  mov                   ax , 4C01H
	                                  int                   21h


MAIN ENDP


	;  ______________
	; |  _________   |
	; | |         |  |
	; | |_________|  |
	; |  ____________|
	; |  |
	; |  |
	; |  |
	; |__|

USERNAMES PROC NEAR
	                                  mov                   si,offset username1+1
	                                  mov                   di,offset username2+1
	                                  mov                   cx,18
	USERNAMELOOP:                     
	                                  mov                   al,[si]
	                                  mov                   Char_Sent,al
	                                  CALL                  Send_Char

	                                  mov                   al,-1
	                                  mov                   Char_Received,al
	; forcereceive:
	;                                   CALL                  Receive_Char
	;                                   cmp                   Char_Received,-1
	;                                   jz                    forcereceive
	                                  call                  Force_Receive_Char
	                                  mov                   al , Char_Received
	                                  mov                   [di],al
	                                  inc                   si
	                                  inc                   di
	                                  dec                   cx
	                                  jnz                   USERNAMELOOP
	;remove enter at the end of uusernames
	                                  FixUserName           username1
	                                  FixUserName           username2
	                                  print_status_3_mesg   waiting,username1+2,responsetoplay
	                                  RET
USERNAMES ENDP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

Send_Char PROC NEAR

	                                  mov                   dx , 3FDH                                                                	; Line Status Register
	AGAIN:                            In                    al , dx                                                                  	;Read Line Status
	                                  test                  al , 00100000b
	                                  JZ                    AGAIN                                                                    	;Not empty
	;If empty put the VALUE in Transmit data register
	                                  mov                   dx , 3F8H                                                                	; Transmit data register
	                                  mov                   al,Char_Sent
	                                  out                   dx , al

	return22:                         
	                                  RET
Send_Char ENDP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

Force_Receive_Char PROC NEAR
	                                  mov                   Char_Received , -1
	                                  mov                   dx , 3FDH                                                                	; Line Status Register
	RETURN112:                        in                    al , dx
	                                  test                  al , 1
	                                  JZ                    RETURN112                                                                	;Not Ready
	;If Ready read the VALUE in Receive data register
	                                  mov                   dx , 03F8H
	                                  in                    al , dx
	                                  mov                   Char_Received , al

	                                  RET
Force_Receive_Char ENDP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

Receive_Char PROC NEAR
	                                  mov                   Char_Received , -1
	                                  mov                   dx , 3FDH                                                                	; Line Status Register
	                                  in                    al , dx
	                                  test                  al , 1
	                                  JZ                    RETURN11                                                                 	;Not Ready
	;If Ready read the VALUE in Receive data register
	                                  mov                   dx , 03F8H
	                                  in                    al , dx
	                                  mov                   Char_Received , al
	RETURN11:                         
	                                  RET
Receive_Char ENDP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

ConfigureCommunication PROC NEAR
	                                  mov                   dx,3fbh                                                                  	; Line Control Register
	                                  mov                   al,10000000b                                                             	;Set Divisor Latch Access Bit
	                                  out                   dx,al                                                                    	;Out it

	                                  mov                   dx,3f8h
	                                  mov                   al,01h
	                                  out                   dx,al

	                                  mov                   dx,3f9h
	                                  mov                   al,00h
	                                  out                   dx,al

	                                  mov                   dx,3fbh
	                                  mov                   al,00011011b
	                                  out                   dx,al

                                    
	                                  RET
ConfigureCommunication ENDP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

Adjusting_GAME_LEVEL PROC NEAR
	                                  MOV                   AH, 06h                                                                  	; Scroll up function
	                                  XOR                   AL, AL                                                                   	; Clear entire screen
	                                  mov                   CX,  0                                                                   	; Upper left corner CH=row, CL=column
	                                  MOV                   DX, 184FH                                                                	; lower right corner DH=row, DL=column
	                                  MOV                   BH, 07fh
	                                  INT                   10H



	                                  cmp                   Controller_Player,1                                                      	;
	                                  jne                   Player2_is_the_controller
	                                  print_mesg            5,5,1,mes_choose_level
	WaitUntillAKeyPressed:            
	                                  Check_For_Key_Pressed
	                                  cmp                   ah,-1
	                                  je                    WaitUntillAKeyPressed
	                                  cmp                   al,31h                                                                   	;if user click 1
	                                  jne                   checkforclick2
	                                  mov                   GameLevel,1
	                                  mov                   Delay_A,0
	                                  mov                   Delay_B,20000
	                                  JMP                   SendLevel
	checkforclick2:                   cmp                   al,32h                                                                   	;if user click 2
	                                  jne                   WaitUntillAKeyPressed
	                                  mov                   GameLevel,2
	                                  mov                   Delay_A,0
	                                  mov                   Delay_B,15000
	                                  JMP                   SendLevel
	SendLevel:                        
	                                  mov                   ah,GameLevel
	                                  mov                   Char_Sent,ah
	                                  CALL                  Send_Char
	                                  RET
	Player2_is_the_controller:        
	                                  print_mesg            5,5,1,mes_wair_for_level
	WairForGameLevel:                 
	                                  mov                   Char_Received,-1
	                                  CALL                  Receive_Char
	                                  cmp                   Char_Received,1
	                                  jne                   CompareLevel2
	                                  mov                   GameLevel,1
	                                  mov                   Delay_A,0
	                                  mov                   Delay_B,20000
	                                  RET
	CompareLevel2:                    
	                                  cmp                   Char_Received,2
	                                  jne                   WairForGameLevel
	                                  mov                   GameLevel,2
	                                  mov                   Delay_A,0
	                                  mov                   Delay_B,15000
	                                  RET
Adjusting_GAME_LEVEL ENDP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

Game PROC NEAR
	;open graphics mode
	                                  mov                   ax, 0013h
	                                  INT                   10h
			

	                                  CALL                  Play_Again_proc

	                                  cmp                   Controller_Player,1
	                                  jz                    InitialConditions

			
	;------------------------------Player 2 is the controller
	                                  mov                   bx,0
	                                  ClearArea             WindowsHeight,WindowsWidth,bx,bx                                         	;drawing background
	Player2_MainLoop:                 
	;--check for chat
	plr2clr:                          CALL                  Player2_Clear
	                                  CALL                  Receive_Data_From_Player_1
	                                  CALL                  Send_Data_to_Player_1
	                                  CALL                  Player2_Draw_Obj
	                                  CALL                  DrawScores
	                                  CALL                  Check_Player2_for_winner
	                                  cmp                   Exit,0
	                                  jnz                   EndGame
	                                  Delay                 Delay_A,Delay_B
	                                  cmp                   gotochat,1
	                                  jne                   Player2_MainLoop
	                                  mov                   gotochat,0
	                                  call                  chat_mode
	                                  JMP                   Player2_MainLoop

	;------------------------------Player 1 is the controller
	;Initial Conditions
	InitialConditions:                CALL                  Initial_Conditions
		
	;Game Loop
	MainLoop:                                                                                                                        	;Call        MovePlayer1
	                                  Call                  MovePlayer1
	                                  Call                  MovePlayer2
	                                  Call                  MoveBall
	                                  CALL                  DrawScores
	                                  CALL                  Send_Data_to_Player_2
	                                  CALL                  Receive_Data_From_Player_2
	                                  cmp                   gotochat,1
	                                  jne                   chkforchat
	                                  mov                   gotochat,0
	                                  call                  chat_mode

	chkforchat:                       
	;----check for chat
	                                  Check_For_Key_Pressed
	                                  cmp                   ah,ESC_
	                                  jne                   clrbfr
	                                  mov                   gotochat,1
	;----

	clrbfr:                           ClearBuffer
	                                  Delay                 Delay_A,Delay_B
	                                  cmp                   Exit,0
	                                  jnz                   EndGame
	                                  cmp                   PointFinished,0
	                                  jz                    MainLoop
	                                  CALL                  Initial_Conditions
	                                  mov                   PointFinished,0
	                                  JMP                   InitialConditions

	;Final Screen
	EndGame:                          CALL                  final_screen

	                                  RET
GAME ENDP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

Check_Player2_for_winner PROC NEar
	                                  cmp                   score_1,MAX_Score
	                                  jne                   cmpscr2
	                                  mov                   exit,1
	cmpscr2:                          cmp                   score_2,MAX_Score
	                                  jne                   rrttnn
	                                  mov                   exit,1
	rrttnn:                           
	                                  RET
Check_Player2_for_winner ENDP
	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

Receive_Data_From_Player_1 PROC NEAR
	;print_mesg            10,10,1,abbasre
			
	LLPP2:                            
	                                  call                  Receive_Char
	                                  cmp                   Char_Received,-22
	                                  jne                   LLPP2

	;   mov                   bh,-22
	;   mov                   Char_Sent,bh
	;   call                  Send_Char
	                                  CALL                  Force_Receive_Char
	                                  mov                   bl,Char_Received
	                                  mov                   exit,bl



	                                  CALL                  Force_Receive_Char
	                                  mov                   bl,Char_Received
	                                  CALL                  Force_Receive_Char
	                                  mov                   bh,Char_Received
	                                  mov                   Ball_X,bx
	                                  CALL                  Force_Receive_Char
	                                  mov                   bl,Char_Received
	                                  CALL                  Force_Receive_Char
	                                  mov                   bh,Char_Received
	                                  mov                   Ball_Y,bx
	;-------------------------------------------------------
	                                  CALL                  Force_Receive_Char
	                                  mov                   bl,Char_Received
	                                  CALL                  Force_Receive_Char
	                                  mov                   bh,Char_Received
	                                  mov                   Player1_X,bx
	                                  CALL                  Force_Receive_Char
	                                  mov                   bl,Char_Received
	                                  CALL                  Force_Receive_Char
	                                  mov                   bh,Char_Received
	                                  mov                   Player1_Y,bx
	; ;-------------------------------------------------------
	                                  CALL                  Force_Receive_Char
	                                  mov                   bl,Char_Received
	                                  CALL                  Force_Receive_Char
	                                  mov                   bh,Char_Received
	                                  mov                   Player2_X,bx
	                                  CALL                  Force_Receive_Char
	                                  mov                   bl,Char_Received
	                                  CALL                  Force_Receive_Char
	                                  mov                   bh,Char_Received
	                                  mov                   Player2_Y,bx
	; ;-------------------------------------------------------
	                                  CALL                  Force_Receive_Char
	                                  mov                   bl,Char_Received
	                                  mov                   score_ascii_1,bl
	                                  CALL                  Force_Receive_Char
	                                  mov                   bl,Char_Received
	                                  mov                   score_ascii_2,bl

	                                  CALL                  Force_Receive_Char
	                                  mov                   bl,Char_Received
	                                  mov                   gotochat,bl

	                                  CALL                  Force_Receive_Char
	                                  mov                   bl,Char_Received
	                                  mov                   score_1,bl

	                                  CALL                  Force_Receive_Char
	                                  mov                   bl,Char_Received
	                                  mov                   score_2,bl



	                                  RET
Receive_Data_From_Player_1 ENDP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

Send_Data_to_Player_2 PROC NEAR
	;print_mesg 10,10,1,abbassend
	                                  mov                   bh,-22
	                                  mov                   Char_Sent,bh
	                                  call                  Send_Char
	; LLPP:
	;                                   call                  Receive_Char
	;                                   cmp                   Char_Received,-22
	;                                   jne                   LLPP


	                                  mov                   bl,exit
	                                  mov                   Char_Sent,bl
	                                  CALL                  Send_Char

	                                  mov                   bx,Ball_X
	                                  mov                   Char_Sent,bl
	                                  CALL                  Send_Char
	                                  mov                   Char_Sent,bh
	                                  CALL                  Send_Char
	                                  mov                   bx,Ball_Y

	                                  mov                   Char_Sent,bl
	                                  CALL                  Send_Char
	                                  mov                   Char_Sent,bh
	                                  CALL                  Send_Char
	; ;-------------------------------------------------------
	                                  mov                   bx,Player1_X
	                                  mov                   Char_Sent,bl
	                                  CALL                  Send_Char
	                                  mov                   Char_Sent,bh
	                                  CALL                  Send_Char
	                                  mov                   bx,Player1_Y
	                                  mov                   Char_Sent,bl
	                                  CALL                  Send_Char
	                                  mov                   Char_Sent,bh
	                                  CALL                  Send_Char
	; ;-------------------------------------------------------
	                                  mov                   bx,Player2_X
	                                  mov                   Char_Sent,bl
	                                  CALL                  Send_Char
	                                  mov                   Char_Sent,bh
	                                  CALL                  Send_Char
	                                  mov                   bx,Player2_Y
	                                  mov                   Char_Sent,bl
	                                  CALL                  Send_Char
	                                  mov                   Char_Sent,bh
	                                  CALL                  Send_Char
	; ;-------------------------------------------------------
	                                  mov                   bl,score_ascii_2
	                                  mov                   Char_Sent,bl
	                                  CALL                  Send_Char
	                                  mov                   bl,score_ascii_1
	                                  mov                   Char_Sent,bl
	                                  CALL                  Send_Char

	                                  mov                   bl,gotochat
	                                  mov                   Char_Sent,bl
	                                  CALL                  Send_Char

	                                  mov                   bl,score_2
	                                  mov                   Char_Sent,bl
	                                  CALL                  Send_Char
	                                  mov                   bl,score_1
	                                  mov                   Char_Sent,bl
	                                  CALL                  Send_Char


		
	                                  RET
Send_Data_to_Player_2 ENDP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

Send_Data_to_Player_1 PROC NEAR
	                                  Check_For_Key_Pressed
	                                  cmp                   ah,Player1Up
	                                  je                    SendChar
	                                  cmp                   ah,Player1Right
	                                  je                    SendChar
	                                  cmp                   ah,Player1Left
	                                  je                    SendChar
	                                  cmp                   ah,ESC_
	                                  jne                   rtnn
	                                  mov                   Char_Sent,ah
	                                  Call                  Send_Char
	                                  CALL                  chat_mode
	                                  RET
	SendChar:                         
	                                  mov                   Char_Sent,ah
	                                  Call                  Send_Char
	rtnn:                             
	                                  RET
Send_Data_to_Player_1 ENDP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

Receive_Data_From_Player_2 PROC NEAR
	                                  CALL                  Receive_Char
	;---------------------------------------check for chat
	                                  cmp                   Char_Received,ESC_
	                                  jne                   Receive_Data_From_Player_2_Return
	                                  CALL                  chat_mode
	                                  RET
	Receive_Data_From_Player_2_Return:
	                                  mov                   ah,Char_Received
	                                  mov                   Move_Player_2_Temp,ah
	                                  RET
Receive_Data_From_Player_2 ENDP

	;__________________________________________________________________
	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

Player2_Draw_Obj PROC NEAR
	                                  clearArea             Ballsize, BallSize, Player2_Old_Ball_Y, Player2_Old_Ball_X
	                                  clearArea             Player1Height, Player1Width, Player2_Old_Player1_Y, Player2_Old_Player1_x
	                                  clearArea             Player2Height, Player2Width, Player2_Old_Player2_Y, Player2_Old_Player2_x

	                                  DrawImg               BallImg, Ballsize, Ballsize, Ball_Y, Ball_X
	                                  DrawImg               Player1Img, Player1Height, Player1Width, Player1_Y, Player1_X
	                                  DrawImg               Player2Img, Player2Height, Player2Width, Player2_Y, Player2_X

	                                  RET
Player2_Draw_Obj ENDP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

Player2_Clear PROC NEAR
	                                  mov                   ax,Ball_X
	                                  mov                   Player2_Old_Ball_X,ax
	                                  mov                   ax,Ball_Y
	                                  mov                   Player2_Old_Ball_Y,ax
	                                  mov                   ax,Player1_X
	                                  mov                   Player2_Old_Player1_X,ax
	                                  mov                   ax,Player1_Y
	                                  mov                   Player2_Old_Player1_Y,ax
	                                  mov                   ax,Player2_X
	                                  mov                   Player2_Old_Player2_X,ax
	                                  mov                   ax,Player2_Y
	                                  mov                   Player2_Old_Player2_Y,ax
	                                  RET
Player2_Clear ENDP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

try_proc_Check_For_Key_Pressed proc near
	                                  Check_For_Key_Pressed
	                                  ret
try_proc_Check_For_Key_Pressed endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________


MAINMENU PROC NEAR
	; clear
	MAINMENUStart:                    
	                                  MOV                   AH, 06h                                                                  	; Scroll up function
	                                  XOR                   AL, AL                                                                   	; Clear entire screen
	                                  mov                   CX,  0                                                                   	; Upper left corner CH=row, CL=column
	                                  MOV                   DX, 184FH                                                                	; lower right corner DH=row, DL=column
	                                  MOV                   BH, 07fh
	                                  INT                   10H


	; show mesg
	                                  print_mesg            25,10,1,MAINMENU_mesg1
	; show mesg
	                                  print_mesg            25,11,1,MAINMENU_mesg2
	; show mesg
	                                  print_mesg            25,12,1,MAINMENU_mesg3

									  print_mesg            25,17,1,ingamechatnote1
									  print_mesg            25,18,1,ingamechatnote2
	;print dashed line
	                                  print_mesg            0,23,1,dashedline
	;wait for a key to proceed and then proceed it and then exit the program
	                                  move_cursor           25,12

	; check:
	;                                  mov                  ax,0
	;                                  int                  16h
	;                                  cmp                  ah,1
	;                                  je                   return_from_mainmenu
	;                                  cmp                  ah,59
	;                                  jne                  secondcheck
	;                                  call                 chat_mode
	;                                  jmp                  return_from_mainmenu
	; secondcheck:                     cmp                  ah,60
	;                                  jne                  check
	;                                  call                 Game
	; ;check if the player wants to play again or not (F2 to play again   or    ESC to close the program )
	; mainmenu_playagain:
	;                                  mov                  ah,play_again
	;                                  cmp                  play_again,60
	;                                  jne                  return_from_mainmenu
	;                                  call                 Play_Again_proc

	;                                  jmp                  mainmenu_playagain
	; return_from_mainmenu:            mov                  ah,1
	;                                  mov                  play_again,ah

	                                  mov                   al,-1
	                                  mov                   Char_Sent,al
	                                  mov                   Char_Received,al

	MAINMENULOOP:                     
	                                  call                  Receive_Char
	                                  cmp                   Char_Received ,F1
	                                  je                    palyer2_pressed_f1
	                                  cmp                   Char_Received ,F2
	                                  je                    AAABBBCCC
	                                  cmp                   Char_Received ,F3
	                                  je                    ABDSES
	                                  Check_For_Key_Pressed
	                                  cmp                   ah ,F1
	                                  je                    NMNMNM
	                                  cmp                   ah ,F2
	                                  je                    JKJK
	                                  cmp                   ah ,F3
	                                  jne                   MAINMENULOOP
	                                  mov                   Char_Sent,F3
	                                  CALL                  Send_Char
	ABDSES:                           JMP                   ENDPROGRAM


	AAABBBCCC:                        JMP                   palyer2_pressed_f2
	NMNMNM:                           JMP                   palyer1_pressed_f1
	JKJK:                             JMP                   palyer1_pressed_f2


	palyer2_pressed_f1:               
	                                  print_status_2_mesg   username2+2,wantstochat
	                                  mov                   Controller_Player,2
	LP1:                              call                  try_proc_Check_For_Key_Pressed
	                                  cmp                   ah,F2
	                                  je                    JKJK
	                                  cmp                   ah,F3
	                                  je                    OIOIO
	                                  cmp                   ah ,F1
	                                  jne                   LP1
	                                  mov                   Char_Sent,F1
	                                  CALL                  Send_Char
	                                  CALL                  chat_mode                                                                	;chat mode
	                                  JMP                   MAINMENUStart

	OIOIO:                            JMP                   SendThenEnd

	palyer2_pressed_f2:               
	                                  print_status_2_mesg   username2+2,wantstoplay
	                                  mov                   Controller_Player,2
	LP2:                              
	                                  Check_For_Key_Pressed
	                                  cmp                   ah,F1
	                                  je                    palyer1_pressed_f1
	                                  cmp                   ah,F3
	                                  je                    OIOTTIO
	                                  cmp                   ah ,F2
	                                  jne                   LP2
	                                  mov                   Char_Sent,F2
	                                  CALL                  Send_Char

	;------------Game Level----------------------------
	                                  CALL                  Adjusting_GAME_LEVEL
	                                  CALL                  Game                                                                     	;game mode
	                                  JMP                   MAINMENUStart
	OIOTTIO:                          JMP                   SendThenEnd
	palyer1_pressed_f1:               
	                                  print_status_3_mesg   waiting,username2+2,responsetochat
	                                  mov                   Controller_Player,1
	                                  mov                   Char_Sent,F1
	                                  CALL                  Send_Char
	LP3:                              
	                                  call                  Receive_Char
	                                  cmp                   Char_Received,F2
	                                  je                    DSAF
	                                  cmp                   Char_Received,F3
	                                  je                    LKLKLK
	                                  cmp                   Char_Received ,F1
	                                  jne                   LP3

	                                  CALL                  chat_mode                                                                	;chat mode
	                                  JMP                   MAINMENUStart
	DSAF:                             JMP                   palyer2_pressed_f2
	LKLKLK:                           JMP                   ENDPROGRAM
	palyer1_pressed_f2:               
	                                  print_status_3_mesg   waiting,username2+2,responsetoplay
	                                  mov                   Controller_Player,1
	                                  mov                   Char_Sent,F2
	                                  CALL                  Send_Char
	LP4:                              
	                                  call                  Receive_Char
	                                  cmp                   Char_Received,F1
	                                  je                    YTYTY
	                                  cmp                   Char_Received,F3
	                                  je                    ENDPROGRAM
	                                  cmp                   Char_Received ,F2
	                                  jne                   LP4

	;------------Game Level----------------------------
	                                  CALL                  Adjusting_GAME_LEVEL
	                                  CALL                  Game                                                                     	;game mode
	                                  JMP                   MAINMENUStart
	YTYTY:                            JMP                   palyer2_pressed_f1

		
	SendThenEnd:                      mov                   Char_Sent,F3
	                                  CALL                  Send_Char
	ENDPROGRAM:                       

	                                  RET
MAINMENU ENDP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________


Play_Again_proc PROC NEAR
	                                  mov                   Exit,0
	                                  mov                   score_1,0
	                                  MOV                   score_ascii_1,30h
	                                  MOV                   score_ascii_1+1,'$'
	                                  mov                   score_2,0
	                                  MOV                   score_ascii_2,30h
	                                  MOV                   score_ascii_2+1,'$'
	                                  mov                   Last_Winner, 1
	                                  mov                   PointFinished, 0

	                                  RET
Play_Again_proc ENDP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________
	;--------------------------------------------------------------------------
	; clears keyboard buffer
	;--------------------------------------------------------------------------
clearkeyboardbuffer proc	near

	                                  push                  ax
	                                  push                  es
	                                  mov                   ax, 0000h
	                                  mov                   es, ax
	                                  push                  bx
	                                  mov                   bx,041eh
	                                  mov                   es:[041ah], bx                                                           	;041eh
	                                  mov                   es:[041ch], bx                                                           	;041eh				; Clears keyboard buffer
	                                  pop                   bx
	                                  pop                   es
	                                  pop                   ax

	                                  ret
clearkeyboardbuffer endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

check_scroll_up_sending proc near


	;check to scroll
	                                  cmp                   counter_y1,12
	                                  jne                   s_havent_reach_the_pageend


	                                  mov                   ax,0601h
	                                  mov                   bh,sendind_colors
	                                  mov                   cx,0                                                                     	;from cl,ch
	                                  mov                   dx,0b4FH                                                                 	;to dl,dh
	                                  int                   10h
	                                  dec                   counter_y1


	s_havent_reach_the_pageend:       
	                                  ret
check_scroll_up_sending endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

check_scroll_up_recieving proc near

	;check to scroll
	                                  cmp                   counter_y2,25
	                                  jne                   r_havent_reach_the_pageend

	                                  mov                   ax,0601h
	                                  mov                   bh,recieving_colors
	                                  mov                   cx,0d00H                                                                 	;from cl,ch
	                                  mov                   dx,184FH                                                                 	;to dl,dh
	                                  int                   10h
	                                  dec                   counter_y2


	r_havent_reach_the_pageend:       
	                                  ret
check_scroll_up_recieving endp
	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

recieve_data proc near
	;if al=0 then there is no input

	                                  mov                   dx,3fdh
	                                  in                    al,dx
	                                  and                   al,00000001b
	                                  jz                    no_in

	                                  mov                   dx,3f8h
	                                  in                    al,dx
	                                  mov                   recieves,al
	                                  jmp                   recieve_goout

	no_in:                            mov                   al,0

	recieve_goout:                    

	                                  ret
recieve_data endp
	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

send_data proc near

	                                  mov                   dx,3fdh
	again12:                          in                    al,dx
	                                  and                   al,00100000b
	                                  jz                    again12

	                                  mov                   dx,3f8h
	                                  mov                   al,sends
	                                  out                   dx,al


	                                  ret
send_data endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

handel_backspace_SEND proc near
	;handel sends
	                                  cmp                   counter_x,1
	                                  JE                    the_start_line

	                                  dec                   counter_x
	                                  mov                   sends ,0
	                                  print_mesg            counter_x,counter_y1,1,sends
	                                  dec                   counter_x
	                                  mov                   sends ,8
	                                  jmp                   return_handel_backspace_SEND

	the_start_line:                   
	                                  DEC                   counter_x
	                                  cmp                   counter_y1,0
	                                  je                    return_handel_backspace_SEND
	                                  dec                   counter_y1

	                                  mov                   counter_x,78
	                                  mov                   sends ,0
	                                  print_mesg            counter_x,counter_y1,1,sends
	                                  mov                   sends ,8
	                                  mov                   counter_x,77
	                                  jmp                   return_handel_backspace_SEND

	return_handel_backspace_SEND:     
	                                  ret
handel_backspace_SEND endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

handel_backspace_RECIEVE proc near
	;handel recieve
	                                  cmp                   counter,1
	                                  JE                    the_start_line_rec

	                                  dec                   counter
	                                  mov                   recieves ,0
	                                  print_mesg            counter,counter_y2,1,recieves
	                                  dec                   counter
	                                  mov                   recieves ,8
	                                  jmp                   return_handel_backspace_recieves

	the_start_line_rec:               
	                                  DEC                   counter
	                                  cmp                   counter_y2,13
	                                  je                    return_handel_backspace_recieves
	                                  dec                   counter_y2

	                                  mov                   counter,78
	                                  mov                   recieves ,0
	                                  print_mesg            counter,counter_y2,1,recieves
	                                  mov                   recieves ,8
	                                  mov                   counter,77
	                                  jmp                   return_handel_backspace_recieves

	return_handel_backspace_recieves: 
	                                  ret

handel_backspace_RECIEVE endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

CHAT_SEND PROC near
	;send data
	s_looping:                        
	                                  move_cursor           counter_x,counter_y1
	                                  mov                   ax,0
	                                  mov                   ah,1
	                                  int                   16h
	                                  cmp                   al,0
	                                  je                    no_input
	;clear the buffer
	;ClearBuffer
	                                  call                  clearkeyboardbuffer
	                                  mov                   sends,al
	;--------------------------------checking
	                                  cmp                   sends,13
	                                  je                    send_enter

	                                  cmp                   sends,8
	                                  jne                   not_backspace
	                                  call                  handel_backspace_SEND
	not_backspace:                    


	                                  print_mesg            counter_x,counter_y1,1,sends
	                                  jmp                   conrinue_prog_send
	send_enter:                       
	                                  mov                   counter_x,78
	conrinue_prog_send:               



	                                  call                  send_data
	                                  inc                   counter_x
	                                  mov                   al,counter_x
	                                  cmp                   al,79
	                                  jne                   no_input
	                                  inc                   counter_y1

	                                  call                  check_scroll_up_sending

	                                  mov                   al,1
	                                  mov                   counter_x,al
	no_input:                         
	                                  RET
CHAT_SEND ENDP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

CHAT_RECIEVE PROC near
	r_looping:                        
	                                  call                  recieve_data
	;checking the al 0-> no_input , otherwise-> there's an input
	                                  cmp                   al,0
	                                  je                    fakes

	;--------------------checking input for esc or enter(new line) or backspace
	                                  cmp                   recieves,13
	                                  jne                   normal_msg



	                                  mov                   counter,78
	                                  jmp                   conrinue_prog
	normal_msg:                       


	                                  cmp                   recieves,8
	                                  jne                   not_backspace_recieves
	                                  call                  handel_backspace_RECIEVE
	not_backspace_recieves:           





	                                  print_mesg            counter,counter_y2,1,recieves
	conrinue_prog:                    
	                                  inc                   counter
	                                  mov                   al,counter
	                                  cmp                   al,79
	                                  jne                   fakes
	                                  inc                   counter_y2

	                                  call                  check_scroll_up_recieving

	                                  mov                   al,1
	                                  mov                   counter,al
	fakes:                            
	                                  RET
CHAT_RECIEVE ENDP

	;________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________
get_current_video_mode proc near
	                                  mov                   ah,0fh
	                                  mov                   bh,0
	                                  int                   10h
	                                  mov                   current_video_mode,al
	                                  ret
get_current_video_mode endp
	;________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

chat_mode_set_initials proc near
	                                  mov                   sends,'$'
	                                  mov                   recieves,'$'
	                                  mov                   counter,1
	                                  mov                   counter_x,1
	                                  mov                   counter_y1,0
	                                  mov                   counter_y2,13

	                                  mov                   s_cursor,0
	                                  mov                   s_cursor+1,0
	                                  mov                   r_cursor,0
	                                  mov                   r_cursor+1,13



	                                  ret
chat_mode_set_initials endp
chat_mode PROC NEAR
	                                  call                  get_current_video_mode
	;-----------------------------------------------Clean any garbage in sending/receiving register
	                                  cmp                   Controller_Player,1
	                                  jne                   UIOIUIOO
	;if current is controller
	                                  mov                   bh,-19
	                                  mov                   Char_Sent,bh
	                                  call                  Send_Char
	                                  JMP                   PPPEESD
	;else

	UIOIUIOO:                         
	                            
	                                  call                  Receive_Char
	                                  cmp                   Char_Received,-19
	                                  jne                   UIOIUIOO

	;delay   0,10000
	;-----------------------------------------------
	PPPEESD:                          
	                                  mov                   ax,3
	                                  int                   10h

	; background
	                                  MOV                   AH, 06h                                                                  	; Scroll up function
	                                  XOR                   AL, AL                                                                   	; Clear entire screen
	                                  mov                   CX,  0                                                                   	; Upper left corner CH=row, CL=column
	                                  MOV                   DX, 0b4FH                                                                	; lower right corner DH=row, DL=column
	                                  MOV                   BH, sendind_colors
	                                  INT                   10H

	                                  MOV                   AH, 06h                                                                  	; Scroll up function
	                                  XOR                   AL, AL                                                                   	; Clear entire screen
	                                  mov                   CX,  0c00H                                                               	; Upper left corner CH=row, CL=column
	                                  MOV                   DX, 0c4FH                                                                	; lower right corner DH=row, DL=column
	                                  MOV                   BH, 07h
	                                  INT                   10H
									 
									  print_mesg 0,12,1,PressESCtoExitChat

	                                  MOV                   AH, 06h                                                                  	; Scroll up function
	                                  XOR                   AL, AL                                                                   	; Clear entire screen
	                                  mov                   CX,  0d00H                                                               	; Upper left corner CH=row, CL=column
	                                  MOV                   DX, 184FH                                                                	; lower right corner DH=row, DL=column
	                                  MOV                   BH, recieving_colors
	                                  INT                   10H
	                                  call                  clearkeyboardbuffer
	                                  call                  chat_mode_set_initials
	;-----------------------------------------------------------------------------------------------------------------
	LOOPING:                          
	                                  CALL                  CHAT_SEND
	                                  CMP                   sends,27
	                                  je                    close_chat
	                                  CALL                  CHAT_RECIEVE
	                                  CMP                   recieves,27
	                                  je                    close_chat
	                                  JMP                   LOOPING
	;-------------------------------------------------======================-------recieve data


	close_chat:                       
                                      
	                                  mov                   ax, 0
	                                  mov                   al,current_video_mode
	                                  INT                   10h
	                                  mov                   bx,0
	                                  ClearArea             WindowsHeight,WindowsWidth,bx,bx
	                                  ret


chat_mode ENDP
	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

Initial_Conditions Proc NEAR

	;Draw The Background
	                                  mov                   bx,0
	                                  ClearArea             WindowsHeight,WindowsWidth,bx,bx
			
			

	                                  mov                   Ball_X,WindowsWidth/4-Ballsize/2
	                                  cmp                   Last_Winner,2
	                                  jnz                   Players
	                                  mov                   Ball_X,WindowsWidth*3/4-Ballsize/2
	Players:                          mov                   Ball_Y,50
	                                  mov                   BallVerticalVelocity,0
	                                  mov                   BallHorizontalVelocity,0

	                                  mov                   Player1_X,WindowsWidth/4-Player1Width/2
	                                  mov                   Player1_Y,WindowsHeight-Player1Height
	                                  mov                   Player1VerticalVelocity,0

	                                  mov                   Player2_X,WindowsWidth*3/4-Player2Width/2
	                                  mov                   Player2_Y,WindowsHeight-Player2Height
	                                  mov                   Player2VerticalVelocity,0
	                                  RET
Initial_Conditions ENDP
	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

initial_screen proc NEAR
	; clear
	                                  MOV                   AH, 06h                                                                  	; Scroll up function
	                                  XOR                   AL, AL                                                                   	; Clear entire screen
	                                  mov                   CX,  0                                                                   	; Upper left corner CH=row, CL=column
	                                  MOV                   DX, 184FH                                                                	; lower right corner DH=row, DL=column
	                                  MOV                   BH, 07fh
	                                  INT                   10H


	                                  print_mesg            0,24,1,initial_msg_warning
	                                  print_mesg            0,23,1,dashedline
	write_username1:                  
	                                  print_mesg            5,10,1,initial_msg_1
	                                  read_string           0,0,0,username1
	                                  validate              username1+2
	                                  pop                   ax
	                                  cmp                   ax,0
	                                  jz                    write_username1
	intitial_return:                  

	                                  ret
initial_screen endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

MovePlayer1 Proc Near
	                                  clearArea             Player1Height, Player1Width, Player1_Y, Player1_X
	;--------Vertical Calculations-------Adjusting player y
	                                  cmp                   Player1VerticalVelocity,0
	                                  jnz                   YCalculationsPlayer1
	                                  cmp                   Player1_Y,WindowsHeight-Player1Height
	                                  jz                    CheckForPlayer1Movement
	;-------Player in the air
	;Velocity calculations
	YCalculationsPlayer1:             
	                                  mov                   ah,0
	                                  mov                   al,g
	                                  mov                   bl,deltaT
	                                  imul                  bl
	                                  add                   Player1VerticalVelocity,ax
	;Y position Calculations
	                                  mov                   ax,Player1VerticalVelocity
	                                  add                   ax,g/2
	                                  mov                   bx,DivisionConstant
	                                  CWD                                                                                            	;;;;;; dx mush carry sign flag of ax
	                                  IDIV                  bx
	                                  add                   Player1_Y,ax
	;check for ground touch
	                                  cmp                   Player1_Y,WindowsHeight-Player1Height
	                                  jLE                   CheckForPlayer1Movement
	                                  mov                   Player1_Y,WindowsHeight-Player1Height
	                                  mov                   Player1VerticalVelocity,0



	;;;;;;;;;;;;Calculations;;;;;;;;;
	;--------check for buffer data
	CheckForPlayer1Movement:          
	                                  mov                   ah,1
	                                  int                   16h                                                                      	;if a key is pressed (ah: scan , al:ascii)

	;----------------If Left key pressed
	CompareLeftPlayer1:               
	                                  cmp                   ah,Player1Left

	                                  jnz                   CompareRightPlayer1
	                                  sub                   Player1_X,Player1Movement
	;-----check for left wall
	                                  mov                   bx,Player1_X
	                                  cmp                   bx,0
	                                  jG                    ClearBuffer1
	                                  mov                   Player1_X,0

	                                  Jmp                   ClearBuffer1

	;----------------If right key pressed
	CompareRightPlayer1:              
	                                  cmp                   ah,Player1Right

	                                  jnz                   CompareUpPlayer1
	                                  add                   Player1_X,Player1Movement
	;-----check for Net
	                                  mov                   bx,Player1_X
	                                  add                   bx,Player1Width
	                                  cmp                   bx,NetStartX
	                                  jL                    ClearBuffer1
	                                  mov                   Player1_X,NetStartX-Player1Width

	                                  Jmp                   ClearBuffer1



	CompareUpPlayer1:                 
	                                  cmp                   ah,Player1Up
	                                  jnz                   DrawPlayer1Label
	;---------jumping player
	                                  cmp                   Player1_Y,WindowsHeight-Player1Height
	                                  jnz                   ClearBuffer1
	                                  sub                   Player1VerticalVelocity,JumpVelocity
	                                  Jmp                   ClearBuffer1

	ClearBuffer1:                     ClearBuffer
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	DrawPlayer1Label:                 
	                                  DrawImg               Player1Img, Player1Height, Player1Width, Player1_Y, Player1_X
	                                  RET
MovePlayer1 endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

MovePlayer2 Proc Near
	                                  clearArea             Player2Height, Player2Width, Player2_Y, Player2_X
	;--------Vertical Calculations-------Adjusting player y
	                                  cmp                   Player2VerticalVelocity,0
	                                  jnz                   YCalculationsPlayer2
	                                  cmp                   Player2_Y,WindowsHeight-Player2Height
	                                  jz                    CheckForPlayer2Movement
	;-------Player in the air
	;Velocity calculations
	YCalculationsPlayer2:             
	                                  mov                   ah,0
	                                  mov                   al,g
	                                  mov                   bl,deltaT
	                                  imul                  bl
	                                  add                   Player2VerticalVelocity,ax
	;Y position Calculations
	                                  mov                   ax,Player2VerticalVelocity
	                                  add                   ax,g/2
	                                  mov                   bx,DivisionConstant
	                                  CWD                                                                                            	;;;;;; dx mush carry sign flag of ax
	                                  IDIV                  bx
	                                  add                   Player2_Y,ax
	;check for ground touch
	                                  cmp                   Player2_Y,WindowsHeight-Player2Height
	                                  jLE                   CheckForPlayer2Movement
	                                  mov                   Player2_Y,WindowsHeight-Player2Height
	                                  mov                   Player2VerticalVelocity,0



	;;;;;;;;;;;;Calculations;;;;;;;;;
	;--------check for buffer data
	CheckForPlayer2Movement:          
	;mov                   ah,1
	;int                   16h                                                          	;if a key is pressed (ah: scan , al:ascii)
	                                  mov                   ah,Move_Player_2_Temp
	;----------------If Left key pressed
	CompareLeftPlayer2:               
	                                  cmp                   ah,Player1Left

	                                  jnz                   CompareRightPlayer2
	                                  sub                   Player2_X,Player2Movement
	;-----check for Net
	                                  mov                   bx,Player2_X
	                                  cmp                   bx,NetEndX
	                                  jG                    ClearBuffer2
	                                  mov                   Player2_X,NetEndX

	                                  Jmp                   ClearBuffer2

	;----------------If right key pressed
	CompareRightPlayer2:              
	                                  cmp                   ah,Player1Right

	                                  jnz                   CompareUpPlayer2
	                                  add                   Player2_X,Player2Movement
	;-----check for right wall
	                                  mov                   bx,Player2_X
	                                  add                   bx,Player2Width
	                                  cmp                   bx,WindowsWidth
	                                  jL                    ClearBuffer2
	                                  mov                   Player2_X,WindowsWidth-Player2Width

	                                  Jmp                   ClearBuffer2



	CompareUpPlayer2:                 
	                                  cmp                   ah,Player1Up
	                                  jnz                   DrawPlayer2Label
	;---------jumping player
	                                  cmp                   Player2_Y,WindowsHeight-Player2Height
	                                  jnz                   ClearBuffer2
	                                  sub                   Player2VerticalVelocity,JumpVelocity
	                                  Jmp                   ClearBuffer2

	ClearBuffer2:                     ClearBuffer
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	DrawPlayer2Label:                 
	                                  DrawImg               Player2Img, Player2Height, Player2Width, Player2_Y, Player2_X
	                                  RET
MovePlayer2 endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

MoveBall PROC	NEAR
	                                  cmp                   Ball_Y,0
	                                  JG                    CLEARBALLHERE
	                                  mov                   dx,0
	                                  mov                   cx, Ball_X
	                                  sub                   cx,ArrowConstant
	                                  clearArea             ArrowH,WindowsWidth,dx,dx
	                                  JMP                   CALCULATEMOVEHERE
	CLEARBALLHERE:                    
	                                  clearArea             Ballsize, BallSize, Ball_Y, Ball_X
	;;;;;;;;;Calculating Positions and velocities and Applying bounce;;;;;;
	;--------Calculating New Y
	                                  mov                   ax,Ball_Y
	;mov                  Ball_Old_Y,ax
	CALCULATEMOVEHERE:                
	                                  mov                   ah,0
	                                  mov                   al,g
	                                  mov                   bl,deltaT
	                                  imul                  bl
	                                  add                   BallVerticalVelocity,ax
	                                  mov                   ax,BallVerticalVelocity
	                                  add                   ax,g/2
	;;;;;; dx mush carry sign flag of ax
	                                  CWD
	;;;;;;;;;;;;
	                                  mov                   bx,DivisionConstant
	                                  IDIV                  bx
	                                  add                   Ball_Y,ax
	;--------------Calculating New X
	                                  mov                   ax,BallHorizontalVelocity
	                                  mov                   bx,DivisionConstant
	                                  CWD
	                                  IDIV                  bx
	                                  add                   Ball_X,ax
	;--------------New Horizontal Velocity
	; 						cmp BallHorizontalVelocity,0
	; 						jz GroundBounc
	; 						jG PosBallHV
	; 						add BallHorizontalVelocity,HorizontalResistance
	; 						jmp GroundBounc
	; PosBallHV:				sub BallHorizontalVelocity,HorizontalResistance
	; GroundBounc:
	;----------CHECK GROUND BOUNCE

	                                  mov                   bx,Ball_Y
	                                  add                   bx,Ballsize
	                                  mov                   ax,GroundStartY
	                                  cmp                   bx,ax
	                                  jL                    abbas
	                                  neg                   BallVerticalVelocity
	                                  mov                   Ball_Y,GroundStartY-BallSize
	                                  CALL                  incrementscore
			
	abbas:                            
	;------------CHECK RIGHT WALL
	                                  mov                   bx,Ball_X
	                                  add                   bx,Ballsize
	                                  cmp                   bx,WindowsWidth
	                                  jL                    abbas2
	                                  neg                   BallHorizontalVelocity
	                                  mov                   Ball_X,WindowsWidth-Ballsize
	abbas2:                           

	;-----------CHECK LEFT WALL
	                                  mov                   bx,Ball_X
	                                  cmp                   bx,0
	                                  jG                    abbas3
	                                  neg                   BallHorizontalVelocity
	                                  mov                   Ball_X,0
	abbas3:                           

	;------------------------CHECK NET(right side)

	                                  cmp                   Ball_X,NetEndX
	                                  ja                    abbas4
	                                  cmp                   Ball_X, NetEndX-Ballsize
	                                  jb                    abbas4
	                                  cmp                   Ball_Y,NetStartY-Ballsize/2
	                                  JL                    abbas4
	                                  mov                   ax,NetEndX
	                                  mov                   Ball_X,ax
	                                  neg                   BallHorizontalVelocity

	abbas4:                           

	;------------------------CHECK NET(Left side)

	                                  cmp                   Ball_X,NetStartX-Ballsize
	                                  JB                    abbas5
	                                  cmp                   Ball_X, NetStartX
	                                  JA                    abbas5
	                                  cmp                   Ball_Y,NetStartY-Ballsize/2
	                                  JL                    abbas5
	                                  mov                   ax,NetStartX-Ballsize
	                                  mov                   Ball_X,ax
	                                  neg                   BallHorizontalVelocity

	abbas5:                           

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;------------Check Player1 Collision
	CHKPlayer1Collision:              
	                                  mov                   ax,0
	                                  Call                  CheckBallPlayer1Collision
	                                  cmp                   ax,1
	                                  jnz                   CHKPlayer2Collision
	                                  Call                  BallPlayer1CollisionCalculations
	                                  jmp                   CheckBallOutOfScreen

	;------------Check Player2 Collision
	CHKPlayer2Collision:              
	                                  mov                   ax,0
	                                  Call                  CheckBallPlayer2Collision
	                                  cmp                   ax,1
	                                  jnz                   CheckBallOutOfScreen
	                                  Call                  BallPlayer2CollisionCalculations


	CheckBallOutOfScreen:             
	;-------------------------If the ball got out of the screen----------------
	                                  cmp                   Ball_Y,0
	                                  JGE                   DRAWBALLHERE
	;draw ball sign
	                                  mov                   dx,0
	                                  mov                   cx, Ball_X
	                                  sub                   cx,ArrowConstant
	                                  DrawImg               ArrowImg, ArrowH, ArrowW, dx, cx
	                                  JMP                   ENDMOVE
	;---------------
	DRAWBALLHERE:                     
	                                  DrawImg               BallImg, Ballsize, Ballsize, Ball_Y, Ball_X

ENDMOVE:
	                                  RET
MoveBall ENDP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

BallPlayer1CollisionCalculations Proc   Near
	;How Ball bounce against player (Vertical)
	                                  mov                   ax,Ball_Y
	                                  add                   ax,Ballsize/2
	                                  mov                   Ball_Center,ax
	                                  mov                   ax,Player1_Y
	                                  add                   ax,Player1Height/2
	                                  mov                   Player1_Center,ax
	                                  mov                   ax,Ball_Center
	                                  sub                   ax,Player1_Center                                                        	;ax = ballcenter - player center
	                                  mov                   bx, CollisionConstant
	                                  cwd
	;idiv        bx
	                                  mov                   BallVerticalVelocity,ax
	                                  mov                   bx,Player1VerticalVelocity
	                                  add                   BallVerticalVelocity,bx

	;;;;;;;;TEST;;;;;;;;;;;; For ball not to go into player
	; mov ax,Ball_Y
	; sub ax,Ball_Old_Y
	; mov bx,2
	; cwd
	; Idiv bx
	; add ax,Ball_Old_Y
	; mov Ball_Y,ax
	;;;;;;;;;;;;;;;;;;;;;;
	;How Ball bounce against player (Horizontal)
	                                  mov                   ax,Ball_X
	                                  add                   ax,Ballsize/2
	                                  mov                   Ball_Center,ax
	                                  mov                   ax,Player1_X
	                                  add                   ax,Player1Width/2
	                                  mov                   Player1_Center,ax
	                                  mov                   ax,Ball_Center
	                                  sub                   ax,Player1_Center                                                        	;ax = ballcenter - player center
	                                  mov                   bx, CollisionConstant
	                                  cwd
	;idiv        bx
	                                  mov                   BallHorizontalVelocity,ax
	;mov 		bx,Player1VerticalVelocity
	;add         BallVerticalVelocity,bx
	                                  RET
BallPlayer1CollisionCalculations endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

BallPlayer2CollisionCalculations Proc   Near
	;How Ball bounce against player (Vertical)
	                                  mov                   ax,Ball_Y
	                                  add                   ax,Ballsize/2
	                                  mov                   Ball_Center,ax
	                                  mov                   ax,Player2_Y
	                                  add                   ax,Player2Height/2
	                                  mov                   Player2_Center,ax
	                                  mov                   ax,Ball_Center
	                                  sub                   ax,Player2_Center                                                        	;ax = ballcenter - player center
	                                  mov                   bx, CollisionConstant
	                                  cwd
	;idiv        bx
	                                  mov                   BallVerticalVelocity,ax
	                                  mov                   bx,Player2VerticalVelocity
	                                  add                   BallVerticalVelocity,bx

	;;;;;;;;TEST;;;;;;;;;;;; For ball not to go into player
	; mov ax,Ball_Y
	; sub ax,Ball_Old_Y
	; mov bx,2
	; cwd
	; Idiv bx
	; add ax,Ball_Old_Y
	; mov Ball_Y,ax
	;;;;;;;;;;;;;;;;;;;;;;
	;How Ball bounce against player (Horizontal)
	                                  mov                   ax,Ball_X
	                                  add                   ax,Ballsize/2
	                                  mov                   Ball_Center,ax
	                                  mov                   ax,Player2_X
	                                  add                   ax,Player2Width/2
	                                  mov                   Player2_Center,ax
	                                  mov                   ax,Ball_Center
	                                  sub                   ax,Player2_Center                                                        	;ax = ballcenter - player center
	                                  mov                   bx, CollisionConstant
	                                  cwd
	;idiv        bx
	                                  mov                   BallHorizontalVelocity,ax
	;mov 		bx,Player2VerticalVelocity
	;add         BallVerticalVelocity,bx
	                                  RET
BallPlayer2CollisionCalculations endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

CheckBallPlayer1Collision Proc Near
	;ball is to the left of player right bound
	                                  mov                   bx, Player1_X
	                                  add                   bx, Player1Width
	                                  cmp                   bx, Ball_X
	                                  JLE                   NoCollision1

	;ball is to the right of player left side
	                                  mov                   bx, Ballsize
	                                  add                   bx, Ball_X
	                                  cmp                   bx, Player1_X
	                                  JLE                   NoCollision1

	;ball is beneath player upper side
	                                  mov                   bx, Player1_Y
	                                  add                   bx, Player1Height
	                                  cmp                   bx, Ball_Y
	                                  JLE                   NoCollision1

	;ball is above player lower side
	                                  mov                   bx, Ball_Y
	                                  add                   bx, Ballsize
	                                  cmp                   bx, Player1_Y
	                                  JLE                   NoCollision1

	;TRUE
	                                  mov                   AX, 1

	NoCollision1:                     
	                                  RET
CheckBallPlayer1Collision endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

CheckBallPlayer2Collision Proc Near
	;ball is to the left of player right bound
	                                  mov                   bx, Player2_X
	                                  add                   bx, Player2Width
	                                  cmp                   bx, Ball_X
	                                  JLE                   NoCollision2

	;ball is to the right of player left side
	                                  mov                   bx, Ballsize
	                                  add                   bx, Ball_X
	                                  cmp                   bx, Player2_X
	                                  JLE                   NoCollision2

	;ball is beneath player upper side
	                                  mov                   bx, Player2_Y
	                                  add                   bx, Player2Height
	                                  cmp                   bx, Ball_Y
	                                  JLE                   NoCollision2

	;ball is above player lower side
	                                  mov                   bx, Ball_Y
	                                  add                   bx, Ballsize
	                                  cmp                   bx, Player2_Y
	                                  JLE                   NoCollision2

	;TRUE
	                                  mov                   AX, 1

	NoCollision2:                     
	                                  RET
CheckBallPlayer2Collision endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________


incrementscore proc NEAR
	                                  mov                   dx,Ball_X
	                                  mov                   ax,WindowsWidth/2
	                                  cmp                   dx,ax
	                                  jL                    inc_user_2
	                                  inc                   score_1
	                                  convert_num_to_ascii  score_1,score_ascii_1
	                                  mov                   Last_Winner,1

	                                  cmp                   score_1, MAX_Score
	                                  jnz                   return_inc
	                                  mov                   Exit,1
	                                  jmp                   return_inc
	inc_user_2:                       
	                                  inc                   score_2
	                                  mov                   Last_Winner,2
	                                  convert_num_to_ascii  score_2,score_ascii_2
	                                  cmp                   score_2, MAX_Score
	                                  jnz                   return_inc
	                                  mov                   Exit,1

	return_inc:                       
	                                  mov                   PointFinished,1                                                          	;To reset screen
	                                  ret
incrementscore endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

DrawScores PROC Near
	                                  print_mesg            0,1,1,username1+2
	                                  print_mesg            username1+1,1,1,DrawScores_msg
	                                  print_mesg            0,0,0,score_ascii_1


	                                  print_mesg            20,1,1,username2+2
	                                  mov                   al,20
	                                  add                   al,username2+1
	                                  print_mesg            al,1,1,DrawScores_msg
	                                  print_mesg            0,0,0,score_ascii_2
	                                  RET
DrawScores EndP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

Draw Proc  Near
	                                  pop                   IP_Pointer_Temp                                                          	;store ip pointer for return
	;   pop       HorizontalOffset                                           	;popping data from stack
	;   pop       VerticalOffset
	;   pop       AreaWidth
	;   pop       AreaHeight
	;   pop       bx                                                         	;Carry Img data pointer

	;setting interrupt configurations
	                                  MOV                   CX, 0                                                                    	;AreaWidth ;0
	                                  MOV                   DX, 0                                                                    	; AreaHeight ;0
	                                  add                   cx,HorizontalOffset
	                                  add                   dx,VerticalOffset
	                                  mov                   di,bx
	                                  jmp                   StartDrawing

	Drawit:                           
	                                  MOV                   AH,0Ch                                                                   	;draw pixel
	                                  mov                   al, [DI]                                                                 	;color of current pixel
	                                  cmp                   al,0                                                                     	;if pixel is empty
	                                  jz                    StartDrawing                                                             	;skip
	                                  MOV                   BH,00h                                                                   	;set page number
	                                  INT                   10h
	;call dddd
	StartDrawing:                     
	                                  inc                   DI                                                                       	;move to next pixel
	                                  INC                   Cx                                                                       	;dec
	                                  mov                   bx,HorizontalOffset
	                                  add                   bx,AreaWidth
	                                  cmp                   cx,bx                                                                    	;VerticalOffset ;+areawidth
	                                  JNZ                   Drawit
	                                  mov                   Cx, HorizontalOffset                                                     	;AreaWidth	;0
	                                  INC                   DX                                                                       	;dec
	                                  mov                   bx,VerticalOffset
	                                  add                   bx,AreaHeight
	                                  cmp                   dx,bx                                                                    	;HorizontalOffset	;+areaheight
	                                  JZ                    ENDDrawing
	                                  Jmp                   Drawit

	ENDDrawing:                       
	                                  push                  IP_Pointer_Temp
	                                  RET
draw endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

dddd proc
	                                  push                  ax
	                                  push                  bx
	                                  push                  cx
	                                  push                  dx
	                                  delay                 0,1
	                                  pop                   dx
	                                  pop                   cx
	                                  pop                   bx
	                                  pop                   ax
	                                  RET
dddd endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________


final_screen proc NEAR
	; clear
	                                  mov                   ax,3
	                                  int                   10h
	                                  MOV                   AH, 06h                                                                  	; Scroll up function
	                                  XOR                   AL, AL                                                                   	; Clear entire screen
	                                  mov                   CX,  0                                                                   	; Upper left corner CH=row, CL=column
	                                  MOV                   DX, 184FH                                                                	; lower right corner DH=row, DL=column
	                                  MOV                   BH, 07fh
	                                  INT                   10H
			
	                                  print_mesg            0,10,1,username1+2
	                                  print_mesg            username1+1,10,1,final_msg_1
	                                  print_mesg            0,0,0,score_ascii_1


	                                  print_mesg            0,11,1,username2+2
	                                  print_mesg            username2+1,11,1,final_msg_1
	                                  print_mesg            0,0,0,score_ascii_2

	;PRINT THE STATUS BAR
	                                  print_mesg            0,22,1,dashedline
	                                  print_mesg            0,23,1,final_msg_4
	                                  print_mesg            0,24,1,final_msg_5

	                                  mov                   al, score_1
	                                  mov                   ah, score_2

	                                  cmp                   al,ah
	                                  jnz                   not_tie
	                                  print_mesg            30,17,1,final_msg_3
	                                  jmp                   return
	not_tie:                          
	                                  cmp                   al,ah
	                                  jbe                   player_2_wins
	                                  print_mesg            30,17,1,username1+2
	                                  mov                   al,username1+1
	                                  add                   al,30
	                                  print_mesg            al,17,1,final_msg_2
	                                  jmp                   return
	player_2_wins:                    
	                                  print_mesg            30,17,1,username2+2
	                                  mov                   al,username2+1
	                                  add                   al,30
	                                  print_mesg            al,17,1,final_msg_2
	return:                           
	                                  mov                   ax,0
	                                  int                   16h

	                                  cmp                   ah,1
	                                  jne                   second_check_finalscreen
	                                  mov                   play_again,ah
	                                  jmp                   return_from_finalscreen

	second_check_finalscreen:         
	                                  cmp                   ah,60
	                                  jne                   return
	                                  mov                   play_again,ah

	return_from_finalscreen:          
	                                  ret
final_screen endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

Clear Proc  Near
	                                  Assume                ds:BackgroundData
	;   pop       HorizontalOffset
	;   pop       VerticalOffset
	;   pop       AreaWidth
	;   pop       AreaHeight
	;Assume ds:BackgroundData
	;setting interrupt configurations
	                                  MOV                   CX, 0                                                                    	;AreaWidth ;0
	                                  MOV                   DX, 0                                                                    	;AreaHeight ;0
	                                  add                   cx,ClearHorizontalOffset
	                                  add                   dx,ClearVerticalOffset
	                                  mov                   di,bx
	                                  jmp                   StartClearing

	Clearit:                          

	                                  push                  dx                                                                       	;store dx, to be returned later
	                                  mov                   ax,dx
	                                  mov                   bx,320
	                                  mul                   bx                                                                       	;ax = dx*320
	                                  add                   ax,cx
	                                  mov                   si,ax                                                                    	;si here point to the same pixel that should be removed but in background data
	                                  pop                   dx                                                                       	;return dx(row number)

	                                  MOV                   AH,0Ch                                                                   	;draw pixel mode
	                                  mov                   al,BackGroundImg[SI]                                                     	;color of current background pixel
	;mov                  al,0
	;mov       al,BGC                                                     	;draw pixel with background color
	                                  MOV                   BH,00h                                                                   	;page number
	                                  INT                   10h
	StartClearing:                    
	                                  inc                   DI                                                                       	;move to next pixel
	                                  INC                   Cx                                                                       	;dec
	                                  mov                   bx,ClearHorizontalOffset
	                                  add                   bx,ClearAreaWidth
	                                  cmp                   cx,bx                                                                    	;VerticalOffset
	                                  JNZ                   Clearit
	                                  mov                   Cx, 0                                                                    	;AreaWidth ;0
	                                  add                   cx,ClearHorizontalOffset
	                                  INC                   DX                                                                       	;dec
	                                  mov                   bx,ClearVerticalOffset
	                                  add                   bx,ClearAreaHeight
	                                  cmp                   dx,bx                                                                    	;HorizontalOffset
	                                  JZ                    EndClearing
	                                  Jmp                   Clearit

	EndClearing:                      
	                                  RET
Clear endp

END MAIN