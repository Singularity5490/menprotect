--[[
    This script was obfuscated using menprotect v1.0.0 by elerium:tm:
--]]
return(function()
    local vm_strings
    local opcodes
    local ___index
    local ___newindex
    
    local empty_func = function(...)return(...)end
    
    local _tonumber = tonumber
    local _tostring = tostring
    local _setmetatable = setmetatable
    local _true = true
    
    local String = _tostring(_tonumber)
    
    local Select = select
    local Byte = String.byte
    local Char = String.char
    local Sub = String.sub
    local Concat = table.concat
    local Rep = String.rep
    local Env = getfenv()
    local Pcall = pcall
    local Unpack = unpack
    local Gsub = String.gsub
    
    local function push(t, v)
        t[#t + 1] = v
    end
    
    local function fromhex(str)
        return (Gsub(str, Rep(Char(0x2E), 2), function (cc)
            return Char(_tonumber(cc, 0x10))
        end))
    end
    
    local function xor(a, b)
        local p, c = 1, 0
        while a > 0 and b > 0 do
            local ra, rb = a % 2, b % 2
            if ra ~= rb then
                c = c + p
            end
            a, b, p = (a - ra) / 2, (b - rb) / 2, p * 2
        end
    
        if a < b then
            a = b
        end
    
        while a > 0 do
            local ra = a % 2
    
            if ra > 0 then
                c = c + p
            end
    
            a, p = (a - ra) / 2, p * 2
        end
    
        return c
    end
    
    local function encrypt(s, k)
        local cs = {}
        local pos = 0
        for i = 1, #s do
            push(cs, Char(xor(Byte(s, i, i), k)))
        end
        return Concat(cs)
    end
    
    local function _Returns(...)
        return Select(Char(0x23), ...), {...};
    end;
    
    
    local function parse(bytecode)
        bytecode = encrypt(bytecode, 22)
        
        local type_index, bit_idx
        type_index = {
            _tostring,
            _tonumber,
            function(bit)
                bit_idx = {
                    false,
                    true,
                }
                return bit_idx[bit + 1]
            end,
        }

        local Pos = 1
        local function Next(x)
            Pos = Pos + (x or 1)
        end

        local function silent_gBit()
            local Bit = Byte(bytecode, Pos, Pos)
            return Bit
        end

        local function gBit()
            local Bit = silent_gBit()
            Next()
            return Bit
        end

        local function gBits(n)
            n = n or 1
            local Bits = {}
            for i = 1, n do
                Bits[i] = gBit()
            end
            return _tonumber(Concat(Bits))
        end

        local function gString(n)
            local Bits = {}
            for i = 1, n do
                Bits[i] = Char(gBit())
            end
            return Concat(Bits)
        end

        local function gType()
            local Type = gBit()
            if Type == 0 then return end
            local Length = 1
            if Type < 3 then -- If not boolean
                Length = gBit()
            end

            local isNegative = false
            if (Type == 2 and silent_gBit() == 0) and (Length ~= 1) then
                isNegative = true
            end

            local Func = (Type > 2 and gBit) or (Type > 1 and gBits) or gString
            local Data = type_index[Type](Func(Length))
            if isNegative then
                return -Data
            end
            return Data
        end

        gString(11)
        local vmkey = gBit()

        local function decode_chunk()
            local Instructions = {}
            local Constants = {}
            local Protos = {}

            local Args = gBit()
            local Upvals = gBit()

            do -- Load instructions
                for i1 = 1, gType() do -- Amount of instructions
                    Instructions[i1] = {} -- Register
                    for i2 = 1, gBit() - 2 do -- For each value in register (except Enum and Value, hence -2)
                        Instructions[i1][i2] = gType() -- Add to register
                    end

                    Instructions[i1].X = gType() -- Add Enum
                    Instructions[i1].N = gType() -- Add Value
                end
            end

            do -- Load constants
                for i = 1, gType() do -- Amount of constants
                    Constants[i] = gType()
                end
            end

            do -- Load protos
                for i = 1, gType() do -- Amount of protos
                    Protos[i] = decode_chunk()
                end
            end

            return {
                r = Instructions,
                L = Constants,
                P = Protos,
                O = Args,
                o = Upvals,
            }
        end

        local function gPayload(isNumber)
            local _func = isNumber and _tonumber or empty_func
            local queue = {}
            for i = 1, gBit() do
                queue[i] = _func(encrypt(gType(), vmkey))
            end
            return queue
        end

        vm_strings = gPayload()

        return decode_chunk()
    end

    
	local function Wrap(Chunk, Upvalues)
		local Instr	= Chunk.r;
		local Const	= Chunk.L;
		local Proto	= Chunk.P;
	
		return function(...)
			local InstrPoint, Top	= 1, -1;
			local Vararg, Varargsz	= {}, Select(Char(0x23), ...) - 1;
	
			local GStack	= {};
			local Lupvals	= {};
			local Stack		= _setmetatable({}, {
				[___index]		= GStack;
				[___newindex]	= function(_, Key, Value)
					if (Key > Top) then
						Top	= Key;
					end;
	
					GStack[Key]	= Value;
				end;
			});
	
			local function Loop()
				local Inst, Enum;
	
				while _true do
					Inst		= Instr[InstrPoint];
					Enum		= Inst.X;
					InstrPoint	= InstrPoint + 1;
	
	if Enum == 3 then

    Stack[Inst[1]]	= Const[Inst[2] + 1];
    elseif Enum == -61 then

    Stack[Inst[1]]	= Env[Const[Inst[2] + 1]];
    elseif Enum == -59 then
local A	= Inst[1];
	local B	= Inst[2];
	local C	= Inst[3];
	local Stk	= Stack;
	local Args, Results;
	local Limit, Edx;
	
	Args	= {};
	
	if (B ~= 1) then
		if (B ~= 0) then
			Limit = A + B - 1;
		else
			Limit = Top;
		end;
	
		Edx	= 0;
	
		for Idx = A + 1, Limit do
			Edx = Edx + 1;
	
			Args[Edx] = Stk[Idx];
		end;
	
		Limit, Results = _Returns(Stk[A](Unpack(Args, 1, Limit - A)));
	else
		Limit, Results = _Returns(Stk[A]());
	end;
	
	Top = A - 1;
	
	if (C ~= 1) then
		if (C ~= 0) then
			Limit = A + C - 2;
		else
			Limit = Limit + A - 1;
		end;
	
		Edx	= 0;
	
		for Idx = A, Limit do
			Edx = Edx + 1;
	
			Stk[Idx] = Results[Edx];
		end;
	end;
	elseif Enum == -243 then

	local A	= Inst[1];
	local B	= Inst[2];
	local Stk	= Stack;
	local Edx, Output;
	local Limit;
	
	if (B == 1) then
		return;
	elseif (B == 0) then
		Limit	= Top;
	else
		Limit	= A + B - 2;
	end;
	
	Output = {};
	Edx = 0;
	
	for Idx = A, Limit do
		Edx	= Edx + 1;
	
		Output[Edx] = Stk[Idx];
	end;
	
	return Output, Edx;
	elseif Enum == -23 then

	local NewProto	= Proto[Inst[2] + 1];
	local Stk	= Stack;
	
	local Indexes;
	local NewUvals;
	
	if (NewProto.o ~= 0) then
		Indexes		= {};
		NewUvals	= _setmetatable({}, {
				[___index] = function(_, Key)
					local Val	= Indexes[Key];
	
					return Val[1][Val[2]];
				end,
				[___newindex] = function(_, Key, Value)
					local Val	= Indexes[Key];
	
					Val[1][Val[2]]	= Value;
				end;
			}
		);
	
		for Idx = 1, NewProto.o do
			local Mvm	= Instr[InstrPoint];
	
			if (Mvm.X == undefined) then -- MOVE
				Indexes[Idx - 1] = {Stk, Mvm[2]};
			elseif (Mvm.X == undefined) then -- GETUPVAL
				Indexes[Idx - 1] = {Upvalues, Mvm[2]};
			end;
	
			InstrPoint	= InstrPoint + 1;
		end;
	
		Lupvals[#Lupvals + 1]	= Indexes;
	end;
	
	Stk[Inst[1]]			= Wrap(NewProto, NewUvals);
	elseif Enum == 3 then

	local A	= Inst[1];
	local B	= Inst[2];
	local Stk, Vars	= Stack, Vararg;
	
	Top = A - 1;
	
	for Idx = A, A + (B > 0 and B - 1 or Varargsz) do
		Stk[Idx]	= Vars[Idx - A];
	end;
	
end
	end;
	end;
	
	local Args	= {...};
	
	for Idx = 0, Varargsz do
		if (Idx >= Chunk.O) then
			Vararg[Idx - Chunk.O] = Args[Idx + 1];
		else
			Stack[Idx] = Args[Idx + 1];
		end;
	end;
	
	local A, B, C	= Pcall(Loop);
	
	if A then
		if B and (C > 0) then
			return Unpack(B, 1, C);
		end;
	
		return;
	else
		return print(B)
	end;
	end;
	end;
	
	return function(bytecode)
	local buffer = parse(bytecode)
	___index = vm_strings[1]
	___newindex = vm_strings[2]
	Wrap(buffer)()
	end
	
	;end)()("\123\115\120\102\100\121\98\115\117\98\106\24\20\23\17\71\71\113\118\124\125\96\23\28\71\71\118\125\111\113\118\124\125\96\22\22\20\23\19\18\20\23\22\20\23\22\20\21\22\20\21\20\20\21\16\19\20\23\23\20\23\22\21\22\20\21\22\16\23\20\20\16\31\19\20\23\20\20\23\23\21\22\20\23\21\20\19\23\16\19\23\21\19\20\23\23\20\23\20\20\23\23\20\21\22\19\31\20\30\23\16\17\31\21\16\31\20\19\20\23\22\20\23\23\20\23\22\20\21\22\20\20\20\17\30\21\30\30\16\21\30\20\23\20\23\19\102\100\127\120\98\23\19\87\122\122\119\126\20\23\23\22\22\20\23\21\19\20\23\23\20\23\20\20\23\22\20\23\21\20\30\23\16\17\17\17\21\23\17\19\20\23\23\20\23\20\20\23\22\20\20\22\19\20\30\23\16\17\17\17\21\23\22\19\20\23\22\20\23\23\20\23\22\20\18\22\20\18\21\20\17\30\21\30\30\16\21\30\20\23\22\20\23\22");
