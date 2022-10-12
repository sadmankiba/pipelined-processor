module pg(p, g, a, b);
    input a, b;
    output p, g;

    and2(g, a, b);
    xor2(p, a, b);
endmodule