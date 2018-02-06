
data segment          ; Initialize the data segment
   
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
;
 
    mov ax, data        ; enter data to AX
    mov ds, ax          ; move ax into cs
    mov es, ax          ; move ax into es  
    
    MOV DX,PCW          ; move PWC to DX
    MOV AL,10000000B    ; Control Word 
    OUT DX,AL           ; give this mode to IC I/O    
    
   Main:
    MOV CX,8            ; loop 3 times
    MOV AL,00000001B    ; Set LED 1 on  
    
   Right:                ; LED Moving to the right                               
    MOV DX,PORTA        ; 
    OUT DX,AL           ; Turn on LED in portA
    SHL AX,1            ; Slide the LED Live bit to the right
    CALL DELAY          ; Delay
    LOOP Right          ; loop three times
    
    MOV CX,8            ; Initialize loop counter to 8 again
    MOV AL,10000000B    ; Bit for LED 8 turns on
                        ; LED Moving to left
   Left:
    MOV DX,PORTA        ; move PORTA to DX
    OUT DX,AL           ; Turn on the LED
    SHR AX,1            ; Slide the LED Live bit to the right
    CALL DELAY          ; Delay
    LOOP Left           ; 
    
    JMP Main           ; Repeat the process from the led to the right
    
    
    delay proc near     ; Procedure delay
		push cx		    ; hold cx
        mov cx,2fffh    ; fill cx with delay value
        loop $          ; looping until cx=0
        pop cx          ; re-release cx
        ret             ; back to the main program
    delay endp          ; end procedure delay

    

end start 
