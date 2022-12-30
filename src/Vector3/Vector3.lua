-- Create a Vector3 class

local Vector3 = {}
Vector3.__index = Vector3

function Vector3:__tostring()
    return "Vector3(" .. self.x .. ", " .. self.y .. ", " .. self.z .. ")"
end

function Vector3:__add(other)
    return Vector3:New(self.x + other.x, self.y + other.y, self.z + other.z)
end

function Vector3:__sub(other)
    if type(other) == "number" then
        return Vector3:New(self.x - other, self.y - other, self.z - other)
    end
    return Vector3:New(self.x - other.x, self.y - other.y, self.z - other.z)
end

function Vector3:__mul(other)
    return Vector3:New(self.x * other, self.y * other, self.z * other)
end

function Vector3:__div(other)
    return Vector3:New(self.x / other, self.y / other, self.z / other)
end

function Vector3:__eq(other)
    return self.x == other.x and self.y == other.y and self.z == other.z
end

function Vector3:__lt(other)
    return self.x < other.x and self.y < other.y and self.z < other.z
end

function Vector3:__le(other)
    return self.x <= other.x and self.y <= other.y and self.z <= other.z
end

function Vector3:__unm()
    return Vector3:New(-self.x, -self.y, -self.z)
end

function Vector3:__len()
    return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
end

function Vector3:__index(k)
    if Vector3[k] then
        return Vector3[k]
    end

    if k == "length" then
        return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
    end

    if k == "normalized" then
        local length = math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
        return Vector3:New(self.x / length, self.y / length, self.z / length)
    end

    if k == "magnitude" then
        return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
    end

    if k == "sqrMagnitude" then
        return self.x * self.x + self.y * self.y + self.z * self.z
    end

    if k == "zero" then
        return Vector3:New(0, 0, 0)
    end

    if k == "one" then
        return Vector3:New(1, 1, 1)
    end

    if k == "up" then
        return Vector3:New(0, 1, 0)
    end

    if k == "down" then
        return Vector3:New(0, -1, 0)
    end

    if k == "left" then
        return Vector3:New(-1, 0, 0)
    end

    if k == "right" then
        return Vector3:New(1, 0, 0)
    end

    if k == "forward" then
        return Vector3:New(0, 0, 1)
    end

    if k == "back" then
        return Vector3:New(0, 0, -1)
    end

    if k == "positiveInfinity" then
        return Vector3:New(math.huge, math.huge, math.huge)
    end

    if k == "negativeInfinity" then
        return Vector3:New(-math.huge, -math.huge, -math.huge)
    end

    if k == "nan" then
        return Vector3:New(0 / 0, 0 / 0, 0 / 0)
    end

    if k == "epsilon" then
        return 1.401298E-45
    end

    if k == "maxValue" then
        return 3.402823E+38
    end

    if k == "minValue" then
        return -3.402823E+38
    end

    if k == "x" then
        return self[1]
    end

    if k == "y" then
        return self[2]
    end

    if k == "z" then
        return self[3]
    end

    return nil
end

function Vector3:__newindex(k, v)
    if k == "x" then
        self[1] = v
    elseif k == "y" then
        self[2] = v
    elseif k == "z" then
        self[3] = v
    else
        rawset(self, k, v)
    end
end

function Vector3:New(x, y, z)
    if x == false then
        return Vector3:New(0, 0, 0)
    end

    local self = setmetatable({ x, y, z }, Vector3)
    return self
end

function Vector3:Dot(rhs)
    return self.x * rhs.x + self.y * rhs.y + self.z * rhs.z
end

function Vector3:Cross(rhs)
    return Vector3:New(self.y * rhs.z - self.z * rhs.y, self.z * rhs.x - self.x * rhs.z, self.x * rhs.y - self.y * rhs.x)
end

function Vector3:Distance(b)
    return FastDistance(self.x, self.y, self.z, b.x, b.y, b.z)
end

function Vector3:Angle(to)
    return math.acos(self:Dot(to) /
        (
        math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z) *
            math.sqrt(to.x * to.x + to.y * to.y + to.z * to.z)))
end

function Vector3:ClampMagnitude(maxLength)
    if self:Dot(self) > maxLength * maxLength then
        return self.normalized * maxLength
    end

    return self
end

-- Implement a clamp function
local function clamp(x, min, max)
    return x < min and min or (x > max and max or x)
end

function Vector3:Lerp(b, t)
    t = clamp(t, 0, 1)
    return Vector3:New(self.x + (b.x - self.x) * t, self.y + (b.y - self.y) * t, self.z + (b.z - self.z) * t)
end

function Vector3:MoveTowards(target, maxDistanceDelta)
    local toVector = target - self
    local distance = toVector.magnitude
    if distance <= maxDistanceDelta or distance == 0 then
        return target
    end

    return self + toVector / distance * maxDistanceDelta
end

function Vector3:Scale(b)
    return Vector3:New(self.x * b.x, self.y * b.y, self.z * b.z)
end

function Vector3:Project(onNormal)
    local num = onNormal:Dot(onNormal)
    if num < 1.401298E-45 then
        return Vector3:New(0, 0, 0)
    end

    return onNormal * self:Dot(onNormal) / num
end

function Vector3:ProjectOnPlane(planeNormal)
    return self - self:Project(planeNormal)
end

function Vector3:Reflect(inNormal)
    return -2 * inNormal:Dot(self) * inNormal + self
end

function Vector3:Normalize()
    local num = self:Dot(self)
    if num > 1E-05 then
        return self / math.sqrt(num)
    end

    return Vector3:New(0, 0, 0)
end

return Vector3
