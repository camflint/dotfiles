local history_buffer = require('lib/history_buffer')

local history = history_buffer.new(10)
local log = hs.logger.new('history.spoon')

function goBackHistory()
    local appName, appObj
    repeat
        appName = history:back()
        if appName == nil then break end
        appObj = hs.appfinder.appFromName(appName)
    until appObj ~= nil
    if appObj ~= nil then
        log.i('traversing window history forward to ' .. appName)
        appObj:activate()
    end
end

function goForwardHistory()
    local appName, appObj
    repeat
        appName = history:forward()
        if appName == nil then break end
        appObj = hs.appfinder.appFromName(appName)
    until appObj ~= nil
    if appObj ~= nil then
        log.i('traversing window history backward to' .. appName)
        appObj:activate()
    end
end

function handleAppActivated(name, event, app)
    if event == hs.application.watcher.activated then
        if history:current() ~= name then
            log.i('new history entry: ' .. name)
            history:push(name)
        end
    end
end

local watcher = hs.application.watcher.new(handleAppActivated)
watcher:start()

hs.hotkey.bind(nil, 'home', nil, goForwardHistory)
hs.hotkey.bind(nil, 'end', nil, goBackHistory)
