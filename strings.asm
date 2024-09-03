;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; strings for C64 - display string constants in BASIC program and/or dir listing
;; Copyright (c) 2024 by David R. Van Wagner
;; davevw.com
;; MIT LICENSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MIT License
;;
;; Copyright (c) 2024 David R. Van Wagner
;; davevw.com
;;
;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:
;;
;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

*=$033c
strings:
    lda $2b ; program start (lo)
    sta $fb
    lda $2c ; program start (hi)
    sta $fc
    ldy #$00
    sty $ff ; clear count of lines displayed
program_loop:
    lda ($fb),y ; next line ptr (lo)
    iny
    sta $fd
    lda ($fb),y ; next line ptr (hi)
    sta $fe
    ora $fd
    beq strings_exit
    ldy #$03 ; nearly advance past pointer and line number
line_loop:
    iny
find_string:
    lda ($fb),y ; get token
    beq next_line
    cmp #34 ; quote
    beq found_string
    iny
    bne find_string
found_string:
    lda $c7 ; get reverse
    eor #18 ; toggle
    sta $c7 ; store reverse
    iny
string_loop:
    lda #$01
    sta $d4 ; quote mode on
    sta $d8 ; inserts
    lda ($fb),y ; get token
    bne +
    jsr check_newline
    jmp next_line
+   cmp #34 ; quote
    bne +
    jsr check_newline
    jmp line_loop
+   jsr $ffd2
    lda $d3 ; cursor column
    beq +
    cmp #40 ; cursor column
    bne ++
+   jsr check_pause
++  iny
    bne string_loop
next_line:
    lda $fd
    sta $fb
    lda $fe
    sta $fc
    ldy #$00
    beq program_loop
strings_exit:
    ; fall through check_pause then will exit program

check_pause:
    inc $ff
    lda $ff
    cmp #24 ; lines on screen minus one
    bcc +
    lda #$00
    sta $ff ; reset lines displayed
    tya
    pha
pause_page:
    jsr $ffe4
    beq pause_page
    pla
    tay
+   rts

check_newline:
    nop ; replace with rts to disable feature (revert to compact functionality)
    lda $d3 ; cursor column
    beq +
    cmp #40
    beq +
    lda $c7 ; get reverse
    pha
    lda #$0d
    jsr $ffd2
    pla
    sta $c7 ; restore reverse
    jsr check_pause
+   rts
