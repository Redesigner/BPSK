`include "parameters.svh"

module wave_table_sine
    (
        input wire clk,
	    input wire [$clog2(SINE_RESOLUTION):0] phase,
        output reg [DATA_WIDTH-1:0] signal = 0
    );

    always @(posedge clk) begin
        case(phase)
        0 : begin
 signal <=2047;
 end
1 : begin
 signal <=2140;
 end
2 : begin
 signal <=2234;
 end
3 : begin
 signal <=2327;
 end
4 : begin
 signal <=2420;
 end
5 : begin
 signal <=2512;
 end
6 : begin
 signal <=2603;
 end
7 : begin
 signal <=2692;
 end
8 : begin
 signal <=2781;
 end
9 : begin
 signal <=2868;
 end
10 : begin
 signal <=2953;
 end
11 : begin
 signal <=3036;
 end
12 : begin
 signal <=3117;
 end
13 : begin
 signal <=3196;
 end
14 : begin
 signal <=3272;
 end
15 : begin
 signal <=3346;
 end
16 : begin
 signal <=3417;
 end
17 : begin
 signal <=3486;
 end
18 : begin
 signal <=3551;
 end
19 : begin
 signal <=3613;
 end
20 : begin
 signal <=3672;
 end
21 : begin
 signal <=3727;
 end
22 : begin
 signal <=3779;
 end
23 : begin
 signal <=3827;
 end
24 : begin
 signal <=3871;
 end
25 : begin
 signal <=3912;
 end
26 : begin
 signal <=3949;
 end
27 : begin
 signal <=3981;
 end
28 : begin
 signal <=4010;
 end
29 : begin
 signal <=4034;
 end
30 : begin
 signal <=4055;
 end
31 : begin
 signal <=4071;
 end
32 : begin
 signal <=4083;
 end
33 : begin
 signal <=4090;
 end
34 : begin
 signal <=4093;
 end
35 : begin
 signal <=4092;
 end
36 : begin
 signal <=4087;
 end
37 : begin
 signal <=4077;
 end
38 : begin
 signal <=4063;
 end
39 : begin
 signal <=4045;
 end
40 : begin
 signal <=4023;
 end
41 : begin
 signal <=3996;
 end
42 : begin
 signal <=3966;
 end
43 : begin
 signal <=3931;
 end
44 : begin
 signal <=3892;
 end
45 : begin
 signal <=3850;
 end
46 : begin
 signal <=3803;
 end
47 : begin
 signal <=3753;
 end
48 : begin
 signal <=3700;
 end
49 : begin
 signal <=3643;
 end
50 : begin
 signal <=3582;
 end
51 : begin
 signal <=3519;
 end
52 : begin
 signal <=3452;
 end
53 : begin
 signal <=3382;
 end
54 : begin
 signal <=3310;
 end
55 : begin
 signal <=3234;
 end
56 : begin
 signal <=3157;
 end
57 : begin
 signal <=3077;
 end
58 : begin
 signal <=2995;
 end
59 : begin
 signal <=2910;
 end
60 : begin
 signal <=2824;
 end
61 : begin
 signal <=2737;
 end
62 : begin
 signal <=2648;
 end
63 : begin
 signal <=2557;
 end
64 : begin
 signal <=2466;
 end
65 : begin
 signal <=2374;
 end
66 : begin
 signal <=2281;
 end
67 : begin
 signal <=2187;
 end
68 : begin
 signal <=2093;
 end
69 : begin
 signal <=2000;
 end
70 : begin
 signal <=1906;
 end
71 : begin
 signal <=1812;
 end
72 : begin
 signal <=1719;
 end
73 : begin
 signal <=1627;
 end
74 : begin
 signal <=1536;
 end
75 : begin
 signal <=1445;
 end
76 : begin
 signal <=1356;
 end
77 : begin
 signal <=1269;
 end
78 : begin
 signal <=1183;
 end
79 : begin
 signal <=1098;
 end
80 : begin
 signal <=1016;
 end
81 : begin
 signal <=936;
 end
82 : begin
 signal <=859;
 end
83 : begin
 signal <=783;
 end
84 : begin
 signal <=711;
 end
85 : begin
 signal <=641;
 end
86 : begin
 signal <=574;
 end
87 : begin
 signal <=511;
 end
88 : begin
 signal <=450;
 end
89 : begin
 signal <=393;
 end
90 : begin
 signal <=340;
 end
91 : begin
 signal <=290;
 end
92 : begin
 signal <=243;
 end
93 : begin
 signal <=201;
 end
94 : begin
 signal <=162;
 end
95 : begin
 signal <=127;
 end
96 : begin
 signal <=97;
 end
97 : begin
 signal <=70;
 end
98 : begin
 signal <=48;
 end
99 : begin
 signal <=30;
 end
100 : begin
 signal <=16;
 end
101 : begin
 signal <=6;
 end
102 : begin
 signal <=1;
 end
103 : begin
 signal <=0;
 end
104 : begin
 signal <=3;
 end
105 : begin
 signal <=10;
 end
106 : begin
 signal <=22;
 end
107 : begin
 signal <=38;
 end
108 : begin
 signal <=59;
 end
109 : begin
 signal <=83;
 end
110 : begin
 signal <=112;
 end
111 : begin
 signal <=144;
 end
112 : begin
 signal <=181;
 end
113 : begin
 signal <=222;
 end
114 : begin
 signal <=266;
 end
115 : begin
 signal <=314;
 end
116 : begin
 signal <=366;
 end
117 : begin
 signal <=421;
 end
118 : begin
 signal <=480;
 end
119 : begin
 signal <=542;
 end
120 : begin
 signal <=607;
 end
121 : begin
 signal <=676;
 end
122 : begin
 signal <=747;
 end
123 : begin
 signal <=821;
 end
124 : begin
 signal <=897;
 end
125 : begin
 signal <=976;
 end
126 : begin
 signal <=1057;
 end
127 : begin
 signal <=1140;
 end
128 : begin
 signal <=1225;
 end
129 : begin
 signal <=1312;
 end
130 : begin
 signal <=1401;
 end
131 : begin
 signal <=1490;
 end
132 : begin
 signal <=1581;
 end
133 : begin
 signal <=1673;
 end
134 : begin
 signal <=1766;
 end
135 : begin
 signal <=1859;
 end
136 : begin
 signal <=1953;
 end

        endcase
    end
endmodule