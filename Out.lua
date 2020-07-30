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
        bytecode = encrypt(bytecode, 38)
        
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

                    Instructions[i1].o = gType() -- Add Enum
                    Instructions[i1].v = gType() -- Add Value
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
                A = Instructions,
                q = Constants,
                M = Protos,
                m = Args,
                x = Upvals,
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
		local Instr	= Chunk.A;
		local Const	= Chunk.q;
		local Proto	= Chunk.M;
	
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
					Enum		= Inst.o;
					InstrPoint	= InstrPoint + 1;
	
	if Enum == 165 then

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
	elseif Enum == 26 then

	local NewProto	= Proto[Inst[2] + 1];
	local Stk	= Stack;
	
	local Indexes;
	local NewUvals;
	
	if (NewProto.x ~= 0) then
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
	
		for Idx = 1, NewProto.x do
			local Mvm	= Instr[InstrPoint];
	
			if (Mvm.o == undefined) then -- MOVE
				Indexes[Idx - 1] = {Stk, Mvm[2]};
			elseif (Mvm.o == undefined) then -- GETUPVAL
				Indexes[Idx - 1] = {Upvalues, Mvm[2]};
			end;
	
			InstrPoint	= InstrPoint + 1;
		end;
	
		Lupvals[#Lupvals + 1]	= Indexes;
	end;
	
	Stk[Inst[1]]			= Wrap(NewProto, NewUvals);
	elseif Enum == 118 then

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
		if (Idx >= Chunk.m) then
			Vararg[Idx - Chunk.m] = Args[Idx + 1];
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
		print(B)
	end;
	end;
	end;
	
	return function(bytecode)
	local buffer = parse(bytecode)
	___index = vm_strings[1]
	___newindex = vm_strings[2]
	Wrap(buffer)()
	end
	
	;end)()("\75\67\72\86\84\73\82\67\69\82\90\13\36\39\33\82\82\100\99\105\104\117\39\44\82\82\99\104\122\100\99\105\104\117\38\38\36\39\36\34\36\39\38\36\39\38\36\36\36\32\36\36\37\32\35\36\39\38\36\39\39\36\39\38\36\34\38\39\37\46\36\33\46\37\46\46\32\37\46\36\39\38\36\39\39\38\38\36\39\37\35\36\39\39\36\39\36\36\39\38\36\37\39\39\46\36\46\39\32\33\33\33\37\39\33\35\36\39\39\36\39\36\36\39\38\36\37\38\35\34\36\46\39\32\33\33\33\37\39\38\35\36\39\38\36\39\39\36\39\38\36\37\39\32\35\36\33\46\37\46\46\32\37\46\36\39\38\36\39\38");
