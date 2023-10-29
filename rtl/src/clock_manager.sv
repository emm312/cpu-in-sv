module SystemClockDomainManager (
    input   ref_clk_50,
    input   user_async_rst, // May need to invert this if the incoming rst line is Active Low, as this works with an Active High reset

    output  sys_clk,
    output  sys_clk_en,
    output  sys_clk_init, // Raised for 1 cycle
    output  sys_sync_rst // Raised for 2 cycles
);

    //? Put your PLL here, connect sys_clk to `outclk0`, connect clk_lock to `locked`
        wire clk_lock;
		  pll pll(
			.c0(sys_clk),
			.locked(clk_lock),
			.inclk0(ref_clk_50)
		);
    //?

    //? Async Reset Detection
        reg  [7:0] ReferenceClockResetVector;
        wire       ClockLockCheck = clk_lock || ReferenceClockResetVector[0];
        wire [7:0] NextReferenceClockResetVector = {ReferenceClockResetVector[6:0], ClockLockCheck};
        wire ReferenceClockResetVectorTrigger = clk_lock;
        always_ff @(posedge sys_clk or posedge user_async_rst) begin
            if (user_async_rst) begin
                ReferenceClockResetVector <= 0;
            end
            else if (ReferenceClockResetVectorTrigger) begin
                ReferenceClockResetVector <= NextReferenceClockResetVector;
            end
        end
    //?

    //? Output Assignments
        reg  [2:0] StatusVector;
        wire       clk_en_Check = ReferenceClockResetVector[4];
        wire       clk_init_Check = ~ReferenceClockResetVector[7] && ReferenceClockResetVector[6];
        wire       sync_rst_Check = ~ReferenceClockResetVector[2] && ReferenceClockResetVector[0];
        wire [2:0] NextStatusVector = {clk_en_Check, clk_init_Check, sync_rst_Check};
        wire       StatusVectorTrigger = clk_lock;
        always_ff @(posedge sys_clk or posedge user_async_rst) begin
            if (user_async_rst) begin
                StatusVector <= 0;
            end
            else if (StatusVectorTrigger) begin
                StatusVector <= NextStatusVector;
            end
        end
        assign sys_clk_en = StatusVector[2];
        assign sys_clk_init = StatusVector[1];
        assign sys_sync_rst = StatusVector[0];
    //? 

endmodule : SystemClockDomainManager
