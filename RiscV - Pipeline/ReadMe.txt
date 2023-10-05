05000513    addi x10, x0, 80
00900613    addi x12, x0, 9 // i = 8
00052583    lw x11, 0(x10) // max
00064e63    blt x12, x0, 28
fff60613    addi x12, x12, -1
00450513    addi x10, x10, 4
00052683    lw x13, 0(x10) // x13 = a[i]
feb6c8e3    blt x13, x11, -16 // x13 < x11 do nothing
00068593    addi x11, x13, 0 // x11 = x13
fe9ff06f    jal x0, -24

06400a13    addi x20, x0, 100
00ba2023    sw x11, 0(x20)
