include Macros.inc
.model HUGE
.Stack 64

;  ________________
; |   __________   \
; |  |          \   \
; |  |           |  |
; |  |           |  |
; |  |           |  |
; |  |           |  |
; |  |__________/   /
; |________________/


BackgroundData Segment
	;-------------------Clear Area Data----------
	ClearHorizontalOffset dw ?
	ClearVerticalOffset   dw ?
	ClearAreaWidth        dw ?
	ClearAreaHeight       dw ?
	;-----------------------------------------
	EXTRN BackGroundImg:BYTE
BackgroundData ENDS


.data
	IP_Pointer_Temp         dw  ?
	BGC                     db  0
	WindowsWidth            EQU 320
	WindowsHeight           EQU 200
	Exit                    db  0
	MAX_Score               EQU 11
	Last_Winner             db  1
	PointFinished           db  0
	;BackGround Color
	;---------------Initial/Final screen
	initial_msg_warning     db  "*The username shouldn't exceed 15 characters and should start with a letter.$"
	initial_msg_1           db  'please enter the username of the first player: $'
	initial_msg_2           db  'please enter the username of the second player: $'
	dashedline              db  80 dup('-'),'$'


	final_msg_1             db  "'s final score is  $"
	final_msg_2             db  " is the Winner :) $"
	final_msg_3             db  "It's a TIE :| $"

	final_msg_4             db  "*press ESC to close the program. $"
	final_msg_5             db  "*press F2 to play again. $"

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
	MAINMENU_mesg3          db  "*To end the program press ESC",'$'
	play_again              db  1
	;---------------chat_mode screen
	chat_msg1               db  "*The chat mode is currently unavailable (please try again later).$"
	chat_msg2               db  "*To start volleyball game press F2",'$'
	chat_msg3               db  "*To end the program press ESC",'$'
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
	
	                                 mov                  ax, @data
	                                 mov                  DS, ax
	                                 mov                  ES,ax
	;Initial Screen
	                                 CALL                 initial_screen
	;MAIN Menu Screen
	                                 CALL                 MAINMENU





	;end program
	                                 mov                  ax,3
	                                 int                  10h
	                                 mov                  ax , 4C01H
	                                 int                  21h


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
Game PROC NEAR
	;open graphics mode
	                                 mov                  ax, 0013h
	                                 INT                  10h


	;Initial Conditions
	InitialConditions:               CALL                 Initial_Conditions
									
	;Game Loop
	MainLoop:                                                                                                          	;Call        MovePlayer1
	                                 Call                 MovePlayer1
	                                 Call                 MovePlayer2
	                                 Call                 MoveBall
	                                 CALL                 DrawScores
	                                 ClearBuffer
	                                 Delay                0,25000
	                                 cmp                  Exit,0
	                                 jnz                  EndGame
	                                 cmp                  PointFinished,0
	                                 jz                   MainLoop
	                                 CALL                 Initial_Conditions
	                                 mov                  PointFinished,0
	                                 JMP                  InitialConditions

	;Final Screen
	EndGame:                         CALL                 final_screen

	                                 RET
GAME ENDP
	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________
MAINMENU PROC     NEAR                                                                                             		;the first screen of the terminal
	; clear
	                                 MOV                  AH, 06h                                                      	; Scroll up function
	                                 XOR                  AL, AL                                                       	; Clear entire screen
	                                 mov                  CX,  0                                                       	; Upper left corner CH=row, CL=column
	                                 MOV                  DX, 184FH                                                    	; lower right corner DH=row, DL=column
	                                 MOV                  BH, 07fh
	                                 INT                  10H

	; show mesg
	                                 print_mesg           25,10,1,MAINMENU_mesg1
	; show mesg
	                                 print_mesg           25,11,1,MAINMENU_mesg2
	; show mesg
	                                 print_mesg           25,12,1,MAINMENU_mesg3
	;print dashed line
	                                 print_mesg           0,23,1,dashedline
	;wait for a key to proceed and then proceed it and then exit the program
	                                 move_cursor          25,12
	check:                           
	                                 mov                  ax,0
	                                 int                  16h
	                                 cmp                  ah,1
	                                 je                   return_from_mainmenu
	                                 cmp                  ah,59
	                                 jne                  secondcheck
	                                 call                 chat_mode
	                                 jmp                  return_from_mainmenu
	secondcheck:                     cmp                  ah,60
	                                 jne                  check
	                                 call                 Game
	;check if the player wants to play again or not (F2 to play again   or    ESC to close the program )
	mainmenu_playagain:              
	                                 mov                  ah,play_again
	                                 cmp                  play_again,60
	                                 jne                  return_from_mainmenu
	                                 call                 Play_Again_proc

	                                 jmp                  mainmenu_playagain
	return_from_mainmenu:            mov                  ah,1
	                                 mov                  play_again,ah
	                                 RET
MAINMENU ENDP
	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________


Play_Again_proc PROC NEAR
	                                 mov                  Exit,0
	                                 mov                  score_1,0
	                                 MOV                  score_ascii_1,30h
	                                 MOV                  score_ascii_1+1,'$'
	                                 mov                  score_2,0
	                                 MOV                  score_ascii_2,30h
	                                 MOV                  score_ascii_2+1,'$'
	                                 mov                  Last_Winner, 1
	                                 mov                  PointFinished, 0


	                                 call                 Game
	                                 RET
Play_Again_proc ENDP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

chat_mode PROC NEAR
	; clear
	                                 MOV                  AH, 06h                                                      	; Scroll up function
	                                 XOR                  AL, AL                                                       	; Clear entire screen
	                                 mov                  CX,  0                                                       	; Upper left corner CH=row, CL=column
	                                 MOV                  DX, 184FH                                                    	; lower right corner DH=row, DL=column
	                                 MOV                  BH, 07fh
	                                 INT                  10H
	                                 print_mesg           0,23,1,dashedline
	                                 print_mesg           0,24,1,chat_msg1
	                                 print_mesg           0,10,1,chat_msg2
	                                 print_mesg           0,11,1,chat_msg3

	;----------------------------------------------------------this part is temporary till we add the chat mode
	;wait for a key to proceed and then proceed
	checkchat:                       
	                                 mov                  ax,0
	                                 int                  16h
	                                 cmp                  ah,1
	                                 je                   reurnchat
	                                 cmp                  ah,60
	                                 jne                  checkchat
	                                 call                 Game
	reurnchat:                       
	                                 RET

	                                 ret
chat_mode ENDP
	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________
	
Initial_Conditions Proc NEAR

	;Draw The Background
	                                 mov                  bx,0
	                                 ClearArea            WindowsHeight,WindowsWidth,bx,bx

	                                 mov                  Ball_X,WindowsWidth/4-Ballsize/2
	                                 cmp                  Last_Winner,2
	                                 jnz                  Players
	                                 mov                  Ball_X,WindowsWidth*3/4-Ballsize/2
	Players:                         mov                  Ball_Y,50
	                                 mov                  BallVerticalVelocity,0
	                                 mov                  BallHorizontalVelocity,0

	                                 mov                  Player1_X,WindowsWidth/4-Player1Width/2
	                                 mov                  Player1_Y,WindowsHeight-Player1Height
	                                 mov                  Player1VerticalVelocity,0

	                                 mov                  Player2_X,WindowsWidth*3/4-Player2Width/2
	                                 mov                  Player2_Y,WindowsHeight-Player2Height
	                                 mov                  Player2VerticalVelocity,0
	                                 RET
Initial_Conditions ENDP
	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

initial_screen proc NEAR
	; clear
	                                 MOV                  AH, 06h                                                      	; Scroll up function
	                                 XOR                  AL, AL                                                       	; Clear entire screen
	                                 mov                  CX,  0                                                       	; Upper left corner CH=row, CL=column
	                                 MOV                  DX, 184FH                                                    	; lower right corner DH=row, DL=column
	                                 MOV                  BH, 07fh
	                                 INT                  10H

	                                 print_mesg           0,24,1,initial_msg_warning
	                                 print_mesg           0,23,1,dashedline
	write_username1:                 
	                                 print_mesg           5,10,1,initial_msg_1
	                                 read_string          0,0,0,username1
	                                 validate             username1+2
	                                 pop                  ax
	                                 cmp                  ax,0
	                                 jz                   write_username1
	write_username2:                 
	                                 print_mesg           5,12,1,initial_msg_2
	                                 read_string          0,0,0,username2
	                                 validate             username2+2
	                                 pop                  ax
	                                 cmp                  ax,0
	                                 jz                   write_username2


	intitial_return:                 
	                                 ret
initial_screen endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

MovePlayer1 Proc Near
	                                 clearArea            Player1Height, Player1Width, Player1_Y, Player1_X
	;--------Vertical Calculations-------Adjusting player y
	                                 cmp                  Player1VerticalVelocity,0
	                                 jnz                  YCalculationsPlayer1
	                                 cmp                  Player1_Y,WindowsHeight-Player1Height
	                                 jz                   CheckForPlayer1Movement
	;-------Player in the air
	;Velocity calculations
	YCalculationsPlayer1:            
	                                 mov                  ah,0
	                                 mov                  al,g
	                                 mov                  bl,deltaT
	                                 imul                 bl
	                                 add                  Player1VerticalVelocity,ax
	;Y position Calculations
	                                 mov                  ax,Player1VerticalVelocity
	                                 add                  ax,g/2
	                                 mov                  bx,DivisionConstant
	                                 CWD                                                                               	;;;;;; dx mush carry sign flag of ax
	                                 IDIV                 bx
	                                 add                  Player1_Y,ax
	;check for ground touch
	                                 cmp                  Player1_Y,WindowsHeight-Player1Height
	                                 jLE                  CheckForPlayer1Movement
	                                 mov                  Player1_Y,WindowsHeight-Player1Height
	                                 mov                  Player1VerticalVelocity,0



	;;;;;;;;;;;;Calculations;;;;;;;;;
	;--------check for buffer data
	CheckForPlayer1Movement:         
	                                 mov                  ah,1
	                                 int                  16h                                                          	;if a key is pressed (ah: scan , al:ascii)

	;----------------If Left key pressed
	CompareLeftPlayer1:              
	                                 cmp                  ah,Player1Left

	                                 jnz                  CompareRightPlayer1
	                                 sub                  Player1_X,Player1Movement
	;-----check for left wall
	                                 mov                  bx,Player1_X
	                                 cmp                  bx,0
	                                 jG                   ClearBuffer1
	                                 mov                  Player1_X,0

	                                 Jmp                  ClearBuffer1

	;----------------If right key pressed
	CompareRightPlayer1:             
	                                 cmp                  ah,Player1Right

	                                 jnz                  CompareUpPlayer1
	                                 add                  Player1_X,Player1Movement
	;-----check for Net
	                                 mov                  bx,Player1_X
	                                 add                  bx,Player1Width
	                                 cmp                  bx,NetStartX
	                                 jL                   ClearBuffer1
	                                 mov                  Player1_X,NetStartX-Player1Width

	                                 Jmp                  ClearBuffer1



	CompareUpPlayer1:                
	                                 cmp                  ah,Player1Up
	                                 jnz                  DrawPlayer1Label
	;---------jumping player
	                                 cmp                  Player1_Y,WindowsHeight-Player1Height
	                                 jnz                  ClearBuffer1
	                                 sub                  Player1VerticalVelocity,JumpVelocity
	                                 Jmp                  ClearBuffer1

	ClearBuffer1:                    ClearBuffer
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	DrawPlayer1Label:                
	                                 DrawImg              Player1Img, Player1Height, Player1Width, Player1_Y, Player1_X
	                                 RET
MovePlayer1 endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

MovePlayer2 Proc Near
	                                 clearArea            Player2Height, Player2Width, Player2_Y, Player2_X
	;--------Vertical Calculations-------Adjusting player y
	                                 cmp                  Player2VerticalVelocity,0
	                                 jnz                  YCalculationsPlayer2
	                                 cmp                  Player2_Y,WindowsHeight-Player2Height
	                                 jz                   CheckForPlayer2Movement
	;-------Player in the air
	;Velocity calculations
	YCalculationsPlayer2:            
	                                 mov                  ah,0
	                                 mov                  al,g
	                                 mov                  bl,deltaT
	                                 imul                 bl
	                                 add                  Player2VerticalVelocity,ax
	;Y position Calculations
	                                 mov                  ax,Player2VerticalVelocity
	                                 add                  ax,g/2
	                                 mov                  bx,DivisionConstant
	                                 CWD                                                                               	;;;;;; dx mush carry sign flag of ax
	                                 IDIV                 bx
	                                 add                  Player2_Y,ax
	;check for ground touch
	                                 cmp                  Player2_Y,WindowsHeight-Player2Height
	                                 jLE                  CheckForPlayer2Movement
	                                 mov                  Player2_Y,WindowsHeight-Player2Height
	                                 mov                  Player2VerticalVelocity,0



	;;;;;;;;;;;;Calculations;;;;;;;;;
	;--------check for buffer data
	CheckForPlayer2Movement:         
	                                 mov                  ah,1
	                                 int                  16h                                                          	;if a key is pressed (ah: scan , al:ascii)

	;----------------If Left key pressed
	CompareLeftPlayer2:              
	                                 cmp                  ah,Player2Left

	                                 jnz                  CompareRightPlayer2
	                                 sub                  Player2_X,Player2Movement
	;-----check for Net
	                                 mov                  bx,Player2_X
	                                 cmp                  bx,NetEndX
	                                 jG                   ClearBuffer2
	                                 mov                  Player2_X,NetEndX

	                                 Jmp                  ClearBuffer2

	;----------------If right key pressed
	CompareRightPlayer2:             
	                                 cmp                  ah,Player2Right

	                                 jnz                  CompareUpPlayer2
	                                 add                  Player2_X,Player2Movement
	;-----check for right wall
	                                 mov                  bx,Player2_X
	                                 add                  bx,Player2Width
	                                 cmp                  bx,WindowsWidth
	                                 jL                   ClearBuffer2
	                                 mov                  Player2_X,WindowsWidth-Player2Width

	                                 Jmp                  ClearBuffer2



	CompareUpPlayer2:                
	                                 cmp                  ah,Player2Up
	                                 jnz                  DrawPlayer2Label
	;---------jumping player
	                                 cmp                  Player2_Y,WindowsHeight-Player2Height
	                                 jnz                  ClearBuffer2
	                                 sub                  Player2VerticalVelocity,JumpVelocity
	                                 Jmp                  ClearBuffer2

	ClearBuffer2:                    ClearBuffer
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	DrawPlayer2Label:                
	                                 DrawImg              Player2Img, Player2Height, Player2Width, Player2_Y, Player2_X
	                                 RET
MovePlayer2 endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

MoveBall PROC	NEAR
	                                 cmp                  Ball_Y,0
	                                 JG                   CLEARBALLHERE
	                                 mov                  dx,0
	                                 mov                  cx, Ball_X
	                                 sub                  cx,ArrowConstant
	                                 clearArea            ArrowH,WindowsWidth,dx,dx
	                                 JMP                  CALCULATEMOVEHERE
	CLEARBALLHERE:                   
	                                 clearArea            Ballsize, BallSize, Ball_Y, Ball_X
	;;;;;;;;;Calculating Positions and velocities and Applying bounce;;;;;;
	;--------Calculating New Y
	                                 mov                  ax,Ball_Y
	;mov                  Ball_Old_Y,ax
	CALCULATEMOVEHERE:               
	                                 mov                  ah,0
	                                 mov                  al,g
	                                 mov                  bl,deltaT
	                                 imul                 bl
	                                 add                  BallVerticalVelocity,ax
	                                 mov                  ax,BallVerticalVelocity
	                                 add                  ax,g/2
	;;;;;; dx mush carry sign flag of ax
	                                 CWD
	;;;;;;;;;;;;
	                                 mov                  bx,DivisionConstant
	                                 IDIV                 bx
	                                 add                  Ball_Y,ax
	;--------------Calculating New X
	                                 mov                  ax,BallHorizontalVelocity
	                                 mov                  bx,DivisionConstant
	                                 CWD
	                                 IDIV                 bx
	                                 add                  Ball_X,ax
	;--------------New Horizontal Velocity
	; 						cmp BallHorizontalVelocity,0
	; 						jz GroundBounc
	; 						jG PosBallHV
	; 						add BallHorizontalVelocity,HorizontalResistance
	; 						jmp GroundBounc
	; PosBallHV:				sub BallHorizontalVelocity,HorizontalResistance
	; GroundBounc:
	;----------CHECK GROUND BOUNCE

	                                 mov                  bx,Ball_Y
	                                 add                  bx,Ballsize
	                                 mov                  ax,GroundStartY
	                                 cmp                  bx,ax
	                                 jL                   abbas
	                                 neg                  BallVerticalVelocity
	                                 mov                  Ball_Y,GroundStartY-BallSize
	                                 CALL                 incrementscore
									 
	abbas:                           
	;------------CHECK RIGHT WALL
	                                 mov                  bx,Ball_X
	                                 add                  bx,Ballsize
	                                 cmp                  bx,WindowsWidth
	                                 jL                   abbas2
	                                 neg                  BallHorizontalVelocity
	                                 mov                  Ball_X,WindowsWidth-Ballsize
	abbas2:                          

	;-----------CHECK LEFT WALL
	                                 mov                  bx,Ball_X
	                                 cmp                  bx,0
	                                 jG                   abbas3
	                                 neg                  BallHorizontalVelocity
	                                 mov                  Ball_X,0
	abbas3:                          

	;------------------------CHECK NET(right side)

	                                 cmp                  Ball_X,NetEndX
	                                 ja                   abbas4
	                                 cmp                  Ball_X, NetEndX-Ballsize
	                                 jb                   abbas4
	                                 cmp                  Ball_Y,NetStartY-Ballsize/2
	                                 JL                   abbas4
	                                 mov                  ax,NetEndX
	                                 mov                  Ball_X,ax
	                                 neg                  BallHorizontalVelocity

	abbas4:                          

	;------------------------CHECK NET(Left side)

	                                 cmp                  Ball_X,NetStartX-Ballsize
	                                 JB                   abbas5
	                                 cmp                  Ball_X, NetStartX
	                                 JA                   abbas5
	                                 cmp                  Ball_Y,NetStartY-Ballsize/2
	                                 JL                   abbas5
	                                 mov                  ax,NetStartX-Ballsize
	                                 mov                  Ball_X,ax
	                                 neg                  BallHorizontalVelocity

	abbas5:                          

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;------------Check Player1 Collision
	CHKPlayer1Collision:             
	                                 mov                  ax,0
	                                 Call                 CheckBallPlayer1Collision
	                                 cmp                  ax,1
	                                 jnz                  CHKPlayer2Collision
	                                 Call                 BallPlayer1CollisionCalculations
	                                 jmp                  CheckBallOutOfScreen

	;------------Check Player2 Collision
	CHKPlayer2Collision:             
	                                 mov                  ax,0
	                                 Call                 CheckBallPlayer2Collision
	                                 cmp                  ax,1
	                                 jnz                  CheckBallOutOfScreen
	                                 Call                 BallPlayer2CollisionCalculations


	CheckBallOutOfScreen:            
	;-------------------------If the ball got out of the screen----------------
	                                 cmp                  Ball_Y,0
	                                 JGE                  DRAWBALLHERE
	;draw ball sign
	                                 mov                  dx,0
	                                 mov                  cx, Ball_X
	                                 sub                  cx,ArrowConstant
	                                 DrawImg              ArrowImg, ArrowH, ArrowW, dx, cx
	                                 JMP                  ENDMOVE
	;---------------
	DRAWBALLHERE:                    
	                                 DrawImg              BallImg, Ballsize, Ballsize, Ball_Y, Ball_X

ENDMOVE:
	                                 RET
MoveBall ENDP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

BallPlayer1CollisionCalculations Proc   Near
	;How Ball bounce against player (Vertical)
	                                 mov                  ax,Ball_Y
	                                 add                  ax,Ballsize/2
	                                 mov                  Ball_Center,ax
	                                 mov                  ax,Player1_Y
	                                 add                  ax,Player1Height/2
	                                 mov                  Player1_Center,ax
	                                 mov                  ax,Ball_Center
	                                 sub                  ax,Player1_Center                                            	;ax = ballcenter - player center
	                                 mov                  bx, CollisionConstant
	                                 cwd
	;idiv        bx
	                                 mov                  BallVerticalVelocity,ax
	                                 mov                  bx,Player1VerticalVelocity
	                                 add                  BallVerticalVelocity,bx

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
	                                 mov                  ax,Ball_X
	                                 add                  ax,Ballsize/2
	                                 mov                  Ball_Center,ax
	                                 mov                  ax,Player1_X
	                                 add                  ax,Player1Width/2
	                                 mov                  Player1_Center,ax
	                                 mov                  ax,Ball_Center
	                                 sub                  ax,Player1_Center                                            	;ax = ballcenter - player center
	                                 mov                  bx, CollisionConstant
	                                 cwd
	;idiv        bx
	                                 mov                  BallHorizontalVelocity,ax
	;mov 		bx,Player1VerticalVelocity
	;add         BallVerticalVelocity,bx
	                                 RET
BallPlayer1CollisionCalculations endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

BallPlayer2CollisionCalculations Proc   Near
	;How Ball bounce against player (Vertical)
	                                 mov                  ax,Ball_Y
	                                 add                  ax,Ballsize/2
	                                 mov                  Ball_Center,ax
	                                 mov                  ax,Player2_Y
	                                 add                  ax,Player2Height/2
	                                 mov                  Player2_Center,ax
	                                 mov                  ax,Ball_Center
	                                 sub                  ax,Player2_Center                                            	;ax = ballcenter - player center
	                                 mov                  bx, CollisionConstant
	                                 cwd
	;idiv        bx
	                                 mov                  BallVerticalVelocity,ax
	                                 mov                  bx,Player2VerticalVelocity
	                                 add                  BallVerticalVelocity,bx

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
	                                 mov                  ax,Ball_X
	                                 add                  ax,Ballsize/2
	                                 mov                  Ball_Center,ax
	                                 mov                  ax,Player2_X
	                                 add                  ax,Player2Width/2
	                                 mov                  Player2_Center,ax
	                                 mov                  ax,Ball_Center
	                                 sub                  ax,Player2_Center                                            	;ax = ballcenter - player center
	                                 mov                  bx, CollisionConstant
	                                 cwd
	;idiv        bx
	                                 mov                  BallHorizontalVelocity,ax
	;mov 		bx,Player2VerticalVelocity
	;add         BallVerticalVelocity,bx
	                                 RET
BallPlayer2CollisionCalculations endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

CheckBallPlayer1Collision Proc Near
	;ball is to the left of player right bound
	                                 mov                  bx, Player1_X
	                                 add                  bx, Player1Width
	                                 cmp                  bx, Ball_X
	                                 JLE                  NoCollision1

	;ball is to the right of player left side
	                                 mov                  bx, Ballsize
	                                 add                  bx, Ball_X
	                                 cmp                  bx, Player1_X
	                                 JLE                  NoCollision1

	;ball is beneath player upper side
	                                 mov                  bx, Player1_Y
	                                 add                  bx, Player1Height
	                                 cmp                  bx, Ball_Y
	                                 JLE                  NoCollision1

	;ball is above player lower side
	                                 mov                  bx, Ball_Y
	                                 add                  bx, Ballsize
	                                 cmp                  bx, Player1_Y
	                                 JLE                  NoCollision1

	;TRUE
	                                 mov                  AX, 1

	NoCollision1:                    
	                                 RET
CheckBallPlayer1Collision endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

CheckBallPlayer2Collision Proc Near
	;ball is to the left of player right bound
	                                 mov                  bx, Player2_X
	                                 add                  bx, Player2Width
	                                 cmp                  bx, Ball_X
	                                 JLE                  NoCollision2

	;ball is to the right of player left side
	                                 mov                  bx, Ballsize
	                                 add                  bx, Ball_X
	                                 cmp                  bx, Player2_X
	                                 JLE                  NoCollision2

	;ball is beneath player upper side
	                                 mov                  bx, Player2_Y
	                                 add                  bx, Player2Height
	                                 cmp                  bx, Ball_Y
	                                 JLE                  NoCollision2

	;ball is above player lower side
	                                 mov                  bx, Ball_Y
	                                 add                  bx, Ballsize
	                                 cmp                  bx, Player2_Y
	                                 JLE                  NoCollision2

	;TRUE
	                                 mov                  AX, 1

	NoCollision2:                    
	                                 RET
CheckBallPlayer2Collision endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________


incrementscore proc NEAR
	                                 mov                  dx,Ball_X
	                                 mov                  ax,WindowsWidth/2
	                                 cmp                  dx,ax
	                                 jL                   inc_user_2
	                                 inc                  score_1
	                                 convert_num_to_ascii score_1,score_ascii_1
	                                 mov                  Last_Winner,1

	                                 cmp                  score_1, MAX_Score
	                                 jnz                  return_inc
	                                 mov                  Exit,1
	                                 jmp                  return_inc
	inc_user_2:                      
	                                 inc                  score_2
	                                 mov                  Last_Winner,2
	                                 convert_num_to_ascii score_2,score_ascii_2
	                                 cmp                  score_2, MAX_Score
	                                 jnz                  return_inc
	                                 mov                  Exit,1

	return_inc:                      
	                                 mov                  PointFinished,1                                              	;To reset screen
	                                 ret
incrementscore endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

DrawScores PROC Near
	                                 print_mesg           0,1,1,username1+2
	                                 print_mesg           username1+1,1,1,DrawScores_msg
	                                 print_mesg           0,0,0,score_ascii_1


	                                 print_mesg           20,1,1,username2+2
	                                 mov                  al,20
	                                 add                  al,username2+1
	                                 print_mesg           al,1,1,DrawScores_msg
	                                 print_mesg           0,0,0,score_ascii_2
	                                 RET
DrawScores EndP

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

Draw Proc  Near
	                                 pop                  IP_Pointer_Temp                                              	;store ip pointer for return
	;   pop       HorizontalOffset                                           	;popping data from stack
	;   pop       VerticalOffset
	;   pop       AreaWidth
	;   pop       AreaHeight
	;   pop       bx                                                         	;Carry Img data pointer

	;setting interrupt configurations
	                                 MOV                  CX, 0                                                        	;AreaWidth ;0
	                                 MOV                  DX, 0                                                        	; AreaHeight ;0
	                                 add                  cx,HorizontalOffset
	                                 add                  dx,VerticalOffset
	                                 mov                  di,bx
	                                 jmp                  StartDrawing

	Drawit:                          
	                                 MOV                  AH,0Ch                                                       	;draw pixel
	                                 mov                  al, [DI]                                                     	;color of current pixel
	                                 cmp                  al,0                                                         	;if pixel is empty
	                                 jz                   StartDrawing                                                 	;skip
	                                 MOV                  BH,00h                                                       	;set page number
	                                 INT                  10h
	;call dddd
	StartDrawing:                    
	                                 inc                  DI                                                           	;move to next pixel
	                                 INC                  Cx                                                           	;dec
	                                 mov                  bx,HorizontalOffset
	                                 add                  bx,AreaWidth
	                                 cmp                  cx,bx                                                        	;VerticalOffset ;+areawidth
	                                 JNZ                  Drawit
	                                 mov                  Cx, HorizontalOffset                                         	;AreaWidth	;0
	                                 INC                  DX                                                           	;dec
	                                 mov                  bx,VerticalOffset
	                                 add                  bx,AreaHeight
	                                 cmp                  dx,bx                                                        	;HorizontalOffset	;+areaheight
	                                 JZ                   ENDDrawing
	                                 Jmp                  Drawit

	ENDDrawing:                      
	                                 push                 IP_Pointer_Temp
	                                 RET
draw endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

dddd proc
	                                 push                 ax
	                                 push                 bx
	                                 push                 cx
	                                 push                 dx
	                                 delay                0,1
	                                 pop                  dx
	                                 pop                  cx
	                                 pop                  bx
	                                 pop                  ax
	                                 RET
dddd endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________


final_screen proc NEAR
	; clear
	                                 mov                  ax,3
	                                 int                  10h
	                                 MOV                  AH, 06h                                                      	; Scroll up function
	                                 XOR                  AL, AL                                                       	; Clear entire screen
	                                 mov                  CX,  0                                                       	; Upper left corner CH=row, CL=column
	                                 MOV                  DX, 184FH                                                    	; lower right corner DH=row, DL=column
	                                 MOV                  BH, 07fh
	                                 INT                  10H
                                     
	                                 print_mesg           0,10,1,username1+2
	                                 print_mesg           username1+1,10,1,final_msg_1
	                                 print_mesg           0,0,0,score_ascii_1


	                                 print_mesg           0,11,1,username2+2
	                                 print_mesg           username2+1,11,1,final_msg_1
	                                 print_mesg           0,0,0,score_ascii_2

	;PRINT THE STATUS BAR
	                                 print_mesg           0,22,1,dashedline
	                                 print_mesg           0,23,1,final_msg_4
	                                 print_mesg           0,24,1,final_msg_5

	                                 mov                  al, score_1
	                                 mov                  ah, score_2

	                                 cmp                  al,ah
	                                 jnz                  not_tie
	                                 print_mesg           30,17,1,final_msg_3
	                                 jmp                  return
	not_tie:                         
	                                 cmp                  al,ah
	                                 jbe                  player_2_wins
	                                 print_mesg           30,17,1,username1+2
	                                 mov                  al,username1+1
	                                 add                  al,30
	                                 print_mesg           al,17,1,final_msg_2
	                                 jmp                  return
	player_2_wins:                   
	                                 print_mesg           30,17,1,username2+2
	                                 mov                  al,username2+1
	                                 add                  al,30
	                                 print_mesg           al,17,1,final_msg_2
	return:                          
	                                 mov                  ax,0
	                                 int                  16h

	                                 cmp                  ah,1
	                                 jne                  second_check_finalscreen
	                                 mov                  play_again,ah
	                                 jmp                  return_from_finalscreen

	second_check_finalscreen:        
	                                 cmp                  ah,60
	                                 jne                  return
	                                 mov                  play_again,ah

	return_from_finalscreen:         
	                                 ret
final_screen endp

	;__________________________________________________________________
	;______________________________PROC BREAK__________________________
	;__________________________________________________________________

Clear Proc  Near
	                                 Assume               ds:BackgroundData
	;   pop       HorizontalOffset
	;   pop       VerticalOffset
	;   pop       AreaWidth
	;   pop       AreaHeight
	;Assume ds:BackgroundData
	;setting interrupt configurations
	                                 MOV                  CX, 0                                                        	;AreaWidth ;0
	                                 MOV                  DX, 0                                                        	;AreaHeight ;0
	                                 add                  cx,ClearHorizontalOffset
	                                 add                  dx,ClearVerticalOffset
	                                 mov                  di,bx
	                                 jmp                  StartClearing

	Clearit:                         

	                                 push                 dx                                                           	;store dx, to be returned later
	                                 mov                  ax,dx
	                                 mov                  bx,320
	                                 mul                  bx                                                           	;ax = dx*320
	                                 add                  ax,cx
	                                 mov                  si,ax                                                        	;si here point to the same pixel that should be removed but in background data
	                                 pop                  dx                                                           	;return dx(row number)

	                                 MOV                  AH,0Ch                                                       	;draw pixel mode
	                                 mov                  al,BackGroundImg[SI]                                         	;color of current background pixel
	;mov                  al,0
	;mov       al,BGC                                                     	;draw pixel with background color
	                                 MOV                  BH,00h                                                       	;page number
	                                 INT                  10h
	StartClearing:                   
	                                 inc                  DI                                                           	;move to next pixel
	                                 INC                  Cx                                                           	;dec
	                                 mov                  bx,ClearHorizontalOffset
	                                 add                  bx,ClearAreaWidth
	                                 cmp                  cx,bx                                                        	;VerticalOffset
	                                 JNZ                  Clearit
	                                 mov                  Cx, 0                                                        	;AreaWidth ;0
	                                 add                  cx,ClearHorizontalOffset
	                                 INC                  DX                                                           	;dec
	                                 mov                  bx,ClearVerticalOffset
	                                 add                  bx,ClearAreaHeight
	                                 cmp                  dx,bx                                                        	;HorizontalOffset
	                                 JZ                   EndClearing
	                                 Jmp                  Clearit

	EndClearing:                     
	                                 RET
Clear endp

	


END MAIN