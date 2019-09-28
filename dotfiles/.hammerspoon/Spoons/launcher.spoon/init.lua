function launchApp(app)
    win = hs.window.frontmostWindow()
    front_app = win:application()
    front_appName = front_app:name()
    if front_appName ~= app then
        hs.application.launchOrFocus(app)
    else
        filter = hs.window.filter.new(false)
        filter:setAppFilter(app, {currentSpace=true})
        sw = hs.window.switcher.new(filter)
        sw:next()
    end
end

hs.hotkey.bind(nil, 'F1', nil, hs.fnutils.partial(launchApp, 'iTerm'))
hs.hotkey.bind(nil, 'F2', nil, hs.fnutils.partial(launchApp, 'Safari'))
hs.hotkey.bind(nil, 'F3', nil, hs.fnutils.partial(launchApp, 'Mail'))
hs.hotkey.bind(nil, 'F4', nil, hs.fnutils.partial(launchApp, 'Calendar'))
hs.hotkey.bind(nil, 'F5', nil, hs.fnutils.partial(launchApp, 'Messages'))

