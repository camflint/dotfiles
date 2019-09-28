log = hs.logger.new('launcher', 'debug')

launcherMode = hs.hotkey.modal.new({}, nil)

mappings = {
    { {}, '1', 'iTerm' },
    { {}, '2', 'Safari' },
    { {}, '3', 'Mail' },
    { {}, '4', 'Calendar' },
    { {}, '5', 'Messages' }
}

function launcherMode.bindWithAutoExit(mode, modifiers, key, fn)
    mode:bind(modifiers, key, function()
        mode:exit()
        fn()
    end)
end

function launchApp(app)
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

for i, mapping in ipairs(mappings) do
    local modifiers, trigger, app = table.unpack(mapping)

    launcherMode:bindWithAutoExit(modifiers, trigger, function() 
        launchApp(app)
    end)
end

launcherMode.entered = function()
    --log.i('Entered mode')
end
launcherMode.exited = function()
    --log.i('Exited mode')
end

hs.urlevent.bind('launcherMode', function(eventName, params)
    launcherMode:enter()
end)
launcherMode:bind({}, 'escape', function()
    launcherMode:exit()
end)

