

data segment                ; Define Ports of 8255
    
   PORTA EQU 00H
   PORTB EQU 02H
   PORTC EQU 04H
   PCW   EQU 06H
    
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
 
    mov ax, data            ; Move data to ax
    mov ds, ax              ; fill ds with ax
    mov es, ax              ; fill es with ax
    MOV DX,PCW              ; enter PWC to DX   
   
    MOV AL,10000010B        ; Control Word~Mode 1 PORTA as output, PORTB input
    OUT DX,AL               ; give this mode to IC I/O  
    
   Main:
    MOV CX,00FFH            ; fill in the value of CX with 00ffH
    MOV AL,0FEH             ; value = 1111 1110, set column 0 low
    MOV DX,PORTA            ; mov PORTA to DX
    OUT DX,AL               ;Give this value to PORTA
     
    COLUMN0: 
	 ;Check ROW0
     IN AL,PORTB            ; Get PORTB value  
    
     CMP AL,0FEH            ; If PORTB =1111 1110 - button 1 Keypad is pressed?
     JNE ROW1               ; If not, go to ROW1
     MOV AL,006H;           ; If so, give PORC 006H or 7-Segment value to PORTC
     OUT PORTC,AL;          ; Turning on number 1
     JMP GO                 ; continue loop
     
     ROW1: CMP AL,0FDH     ; Is PORTB == 1111 1101  or (4)Keypad button pressed?
     JNE ROW2              ; If not, go to ROW2 of column 1
     MOV AL,066H;           ; If so, give PORC 066H or 7-Segment to PORTC
     OUT PORTC,AL;          ; Turn on the number 4
     JMP GO                 ; Continue looop
     
     ROW2: 
     CMP AL,0FBH            ; Is PORTB worth 0FBH or 7 Keypad button pressed?
     JNE ROW3              ; If not, go to ROW3
     MOV AL,007H;           ; If so, give PORC 007H or 7-Segment value to PORTC
     OUT PORTC,AL;          ; Turning on the number 7
     JMP GO                 ; Go to GO
     
      ROW3: 
      CMP AL,0F7H           ; Is PORTB == 0F7H or keypad star button pressed?
     JNE GO                 ; continue loop
     MOV AL,07CH;           ; If so, give PORC value 07CH or 7-Segment to PORTC
     OUT PORTC,AL;          ; Turn on the letters b
     
     GO:
    LOOP COLUMN0             ; Looping to COLUMN1 is CX
    
    MOV CX,00FFH            ; Initialize counter
    MOV AL,0FDH             ; value = 1111 1101, set column 1 low
    MOV DX,PORTA            ; enter PORTA to DX
    OUT DX,AL               ; Give this value to PORTA
     
    COLUMN1: 
                            
     IN AL,PORTB            ; Get PORTB value
     CMP AL,0FEH            ; Is PORTB == 0FEH or 2 Keypad button pressed?
     JNE ROW11             ; If not, go to ROW12
     MOV AL,05BH;           ; If so, give PORC 05BH or 7-Segment to PORTC
     OUT PORTC,AL;          ; Turn on the number 2
     JMP GO2                ; Go to GO2
     
     ROW11: CMP AL,0FDH    ; Is PORTB == 0FDH or 5 Keypad button pressed?
     JNE ROW21             ; If not, go to ROW22
     MOV AL,06DH;           ; If so, give PORC 06DH or 7-Segment to PORTC
     OUT PORTC,AL;          ;Turn 5 on
      JMP GO2       
      
     ROW21: 
     CMP AL,0FBH            ; Is PORTB == 0FBH or keypad 8 keypad being pressed?
     JNE ROW31             ;If not, go to ROW32
     MOV AL,07FH;           ; If so, give PORC 07FH or 7-Segment to PORTC
     OUT PORTC,AL;          ;Turn on the number 8
     JMP GO2                ; continue loop
     
      ROW31:               
      CMP AL,0F7H           ; Is PORTB == 0F7H or keypad 0 keypad being pressed?
     JNE GO2                ; If not, go to GO2
     MOV AL,03FH;           ; If so, give PORC 03FH or 7-Segment value to PORTC
     OUT PORTC,AL;          ; Turns 0 on
    
     GO2:                   
    LOOP COLUMN1            ; Looping to COLUMN2 is CX
     
    MOV CX,00FFH            ; fill in the value of CX with 00ffH 
    MOV AL,0FBH             ; value = 1111 1011, set column 2 low
    MOV DX,PORTA            ; enter PORTA to DX
    OUT DX,AL               ; Give this value to PORTA
    
     COLUMN2: 
    
     IN AL,PORTB            ; Get PORTB value
     CMP AL,0FEH            ; Is PORTB == 0FEH or button 3 Keypad is pressed?
     JNE ROW12             ; If not, go to ROW13
     MOV AL,04FH;           ; If so, give PORC 04FH or 7-Segment value to PORTC
     OUT PORTC,AL           ; Turn on the number 3
     JMP GO3                ; Continue loop
     
     ROW12: CMP AL,0FDH    ; Is PORTB == 0FDH or 6 Keypad button pressed?
     JNE ROW22             ;If not, go to ROW23
     MOV AL,07DH;           ; If so, give PORC 07DH or 7-Segment to PORTCrgi to ROW23
     OUT PORTC,AL;          ;Turn on the number 6
     JMP GO3                ; continue loop
     
     ROW22: 
     CMP AL,0FBH            ; Is PORTB == 0FBH or keypad 9 key pressed?
     JNE ROW32             ; If not, go to ROW33
     MOV AL,06FH;           ; If so, give PORC 06FH or 7-Segment to PORTC
     OUT PORTC,AL;          ; Turning on the number 9
     JMP GO3                ; Continue loop
     
      ROW32:               ; Is PORTB == 0F7H or Keypad Fence button pressed?
      CMP AL,0F7H           ; If not, go to GO3
     JNE GO3                ; If so, give PORC 00CH or 7-Segment value to PORTC
     MOV AL,00CH;           ;Turn on the letter A
     OUT PORTC,AL; 
     
     GO3:
    LOOP COLUMN2            ; Looping to COLUMN2 by CX
    JMP Main               ; Repeat the program again
     
 
end start
