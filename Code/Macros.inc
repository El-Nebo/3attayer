DrawImg Macro _ImgData,_ImgHeight,_ImgWidth,_ImgVerticalOffset,_ImgHOrizontalOffset
	        mov  bx,_ImgHOrizontalOffset
	        mov  HorizontalOffset,bx
	        mov  bx,_ImgVerticalOffset
	        mov  VerticalOffset,bx
	        mov  AreaWidth,_ImgWidth
	        mov  AreaHeight,_ImgHeight
	        mov  bx,offset _ImgData
	        Call draw
endm

ClearArea Macro _ClearAreaHeight,_ClearAreaWidth,__ClerAreaVerticalOffset,__ClearAreaHorizontalOffset



	          mov    bx,__ClearAreaHorizontalOffset
	          mov    cx,__ClerAreaVerticalOffset

	          mov    ax,BackgroundData
	          mov    ds,ax
	          Assume ds:BackgroundData

	          mov    ClearHorizontalOffset,bx
	          mov    ClearVerticalOffset,cx
	          mov    ClearAreaWidth,_ClearAreaWidth
	          mov    ClearAreaHeight,_ClearAreaHeight
	          Call   Clear

	          mov    ax,@data
	          mov    ds,ax
	          assume ds: @data
endm 

Delay Macro A,B
	      MOV CX, A
	      MOV DX, B
	      MOV AH, 86H
	      INT 15H
ENDM 

ClearBuffer Macro
	            mov ah,0ch
	            mov al,0
	            int 21h
ENDM

move_cursor MACRO x_axis,y_axis
	; place cursor on row=11 col=25
	            mov ah,2
	            mov bh,0
	            mov dl,x_axis	;x-axis
	            mov dh,y_axis	;y-axis
	            int 10h
ENDM
print_mesg MACRO x_axis,y_axis,defining_byte,localmsg  		;defining_byte=1 to reallocating the cursor and 0 to let it in its place
	                      LOCAL       dont_change_thecursor
	                      mov         ah,defining_byte
	                      cmp         ah,0
	                      jz          dont_change_thecursor
	                      move_cursor x_axis,y_axis
	dont_change_thecursor:
	                      mov         ah,9
	                      lea         dx,localmsg
	                      int         21h
ENDM
print_status_mesg MACRO localmsg
	                  print_mesg 0,24,1,cleanmsg
	                  print_mesg 0,24,1,localmsg
ENDM
print_status_2_mesg MACRO localmsg1,localmsg2
	                    Clear_status_bar
	                    print_mesg       0,24,1,localmsg1
	                    mov              ah,2
	                    mov              dl,' '
	                    int              21h
	                    print_mesg       0,24,0,localmsg2
ENDM
print_status_3_mesg MACRO localmsg1,localmsg2,localmsg3
	                    Clear_status_bar
	                    print_mesg       0,24,1,localmsg1
	                    mov              ah,2
	                    mov              dl,' '
	                    int              21h
	                    print_mesg       0,24,0,localmsg2
	                    mov              ah,2
	                    mov              dl,' '
	                    int              21h
	                    print_mesg       0,24,0,localmsg3
ENDM
Clear_status_bar MACRO
	                 print_status_mesg cleanmsg
ENDM
read_string MACRO x_axis,y_axis,defining_byte,wanted_string		;defining_byte=1 to reallocating the cursor and 0 to let it in its place
	                      LOCAL       dont_change_thecursor
	                      mov         ah,defining_byte
	                      cmp         ah,0
	                      jz          dont_change_thecursor
	                      move_cursor x_axis,y_axis
	dont_change_thecursor:
	                      mov         ah,0ah
	                      lea         dx,wanted_string
	                      int         21h
ENDM
convert_num_to_ascii MACRO num,ascii_num
	                     LOCAL no_tens,gobCK
	                     mov   al,num
	                     mov   dl,10
	                     div   dl           	;al=tens   ah=ones
	                     cmp   al,0
	                     je    no_tens
	                     add   al,30h
	                     add   ah,30h
	                     lea   si,ascii_num
	                     mov   [si],ax
	                     jmp   gobCK
	no_tens:             
	                     add   ah,30h
	                     xchg  al,ah
	                     mov   ah,'$'
	                     lea   si,ascii_num
	                     mov   [si],ax
	gobCK:               
ENDM
validate Macro charachter
	         LOCAL okok,notgood,goodone
	         mov   al,41h
	         mov   ah,5bh

	         mov   bl,61h
	         mov   bh,7ah

	         cmp   charachter,al
	         jb    notgood
	         cmp   charachter,ah
	         jb    goodone

	         cmp   charachter,bl
	         jb    notgood
	         cmp   charachter,bh
	         ja    notgood
	goodone: 
	         mov   ax,1
	         push  ax
	         jmp   okok
	notgood: 
	         mov   ax,0
	         push  ax
	okok:    
ENDM
Check_For_Key_Pressed MACRO
	                      LOCAL NoKeyPressed,EndMacro
	                      mov   ah,1
	                      int   16h
	                      jz    NoKeyPressed
	;if found letter, eat buffer
	                      mov   ah,0
	                      int   16h
	                      JMP   EndMacro
	NoKeyPressed:         
	                      mov   ah,-1
	                      mov   al,-1
	EndMacro:             
ENDM	
FixUserName MACRO usrnm
	            local fixloop1,compare13,ENDFIXLOOP
	            mov   si, offset usrnm
	            add   si,2
	            mov   al,'$'
	            mov   bl,10
	            mov   bh,13
	            mov   cx,17
	fixloop1:   
	            cmp   [si],bl
	            jne   compare13
	            mov   [si],al
	compare13:  cmp   [si],bh
	            jne   ENDFIXLOOP
	            mov   [si],al
	ENDFIXLOOP: 
	            inc   si
	            dec   cx
	            jnz   fixloop1
ENDM