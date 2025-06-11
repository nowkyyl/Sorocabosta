local function IterGCTable(iter)
    for i, v in getgc(true) do
        if iter(v) then
            break
        end
    end
end

IterGCTable(function(v)
    local vType = type(v)
    if vType == 'table' then
        local mt = getrawmetatable(v)
        if not mt or type(mt) ~= 'table' then return end

        local isReadonly = isreadonly(mt)
        if isReadonly then
            setreadonly(mt, false)
        end

        if rawget(mt, '__mode') then
            rawset(mt, '__mode', 'fk u')
        end

        if isReadonly then
            setreadonly(mt, true)
        end
    elseif vType == 'function' then
        local info = debug.getinfo(v)
        if info.name == '__call' and info.nups == 25 then
            hookfunction(v, function()
                return 'SUCCESS'
            end)
        end
    end
end)

print('bypass :)')
