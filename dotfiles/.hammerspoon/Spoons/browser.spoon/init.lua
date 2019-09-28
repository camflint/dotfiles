obj = {}
obj.__index = obj

function isAppFrontmost(name)
    local app = hs.appfinder.appFromName(name)
    if app ~= nil then
        return app.name == name
    end
    return false
end

local isSafariFrontmost = hs.fnutils.partial(isAppFrontmost, 'Safari')

function getSafariApp()
    local app = hs.appfinder.appFromName('Safari')
    if app:isFrontmost() then
        return app
    else
        return nil
    end
end

function sendMenu(lst)
    local app = getSafariApp()
    if app ~= nil then
        app:selectMenuItem(lst)
    end
end

local menus = {
    back = {'Window', 'Show Previous Tab'},
    forward = {'Window', 'Show Next Tab'}
}

hs.hotkey.bind(nil, 'F11', nil, hs.fnutils.partial(sendMenu, menus.back))
hs.hotkey.bind(nil, 'F12', nil, hs.fnutils.partial(sendMenu, menus.forward))
