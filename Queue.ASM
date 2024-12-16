DATA SEGMENT
    MSG2  DB 10,13,'Enter num -> $'
    MSG3  DB 10,13,'press e again to enqueue more $'
    MSG4  DB 10,13,'Queue -> $'
    MSG5  DB 10,13,'Dequeue Value is -> $'
    MSG6  DB 10,13,'Queue Is Empty $'
    MSG1  DB 10,13,'Operations'
    MSG7  DB 10,13,'e -> To Enqueue'
    MSG8  DB 10,13,'d -> To Dequeue'
    MSG9  DB 10,13,'p -> To printQueue $'
    MSG10  DB 10,13,'Queue is Full $'
    CHOOSE DB 1 DUP(0)
    FRONT DB 1 DUP(0)
    REAR  DB 1 DUP(0)
    ARRAY DB 10 DUP(0)    ;can be expanded if needed
    MaxArray DB 1 DUP(0)
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE, DS:DATA, ES:DATA

START:
    MOV AX, DATA   
    MOV DS, AX
    
    MOV REAR, 0
    MOV SI, OFFSET ARRAY      ; point to rear

    MOV FRONT, 0
    MOV DI, OFFSET ARRAY      ; point to front
    
    Mov MaxArray,10           ; based on array size
    MOV BX, OFFSET ARRAY      ; (temp) point to front

Menu:
    MOV AH, 09H              
    LEA DX, MSG1     ; will print all operations
    INT 21H                           

    MOV AH, 01H              
    INT 21H
    MOV CHOOSE,AL 
    CMP CHOOSE, 'e'
    JE Enqueue
    CMP CHOOSE, 'd'
    JE Dequeue
    CMP CHOOSE, 'p'
    JE PrintQueue
    JMP Menu

Enqueue:
    
    Mov CH,MaxArray
    Mov CL,REAR
    CMP CL,CH
    JE QueueFull
    
    MOV AH, 09H
    LEA DX, MSG2
    INT 21H

    MOV AH, 01H              
    INT 21H
    MOV [SI], AL             
    INC SI
    INC REAR

    MOV AH, 09H              
    LEA DX, MSG3  ;will print press e again to enqueue more
    INT 21H

    MOV AH, 01H
    INT 21H
    CMP AL, 'e'
    JE Enqueue
    JMP Menu

Dequeue:
    
    MOV CL, FRONT
    MOV CH, REAR
    CMP CL, CH
    JAE Empty

    MOV AH, 09H
    LEA DX, MSG5
    INT 21H

    MOV DL, [DI]           
    MOV AH, 02H          
    INT 21H

    INC DI
    INC FRONT
    
    MOV BX, DI  
    JMP Menu

PrintQueue:
    MOV CL, FRONT
    MOV CH, REAR
    CMP CL, CH
    JAE Empty   

    MOV AH, 09H       
    LEA DX, MSG4     ; will print Queue
    INT 21H

PrintFullQueue:
    MOV DL, [BX]            
    MOV AH, 02H
    INT 21H
    
    INC CL    ; store front
    INC BX
    CMP CH, CL   ; CH store rear   
    JNE PrintFullQueue
    
    MOV BX, DI
    JMP Menu

Empty:
    MOV AH, 09H      
    LEA DX, MSG6     ;will print Queue Is Empty 
    INT 21H
    JMP Menu
    
QueueFull:
    MOV AH, 09H
    LEA DX, MSG10      ;will print Queue Is Full
    INT 21H
    JMP Menu

CODE ENDS
END START
