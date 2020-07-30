--[[
    Written by Stroketon#0019 for delerium
    You are not allowed to use any of the auth code on your projects
]]


getfenv().WS_ENCRYPT_STRING = function(str) return str end;


local mod = 2^32
local modm = mod-1

local function memoize(f)
    local mt = {}
    local t = setmetatable({}, mt)
    function mt:__index(k)
        local v = f(k)
        t[k] = v
        return v
    end
    return t
end

local function make_bitop_uncached(t, m)
    local function bitop(a, b)
        local res,p = 0,1
        while a ~= 0 and b ~= 0 do
            local am, bm = a % m, b % m
            res = res + t[am][bm] * p
            a = (a - am) / m
            b = (b - bm) / m
            p = p*m
        end
        res = res + (a + b) * p
        return res
    end
    return bitop
end

local function make_bitop(t)
    local op1 = make_bitop_uncached(t,2^1)
    local op2 = memoize(function(a) return memoize(function(b) return op1(a, b) end) end)
    return make_bitop_uncached(op2, 2 ^ (t.n or 1))
end

local bxor1 = make_bitop({[0] = {[0] = 0,[1] = 1}, [1] = {[0] = 1, [1] = 0}, n = 4})

local function bxor(a, b, c, ...)
    local z = nil
    if b then
        a = a % mod
        b = b % mod
        z = bxor1(a, b)
        if c then z = bxor(z, c, ...) end
        return z
    elseif a then return a % mod
    else return 0 end
end

local function band(a, b, c, ...)
    local z
    if b then
        a = a % mod
        b = b % mod
        z = ((a + b) - bxor1(a,b)) / 2
        if c then z = bit32_band(z, c, ...) end
        return z
    elseif a then return a % mod
    else return modm end
end

local function bnot(x) return (-1 - x) % mod end

local function rshift1(a, disp)
    if disp < 0 then return lshift(a,-disp) end
    return math.floor(a % 2 ^ 32 / 2 ^ disp)
end

local function rshift(x, disp)
    if disp > 31 or disp < -31 then return 0 end
    return rshift1(x % mod, disp)
end

local function lshift(a, disp)
    if disp < 0 then return rshift(a,-disp) end
    return (a * 2 ^ disp) % 2 ^ 32
end

local function rrotate(x, disp)
    x = x % mod
    disp = disp % 32
    local low = band(x, 2 ^ disp - 1)
    return rshift(x, disp) + lshift(low, 32 - disp)
end

local k = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
    0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
    0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
    0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
    0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
    0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
    0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
    0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
}

local function str2hexa(s)
    return (string.gsub(s, ".", function(c) return string.format("%02x", string.byte(c)) end))
end

local function num2s(l, n)
    local s = ""
    for i = 1, n do
        local rem = l % 256
        s = string.char(rem) .. s
        l = (l - rem) / 256
    end
    return s
end

local function s232num(s, i)
    local n = 0
    for i = i, i + 3 do n = n*256 + string.byte(s, i) end
    return n
end

local function preproc(msg, len)
    local extra = 64 - ((len + 9) % 64)
    len = num2s(8 * len, 8)
    msg = msg .. "\128" .. string.rep("\0", extra) .. len
    assert(#msg % 64 == 0)
    return msg
end

local function InitH256(H)
    H[1] = 0x6a09e667
    H[2] = 0xbb67ae85
    H[3] = 0x3c6ef372
    H[4] = 0xa54ff53a
    H[5] = 0x510e527f
    H[6] = 0x9b05688c
    H[7] = 0x1f83d9ab
    H[8] = 0x5be0cd19
    return H
end

local function DigestBlock(msg, i, H)
    local w = {}
    for j = 1, 16 do w[j] = s232num(msg, i + (j - 1)*4) end
    for j = 17, 64 do
        local v = w[j - 15]
        local s0 = bxor(rrotate(v, 7), rrotate(v, 18), rshift(v, 3))
        v = w[j - 2]
        w[j] = w[j - 16] + s0 + w[j - 7] + bxor(rrotate(v, 17), rrotate(v, 19), rshift(v, 10))
    end

    local a, b, c, d, e, f, g, h = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]
    for i = 1, 64 do
        local s0 = bxor(rrotate(a, 2), rrotate(a, 13), rrotate(a, 22))
        local maj = bxor(band(a, b), band(a, c), band(b, c))
        local t2 = s0 + maj
        local s1 = bxor(rrotate(e, 6), rrotate(e, 11), rrotate(e, 25))
        local ch = bxor (band(e, f), band(bnot(e), g))
        local t1 = h + s1 + ch + k[i] + w[i]
        h, g, f, e, d, c, b, a = g, f, e, d + t1, c, b, a, t1 + t2
    end

    H[1] = band(H[1] + a)
    H[2] = band(H[2] + b)
    H[3] = band(H[3] + c)
    H[4] = band(H[4] + d)
    H[5] = band(H[5] + e)
    H[6] = band(H[6] + f)
    H[7] = band(H[7] + g)
    H[8] = band(H[8] + h)
end

local function sha256(msg)
    msg = preproc(msg, #msg)
    local H = InitH256({})
    for i = 1, #msg, 64 do DigestBlock(msg, i, H) end
    return str2hexa(num2s(H[1], 4) .. num2s(H[2], 4) .. num2s(H[3], 4) .. num2s(H[4], 4)
        .. num2s(H[5], 4) .. num2s(H[6], 4) .. num2s(H[7], 4) .. num2s(H[8], 4))
end

local function hmac(str, key) 
    return sha256(key .. key .. str .. key .. key .. str .. key .. str);
end;

local index_table = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'


local function to_binary(integer)
    local remaining = tonumber(integer)
    local bin_bits = ''

    for i = 7, 0, -1 do
        local current_power = 2 ^ i

        if remaining >= current_power then
            bin_bits = bin_bits .. '1'
            remaining = remaining - current_power
        else
            bin_bits = bin_bits .. '0'
        end
    end

    return bin_bits
end

local function from_binary(bin_bits)
    return tonumber(bin_bits, 2)
end


local function to_base64(to_encode)
    local bit_pattern = ''
    local encoded = ''
    local trailing = ''

    for i = 1, string.len(to_encode) do
        bit_pattern = bit_pattern .. to_binary(string.byte(string.sub(to_encode, i, i)))
    end

    -- Check the number of bytes. If it's not evenly divisible by three,
    -- zero-pad the ending & append on the correct number of ``=``s.
    if string.len(bit_pattern) % 3 == 2 then
        trailing = '=='
        bit_pattern = bit_pattern .. '0000000000000000'
    elseif string.len(bit_pattern) % 3 == 1 then
        trailing = '='
        bit_pattern = bit_pattern .. '00000000'
    end

    for i = 1, string.len(bit_pattern), 6 do
        local byte = string.sub(bit_pattern, i, i+5)
        local offset = tonumber(from_binary(byte))
        encoded = encoded .. string.sub(index_table, offset+1, offset+1)
    end

    return string.sub(encoded, 1, -1 - string.len(trailing)) .. trailing
end


local function from_base64(to_decode)
    local padded = to_decode:gsub("%s", "")
    local unpadded = padded:gsub("=", "")
    local bit_pattern = ''
    local decoded = ''

    for i = 1, string.len(unpadded) do
        local char = string.sub(to_decode, i, i)
        local offset, _ = string.find(index_table, char)
        if offset == nil then
             error("Invalid character '" .. char .. "' found.")
        end

        bit_pattern = bit_pattern .. string.sub(to_binary(offset-1), 3)
    end

    for i = 1, string.len(bit_pattern), 8 do
        local byte = string.sub(bit_pattern, i, i+7)
        decoded = decoded .. string.char(from_binary(byte))
    end

    local padding_length = padded:len()-unpadded:len()

    if (padding_length == 1 or padding_length == 2) then
        decoded = decoded:sub(1,-2)
    end
    return decoded
end

local function XOR(a, b)
    local p,c=1,0
    while a>0 and b>0 do
        local ra,rb=a%2,b%2
        if ra~=rb then c=c+p end
        a,b,p=(a-ra)/2,(b-rb)/2,p*2
    end
    if a<b then a=b end
    while a>0 do
        local ra=a%2
        if ra>0 then c=c+p end
        a,p=(a-ra)/2,p*2
    end
    return c
end;


local function ConvertJobId(JobId)
    local Nums = {

    };

    local Counter = 1;
    for i = 45, 122 do 
        Nums[string.char(i)] = Counter;
        Counter = Counter + 1;
    end;

    local Num = 0;
    for Length = 1, #JobId do
        Num = Num + Nums[JobId:sub(Length, Length)];
    end;
    return Num;
end;

local function GetJobIdUniqueIdentifier(ServerID, UserId) 
    local function Get(JobId) 
        local Nums = {

        };
        for i = 37, 137 do 
            table.insert(Nums, string.char(i));
        end;
        local Identifier = "";
        JobId = tostring(JobId);
        for i = 1, #JobId do
            local Num = tonumber(JobId:sub(i, i));
            Identifier = Identifier .. Nums[Num == 0 and 1 or Num];
        end;
        return Identifier;
    end;

    local NonAlphaBetsIdentifier = Get(ServerID);
    local Offset = tonumber(tostring(UserId):sub(1, 2));
    local NewIdentifier = "";

    for i = 1, #NonAlphaBetsIdentifier do 
        local CharCode = NonAlphaBetsIdentifier:sub(i, i):byte() + Offset;
        local Num = tonumber(tostring(CharCode):sub(#tostring(CharCode) - 1, #tostring(CharCode)));
        if math.floor(Num / 10) % 2 == 1 then 
            Num = Num - (math.floor(Num / 10) * 10) + 10;
        end;
        Num = 100 + Num;
        if Num > 122 then 
            Num = Num - (Num - 122);
        end;
        NewIdentifier = NewIdentifier .. string.char(Num);
    end;
    

    local List = {

    };

    for i = 97, 122 do 
        table.insert(List, string.char(i));
    end;


    local UserIdIdentifier = "";
    local UserIdStr = tostring(UserId);
    local ServerIDArray = {};
    local ServerIDStr = tostring(ServerID);

    for i = 1, #ServerIDStr do 
        table.insert(ServerIDArray, tonumber(ServerIDStr:sub(i, i)));
    end;


    local ServerIDOffset = math.min(unpack(ServerIDArray));
    
    for i = 1, #UserIdStr do 
        local UserIdNumChar = tonumber(UserIdStr:sub(i, i))
        local CharCode = List[UserIdNumChar == 0 and 1 or UserIdNumChar]:byte();
        UserIdIdentifier = UserIdIdentifier .. string.char(CharCode + ServerIDOffset);
    end;
    UserIdIdentifier = UserIdIdentifier:sub(1, #NewIdentifier);
    
    NewIdentifier = NewIdentifier .. "-" .. UserIdIdentifier;

    return NewIdentifier;
end;


local function GetXORKey(jobid) 
    local CustomCodes = {};
    local Times = 1;

    for i = 97, 122 do 
        CustomCodes[string.char(i)] = Times;
        Times = Times + 1;
    end;
    CustomCodes["-"] = Times + 1;
    Times = Times + 1;
    CustomCodes[" "] = Times + 1;
    local xorkey = 0;

    for i = 1, #jobid do
        xorkey = xorkey + CustomCodes[jobid:sub(i, i)];
    end;
    return xorkey;
end;



local function XOREncrypt(str, Key) 
    local Bytes = {};
    for i = 1, #str do 
        local Char = str:sub(i, i);
        table.insert(Bytes, string.char(XOR(Char:byte(), Key)));
    end;

    return table.concat(Bytes);
end;


local function GetHMACInt(Identifier)
    local Nums = {};
    local Key = 0;
    local Counter = 1;
    for i = 97, 122 do 
        Nums[string.char(i)] = Counter;
        Counter = Counter + 1;
    end;

    Nums["-"] = Counter;
    Counter = Counter + 1;

    for i = 1, #Identifier do 

        Key = Key + Nums[Identifier:sub(i, i)] + (Identifier:sub(i, i):byte() * 100); -- removes the static effect (unverified effect)
    end;

    return Key;
end;


local function GetHMACIdentifier(Num) 
    Num = tostring(Num)
    local new = "";
    local Nums = {}
    for i = 0, 25 do 
        Nums[tostring(i)] = string.char(97 + i);
    end;

    for i = 1, #Num do 
        local h = tonumber(Num:sub(i, i));
        new = new .. Nums[tostring(h)];
    end;
    return new;
end;

--[[if not getreg().whitelist_key then return end;
if not getreg().whitelist_script_id then return end;
local WLKey = getreg().whitelist_key;
local ScriptID = getreg().whitelist_script_id;]]
local WLKey = "0b68df6a98f440773aa88a3cfbfa6bb7c349"
local ScriptID = "9f1ab0110a2a977f65e69aed6807c264f14d";
-- replace var
--local AuthUrl = PRODUCTION_URL and PRODUCTION_URL .. WS_ENCRYPT_STRING("/auth/") or WS_ENCRYPT_STRING("http://localhost/auth/");
local AuthUrl = PRODUCTION_URL and PRODUCTION_URL .. WS_ENCRYPT_STRING("/auth/") or WS_ENCRYPT_STRING("https://elerium.cc/delerium/auth/");
local UserId = game.Players.LocalPlayer.UserId;

local Response = game:HttpGet(AuthUrl .. WS_ENCRYPT_STRING("a?a=") .. tostring(UserId));
local Identifier = GetJobIdUniqueIdentifier(ConvertJobId(game.JobId), UserId);
local XORKey = GetXORKey(Identifier);
local VerificationKey, jobid = XOREncrypt(from_base64(Response), XORKey):match(WS_ENCRYPT_STRING("(%l+)|(%l+)"));
local MainResponse = syn.request({
    Url = AuthUrl .. WS_ENCRYPT_STRING("b") .. WS_ENCRYPT_STRING("?a=") .. WLKey .. WS_ENCRYPT_STRING("&b=") .. ScriptID;
    Method = "GET";
    Headers = {
        a = game.JobId;
        b = tostring(UserId);
        c = game.Players.LocalPlayer.Name;
    };
})
local joemamastr = GetHMACIdentifier(GetHMACInt(VerificationKey) + ConvertJobId(game.JobId));
if MainResponse.Body == hmac(VerificationKey, Identifier) and jobid == joemamastr then
    warn("Whitelisted");
    -- replace script
else 
    game:GetService("Players").LocalPlayer:Kick(MainResponse.Body);
end;