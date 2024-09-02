*=$033C
STRINGS:
    LDA $2B
    STA $FB
    LDA $2C
    STA $FC
    LDY #$00
    STY $FF
L0348:
    LDA ($FB),Y
    INY
    STA $FD
    LDA ($FB),Y
    STA $FE
    ORA $FD
    BEQ L03A7
    LDY #$03
L0357:
    INY
L0358:    
    LDA ($FB),Y
    BEQ L039B
    CMP #$22
    BEQ L0363
    INY
    BNE L0358
L0363:
    LDA $C7
    EOR #$12
    STA $C7
    INY
L036A:    
    LDA #$01
    STA $D4
    STA $D8
    LDA ($FB),Y
    BEQ L039B
    CMP #$22
    BEQ L0357
    JSR $FFD2
    LDA $D3
    BEQ L0383
    CMP #$28
    BNE L0398
L0383:    
    INC $FF
    LDA $FF
    CMP #$18
    BNE L0398
    LDA #$00
    STA $FF
    TYA
    PHA
L0391:
    JSR $FFE4
    BEQ L0391
    PLA
    TAY
L0398:    
    INY
    BNE L036A
L039B:
    LDA $FD
    STA $FB
    LDA $FE
    STA $FC
    LDY #$00
    BEQ L0348
L03A7:
    LDA #$0D
    JMP $FFD2
