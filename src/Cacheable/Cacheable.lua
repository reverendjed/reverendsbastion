local Tinkr, Bastion = ...

-- Define a Cacheable class
---@class Cacheable
local Cacheable = {
    cache = nil,
    callback = nil,
    value = nil,
    __eq = function(self, other)
        return self.value.__eq(self.value, other)
    end
}

-- On index check the cache to be valid and return the value or reconstruct the value and return it
function Cacheable:__index(k)
    if Cacheable[k] then
        return Cacheable[k]
    end

    if self.cache == nil then
        error("Cacheable:__index: " .. k .. " does not exist")
    end

    if not self.cache:IsCached('self') then
        self.value = self.callback()
        self.cache:Set('self', self.value, 0.5)
    end

    return self.value[k]
end

-- When the object is accessed return the value
function Cacheable:__tostring()
    return "Bastion.__Cacheable(" .. tostring(self.value) .. ")"
end

-- Create
function Cacheable:New(value, cb)
    local self = setmetatable({}, Cacheable)

    self.cache = Bastion.Cache:New()
    self.value = value
    self.callback = cb

    self.cache:Set('self', self.value, 0.5)

    return self
end

-- Try to update the value
function Cacheable:TryUpdate()
    if self.cache:IsCached("value") then
        self.value = self.callback()
    end
end

-- Update the value
function Cacheable:Update()
    self.value = self.callback()
end

-- Set a new value
function Cacheable:Set(value)
    self.value = value
end

-- Set a new callback
function Cacheable:SetCallback(cb)
    self.callback = cb
end

return Cacheable
