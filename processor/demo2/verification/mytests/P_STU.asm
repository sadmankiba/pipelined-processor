lbi r0, 128 // icount 0
lbi r1, 128 // icount 2
lbi r3, 128 // icount 6
stu r3, r0, 14 // icount 50
nop 
ld r3, r1, -4 // icount 52
stu r3, r1, 6 // icount 53
halt 