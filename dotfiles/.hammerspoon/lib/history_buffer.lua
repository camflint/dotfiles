-- circular history buffer for lua

local history_buffer = {}
history_buffer.__index = history_buffer

local function rotate_indice(i, n)
    return ((i - 1) % n) + 1
end

function history_buffer:rotate(i)
    return rotate_indice(i, self:size())
end

function history_buffer:moveForward(i)
    return self:rotate(i+1)
end

function history_buffer:moveBack(i)
    return self:rotate(i-1)
end

function history_buffer:size()
    return #(self.history)
end

function history_buffer:filled()
    return #(self.history) == self.max_size
end

function history_buffer:first()
    if self.i_first >= 1 then
        return self[self.i_first]
    else
        return nil
    end
end

function history_buffer:last()
    if self.i_last >= 1 then
        return self[self.i_last]
    else
        return nil
    end
end

function history_buffer:current()
    if self.i_current >= 1 then
        return self[self.i_current]
    else
        return nil
    end
end

function history_buffer:forward()
    if self:size() <= 1 then return nil end

    if self.i_current ~= self.i_end then
        self.i_current = rotate_indice(self.i_current + 1, self:size())
    elseif self.wrap then
        self.i_current = self.i_first
    else
        return nil
    end

    return self:current()
end

function history_buffer:back()
    if self:size() <= 1 then return nil end

    if self.i_current ~= self.i_first then
        self.i_current = rotate_indice(self.i_current - 1, self:size())
    elseif self.wrap then
        self.i_current = self.i_last
    else
        return nil
    end

    return self:current()
end

function history_buffer:current()
    if self.i_current >= 1 then
        return self[self.i_current]
    else
        return nil
    end
end

function history_buffer:push(val)
    local sz = self:size()
    local i_next = -1
    if sz < 1 then
        i_next = 1
        self.i_first = 1
    elseif not self:filled() then
        i_next = self.i_current + 1
    else
        i_next = rotate_indice(self.i_current + 1, sz)
        if i_next == self.i_first then
            self.i_first = rotate_indice(self.i_first + 1, sz)
        end
    end
    self.i_current = i_next
    self.i_last = i_next
    self.history[self.i_current] = val
    self.lookup[val] = i_next
    self.log.df("i_first=%d, i_last=%d, i_current=%d", self.i_first, self.i_last, self.i_current)
end

function history_buffer:clear()
    self.history = {}
    self.lookup = {}
end

function history_buffer:ensureAndSync(val)
    local i_jump = self.lookup[val]
    if i_jump == nil then
        self:push(val)
    else
        self:jump(i_jump)
    end
end

function history_buffer:jump(idx)
    if idx == self.i_current then return end
    if idx >= 1 and idx < self:size() then
        local val = self[idx]
        self:remove(idx)
        self:push(val)
    end
end

function history_buffer:remove(val)
    idx = self.lookup[val]
    if idx == nil then return end

    local i_first = self.i_first
    local i_last = self.i_last
    local i_current = self.i_current

    if self:size() > 1 then
        -- Case A: Remove an element that is pointed to.
        if self.i_first == idx then
            if idx ~= self:size() then
                -- Do nothing.
            else
                i_first = self:moveForward(self.i_first)
            end
        end
        if self.i_last == idx then
            i_last = self:moveBack(self.i_last)
        end
        if self.i_current == idx then
            if self.i_last ~= idx then
                i_current = self:moveForward(self.i_current)
            else
                i_current = self:moveBack(self.i_current)
            end
        end

        -- Case B: Remove an element in between pointers.
        if self.i_first > idx then i_first = self:moveBack(self.i_first) end
        if self.i_last > idx then i_last = self:moveBack(self.i_last) end
        if self.i_current > idx then i_current = self:moveBack(self.i_current) end
    else
        i_first = -1
        i_last = -1
        i_current = -1
    end

    table.remove(self.history, idx)
    self.lookup[val] = nil

    -- Fix lookup table.
    for i = self:rotate(idx), self:size() do
        self.lookup[self.history[i]] = i
    end

    self.i_first = i_first
    self.i_last = i_last
    self.i_current = i_current
end

history_buffer.metatable = {}

function history_buffer.metatable:__index(i)
    if self:size() > 0 then
        return self.history[i]
    else
        return nil
    end
end

function history_buffer.metatable:__len()
    return #(self.history)
end

function history_buffer.new(max_size, wrap)
    if type(max_size) ~= 'number' or max_size <= 1 then
        error("Buffer length must be a positive integer")
    end
    wrap = wrap == nil and true or wrap

    local instance = {
        history = {},
        lookup = {},
        wrap = wrap,
        log = hs.logger.new('history_buffer'),
        i_first = -1,
        i_last = -1,
        i_current = -1,
        max_size = max_size,
        size = history_buffer.size,
        filled = history_buffer.filled,
        first = history_buffer.first,
        last = history_buffer.last,
        current = history_buffer.current, 
        back = history_buffer.back,
        forward = history_buffer.forward,
        push = history_buffer.push,
        clear = history_buffer.clear,
        jump = history_buffer.jump,
        rotate = history_buffer.rotate,
        moveForward = history_buffer.moveForward,
        moveBack = history_buffer.moveBack,
        ensureAndSync = history_buffer.ensureAndSync,
        remove = history_buffer.remove
    }
    setmetatable(instance, history_buffer.metatable)
    return instance
end

return history_buffer

