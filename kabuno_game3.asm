.text

#           ----------------------
#          |   PIXELS 4x4         |
#          |   RESOLUÇÃO 512x512  |
#          |   STATIC DATA        |
#           ----------------------

 #      ------- HEX CORES: --------
#       $20 armazena as cores:  
#       0x80e5ff #azul (ceu/agua)
#       0x009933 #verde
#       0x009939 : linha delimitadora das bombas
     #      Cores do ladrão:
#       0xcc6600 #gorro1/pontuaçao
#       0x994d00 #gorro2(sombra)
#       0xffaa80 #pele1(sombra)
#       0xffccb3 #pele2
#       0xf2f2f2 #roupa1 (branco)
#       0xb3b3b3 #roupa2 (sombra) (cinza)
#       0x333333 #roupa3 (preto)
     #      Bacia:
#       0xcc0066 #magenta
     #      Bomba:
#       0xffd11a #faisca/fogo


         
main: 
     addi $10, $0, 65536 #Número de pixels
     addi $11, $0, 0 #Índice for
     #addi $19, $0, 476
     jal fundo 
     jal mov_bomber 
     
   
#-------------------------------
#      * MOVIMENTAÇÃO *       
#-------------------------------     

mov_bomber:    
   ida: 
     jal bacia #Colorir as bacias
     addi $8, $8, 1536
     jal bacia
     addi $8, $8, 1536
     jal bacia
     
     jal bomber 
     #slt $17, $19, $15
     jal apaga_bomber
     addi $16, $15, -4
     jal bomber 
     
     jal apaga_bomb     
     jal bomb
     jal apaga_bomb
     
     #syscall para int aleatorio
     addi $5, $0, 30 #range 
     addi $2, $0, 42   
     syscall
     beq $4, $0, drop_bomb_ida
  conti:  
     jal apaga_bomb 
     jal explo
     #jal apaga_explo 
     beq $15, 476, volta
     addi $15, $15, 4
     #addi $5, $5, 4
     lui $8, 0x1001  

     jal delay
     add $18, $0, $0
     
     add $6, $16, $0 #adiciona a posição do bomber a bomba
     add $14, $0, $0 
     j mov_bomber
     
   drop_bomb_ida:
   
     lui $8, 0x1001
     addi $14, $14, 512
     add $8, $8, $14
     lw $13, 14348($8)
     beq $13, 0x009939, conti       
     jal apaga_bomb
     addi $6, $6, 512
     jal bomb
     jal delay_bomb
     add $21, $0, $0
     j drop_bomb_ida
     #addi $6, $5, -4
     #jal bomb
     
   volta:
      lui $8, 0x1001
      jal bacia #Colorir as bacias
      addi $8, $8, 1536
      jal bacia
      addi $8, $8, 1536
      jal bacia
      
      jal bomber 
      jal apaga_bomber
      addi $16, $15, 4
      jal bomber
      
      jal apaga_bomb
      #addi $6, $6, 512
      jal bomb
      jal apaga_bomb    
      
      #syscall para int aleatorio
      addi $5, $0, 30 #range 
      addi $2, $0, 42   
      syscall
      beq $4, $0, drop_bomb_volta  
      #addi $6, $5, 4
      #jal bomb
contv:
      jal apaga_bomb      
      beq $15, 4, ida
      addi $15, $15, -4   
      #addi $5, $5, -4
      lui $8, 0x1001
      jal delay
      add $18, $0, $0
      add $6, $16, $0
      add $14, $0, $0
      j volta
      
      drop_bomb_volta:
   
      lui $8, 0x1001
      addi $14, $14, 512
      add $8, $8, $14
      lw $13, 14348($8)
      beq $13, 0x009939, contv       
      jal apaga_bomb
      addi $6, $6, 512
      jal bomb
      jal delay_bomb
      add $21, $0, $0
      j drop_bomb_volta
      #jal apaga_bomber

#------------------------------------
#           * CENÁRIO *
#------------------------------------    
delay:
	beq $18, 9000, delay2
	addi $18, $18, 1
	j delay
        delay2:
        jr $31
delay_bomb:
       beq $21, 7000, delay_bomb2
       addi $21, $21, 1
       j delay_bomb
       delay_bomb2:
       jr $31        
                      
                                                    
     
fundo: 
    addi $12, $0, 10752 #Pixels do ceu
    lui $8, 0x1001 #Inicio do array
    addi $20, $0, 0x80e5ff
    
    loop1: #preenche a cor do ceu
    beq $11, $12, def_color_2 #Quando terminar de preencher o ceu, vai para o muro
    sw $20, 0($8)
    addi $11, $11, 4 
    addi $8, $8, 4
    j loop1
    
    def_color_2: #troca a cor do $20
    add $20, $0, $0
    addi $20, $0, 0x009933
    j loop2
    loop2: #preenche a cor do muro
    beq $11, 65024, def_color_f
    sw $20, 0($8)
    addi $11, $11, 4 
    addi $8, $8, 4
    j loop2
    
    def_color_f:
    add $20, $0, $0
    addi $20, $0, 0x009939
    j final_line
    
    final_line:
    beq $11, $10, saif
    sw $20, 0($8)
    addi $11, $11, 4
    addi $8, $8, 4
    j final_line
    saif: jr $31
    
#------------------------------------
#           * INIMIGOS *
#------------------------------------       
bomber:
    lui $8, 0x1001
    add $8, $8, $15
    
    # ---- GORRO ----
    add $20, $0, $0
    addi $20, $0, 0xcc6600
    sw $20, 2060($8)
    sw $20, 2064($8)
    sw $20, 2068($8)
    
    add $20, $0, $0
    addi $20, $0, 0x994d00
    sw $20, 2568($8)
    sw $20, 2572($8)
    sw $20, 2576($8)
    sw $20, 2580($8)
    sw $20, 2584($8)

       #mascara
    add $20, $0, $0
    addi $20, $0, 0x333333
    sw $20, 3076($8)
    sw $20, 3080($8)
    sw $20, 3084($8)
    sw $20, 3088($8)
    sw $20, 3092($8)
    sw $20, 3096($8)
    sw $20, 3100($8)
    sw $20, 3588($8)
    sw $20, 3592($8)    
    sw $20, 3600($8)    
    sw $20, 3608($8)
    sw $20, 3612($8)
    
       #olhos
    add $20, $0, $0
    addi $20, $0, 0xb3b3b3 
    sw $20, 3596($8)
    sw $20, 3604($8)
    
    # ----- PELE ------
    add $20, $0, $0
    addi $20, $0, 0xffccb3
    sw $20, 4104($8)
    sw $20, 4108($8)
    sw $20, 4112($8)
    sw $20, 4116($8)
    sw $20, 4120($8)
    sw $20, 4616($8)
    sw $20, 4620($8)
    sw $20, 4624($8)
    sw $20, 4628($8)
    sw $20, 4632($8)
         #mãos
    sw $20, 10756($8)
    sw $20, 11268($8)
    sw $20, 11272($8)
    
    sw $20, 10780($8)
    sw $20, 11288($8)
    sw $20, 11292($8)
         #sombra
    add $20, $0, $0
    addi $20, $0, 0xffaa80
    sw $20, 5132($8)
    sw $20, 5136($8)
    sw $20, 5140($8)
    
    
    # ---- ROUPA ----
    
    # listras brancas
    add $20, $0, $0
    addi $20, $0, 0xf2f2f2
    sw $20, 6152($8)
    sw $20, 6156($8)
    sw $20, 6160($8)
    sw $20, 6164($8)
    sw $20, 6168($8)
    
    sw $20, 7172($8)
    sw $20, 7176($8)
    sw $20, 7180($8)
    sw $20, 7184($8)
    sw $20, 7188($8)
    sw $20, 7192($8)
    sw $20, 7196($8)
    
    sw $20, 8196($8)
    sw $20, 8204($8)
    sw $20, 8208($8)
    sw $20, 8212($8)
    sw $20, 8220($8)   
        
    sw $20, 9220($8)
    sw $20, 9228($8)
    sw $20, 9232($8)
    sw $20, 9236($8)
    sw $20, 9244($8)
       
    sw $20, 10244($8)
    sw $20, 10252($8)
    sw $20, 10256($8)
    sw $20, 10260($8)
    sw $20, 10268($8)
    
    # sombra 
    add $20, $0, $0
    addi $20, $0, 0xb3b3b3
    sw $20, 8200($8)
    sw $20, 8216($8)
    sw $20, 9224($8)
    sw $20, 9240($8)
    sw $20, 10248($8)
    sw $20, 10264($8)

    # listras pretas 
    add $20, $20, $0
    addi $20, $0, 0x333333
    sw $20, 5644($8)
    sw $20, 5648($8)
    sw $20, 5652($8)
    
    sw $20, 6660($8)
    sw $20, 6664($8)
    sw $20, 6668($8)
    sw $20, 6672($8)
    sw $20, 6676($8)
    sw $20, 6680($8)
    sw $20, 6684($8)
    
    sw $20, 7684($8)
    sw $20, 7688($8)
    sw $20, 7692($8)
    sw $20, 7696($8)
    sw $20, 7700($8)
    sw $20, 7704($8)
    sw $20, 7708($8)
    
    sw $20, 8708($8)
    sw $20, 8712($8)
    sw $20, 8716($8)
    sw $20, 8720($8)
    sw $20, 8724($8)
    sw $20, 8728($8)
    sw $20, 8732($8)
    
    sw $20, 9732($8)
    sw $20, 9736($8)
    sw $20, 9740($8)
    sw $20, 9744($8)
    sw $20, 9748($8)
    sw $20, 9752($8)
    sw $20, 9756($8)
 
   
    
    jr $31
    
apaga_bomber:

    lui $8, 0x1001
    #addi $16, $15, -4
    add $8, $8, $16
    
    # ---- GORRO ----
    add $20, $0, $0
    addi $20, $0, 0x80e5ff
    sw $20, 2060($8)
    sw $20, 2064($8)
    sw $20, 2068($8)
    
    sw $20, 2568($8)
    sw $20, 2572($8)
    sw $20, 2576($8)
    sw $20, 2580($8)
    sw $20, 2584($8)
       #mascara   
    sw $20, 3076($8)
    sw $20, 3080($8)
    sw $20, 3084($8)
    sw $20, 3088($8)
    sw $20, 3092($8)
    sw $20, 3096($8)
    sw $20, 3100($8)
    sw $20, 3588($8)
    sw $20, 3592($8)
    sw $20, 3596($8)
    sw $20, 3600($8)
    sw $20, 3604($8)
    sw $20, 3608($8)
    sw $20, 3612($8)
    
    # ----- PELE ------
    sw $20, 4104($8)
    sw $20, 4108($8)
    sw $20, 4112($8)
    sw $20, 4116($8)
    sw $20, 4120($8)
    sw $20, 4616($8)
    sw $20, 4620($8)
    sw $20, 4624($8)
    sw $20, 4628($8)
    sw $20, 4632($8)
          
    sw $20, 5132($8)
    sw $20, 5136($8)
    sw $20, 5140($8)
    
    # ---- ROUPA ----
    sw $20, 5644($8)
    sw $20, 5648($8)
    sw $20, 5652($8)
    
    sw $20, 6152($8)
    sw $20, 6156($8)
    sw $20, 6160($8)
    sw $20, 6164($8)
    sw $20, 6168($8)
    
    sw $20, 6660($8)
    sw $20, 6664($8)
    sw $20, 6668($8)
    sw $20, 6672($8)
    sw $20, 6676($8)
    sw $20, 6680($8)
    sw $20, 6684($8)
    
    sw $20, 7172($8)
    sw $20, 7176($8)
    sw $20, 7180($8)
    sw $20, 7184($8)
    sw $20, 7188($8)
    sw $20, 7192($8)
    sw $20, 7196($8)
    
    sw $20, 7684($8)
    sw $20, 7688($8)
    sw $20, 7692($8)
    sw $20, 7696($8)
    sw $20, 7700($8)
    sw $20, 7704($8)
    sw $20, 7708($8)
    
    sw $20, 8196($8)
    sw $20, 8200($8)
    sw $20, 8204($8)
    sw $20, 8208($8)
    sw $20, 8212($8)
    sw $20, 8216($8)
    sw $20, 8220($8)
    
    sw $20, 8708($8)
    sw $20, 8712($8)
    sw $20, 8716($8)
    sw $20, 8720($8)
    sw $20, 8724($8)
    sw $20, 8728($8)
    sw $20, 8732($8)
    
    sw $20, 9220($8)
    sw $20, 9224($8)
    sw $20, 9228($8)
    sw $20, 9232($8)
    sw $20, 9236($8)
    sw $20, 9240($8)
    sw $20, 9244($8)
    
    sw $20, 9732($8)
    sw $20, 9736($8)
    sw $20, 9740($8)
    sw $20, 9744($8)
    sw $20, 9748($8)
    sw $20, 9752($8)
    sw $20, 9756($8)
    
    sw $20, 10244($8)
    sw $20, 10248($8)
    sw $20, 10252($8)
    sw $20, 10256($8)
    sw $20, 10260($8)
    sw $20, 10264($8)
    sw $20, 10268($8)
    
    add $20, $0, $0
    addi $20, $0, 0x009933
         #mãos
    sw $20, 10756($8)
    sw $20, 11268($8)
    sw $20, 11272($8)
    
    sw $20, 10780($8)
    sw $20, 11288($8)
    sw $20, 11292($8)
    
    
    
    jr $31
        
    
bomb: 
    lui $8, 0x1001 
    add $8, $8, $6 # $6 posição da bomba
    
    # --- BOMBA ----
    
    add $20, $20, $0
    addi $20, $0, 0xb3b3b3
    sw $20, 11796($8)
    sw $20, 12304($8)
    
    add $20, $20, $0
    addi $20, $0, 0x333333        
    sw $20, 12812($8)
    sw $20, 12816($8)
    sw $20, 12820($8)
    
    sw $20, 13320($8)
    sw $20, 13324($8)
    sw $20, 13328($8)
    sw $20, 13332($8)
    sw $20, 13336($8)
    
    sw $20, 13832($8)
    sw $20, 13836($8)
    sw $20, 13840($8)
    sw $20, 13844($8)
    sw $20, 13848($8)
    
    sw $20, 14348($8)
    sw $20, 14352($8)
    sw $20, 14356($8)
    
    add $20, $20, $0
    addi $20, $0, 0xffd11a
    sw $20, 11800($8)
    
    jr $31
    
apaga_bomb: 
    
    lui $8, 0x1001 
    #addi $6, $5, -4
    add $8, $8, $6
    
    # --- BOMBA ----
    add $20, $0, $0
    addi $20, $0, 0x009933
    sw $20, 11796($8)
    sw $20, 11800($8)
    sw $20, 12304($8)
        
    sw $20, 12812($8)
    sw $20, 12816($8)
    sw $20, 12820($8)
    
    sw $20, 13320($8)
    sw $20, 13324($8)
    sw $20, 13328($8)
    sw $20, 13332($8)
    sw $20, 13336($8)
    
    sw $20, 13832($8)
    sw $20, 13836($8)
    sw $20, 13840($8)
    sw $20, 13844($8)
    sw $20, 13848($8)
    
    sw $20, 14348($8)
    sw $20, 14352($8)
    sw $20, 14356($8)
    
    jr $31
    
explo:
    lui $8, 0x1001
    #add $7, $6, $0
    
    add $20, $0, $0
    addi $20, $0, 0xffd11a
    
    sw $20, 64008($8)
    sw $20, 64524($8)
    
    sw $20, 63508($8)
    sw $20, 64020($8)
    sw $20, 64532($8)
    
    sw $20, 64032($8)
    sw $20, 64540($8)
    
    jr $31
    
apaga_explo:
    lui $8, 0x1001
    
    add $20, $0, $0
    addi $20, $0, 0x009933
    
    sw $20, 64008($8)
    sw $20, 64524($8)
    
    sw $20, 63508($8)
    sw $20, 64020($8)
    sw $20, 64532($8)
    
    sw $20, 64032($8)
    sw $20, 64540($8)
    
    jr $31
    
    
#------------------------------------
#           * USUÁRIO *
#------------------------------------    
    
bacia:
    add $20, $0, $0
    addi $20, $0, 0x80e5ff
    sw $20, 59612($8)
    sw $20, 59616($8)
    sw $20, 59620($8)
    sw $20, 59624($8)
    sw $20, 59628($8)
    sw $20, 59632($8)
    sw $20, 59636($8)
    sw $20, 59640($8)
    sw $20, 59644($8)
    
    add $20, $0, $0
    addi $20, $0, 0xcc0066
    sw $20, 60120($8)
    sw $20, 60124($8)
    sw $20, 60128($8)
    sw $20, 60132($8)
    sw $20, 60136($8)
    sw $20, 60140($8)
    sw $20, 60144($8)
    sw $20, 60148($8)
    sw $20, 60152($8)
    sw $20, 60156($8)
    sw $20, 60160($8)
    
    sw $20, 60636($8)
    sw $20, 60640($8)
    sw $20, 60644($8)
    sw $20, 60648($8)
    sw $20, 60652($8)
    sw $20, 60656($8)
    sw $20, 60660($8)
    sw $20, 60664($8)
    sw $20, 60668($8)
    
    jr $31    
    
#------------------------------------
#           * PONTUAÇÃO *
#------------------------------------   
ponto0:
    lui $8, 0x1001
    
    add $20, $0, $0
    addi $20, $0, 0xcc6600
    sw $20, 232($8)
    sw $20, 236($8)
    sw $20, 240($8)
    
    sw $20, 744($8)
    sw $20, 1256($8)
    sw $20, 1768($8)
    
    sw $20, 1772($8)
    sw $20, 1776($8)
    
    sw $20, 752($8)
    sw $20, 1264($8)
    
    jr $31    
    
    

    
    
    
    
     
    
     
