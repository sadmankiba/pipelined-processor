# HW2 Notes

## Carry-Lookahead Adder
Define,<br>
P<sub>i</sub> = A<sub>i</sub> ⊕ B<sub>i</sub><br>
G<sub>i</sub> = A<sub>i</sub> B<sub>i</sub>

Then,<br>
S<sub>i</sub> = P<sub>i</sub> ⊕ C<sub>i</sub><br>
C<sub>i+1</sub> = G<sub>i</sub> + P<sub>i</sub> C<sub>i</sub>

So,<br>
C1 = G0 + P0C0<br>
C2 = G1 + P1C1 = G1 + P1(G0 + P0C0) = G1 + P1G0 + P1P0C0<br>
C3 = G2 + P2C2 = G2 + P2G1 + P2P1G0 + P2P1P0C0<br>
C4 = G3 + P3*G2 + p3*p2*g1 + p3*p2*p1*g0 + p3*p2*p1*p0*c0<br>