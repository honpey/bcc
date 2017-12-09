local ffi = require("ffi")
local bpf = require("bpf")
local S = require("syscall")

-- Shared part of the program
local map = bpf.map('hash', 256)
map[1], map[6], map[17] = 0, 0, 0
local map2 = bpf.map('array', 2)
-- Kernel-space part1 of the program
-- translate lua code to BPF! code 
-- how to tran 
-- how to get parameters in
--[[
bpf.socket('lo', function(skb)
   local proto = pkt.ip.proto -- Get byte (ip.proto) from frame at [23]
   xadd(map[proto], 1)        -- Atomic `map[proto] += 1`
end)
--]]

print("Before bpf.kprobe")
-- Kernel-space part2 of the program
-- call function
-- how to transla
--[[
bpf.kprobe('myprobe2:blk_start_request', function(req)
--	map2[0] = 12345678
--	map2[1] = req.cpu
	print("HFuxi:hello world--->ca \n")
end, false, -1, 0)
print("After bpf.kprobe")
--]]

--函数的参数
bpf.tracepoint('sched/sched_switch', function()
	map2[0] = 123456
--	map2[1] = req.cpu
end, 0, -1)

-- User-space part of the program
for _ = 1, 20000 do
   local icmp, udp, tcp = map[1], map[17], map[6]
   local iMap1, iMap2 = map2[0], map2[1]
--   print(string.format('TCP %d UDP %d ICMP %d packets',
--  	     tonumber(tcp or 0), tonumber(udp or 0), tonumber(icmp or 0)))
	print(string.format('%d %d', tonumber(iMap1), tonumber(iMap2)))
	S.sleep(3)
end

return function()
	print("hello world")
end
