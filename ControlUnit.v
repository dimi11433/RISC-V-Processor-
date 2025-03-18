module controlU(
    input clk,
    input [6:0] opcode,
    input reset,
    output reg PCWriteCond, PCWrite, IorD, PCSource, MemRead, MemWrite, MemtoReg, IRWrite, RegWrite, ALUSrcA,
    output reg [1:0] ALUOp, ALUSrcB 
    
);

    parameter [3:0] IF = 4'b0000;
                    ID = 4'b0001;
                    MA = 4'b0010;
                    MEM_R = 4'b0011;
                    MRCS = 4'b0100;
                    MEM_W = 4'b0101;
                    EX = 4'b0110;
                    RT = 4'b0111;
                    BC = 4'b 1000;
    reg[3:0] curr_state, next_state;

    //State transition Logic 
    always@(posedge clk or posedge reset)begin

        if(reset)begin
            curr_state <= IF;
        end 
        else begin
            curr_state <= next_state;
        end 
    end 

    //next state Logic 

    always@(*)begin
        case(curr_state)
            IF: next_state <= ID;
            ID: begin
                case(opcode)
                    7'b0110011 : next_state <= EX; //R-Type
                    7'b0000011 : next_state <= MA; //Load
                    7'b0100011 : next_state <= MA; //Store
                    7'b1100011 : next_state <= BC; //Branch
                    default: next_state <= IF; //Unkown
                endcase 
            end 
            MA: begin
                case(opcode)
                7'b0000011 : next_state <= MEM_R; //load 
                7'b0100011 : next_state <= MEM_W; //write aka store
                default : next_state <= MA; //unkown opcode
                endcase 
            end 
            MEM_R: next_state <= MRCS;
            MRCS: next_state <= IF;
            MEM_W: next_state <= IF;
            EX: next_state <= RT;
            BC: next_state <= IF;
            default: next_state <= IF;
        endcase 
    end 

    //output logic 
    always@(*)begin 
        //Default values 
        MemRead = 0;
            MemWrite = 0;
            ALUSrcA = 0;
            ALUSrcB = 2'b00;
            ALUOp = 2'b00;
            IRWrite = 0;
            PCWrite = 0;
            PCSource = 0;
            PCWriteCond = 0;
            IorD = 0;
            RegWrite = 0;
            MemtoReg = 0;

            case(curr_state)
                IF: begin
                    MemRead = 1;
                    ALUSrcA = 0;
                    ALUSrcB = 2'b01;
                    ALUOp = 2'b00;
                    IRWrite = 1;
                    PCWrite = 1;
                    PCSource = 0;
                    IorD = 0;
                end 
                ID: begin
                    ALUSrcA = 0;
                    ALUSrcB = 2'b10;
                    ALUOp = 2'b00;
                end 
                MA: begin
                    ALUSrcA = 1;
                    ALUSrcB = 2'b10;
                    ALUOp = 2'b00;
                end 
                MEM_R: begin
                    IorD = 1;
                    MemRead = 1;
                end 
                MRCS: begin
                    RegWrite = 1;
                    MemtoReg = 1;
                end 
                MEM_W: begin
                    MemWrite = 1;
                    IorD = 1;

                end 
                EX: begin 
                    ALUSrcA = 1;
                    ALUSrcB = 2'b00;
                    ALUOp = 2'b10;
                end 
                RT: begin
                    RegWrite = 1;
                    MemtoReg = 0;
                end 
                BC: begin 
                    ALUSrcA = 1;
                    ALUSrcB = 2'b00;
                    ALUOp = 2'b01;
                    PCWriteCond = 1;
                    PCSource = 1;
                end 
            endcase 
    end 


endmodule 
