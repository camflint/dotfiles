log = hs.logger.new('launcher', 'debug')

obj = {
    win_switch_toggle = 0
}
obj.__index = obj

mode = hs.hotkey.modal.new({}, nil)
obj.mode = mode

-- Set up URL triggers.
hs.urlevent.bind('godMode', function(eventName, params)
    if params['switchWindow'] ~= nil then
        obj:switchWindow()
    else
        -- Default behavior: enter mode and wait for second trigger.
        obj.mode:enter()
    end
end)
mode:bind({}, 'escape', function()
    obj.mode:exit()
end)

function obj:bindWithAutoExit(modifiers, key, fn)
    self.mode:bind(modifiers, key, function()
        self.mode:exit()
        fn()
    end)
end

function obj:launchApp(app)
    win = hs.window.frontmostWindow()
    front_app = win:application()
    front_app_name = front_app:name()
    if front_app_name ~= app then
        hs.application.launchOrFocus(app)
    else
        filter = hs.window.filter.new(false)
        filter:setAppFilter(app, {currentSpace=true})
        sw = hs.window.switcher.new(filter)
        sw:next()
    end
end

function obj:switchWindow()
    log.i('switchWindow!')
    sw = hs.window.switcher.new()
    if self.win_switch_toggle == 0 then
        sw:previous()
    else
        sw:previous()
    end
    self.win_switch_toggle = (self.win_switch_toggle + 1) % 2
end

mappings = {
    -- Application launcher.
    { {}, '1', hs.fnutils.partial(obj.launchApp, obj, 'iTerm')},
    { {}, '2', hs.fnutils.partial(obj.launchApp, obj, 'Safari')},
    { {}, '3', hs.fnutils.partial(obj.launchApp, obj, 'Mail')},
    { {}, '4', hs.fnutils.partial(obj.launchApp, obj, 'Calendar')},
    { {}, '5', hs.fnutils.partial(obj.launchApp, obj, 'Messages')},

    -- Window switching.
    { {}, 'fn', hs.fnutils.partial(obj.switchWindow, obj)}
}

for i, mapping in ipairs(mappings) do
    local modifiers, trigger, fn = table.unpack(mapping)
    obj:bindWithAutoExit(modifiers, trigger, fn)
end

