local utils = {}

function utils.clamp(x, a, b)
    return math.max(a, math.min(x, b))
end
function utils.CCCollision(x1, y1, r1, x2, y2, r2) -- 판정1: Circle 모양 판정2: Circle 모양
    local dist = (x2-x1)^2 + (y2-y1)^2
    return dist <= (r1 + r2)^2
end
function utils.lerp(a, b, t)
    return a + (b - a) * t
end
function utils.round(w)
    return math.floor(w + 0.5)
end
function utils.sign(x)
    if x > 0 then
        return 1
    elseif x == 0 then
        return 0
    else
        return -1
    end
end
function utils.lengthDirX(len, dir)
    return len * math.cos(math.rad(dir))
end
function utils.lengthDirY(len, dir)
    return -len * math.sin(math.rad(dir))
end
function utils.tableFind(tbl, val)
    for i, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

-- function utils.copyTable(t)
--     local new = {}
--     for k, v in pairs(t) do
--         new[k] = v
--     end
--     return new
-- end

return utils