luaScript = """
local all_keys = {}
local keys = {}
local cursor = "0"
local done = false
repeat
    local result = redis.call('SCAN', cursor, 'match',ARGV[1]) 
    cursor = result[1]
    keys = result[2]
    for i,key in ipairs(keys) do
        all_keys[#all_keys+1] = key
    end
    if cursor == "0" then
        done = true
    end
until done

local values = {}
local step = 7000
for i = 1, #all_keys, step do
    values[#values+1] = redis.call('MGET', unpack(all_keys, i, math.min(i + step - 1, #all_keys)))
end

return values """
