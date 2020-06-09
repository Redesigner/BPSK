`include "parameters.svh"

module phase_table
    (
        input wire clk,
        input wire data,
	    input wire [$clog2(WAVELENGTH):0] index,
        output reg [$clog2(SINE_RESOLUTION):0] phase = 0
    );

    always @(posedge clk) begin
        if(data) begin
            case(index)
                0 : begin
 phase <=0;
 end
1 : begin
 phase <=1;
 end
2 : begin
 phase <=2;
 end
3 : begin
 phase <=3;
 end
4 : begin
 phase <=4;
 end
5 : begin
 phase <=5;
 end
6 : begin
 phase <=6;
 end
7 : begin
 phase <=7;
 end
8 : begin
 phase <=8;
 end
9 : begin
 phase <=9;
 end
10 : begin
 phase <=0;
 end
11 : begin
 phase <=1;
 end
12 : begin
 phase <=2;
 end
13 : begin
 phase <=3;
 end
14 : begin
 phase <=4;
 end
15 : begin
 phase <=5;
 end
16 : begin
 phase <=6;
 end
17 : begin
 phase <=7;
 end
18 : begin
 phase <=8;
 end
19 : begin
 phase <=9;
 end
20 : begin
 phase <=0;
 end
21 : begin
 phase <=1;
 end
22 : begin
 phase <=2;
 end
23 : begin
 phase <=3;
 end
24 : begin
 phase <=4;
 end
25 : begin
 phase <=5;
 end
26 : begin
 phase <=6;
 end
27 : begin
 phase <=7;
 end
28 : begin
 phase <=8;
 end
29 : begin
 phase <=9;
 end
30 : begin
 phase <=0;
 end
31 : begin
 phase <=1;
 end
32 : begin
 phase <=2;
 end
33 : begin
 phase <=3;
 end
34 : begin
 phase <=4;
 end
35 : begin
 phase <=5;
 end
36 : begin
 phase <=6;
 end
37 : begin
 phase <=7;
 end
38 : begin
 phase <=8;
 end
39 : begin
 phase <=9;
 end
40 : begin
 phase <=0;
 end
41 : begin
 phase <=1;
 end
42 : begin
 phase <=2;
 end
43 : begin
 phase <=3;
 end
44 : begin
 phase <=4;
 end
45 : begin
 phase <=5;
 end
46 : begin
 phase <=6;
 end
47 : begin
 phase <=7;
 end
48 : begin
 phase <=8;
 end
49 : begin
 phase <=9;
 end
50 : begin
 phase <=0;
 end
51 : begin
 phase <=1;
 end
52 : begin
 phase <=2;
 end
53 : begin
 phase <=3;
 end
54 : begin
 phase <=4;
 end
55 : begin
 phase <=5;
 end
56 : begin
 phase <=6;
 end
57 : begin
 phase <=7;
 end
58 : begin
 phase <=8;
 end
59 : begin
 phase <=9;
 end
60 : begin
 phase <=0;
 end
61 : begin
 phase <=1;
 end
62 : begin
 phase <=2;
 end
63 : begin
 phase <=3;
 end
64 : begin
 phase <=4;
 end
65 : begin
 phase <=5;
 end
66 : begin
 phase <=6;
 end
67 : begin
 phase <=7;
 end
68 : begin
 phase <=8;
 end
69 : begin
 phase <=9;
 end
70 : begin
 phase <=0;
 end
71 : begin
 phase <=1;
 end
72 : begin
 phase <=2;
 end
73 : begin
 phase <=3;
 end
74 : begin
 phase <=4;
 end
75 : begin
 phase <=5;
 end
76 : begin
 phase <=6;
 end
77 : begin
 phase <=7;
 end
78 : begin
 phase <=8;
 end
79 : begin
 phase <=9;
 end
80 : begin
 phase <=0;
 end
81 : begin
 phase <=1;
 end
82 : begin
 phase <=2;
 end
83 : begin
 phase <=3;
 end
84 : begin
 phase <=4;
 end
85 : begin
 phase <=5;
 end
86 : begin
 phase <=6;
 end
87 : begin
 phase <=7;
 end
88 : begin
 phase <=8;
 end
89 : begin
 phase <=9;
 end
90 : begin
 phase <=0;
 end
91 : begin
 phase <=1;
 end
92 : begin
 phase <=2;
 end
93 : begin
 phase <=3;
 end
94 : begin
 phase <=4;
 end
95 : begin
 phase <=5;
 end
96 : begin
 phase <=6;
 end
97 : begin
 phase <=7;
 end
98 : begin
 phase <=8;
 end
99 : begin
 phase <=9;
 end
100 : begin
 phase <=0;
 end
101 : begin
 phase <=1;
 end
102 : begin
 phase <=2;
 end
103 : begin
 phase <=3;
 end
104 : begin
 phase <=4;
 end
105 : begin
 phase <=5;
 end
106 : begin
 phase <=6;
 end
107 : begin
 phase <=7;
 end
108 : begin
 phase <=8;
 end
109 : begin
 phase <=9;
 end
110 : begin
 phase <=0;
 end
111 : begin
 phase <=1;
 end
112 : begin
 phase <=2;
 end
113 : begin
 phase <=3;
 end
114 : begin
 phase <=4;
 end
115 : begin
 phase <=5;
 end
116 : begin
 phase <=6;
 end
117 : begin
 phase <=7;
 end
118 : begin
 phase <=8;
 end
119 : begin
 phase <=9;
 end
120 : begin
 phase <=0;
 end
121 : begin
 phase <=1;
 end
122 : begin
 phase <=2;
 end
123 : begin
 phase <=3;
 end
124 : begin
 phase <=4;
 end
125 : begin
 phase <=5;
 end
126 : begin
 phase <=6;
 end
127 : begin
 phase <=7;
 end
128 : begin
 phase <=8;
 end
129 : begin
 phase <=9;
 end

            endcase
        end
        else begin
            case(index)
                0 : begin
 phase <=5;
 end
1 : begin
 phase <=6;
 end
2 : begin
 phase <=7;
 end
3 : begin
 phase <=8;
 end
4 : begin
 phase <=9;
 end
5 : begin
 phase <=0;
 end
6 : begin
 phase <=1;
 end
7 : begin
 phase <=2;
 end
8 : begin
 phase <=3;
 end
9 : begin
 phase <=4;
 end
10 : begin
 phase <=5;
 end
11 : begin
 phase <=6;
 end
12 : begin
 phase <=7;
 end
13 : begin
 phase <=8;
 end
14 : begin
 phase <=9;
 end
15 : begin
 phase <=0;
 end
16 : begin
 phase <=1;
 end
17 : begin
 phase <=2;
 end
18 : begin
 phase <=3;
 end
19 : begin
 phase <=4;
 end
20 : begin
 phase <=5;
 end
21 : begin
 phase <=6;
 end
22 : begin
 phase <=7;
 end
23 : begin
 phase <=8;
 end
24 : begin
 phase <=9;
 end
25 : begin
 phase <=0;
 end
26 : begin
 phase <=1;
 end
27 : begin
 phase <=2;
 end
28 : begin
 phase <=3;
 end
29 : begin
 phase <=4;
 end
30 : begin
 phase <=5;
 end
31 : begin
 phase <=6;
 end
32 : begin
 phase <=7;
 end
33 : begin
 phase <=8;
 end
34 : begin
 phase <=9;
 end
35 : begin
 phase <=0;
 end
36 : begin
 phase <=1;
 end
37 : begin
 phase <=2;
 end
38 : begin
 phase <=3;
 end
39 : begin
 phase <=4;
 end
40 : begin
 phase <=5;
 end
41 : begin
 phase <=6;
 end
42 : begin
 phase <=7;
 end
43 : begin
 phase <=8;
 end
44 : begin
 phase <=9;
 end
45 : begin
 phase <=0;
 end
46 : begin
 phase <=1;
 end
47 : begin
 phase <=2;
 end
48 : begin
 phase <=3;
 end
49 : begin
 phase <=4;
 end
50 : begin
 phase <=5;
 end
51 : begin
 phase <=6;
 end
52 : begin
 phase <=7;
 end
53 : begin
 phase <=8;
 end
54 : begin
 phase <=9;
 end
55 : begin
 phase <=0;
 end
56 : begin
 phase <=1;
 end
57 : begin
 phase <=2;
 end
58 : begin
 phase <=3;
 end
59 : begin
 phase <=4;
 end
60 : begin
 phase <=5;
 end
61 : begin
 phase <=6;
 end
62 : begin
 phase <=7;
 end
63 : begin
 phase <=8;
 end
64 : begin
 phase <=9;
 end
65 : begin
 phase <=0;
 end
66 : begin
 phase <=1;
 end
67 : begin
 phase <=2;
 end
68 : begin
 phase <=3;
 end
69 : begin
 phase <=4;
 end
70 : begin
 phase <=5;
 end
71 : begin
 phase <=6;
 end
72 : begin
 phase <=7;
 end
73 : begin
 phase <=8;
 end
74 : begin
 phase <=9;
 end
75 : begin
 phase <=0;
 end
76 : begin
 phase <=1;
 end
77 : begin
 phase <=2;
 end
78 : begin
 phase <=3;
 end
79 : begin
 phase <=4;
 end
80 : begin
 phase <=5;
 end
81 : begin
 phase <=6;
 end
82 : begin
 phase <=7;
 end
83 : begin
 phase <=8;
 end
84 : begin
 phase <=9;
 end
85 : begin
 phase <=0;
 end
86 : begin
 phase <=1;
 end
87 : begin
 phase <=2;
 end
88 : begin
 phase <=3;
 end
89 : begin
 phase <=4;
 end
90 : begin
 phase <=5;
 end
91 : begin
 phase <=6;
 end
92 : begin
 phase <=7;
 end
93 : begin
 phase <=8;
 end
94 : begin
 phase <=9;
 end
95 : begin
 phase <=0;
 end
96 : begin
 phase <=1;
 end
97 : begin
 phase <=2;
 end
98 : begin
 phase <=3;
 end
99 : begin
 phase <=4;
 end
100 : begin
 phase <=5;
 end
101 : begin
 phase <=6;
 end
102 : begin
 phase <=7;
 end
103 : begin
 phase <=8;
 end
104 : begin
 phase <=9;
 end
105 : begin
 phase <=0;
 end
106 : begin
 phase <=1;
 end
107 : begin
 phase <=2;
 end
108 : begin
 phase <=3;
 end
109 : begin
 phase <=4;
 end
110 : begin
 phase <=5;
 end
111 : begin
 phase <=6;
 end
112 : begin
 phase <=7;
 end
113 : begin
 phase <=8;
 end
114 : begin
 phase <=9;
 end
115 : begin
 phase <=0;
 end
116 : begin
 phase <=1;
 end
117 : begin
 phase <=2;
 end
118 : begin
 phase <=3;
 end
119 : begin
 phase <=4;
 end
120 : begin
 phase <=5;
 end
121 : begin
 phase <=6;
 end
122 : begin
 phase <=7;
 end
123 : begin
 phase <=8;
 end
124 : begin
 phase <=9;
 end
125 : begin
 phase <=0;
 end
126 : begin
 phase <=1;
 end
127 : begin
 phase <=2;
 end
128 : begin
 phase <=3;
 end
129 : begin
 phase <=4;
 end

            endcase
        end 
    end
endmodule