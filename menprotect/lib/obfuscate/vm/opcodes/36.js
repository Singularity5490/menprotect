const functions = require('../../../funcs')
const funcs = new functions()

module.exports = function(data) {
	let keys = data[0]

	return `
	local NewProto	= Proto[Inst[2] + 1];
	local Stk	= Stack;
	
	local Indexes;
	local NewUvals;
	
	if (NewProto.O_UPVALS ~= 0) then
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
	
		for Idx = 1, NewProto.O_UPVALS do
			local Mvm	= Instr[InstrPoint];
	
			if (Mvm.O_ENUM == ${funcs.xor(0, keys.register)}) then -- MOVE
				Indexes[Idx - 1] = {Stk, Mvm[2]};
			elseif (Mvm.O_ENUM == ${funcs.xor(4, keys.register)}) then -- GETUPVAL
				Indexes[Idx - 1] = {Upvalues, Mvm[2]};
			end;
	
			InstrPoint	= InstrPoint + 1;
		end;
	
		Lupvals[#Lupvals + 1]	= Indexes;
	end;
	
	Stk[Inst[1]]			= Wrap(NewProto, NewUvals);
	`
}
