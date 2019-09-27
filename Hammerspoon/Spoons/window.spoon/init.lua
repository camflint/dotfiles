history_buffer = require('lib/history_buffer')

local app = nil
local windows = {}
local appWatcher = nil
local windowWatchers = {}
local buffer = history_buffer.new(10)
local log = hs.logger.new('window.spoon')

function handleGlobalAppEvent(name, event, app)
    if event == hs.application.watcher.activated then
        log.i('app activated')
        handleAppActivated()
    end
end

function handleAppActivated()
    hookApp()
end

function handleAppDeactivated()
    unhookApp()
end

function hookApp()
    log.i('hookApp')
    app = hs.application.frontmostApplication()

    -- Start new watchers.
    appWatcher = app:newWatcher(handleUiEvent)
    appWatcher:start({
        hs.uielement.watcher.applicationDeactivated,
        hs.uielement.watcher.windowCreated,
    })
    for _, win in ipairs(app:allWindows()) do
        watchWindow(win)
    end

    -- Build buffer to switch between visible windows.
    local frontWin = hs.window.frontmostWindow()
    for _, win in ipairs(app:visibleWindows()) do
        if win:id() ~= frontWin:id() then
            buffer:push(win:id())
        end
    end
    buffer:push(frontWin:id())
end

function watchWindow(win)
    local watcher = win:newWatcher(handleUiEvent)
    watcher:start({
        hs.uielement.watcher.elementDestroyed
    })
    windowWatchers[#(windowWatchers) + 1] = watcher
end

function unhookApp()
    log.i('unhook app')
    if app ~= nil then
        for _, windowWatcher in ipairs(windowWatchers) do
            windowWatcher:stop()
        end
        if appWatcher ~= nil then
            appWatcher:stop()
        end
        buffer:clear()
        app = nil
    end
end

function handleUiEvent(element, event, watcher, userData)
    if event == hs.uielement.watcher.windowCreated then
        log.i('window created')
        handleWindowCreated(element)
    elseif event == hs.uielement.watcher.applicationDeactivated then
        log.i('application deactivated')
        handleAppDeactivated()
    elseif event == hs.uielement.watcher.elementDestroyed then
        log.i('window destroyed')
        handleWindowDestroyed(element)
    end
end

function handleWindowCreated(elem)
    watchWindow(elem)
    if elem:isVisible() then
        buffer:ensureAndSync(elem:id())
    end
end

function handleWindowDestroyed(elem)
    buffer:remove(elem:id())
    local win = app:focusedWindow()
    if win ~= nil then
        buffer:ensureAndSync(win:id())
    end
end

function switchAppWindow(fwd)
    local id = fwd and buffer:forward() or buffer:back()
    if id ~= nil then
        local win = hs.window.get(id)
        if win ~= nil then
            log.i('switching to window: ' .. id)
            win:focus()
        end
    end
end

hs.hotkey.bind(nil, 'pagedown', nil, hs.fnutils.partial(switchAppWindow, true))
hs.hotkey.bind(nil, 'pageup', nil, hs.fnutils.partial(switchAppWindow, false))

local globalWatcher = hs.application.watcher.new(handleGlobalAppEvent)
globalWatcher:start()

function killForemost()
    app = hs.application.frontmostApplication()
    if app ~= nil and app:name() ~= 'Hammerspoon' then
        app:kill()
    end
end

hs.hotkey.bind(nil, 'F9', nil, killForemost)

