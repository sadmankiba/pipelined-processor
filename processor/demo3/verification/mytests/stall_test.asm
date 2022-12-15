j .RealStart

halt
halt
halt
halt
halt
.Data1:
halt
halt

.RealStart:
lbi r2, L.Data1

.GoHere:
ld r3, r2, 0       
bnez r3, .GoThere
halt
halt
halt
halt

.GoThere:
lbi r0, U.GoGoGo
slbi r0, L.GoGoGo
jalr r0, 0
.RetAddr:
halt
halt
halt
halt

.GoGoGo:
st r7, r2, -2      // .Data1-2 = .RetAddr (0x00a4)
halt
halt
halt