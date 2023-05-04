# IITB-RISC 22
## Instruction types

- `R Type`: OPCODE RA RB RC $\bar{C}$ CZ
  - OPCODE **(15-12)** RA **(11-9)** RB **(8-6)** RC **(5-3)** $\bar{C}$ **(2-2)** CZ **(1-0)**
- `I Type`: OPCODE RA RC IMM 6
  - OPCODE **(15-12)** RA **(11-9)** RC **(8-6)** IMM 6 **(5-0)**
- `J Type`: OPCODE RA IMM 9
  - OPCODE **(15-12)** RA **(11-9)** IMM 9 **(8-0)**

> **OPCODE** : 4 bits

> **RX** : 3 bits

> **C** : 1 bits

> **CZ** : 2 bits

> **IMM X** : X bits

## Specifications

- X number no Control Signals

- PR: **Pipeline registers** 
  - 5 no of PR
    - **Instruction Fetch (IF)(16 bits)**
    - **Instruction Decode (ID)(56 bits)**
    - **Register Read (RR)(90 bits)**
    - **Execute (EX)(36 bits)**
    - **Memory Access (MAcc)(20 bits)**
- **16-bit** System All `egisters`, `Accumilator`, and `ALU` are of 16 bits.
## hazard
1. Load Hazard(stop for 1 cycle)
   1. check both sources
      - ADD
      - NAND
      - BEQ
      - BLT
      - BLE
   2. chech only rb
      - JLR
      - LW
      - SW
   3. check on ra
      - JRI
2. x` 

## Pipelining Stages

1. **Instruction Fetch (IF)**
    - Fetch instruction from Instruction Memory and send to next stage  

## Control Signals

- ### Register File Data Write
  - C Flag
  - Z FLag
  - C bit 
  - Z bit
- ### ALU Control
  - OPCODE
  - $\bar{\text{C}}$
  1. MUX inside ALU to determine carry inclusion
     - CZ BIT 
- ### C Flag WR
  - OPCODE
  - **ONLY** `ADD` instructions 
- ### Z Flag WR
  - OPCODE
  - ALL **ADD** instructions, ALL **NAND** instructions, **LW**
- ### MUX
  1. M1
      - OPCODE(ABCD)
     - CZ bits(EF)
     - **ADC ADZ ACC ACZ** 
     - C1 C0
     - 0  X - **RF-WR**
     - 1  0 - **C FLAG**(prev instr)
     - 1  1 - **Z Flag** (prev instr)
     - m1c1=A'B'C'DE'F + A'B'C'DEF' + A'B'CD'E'F + A'B'CD'EF'
     - m1c1=(B') (A') (C + D) (E + F) (E' + F') (C' + D')
     - m1c0=F
     - m1c0=E'
  2. M2
      - OPCODE(ABCD)
      - **ADI**
      - C0=A'B + CD + A'C'D'
      - 0 - **D2**
      - 1 - **SE-OUT**
  3. M3
     - OPCODE
     - **ADI**
  4. M4
     - OPCODE(ABCD)
     - 9th bit of PR2(MSB of IMM-9)(E)
     - `Constants` **0000001000000000 0000000000000000**
     - **LDI**
     - C1 C0
     - 0  0 - Cosnt(00)
     - 0  1 - Cosnt(01)
     - 1  0 - D1
     - C1=D' + A'C' + AB' + BC
     - C0=A'E
  5. M5
     - ALU(C)
     - Memory Data Out
     - **SW**,**LW**
     - OPCODE(ABCD)
     - C1 C0
     - 0  X - **ALU-C**
     - 1  0 - **Memory-Out**
     - 1  1 - **PC+2**
     - C1= B
     - C0= A
  6. M6
     - OPCODE(ABCD)
     - Compliment bit(E)
     - C0
     - 0  - **D2**
     - 1  - **Compliment**
     - C0= AB' + B'C'DE + B'CD'E
  7. Memory Write
     - wr
     - 0- dont write
     - 1- Write
     - wr=A'BD
  8. Carry Write
     - wr
     - 0- dont write
     - 1- Write
     - wr=A'B'C'
  9. Zero Write
     - wr
     - 0- dont write
     - 1- Write
     - wr=A'B'C' + A'B'D' + A'C'D'
  10. RF Write(Original)
      - wr
      - 0- dont write
      - 1- Write
      - wr=A'B' + A'D' + ABC'
  11. SE-Control
      - Control
      - 0 -**SE-6**
      - 1 -**SE-9**
      - C=A'C + AB
  12. ALU
      - Opcode(ABCD)
      - CZ bits(EF)
      - C2-**ADD/Nand**
      - C1-**W/Wo Carry**
      - C0-**For SUbtraction**
      - C2-0(ADD),1(NAND)=A'B'CD'
      - C1-A'B'C'DEF
      - C0-AB'
  13. M7
         - OPCODE(ABCD)
         - CZ FLAG(EF)
         - C0
         - 0  - **+2**
         - 1  - **-6**
         - C0= ABD' + AC'D'F + AB'EF + AB'DE + AB'CF'
  14. M8
        - OPCODE(ABCD)
         - CZ FLAG(EF)
         - C0
         - 0  - **RA**
         - 1  - **PC-6**
         - C0= ABD' + AC'D'F + AB'EF + AB'DE + AB'CF'
  15. M9
         - OPCODE(ABCD)
         - CZ FLAG(EF)
         - C0
         - 1  - **PC+2**
         - 0  - **PC-6+IMM*2(RA+IMM*2)**
         - C0= A' + B'DE' + B'CD + B'C'D'F' + B'CE'F
  16.  M14
       - OPCODE(ABCD)
       - C0
       - 1  - **RB**
       - 0  - **o/w**
       - C0= ABC'D
  17. Source Decoder 1
      - OPCODE(ABCD)
       - C0
       - 0 - RA
       - 1 - RB
       - C0 =A'C' + A'B'
  18. Source Decoder 2
      - OPCODE(ABCD)
       - C0
       - 0 - RB
       - 1 - RC
       - C0 =A'
  
## Decode
  1. **PR2**
     1. 8-0 **Immediate** (from OPCODE)
     2. 11-9 **Destination** Address(from OPCODE)
     3. 14-12 **Source** 1 Address(from OPCODE)
     4. 17-13 **Source** 2 Address(from OPCODE)
     5. 18 **RF Write** 
     6. 19 **MEM. WRite**
     7. 20 **Cary FLag Write**
     8. 21 **Zero FLag Write**
     9. 22 **Compliment bit**
     10. 25-23 **ALU Control** C2-C1-C0
     11. 26 **SE Control** 
     12. 28-27 **M1 Control**
     13. 29 **M2 Control**
     14. 31-30 **M4 Control**
     15. 33-32 **M5 Control**
     16. 34 **M6 Control**
     17. 35 **M14**
     18. 39-36 **OPCODE**
     19. 55-40 **PC Next**
     20. 56 **Imm_reg_en** (for lmsm)
  2. **OPCODE Decoder**
     1. **T1 T0**
     -  0  0 -**R Type**
     -  1  0 -**I Type**
     -  1  1 -**J Type**`
     1. **OPCODE** (ABCD)
        1. T0=$A'C + CD + ABD'$
           >T0=+$A'C + CD + ABD'$
        2. T1=$B + A + C'D' + CD$
           >T1=$B + A + C'D' + CD$
  3. **Decoder 2**
     1. M7
         - OPCODE(ABCD)
         - CZ FLAG(EF)
         - C0
         - 0  - **+2**
         - 1  - **-6**
         - C0= ABD' + AC'D'F + AB'EF + AB'DE + AB'CF'
     2. M8
        - OPCODE(ABCD)
         - CZ FLAG(EF)
         - C0
         - 0  - **RA**
         - 1  - **PC-6**
         - C0= ABD' + AC'D'F + AB'EF + AB'DE + AB'CF'
      3. M9
         - OPCODE(ABCD)
         - CZ FLAG(EF)
         - C0
         - 1  - **PC+2**
         - 0  - **PC-6+IMM*2(RA+IMM*2)**
         - C0= A' + B'DE' + B'CD + B'C'D'F' + B'CE'F


## Execute
  1. **ALU**
     1. $\text{ADD}(A+B)$
     2. $\text{ADD Compliment}(A+\bar{B})$
     3. $\text{NAND}(\bar{A}+\bar{B})$
     4. $\text{SUBB}(A-B)$
  2. **PR3**
     1. 15-0 **Immediate** (from SE-OUT)
     2. 31-16 **Source1 DATA** for ALU1A 
     3. 47-32 **Source2 DATA** for ALU1B
     4. 50-48 **Destination** Address(from Instruction)
     5. 51 **RF Write** 
     6. 52 **MEM. WRite**
     7. 53 **Cary FLag Write**
     8. 54 **Zero FLag Write**    
     9.  57-55 **ALU Control** C2-C1-C0
     10. 59-58 **M1 Control**
     11. 61-60 **M5 Control**
     12. 62 **M6 Control**
     13. 63 **M14**
     14. 67-64 **OPCODE**
     15. 83-68 **PC Next**
     16. 99-84 **D2**(For Mem. Store SW instr.)(has value of **RA**)
  3. **Outpus**
     1. pr4 outputs(54 downto 0)
     2. RegA data (0 downto 15)
     3. REg B data (0 downto 15)
     4. SE_OUT(0 downto 15)
     5. Decoder 2 out (0 downto 2)
     6. M14 control bit 
     7. ALU out (16 bits for data forward)
     8. Destination address from PR3(3 bits for data forwarding)
## Memory Access
1. **PR4**
   1. 15-0 **ALU-C** (from ALU1 output)
   2. 18-16 **Destination** Address(from Instruction)
   3. 19 **RF Write** 
   4. 20 **MEM. WRite**
   5.  22-21 **M5 Control**
   6.  38-23 **PC Next**
   7.  54-39 **D2**(For Mem. Store SW instr.)(has value of **RA**)
  > JLR instruction RB+0 =RB is calculated in ALU and sent through M-14 in this stage so control signal for M14 is no loger needed in PR-4.
## Write Back
1.**PR5**
  1. 15-0 **Write Back Data** (from M5 could be ALU-C or Mem_Data PC_next)
  2. 18-16 **Destination** Address(from Instruction)
  3. 19 **RF Write** 


##  Instructions
- ### Common stage for Instruction fetch
  - $\text{PC}$ $\rightarrow$ $\text{ADDR}_{IM}$
  - $\text{DO}_{IM}$ $\rightarrow$ $\text{PR}_1 (0-15)$
- ### Instruction Decode


  
1. ###  **ADA** 
   - **Register read**
     - $\text{PR}_2 (\text{RA})  \rightarrow \text{A}_1$ 
     - $\text{PR}_2 (\text{RB})  \rightarrow \text{A}_2$ 
     - $\text{D1} \rightarrow \text{PR}_3$
     - $\text{D2} \rightarrow \text{PR}_3$
   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
     - $\text{CZ Update}$
     - $\text{ALU}_1\text{C} \rightarrow \text{PR}_4$
  > ADD Operation is Performed in ALU.
   - **Memory Access**
     - $\text{PR}_4 (\text{ALU}_1 \text{C}) \rightarrow \text{PR}_5$
   - **Write back**
     - $\text{PR}_5 (\text{RC}) \rightarrow \text{A}_3$
     - $\text{PR}_5 (\text{ALU}_1 \text{C}) \rightarrow \text{D}_3$

2. ### **ADC**
  If **Carry Flag** of previous instruction's output is set then `Register File Data Write` is set o/w it is not set. 
  
  The ALU opperation remains same as **ADA**.
  - **Register read**
     - $\text{PR}_2 (\text{RA})  \rightarrow \text{A}_1$ 
     - $\text{PR}_2 (\text{RB})  \rightarrow \text{A}_2$ 
     - $\text{D1} \rightarrow \text{PR}_3$
     - $\text{D2} \rightarrow \text{PR}_3$
   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
     - $\text{CZ Update}$
     - $\text{ALU}_1\text{C} \rightarrow \text{PR}_4$
     > ADD Operation is Performed in ALU.
   - **Memory Access**
     - $\text{PR}_4 (\text{ALU}_1 \text{C}) \rightarrow \text{PR}_5$
   - **Write back**
     - $\text{PR}_5 (\text{RC}) \rightarrow \text{A}_3$
     - $\text{PR}_5 (\text{ALU}_1 \text{C}) \rightarrow \text{D}_3$
     
     >This **WR** Would  be effective only if **Carry Flag** of previous instruction's output is set.
3. ### **ADZ**
  If **Zero Flag** of previous instruction's output is set then `Register File Data Write` is set o/w it is not set. 
  
  The ALU opperation remains same as **ADA**.
  - **Register read**
     - $\text{PR}_2 (\text{RA})  \rightarrow \text{A}_1$ 
     - $\text{PR}_2 (\text{RB})  \rightarrow \text{A}_2$ 
     - $\text{D1} \rightarrow \text{PR}_3$
     - $\text{D2} \rightarrow \text{PR}_3$
   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
     - $\text{CZ Update}$
     - $\text{ALU}_1\text{C} \rightarrow \text{PR}_4$
     > ADD Operation is Performed in ALU.
   - **Memory Access**
     - $\text{PR}_4 (\text{ALU}_1 \text{C}) \rightarrow \text{PR}_5$
   - **Write back**
     - $\text{PR}_5 (\text{RC}) \rightarrow \text{A}_3$
     - $\text{PR}_5 (\text{ALU}_1 \text{C}) \rightarrow \text{D}_3$
     
     >This **WR** Would  be effective only if **Zero Flag** of previous instruction's output is set.

4. ### **AWC**
  - **Register read**
     - $\text{PR}_2 (\text{RA})  \rightarrow \text{A}_1$ 
     - $\text{PR}_2 (\text{RB})  \rightarrow \text{A}_2$ 
     - $\text{D1} \rightarrow \text{PR}_3$
     - $\text{D2} \rightarrow \text{PR}_3$
   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
     - $\text{CZ Update}$
     - $\text{ALU}_1\text{C} \rightarrow \text{PR}_4$
     > Opperation would be ADD but ALU would have a **MUX** which would decide wether to add with carry or not In this case it would be set.
   - **Memory Access**
     - $\text{PR}_4 (\text{ALU}_1 \text{C}) \rightarrow \text{PR}_5$
   - **Write back**
     - $\text{PR}_5 (\text{RC}) \rightarrow \text{A}_3$
     - $\text{PR}_5 (\text{ALU}_1 \text{C}) \rightarrow \text{D}_3$

5. ###  **ACA** 
   - **Register read**
     - $\text{PR}_2 (\text{RA})  \rightarrow \text{A}_1$ 
     - $\text{PR}_2 (\text{RB})  \rightarrow \text{A}_2$ 
     - $\text{D1} \rightarrow \text{PR}_3$
     - $\text{D2} \rightarrow \text{PR}_3$
   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
     - $\text{CZ Update}$
     - $\text{ALU}_1\text{C} \rightarrow \text{PR}_4$
  > ADD Operation is Performed in **ALU Compliment**.
   - **Memory Access**
     - $\text{PR}_4 (\text{ALU}_1 \text{C}) \rightarrow \text{PR}_5$
   - **Write back**
     - $\text{PR}_5 (\text{RC}) \rightarrow \text{A}_3$
     - $\text{PR}_5 (\text{ALU}_1 \text{C}) \rightarrow \text{D}_3$
   - Control Signals
6. ### **ACC**
  If **Carry Flag** of previous instruction's output is set then `Register File Data Write` is set o/w it is not set. 
  
  The ALU opperation remains same as **ADA**.
  - **Register read**
     - $\text{PR}_2 (\text{RA})  \rightarrow \text{A}_1$ 
     - $\text{PR}_2 (\text{RB})  \rightarrow \text{A}_2$ 
     - $\text{D1} \rightarrow \text{PR}_3$
     - $\text{D2} \rightarrow \text{PR}_3$
   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
     - $\text{CZ Update}$
     - $\text{ALU}_1\text{C} \rightarrow \text{PR}_4$
     > **ALU Compliment** Operation is Performed in ALU.
   - **Memory Access**
     - $\text{PR}_4 (\text{ALU}_1 \text{C}) \rightarrow \text{PR}_5$
   - **Write back**
     - $\text{PR}_5 (\text{RC}) \rightarrow \text{A}_3$
     - $\text{PR}_5 (\text{ALU}_1 \text{C}) \rightarrow \text{D}_3$
     
     >This **WR** Would  be effective only if **Carry Flag** of previous instruction's output is set.
7. ### **ACZ**
  If **Zero Flag** of previous instruction's output is set then `Register File Data Write` is set o/w it is not set. 
  
  The ALU opperation remains same as **ADA**.
  - **Register read**
     - $\text{PR}_2 (\text{RA})  \rightarrow \text{A}_1$ 
     - $\text{PR}_2 (\text{RB})  \rightarrow \text{A}_2$ 
     - $\text{D1} \rightarrow \text{PR}_3$
     - $\text{D2} \rightarrow \text{PR}_3$
   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
     - $\text{CZ Update}$
     - $\text{ALU}_1\text{C} \rightarrow \text{PR}_4$
     >**ALU Compliment** opperation is performed
   - **Memory Access**
     - $\text{PR}_4 (\text{ALU}_1 \text{C}) \rightarrow \text{PR}_5$
   - **Write back**
     - $\text{PR}_5 (\text{RC}) \rightarrow \text{A}_3$
     - $\text{PR}_5 (\text{ALU}_1 \text{C}) \rightarrow \text{D}_3$
     
     >This **WR** Would  be effective only if **Zero Flag** of previous instruction's output is set.

8. ### **ACW**
  - **Register read**
     - $\text{PR}_2 (\text{RA})  \rightarrow \text{A}_1$ 
     - $\text{PR}_2 (\text{RB})  \rightarrow \text{A}_2$ 
     - $\text{D1} \rightarrow \text{PR}_3$
     - $\text{D2} \rightarrow \text{PR}_3$
   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
     - $\text{CZ Update}$
     - $\text{ALU}_1\text{C} \rightarrow \text{PR}_4$
     > Opperation would be **ALU Compliment** but ALU would have a **MUX** which would decide wether to add with carry or not In this case it would be set.
   - **Memory Access**
     - $\text{PR}_4 (\text{ALU}_1 \text{C}) \rightarrow \text{PR}_5$
   - **Write back**
     - $\text{PR}_5 (\text{RC}) \rightarrow \text{A}_3$
     - $\text{PR}_5 (\text{ALU}_1 \text{C}) \rightarrow \text{D}_3$

9. ### **ADI**
  - **Register read**
     - $\text{PR}_2 (\text{RA})  \rightarrow \text{A}_1$ 
     
     - $\text{D1} \rightarrow \text{PR}_3$
     - $\text{PR}_2(\text{IMM6}) \rightarrow \text{SE-6}_{\text{IN}}$
     - $\text{SE}_{\text{OUT}} \rightarrow \text{M}_2$ 
   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
     - $\text{CZ Update}$
     - $\text{ALU}_1\text{C} \rightarrow \text{PR}_4$
  > ADD Operation is Performed in ALU.
   - **Memory Access**
     - $\text{PR}_4 (\text{ALU}_1 \text{C}) \rightarrow \text{PR}_5$
   - **Write back**
     - $\text{PR}_5 (\text{RB}) \rightarrow \text{A}_3$
     - $\text{PR}_5 (\text{ALU}_1 \text{C}) \rightarrow \text{D}_3$
   
10.  ###  **NDU** 
   - **Register read**
     - $\text{PR}_2 (\text{RA})  \rightarrow \text{A}_1$ 
     - $\text{PR}_2 (\text{RB})  \rightarrow \text{A}_2$ 
     - $\text{D1} \rightarrow \text{PR}_3$
     - $\text{D2} \rightarrow \text{PR}_3$
   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
     - $\text{Z Update}$
     - $\text{ALU}_1\text{C} \rightarrow \text{PR}_4$
  > NAND Operation is Performed in ALU.
   - **Memory Access**
     - $\text{PR}_4 (\text{ALU}_1 \text{C}) \rightarrow \text{PR}_5$
   - **Write back**
     - $\text{PR}_5 (\text{RC}) \rightarrow \text{A}_3$
     - $\text{PR}_5 (\text{ALU}_1 \text{C}) \rightarrow \text{D}_3$     

11.  ### **NDC**
  If **Carry Flag** of previous instruction's output is set then `Register File Data Write` is set o/w it is not set. 
  
  The ALU opperation remains same as **NDU**.
  - **Register read**
     - $\text{PR}_2 (\text{RA})  \rightarrow \text{A}_1$ 
     - $\text{PR}_2 (\text{RB})  \rightarrow \text{A}_2$ 
     - $\text{D1} \rightarrow \text{PR}_3$
     - $\text{D2} \rightarrow \text{PR}_3$
   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
     - $\text{Z Update}$
     - $\text{ALU}_1\text{C} \rightarrow \text{PR}_4$
     > NAND Operation is Performed in ALU.
   - **Memory Access**
     - $\text{PR}_4 (\text{ALU}_1 \text{C}) \rightarrow \text{PR}_5$
   - **Write back**
     - $\text{PR}_5 (\text{RC}) \rightarrow \text{A}_3$
     - $\text{PR}_5 (\text{ALU}_1 \text{C}) \rightarrow \text{D}_3$
     
     >This **WR** Would  be effective only if **Carry Flag** of previous instruction's output is set.

12. ### **NDZ**
  If **Zero Flag** of previous instruction's output is set then `Register File Data Write` is set o/w it is not set. 
  
  The ALU opperation remains same as **NDU**.
  - **Register read**
     - $\text{PR}_2 (\text{RA})  \rightarrow \text{A}_1$ 
     - $\text{PR}_2 (\text{RB})  \rightarrow \text{A}_2$ 
     - $\text{D1} \rightarrow \text{PR}_3$
     - $\text{D2} \rightarrow \text{PR}_3$
   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
     - $\text{Z Update}$
     - $\text{ALU}_1\text{C} \rightarrow \text{PR}_4$
     > NAND Operation is Performed in ALU.
   - **Memory Access**
     - $\text{PR}_4 (\text{ALU}_1 \text{C}) \rightarrow \text{PR}_5$
   - **Write back**
     - $\text{PR}_5 (\text{RC}) \rightarrow \text{A}_3$
     - $\text{PR}_5 (\text{ALU}_1 \text{C}) \rightarrow \text{D}_3$
     
     >This **WR** Would  be effective only if **Zero Flag** of previous instruction's output is set.

13. ###  **NCU** 
   - **Register read**
     - $\text{PR}_2 (\text{RA})  \rightarrow \text{A}_1$ 
     - $\text{PR}_2 (\text{RB})  \rightarrow \text{A}_2$ 
     - $\text{D1} \rightarrow \text{PR}_3$
     - $\text{D2} \rightarrow \text{PR}_3$
   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
     - $\text{Z Update}$
     - $\text{ALU}_1\text{C} \rightarrow \text{PR}_4$
  > **NAND Compliment** Operation is Performed in ALU.
   - **Memory Access**
     - $\text{PR}_4 (\text{ALU}_1 \text{C}) \rightarrow \text{PR}_5$
   - **Write back**
     - $\text{PR}_5 (\text{RC}) \rightarrow \text{A}_3$
     - $\text{PR}_5 (\text{ALU}_1 \text{C}) \rightarrow \text{D}_3$     

14. ### **NCC**
  If **Carry Flag** of previous instruction's output is set then `Register File Data Write` is set o/w it is not set. 
  
  The ALU opperation remains same as **NDU**.
  - **Register read**
     - $\text{PR}_2 (\text{RA})  \rightarrow \text{A}_1$ 
     - $\text{PR}_2 (\text{RB})  \rightarrow \text{A}_2$ 
     - $\text{D1} \rightarrow \text{PR}_3$
     - $\text{D2} \rightarrow \text{PR}_3$
   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
     - $\text{Z Update}$
     - $\text{ALU}_1\text{C} \rightarrow \text{PR}_4$
     > **NAND Compliment** Operation is Performed in ALU.
   - **Memory Access**
     - $\text{PR}_4 (\text{ALU}_1 \text{C}) \rightarrow \text{PR}_5$
   - **Write back**
     - $\text{PR}_5 (\text{RC}) \rightarrow \text{A}_3$
     - $\text{PR}_5 (\text{ALU}_1 \text{C}) \rightarrow \text{D}_3$
     
     >This **WR** Would  be effective only if **Carry Flag** of previous instruction's output is set.

15. ### **NCZ**
  If **Zero Flag** of previous instruction's output is set then `Register File Data Write` is set o/w it is not set. 
  
  The ALU opperation remains same as **NDU**.
  - **Register read**
     - $\text{PR}_2 (\text{RA})  \rightarrow \text{A}_1$ 
     - $\text{PR}_2 (\text{RB})  \rightarrow \text{A}_2$ 
     - $\text{D1} \rightarrow \text{PR}_3$
     - $\text{D2} \rightarrow \text{PR}_3$
   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
     - $\text{Z Update}$
     - $\text{ALU}_1\text{C} \rightarrow \text{PR}_4$
     > **NAND Compliment** Operation is Performed in ALU.
   - **Memory Access**
     - $\text{PR}_4 (\text{ALU}_1 \text{C}) \rightarrow \text{PR}_5$
   - **Write back**
     - $\text{PR}_5 (\text{RC}) \rightarrow \text{A}_3$
     - $\text{PR}_5 (\text{ALU}_1 \text{C}) \rightarrow \text{D}_3$
     
     >This **WR** Would  be effective only if **Zero Flag** of previous instruction's output is set.

16. ### **LLI** 
  - **Register read** 
     - $\text{PR}_2 (\text{IMM9})  \rightarrow \text{SE-9}_\text{IN}$ 
     - $\text{SE}_\text{OUT} \rightarrow \text{M}_2$
     - $\text{Constant} \rightarrow \text{M}_4$
     > Constants are **0000001000000000** and **000000000000000000**

     > The Constant will be selected based on **MSB** of IMM9.
   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
     - $\text{ALU}_1\text{C} \rightarrow \text{PR}_4$
     > **ADD** Operation is Performed in ALU.
   - **Memory Access**
     - $\text{PR}_4 (\text{ALU}_1 \text{C}) \rightarrow \text{PR}_5$
   - **Write back**
     - $\text{PR}_5 (\text{RA}) \rightarrow \text{A}_3$
     - $\text{PR}_5 (\text{ALU}_1 \text{C}) \rightarrow \text{D}_3$

17. ### **LW** 
  - **Register read** 
     - $\text{PR}_2 (\text{IMM6})  \rightarrow \text{SE-6}_\text{IN}$ 
     - $\text{SE}_\text{OUT} \rightarrow \text{M}_2$
     - $\text{D}_2 \rightarrow \text{M}_4$

   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
     - $\text{ALU}_1\text{C} \rightarrow \text{PR}_4$
     > **ADD** Operation is Performed in ALU.
   - **Memory Access**
     - $\text{PR}_4 (\text{ALU}_1 \text{C}) \rightarrow \text{Memory}_\text{Address}$
     - $\text{Memory}_\text{Data} \rightarrow \text{M}_5$
   - **Write back**
     - $\text{PR}_5 (\text{RA}) \rightarrow \text{A}_3$
     - $\text{PR}_5 (\text{ALU}_1 \text{C}) \rightarrow \text{D}_3$
18. ### **SW** 
  - **Register read** 
     - $\text{PR}_2 (\text{IMM6})  \rightarrow \text{SE-6}_\text{IN}$ 
     - $\text{SE}_\text{OUT} \rightarrow \text{M}_2$
     - $\text{D}_2 \rightarrow \text{M}_4$

   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
     - $\text{ALU}_1\text{C} \rightarrow \text{PR}_4$
     > **ADD** Operation is Performed in ALU.
   - **Memory Access**
     - $\text{PR}_4 (\text{ALU}_1 \text{C}) \rightarrow \text{Memory}_\text{Address}$
     - $\text{PR}_4 (\text{D1}) \rightarrow \text{Memory}_\text{DI}$
   - **Write back**

21. ### **BEQ** 
  **Turn off ALL** Write Signals(RF,Memory,CZ FLAGS).
  - **Register read**
     - $\text{PR}_2 (\text{RA})  \rightarrow \text{A}_1$ 
     - $\text{PR}_2 (\text{RB})  \rightarrow \text{A}_2$ 
     - $\text{D1} \rightarrow \text{PR}_3$
     - $\text{D2} \rightarrow \text{PR}_3$
   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
     
     
  > SUBB Operation is Performed in ALU. If output is zero then it means branch is executed.

  > Chech for Equality and turn on Appropriate MUXes
   - **Memory Access**
    
   - **Write back**
  
 22. ### **BLT** 
  **Turn off ALL** Write Signals(RF,Memory,CZ FLAGS).
  - **Register read**
     - $\text{PR}_2 (\text{RA})  \rightarrow \text{A}_1$ 
     - $\text{PR}_2 (\text{RB})  \rightarrow \text{A}_2$ 
     - $\text{D1} \rightarrow \text{PR}_3$
     - $\text{D2} \rightarrow \text{PR}_3$
   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
  > SUBB Operation is Performed in ALU. If Carry is one then it means branch is executed.
  > Chech for Less than and turn on Appropriate MUXes
   - **Memory Access**
   - **Write back**
23. ### **BLE** 
  **Turn off ALL** Write Signals(RF,Memory,CZ FLAGS).
  - **Register read**
     - $\text{PR}_2 (\text{RA})  \rightarrow \text{A}_1$ 
     - $\text{PR}_2 (\text{RB})  \rightarrow \text{A}_2$ 
     - $\text{D1} \rightarrow \text{PR}_3$
     - $\text{D2} \rightarrow \text{PR}_3$
   - **Execute**
     - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
     - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
  > SUBB Operation is Performed in ALU. If Carry is **one** `or` Z is **Zero** then it means branch is executed.
  > Chech for Less than and turn on Appropriate MUXes
   - **Memory Access**
   - **Write back**
24. ### **JAL** 
  Instruction fetch is **same** as `BEQ` **Unconditionally**

  **Turn off ALL** Write Signals(RF,Memory,CZ FLAGS).
  - **Instruction Decode**
    - $\text{PC}+2 \rightarrow \text{PR}_2(\text{PC})$
  - **Register read**
    - $\text{PR}_2(\text{PC}) \rightarrow \text{PR}_3(\text{PC})$ 
   - **Execute**
     - $\text{PR}_3(\text{PC}) \rightarrow \text{PR}_4(\text{PC})$
   >ALU 1 is of no use  

   - **Memory Access**
      - $\text{PR}_4(\text{PC}) \rightarrow \text{M}_5$
   - **Write back**
     - $\text{PR}_5 (\text{RA}) \rightarrow \text{A}_3$
     - $\text{PR}_5 (\text{PC}) \rightarrow \text{D}_3$ 

25.  ### **JLR**
  **Turn off ALL** Write Signals(RF,Memory,CZ FLAGS).
  Stall the system onece **JRI** is decoded till it reaches **Mem Acc.** 
- **Instruction Decode**
  - $\text{PC}+2 \rightarrow \text{PR}_2(\text{PC})$
- **Register read** 
     - $\text{PR}_2(\text{PC}) \rightarrow \text{PR}_3(\text{PC})$
     - $\text{Constant}(\text{00}) \rightarrow \text{M}_4$
     > Rb is sent through D2 
     - $\text{D}_2 \rightarrow \text{M}_2$

 - **Execute**
   - $\text{PR}_3 (\text{D1})  \rightarrow \text{ALU}_1\text{A}$
   - $\text{PR}_3 (\text{D2})  \rightarrow \text{ALU}_1\text{B}$
   - $\text{ALU}_1\text{C} \rightarrow \text{PR}_4$
   - $\text{PR}_3(\text{PC}) \rightarrow \text{PR}_4(\text{PC})$
   > **ADD** Operation is Performed in ALU.
 - **Memory Access**
   - $\text{PR}_4 (\text{ALU}_1 \text{C}) \rightarrow \text{Memory}_\text{Address}$
   - $\text{Memory}_\text{Data} \rightarrow \text{M}_{12}$
   - $\text{PR}_4(\text{PC}) \rightarrow \text{PR}_5(\text{PC})$
 - **Write back**
    - $\text{PR}_5 (\text{RA}) \rightarrow \text{A}_3$
    - $\text{PR}_5 (\text{PC}) \rightarrow \text{D}_3$ 
    >Via **M5**
    
26.  ### **JRI**
  **Turn off ALL** Write Signals(RF,Memory,CZ FLAGS).
  Stall the system onece **JRI** is decoded till it reaches **Mem Acc.** 
- **Register read** 
     - $\text{PR}_2 (\text{IMM6})  \rightarrow \text{SE-6}_\text{IN}$ 
     - $\text{SE}_\text{OUT} \rightarrow \text{M}_2$
     - $\text{D}_1 \rightarrow \text{M}_4$

 - **Execute**
   - $\text{PR}_3 (\text{D1})  \rightarrow \text{M}_3$
   - $\text{PR}_3 (\text{SE-OUT}) \rightarrow \text{ALU}_3\text{B}$
   
   > **ADD** Operation is Performed in ALU.
 - **Memory Access**
 - **Write back**
