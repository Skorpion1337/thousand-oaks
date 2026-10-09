GAMENAME = "Thousand Oaks: The Mining Empire"

DEFSCREENSPACE = 88 -- a percentage, /100 . default 88
MINIMUM_SCREEN_SCALE = 33 -- like above but minimum
SMALLFONT = 0.0125
BIGFONT = 0.02
BANNERH = 0.045

-- values with zero are shifting constants, see calculate_shifting_constants() when scaling

SMALLFONTDRAWS = 3
SCROLLLINES = 9

BUTTONHOOVERCOLOR = {0.5,0,0}
BUTTONNORMALCOLOR = {0.5,0.5,0.5}

SAVEFILE = "savefile" -- +n
COMPRESSION = "zlib"
SAVENAMEFILE = "savenames"
SCREENDIMFILE = "screenpercentage"
SAVEFILEAMOUNT = 11

--STATEMENTS


HELP_TEXT = 'SOMETHING ABOUT CLUTTER\n\n\nLook at folder %APPDATA%/LOVE to save some space! This folder is \nfor starting directly from code.\n \n\nAnd look at folder %APPDATA%/gamename or simply %APPDATA%/game. This folder is \nfor starting from the compiled executable.\n\n\nIn Linux look for these\n$XDG_DATA_HOME/love/ or ~/.local/share/love/\nlove may be replaced by game name or simply "game"\n\n\nAND NOW FOR LICENSES\n\n\nAdditional licenses not mentioned in the license file in the game folder \nand folder love in the source distribution\n\n\nThis game\nby Skorpion1337\ntinyurl.com/1000oakz\nGPLv3\nhttps://www.gnu.org/licenses/gpl-3.0.html\n\n\n----Libraries----\n\n\nlume\nA collection of functions for Lua, geared towards game development.\nUsing it for serializing data before compression.\nhttps://github.com/rxi/lume\nMIT \n--\n-- lume\n--\n-- Copyright (c) 2020 rxi\n--\n-- Permission is hereby granted, free of charge, to any person obtaining a copy of\n-- this software and associated documentation files (the "Software"), to deal in\n-- the Software without restriction, including without limitation the rights to\n-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies\n-- of the Software, and to permit persons to whom the Software is furnished to do\n-- so, subject to the following conditions:\n--\n-- The above copyright notice and this permission notice shall be included in all\n-- copies or substantial portions of the Software.\n--\n-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n-- SOFTWARE.\n--\n\n\n----Graphics----\n\n\nBackground love potion - graphics/potion.jpg\nhttps://en.wikipedia.org/wiki/File:Filtre_d%27Amour.jpg\nFrom user https://commons.wikimedia.org/wiki/User:Arnaud_25 - Arnaud_25\nCreative Commons Attribution-Share Alike 4.0 International\nhttps://creativecommons.org/licenses/by-sa/4.0/deed.en'

do
    local love = require("love")
    local lume = require("lib.lume")
    local utf8 = require("utf8")

    love.window.setIcon(love.image.newImageData("graphics/large_purple.png"))

    local gfx = love.graphics

    randomgen = love.math.newRandomGenerator()
    randomgen:setSeed(os.time())

    local function savefile(save_number)
        local compressed = love.data.compress("string", COMPRESSION, lume.serialize(Save), 9)

        love.filesystem.write(SAVEFILE..save_number, compressed)
    end

    local function debugbox(value)
        love.window.showMessageBox("Debug Info", value, {"OK"}, "info", true)
    end

    local function load_file(save_number)
        local contents, _ = love.filesystem.read(SAVEFILE..save_number)

        Save = lume.deserialize(love.data.decompress("string", COMPRESSION, contents))
    end

    local function table_len(t)
        local n = 0
        for _ in pairs(t) do
            n = n + 1
        end
        return n
    end

    local function find_hoovered_button(x, y)
        State.hoover = 0
        local len = table_len(Buttons[State.leaf])
        for i=1,len do
            local button = Buttons[State.leaf][i]
            if x > button.x and x < button.x + button.width and y > button.y and y < button.y + button.height then
                State.hoover = i
                break
            end
        end
    end

    local function quitmessage()
        local pressedbutton = love.window.showMessageBox("Want to Quit?", "All unsaved progress will be lost", {"OK", "No!", enterbutton = 2}, "warning", true)
        if pressedbutton == 1 then
            love.event.quit()
        end
    end

    local function change_page(n)
        State.oldleaf = State.leaf
        State.leaf = n
        State.hoover = 0
        find_hoovered_button(Currentx, Currenty)
    end

    local function save_game()
        change_page(3)
    end

    local function save_file(i)
        local pressedbutton = love.window.showMessageBox("Want to save slot "..i.."?", "Old data will be lost.", {"OK", "No!", enterbutton = 2}, "warning", true)
        if pressedbutton == 1 then
            debugbox("Close this dialog, Press ENTER, Write Name, Press ENTER - Slot "..i)
            State.waitingforsavename = true
            State.waitingforsavename_n = i
        end
    end

    local function format_map()
        local map = {}
        for i=1,MAP_SQUARE do
            map[i] = {}
            for j=1,MAP_SQUARE do
                map[i][j] = randomgen:random(2)
            end
        end
        return map
    end

    local function generate_map()
        local map = format_map()

        Save.map = map
        MapGenerated = true
    end

    local function init_save()
        --initialize savedata
        MapGenerated = false
        local map = {}
        Save = {map=map, npcs={}, positionx = 1, positiony = 1}
    end

    local function newgame()
        local pressedbutton = love.window.showMessageBox("Remember to save map first", "Entering new game formats the current map in memory. Want to continue?", {"OK", "No!", enterbutton = 2}, "warning", true)
        if pressedbutton == 1 then
            init_save()
            change_page(2)
        end

    end

    local function loadgame()
        change_page(4)
    end

    local function continuegame()
        change_page(6)
    end

    local function explode(inputstr, sep)
        sep=sep or '%s'
        local t={}
        for field,s in string.gmatch(inputstr, "([^"..sep.."]*)("..sep.."?)") do
            table.insert(t,field)
            if s=="" then return t
            end
        end
    end

    local function debugbox(value)
        love.window.showMessageBox("Debug Info", value, {"OK"}, "info", true)
    end

    local function load_help_text(prefix)
        local lines = explode(HELP_TEXT, "\n")
        local fits = (Buttons[State.leaf][3].y-State.helppadding-(Buttons[State.leaf][2].y+Buttons[State.leaf][2].height+State.helppadding))/SmallFont:getHeight()
        local sliced = {}
        for i=0, fits do
            sliced[i] = lines[prefix+i]
        end
        local nstring = table.concat(sliced, "\n")
        State.savedhelpprefix = prefix
        return nstring
    end

    local function helpwindow()
        change_page(5)
        State.help_text = load_help_text(State.savedhelpprefix)
    end

    local function optionwindow()
        change_page(5)
    end

    local function quitgame()
        quitmessage()
    end

    local function save_n(n)
        savefile(n)
        Buttons[3][n].text = CommandLine.text
        Buttons[4][n].text = CommandLine.text
        local names = {}
        for i = 1, SAVEFILEAMOUNT do
            names[i] = Buttons[3][i].text
        end
        love.filesystem.write(SAVENAMEFILE, lume.serialize(names))
        debugbox("Saved!")
    end

    local function load_n(n)
        if love.filesystem.getInfo(SAVEFILE..n) == nil then
            debugbox("Unloaded Save File")
        else
            local pressedbutton = love.window.showMessageBox("Lose all data when loading", "Loading a game formats the current memory. Want to continue?", {"OK", "No!", enterbutton = 2}, "warning", true)
            if pressedbutton == 1 then
                load_file(n)
                MapGenerated = true
                change_page(6)
            end
        end
    end

    local function has_value (tab, val)
        for _, value in ipairs(tab) do
            if value == val then
                return true
            end
        end

        return false
    end

    local function translatexy(x1, y1)
        x1 = x1*ScreenWidth
        y1 = y1*ScreenHeight
        return x1, y1
    end

    local function backtomain()
        change_page(1)
    end

    local function scrollhelpup()
        State.savedhelpprefix = State.savedhelpprefix - SCROLLLINES
        if State.savedhelpprefix < 0 then
            State.savedhelpprefix = 0
        end
        State.help_text = load_help_text(State.savedhelpprefix)
    end

    local function scrollhelpdown()
        State.savedhelpprefix = State.savedhelpprefix + SCROLLLINES
        State.help_text = load_help_text(State.savedhelpprefix)
    end

    local function startalchcombine()
        State.waitingforalchcombine=true
        debugbox("Close this dialog. Hit enter. Type number+number+number+.. . Hit enter.")
    end

    local function startalchremove()
        State.waitingforalchremove= true
        debugbox("Close this dialog. Hit enter. Type the number to delete. Hit enter.")
    end

    local function count_map_items(item_number)
        local count = 0
        for x=1,MAP_SQUARE do
            for y=1,MAP_SQUARE do
                if Save.map[x][y] == item_number then
                    count = count + 1
                end
            end
        end
        return count
    end

    local function refresh_state()
        love.window.setTitle(GAMENAME)
        love.window.setVSync(2)
        love.keyboard.setKeyRepeat(true)

        Canvas = gfx.newCanvas(ScreenWidth, ScreenHeight)

        local fontsize, _ = translatexy(SMALLFONT,0)
        SmallFont = gfx.newFont(fontsize)
        fontsize, _ = translatexy(BIGFONT, 0)
        BigFont = gfx.newFont(fontsize)

        local newgamebuttonw, newgamebuttonh = translatexy(0.25, 0.07)
        local newbuttonstartw, newbuttonstarth = translatexy(0.5, 0.3)
        local wt, newgamebuttonpadding = translatexy(0.5, 0.02)

        Buttons = {{}}
        Buttons[1] = {{size=1, text="Continue", x = ScreenWidth/2.0-newgamebuttonw/2.0, y = newbuttonstarth, width = newgamebuttonw, height=newgamebuttonh, call = continuegame}, {size=1, text="New Game", x = ScreenWidth/2.0-newgamebuttonw/2.0, y = newbuttonstarth+newgamebuttonh+newgamebuttonpadding, width = newgamebuttonw, height=newgamebuttonh, call = newgame},{size=1, text="Save Game", x = ScreenWidth/2.0-newgamebuttonw/2.0, y =  newbuttonstarth+2*newgamebuttonh+2*newgamebuttonpadding, width = newgamebuttonw, height=newgamebuttonh, call = save_game}, {size=1, text="Load Game", x = ScreenWidth/2.0-newgamebuttonw/2.0, y = newbuttonstarth+3*newgamebuttonh+3*newgamebuttonpadding, width = newgamebuttonw, height=newgamebuttonh, call = loadgame}, {size=1, text="Options", x = ScreenWidth/2.0-newgamebuttonw/2.0, y = newbuttonstarth+4*newgamebuttonh+4*newgamebuttonpadding, width = newgamebuttonw, height=newgamebuttonh, call = optionwindow}, {size=1, text="Help", x = ScreenWidth/2.0-newgamebuttonw/2.0, y = newbuttonstarth+5*newgamebuttonh+5*newgamebuttonpadding, width = newgamebuttonw, height=newgamebuttonh, call = helpwindow}, {size=1, text="Quit", x = ScreenWidth/2.0-newgamebuttonw/2.0, y = newbuttonstarth+6*newgamebuttonh+6*newgamebuttonpadding, width = newgamebuttonw, height=newgamebuttonh, call = quitgame}}

        local newbuttonwidth, newbuttonheight = translatexy(0.2,0.05)
        local paddingx, paddingy = translatexy(0.01,0.01)
        local startpaddingx, startpaddingy = translatexy(0.1,0.1)
        Buttons[2] = {
            {size=1, text="Generate MAP", x = 0, y = startpaddingy, width = newbuttonwidth, height=newbuttonheight, call = generate_map},
            {size=1, text="Save MAP", x = 0, y = newbuttonheight+paddingy+startpaddingy, width = newbuttonwidth, height=newbuttonheight, call = save_game},
            {size=1, text="Back to Main", x = 0, y = 2*newbuttonheight+2*paddingy+startpaddingy, width = newbuttonwidth, height=newbuttonheight, call = backtomain},
        }

        Buttons[3] = {{}}
        local buttonwidth, buttonheight = translatexy(0.33, 0.05)
        local continuebuttonx, continuebuttony = translatexy(0.115, 0.035)
        local buttonpadding, __ = translatexy(0.01, 0)
        for i = 1, SAVEFILEAMOUNT do
            Buttons[3][i] = {size=1, text="Empty MAP File "..i, x = continuebuttonx, y = continuebuttony+buttonheight*i+buttonpadding*i, width = buttonwidth, height=buttonheight, call = save_file}
        end
        local amount = SAVEFILEAMOUNT+1
        Buttons[3][amount] = {size=1, text="Back to Main", x = continuebuttonx, y = continuebuttony+buttonheight*amount+buttonpadding*amount, width = buttonwidth, height=buttonheight, call = backtomain}

        Buttons[4] = {{}}
        for i = 1, SAVEFILEAMOUNT do
            Buttons[4][i] = {size=1, text="Empty MAP File "..i, x = continuebuttonx, y = continuebuttony+buttonheight*i+buttonpadding*i, width = buttonwidth, height=buttonheight, call = load_n}
        end
        amount = SAVEFILEAMOUNT+1
        Buttons[4][amount] = {size=1, text="Back to Main", x = continuebuttonx, y = continuebuttony+buttonheight*amount+buttonpadding*amount, width = buttonwidth, height=buttonheight, call = backtomain}

        local helpbuttonw, helpbuttonh = translatexy(0.3, 0.07)
        local helpbuttonstartx, helpbuttonstarty = translatexy(0, 0.1)
        local centeredx = ScreenWidth/2.0-helpbuttonw/2.0
        Buttons[5] = {{size=1, text="Back to Main", x = centeredx, y = helpbuttonstarty, width = helpbuttonw, height=helpbuttonh, call = backtomain}, {size=1, text="Scroll Up", x = centeredx, y = helpbuttonstarty+helpbuttonh, width = helpbuttonw, height=helpbuttonh, call = scrollhelpup}, {size=1, text="Scroll Down", x = centeredx, y = helpbuttonstarty+10*helpbuttonh, width = helpbuttonw, height=helpbuttonh, call = scrollhelpdown}}

        local gamebuttonw, gamebuttonh = translatexy(0.115, 0.03)
        local wpadding, hpadding = translatexy(0,0.15)
        Buttons[6] = {{size=2, text="Alchemy", x = 0, y = 0*gamebuttonh+hpadding, width = gamebuttonw, height=gamebuttonh, call = newalchemy}, {size=2, text="Back to Main", x = 0, y = 1*gamebuttonh+hpadding, width = gamebuttonw, height=gamebuttonh, call = backtomain}}

        Buttons[7] = {}

        if love.filesystem.getInfo(SAVENAMEFILE) == nil then
            local names = {}
            for n=1,SAVEFILEAMOUNT do
                names[n] = "Unloaded File "..n
            end
            love.filesystem.write(SAVENAMEFILE, lume.serialize(names))
        end
        local names = lume.deserialize(love.filesystem.read(SAVENAMEFILE))
        for n=1, SAVEFILEAMOUNT do
            if names[n] == nil then
                names[n] = "Unloaded File"
            end
            Buttons[3][n].text = names[n]
            Buttons[4][n].text = names[n]
        end

        for i=1,State.mainmenubgsamount do
            State.mainmenubgs[i] = gfx.newImage("graphics/mainmenu/"..i..".png")
        end

        for i=1,State.mainmenubgsamount do
            for j=1, State.mainmenurepeat do
                State.mainmenubgslocation[j+(i-1)*State.mainmenurepeat] = {i,randomgen:random(1,ScreenWidth-State.mainmenubgs[i]:getWidth()), randomgen:random(1,ScreenHeight-State.mainmenubgs[i]:getHeight())}
            end
        end
    end

    local function set_screen_dim(percent, overwrite)
        if percent < MINIMUM_SCREEN_SCALE then
            percent = MINIMUM_SCREEN_SCALE
        end
        if overwrite then
            love.filesystem.write(SCREENDIMFILE, tostring(percent))
        else
            if love.filesystem.getInfo(SCREENDIMFILE) == nil then
                love.filesystem.write(SCREENDIMFILE, tostring(percent))
            else
                local contents, _ = love.filesystem.read(SCREENDIMFILE)
                percent = tonumber(contents)
            end
        end
        DEFSCREENSPACE = percent
        percent = percent / 100.0
        ScreenWidth, ScreenHeight = love.window.getDesktopDimensions()
        ScreenWidth, ScreenHeight = ScreenWidth*percent, ScreenHeight*percent
        love.window.setMode(ScreenWidth, ScreenHeight, {resizable = false, borderless = true, y=ScreenHeight/percent*(1-percent)/2.0, x=ScreenWidth/percent*(1-percent)/2.0})
    end

    local function separate_spaces(s)
        local chunks = {}
        for substring in s:gmatch("%S+") do
            table.insert(chunks, substring)
        end
        return chunks
    end

    function love.keypressed(key, scancode, isrepeat)

    end

    function love.keyreleased(key, scancode, isrepeat)
        if key == "escape" then
            if State.leaf == 1 and State.oldleaf == 1 then
                quitmessage()
            else
                change_page(State.oldleaf)
            end
        end
    end

    local function print_to_debug(text)
        local width, height = translatexy(0, 1)
        gfx.setColor(0.5,0.2,0.1)
        local height2 = SmallFont:getHeight(text)
        gfx.rectangle("fill",0,height-height2,SmallFont:getWidth(text), height2)
        gfx.setFont(SmallFont)
        gfx.setColor(1,0,0)
        for _ =1, SMALLFONTDRAWS do
            gfx.print(text, width, height-height2)
        end
    end

    local function mousepressed(x, y, mouse_button)
        Buttons[State.leaf][State.hoover].call()
    end

    function love.mousemoved(x, y, dx, dy, istouch )
        find_hoovered_button(x, y)
        Currentx, Currenty = x,y
    end

    function love.load()
        init_save()

        set_screen_dim(DEFSCREENSPACE, false)

        Scaling_Down = 0

        State = {leaf = 1, oldleaf = 1, hoover = 0, logo = gfx.newImage("graphics/logo.png"), logo2 = gfx.newImage("graphics/logo2.png"), button_bg = nil, button_bg_quad = nil, button_bg_hover = nil, bg_tile = gfx.newImage("graphics/bg_tile.png"), banner = gfx.newImage("graphics/banner.png"), bannerx = gfx.newImage("graphics/red.png"), bannerm = gfx.newImage("graphics/yellow.png"), helpbg = gfx.newImage("graphics/forest.png"), helppadding = ScreenWidth*0.2*0.1, savedhelpprefix=0, xprefix=0, yprefix=0, walkingwait = WALKSPEED, lovepotion=gfx.newImage("graphics/potion.jpg"), waitingforsavename = false, waitingforsavename_n = 0, mainmenubgs = {}, mainmenubgslocation = {}, mainmenubgsamount= 10, mainmenurepeat = 10}

        local gradientData = love.image.newImageData(2, 1, 'rgba8', '\200\200\200' .. '\255' .. '\050\050\050' .. '\255')
        State.button_bg = gfx.newImage(gradientData)
        State.button_bg:setFilter('linear', 'linear')

        gradientData = love.image.newImageData(2, 1, 'rgba8', '\050\050\050' .. '\255' .. '\200\200\200' .. '\255')
        State.button_bg_hover = gfx.newImage(gradientData)
        State.button_bg_hover:setFilter('linear', 'linear')

        State.button_bg_quad = gfx.newQuad(0.5, 0, 1, 1, 2, 1)

        Tiles={
            {i = 1, name="", file = gfx.newImage("graphics/logo.png"), obstacle = false},
        }

        Hooveredx, Hooveredy = 0, 0

        refresh_state()
    end

    function love.mousereleased(x, y, button, istouch, presses)
        if button == 1 and State.hoover > 0 then
            if State.leaf == 3 or State.leaf == 4 then
                Buttons[State.leaf][State.hoover].call(State.hoover)
            else
                Buttons[State.leaf][State.hoover].call()
            end
        elseif x > ScreenWidth-ScreenHeight*BANNERH and x < ScreenWidth and y > 0 and y < ScreenHeight*BANNERH then
            if State.hoover == -2 then
                State.hoover = 0
            else
                quitmessage()
            end
        elseif x > ScreenWidth-2*ScreenHeight*BANNERH and x < ScreenWidth-ScreenHeight*BANNERH and y > 0 and y < ScreenHeight*BANNERH then
            if State.hoover == -2 then
                State.hoover = 0
            else
                love.window.minimize()
            end
        else
            State.hoover = 0
            find_hoovered_button(x, y)
        end
    end

    function love.update(dt)
        if (State.leaf == 2 or State.leaf == 6) and MapGenerated then
            State.watersparklecur = State.watersparklecur - dt
            if State.watersparklecur <= 0 then
                State.watersparklecur = WATERSPARKLESPEED

                local value
                local randomchoice
                for x=math.max(State.xprefix-6,1),math.min(math.floor(State.xprefix+ScreenWidth/SQUARESIZE+6), MAP_SQUARE) do
                    for y=math.max(State.yprefix-6,1),math.min(math.floor(State.yprefix+ScreenHeight/SQUARESIZE+6), MAP_SQUARE) do
                        value = Save.map[x][y]
                        if value == 11 or value == 12 or value == 13 then
                            if randomgen:random(WATERANIMATIONSPEED) == 1 then
                                randomchoice = randomgen:random(3)
                                if randomchoice == 1 then
                                    Save.map[x][y] = 11
                                elseif  randomchoice == 2 then
                                    Save.map[x][y] = 12
                                else
                                    Save.map[x][y] = 13
                                end
                            end
                        end
                    end
                end
            end
        end

        if State.hoover ~= -2 then
            if State.leaf == 2 then
                if love.keyboard.isDown('w') then
                    State.yprefix = math.floor(State.yprefix - SCROLLLINESMAP)
                    if State.yprefix < 0 then
                        State.yprefix = 0
                    end
                end
                if love.keyboard.isDown('s') then
                    State.yprefix = math.floor(State.yprefix + SCROLLLINESMAP)
                    local check = math.floor(#Save.map[1]-ScreenHeight/SQUARESIZE)
                    if State.yprefix > check then
                        State.yprefix = check
                    end
                end
                if love.keyboard.isDown('a') then
                    State.xprefix = math.floor(State.xprefix - SCROLLLINESMAP)
                    if State.xprefix < 0 then
                        State.xprefix = 0
                    end
                end
                if love.keyboard.isDown('d') then
                    State.xprefix = math.floor(State.xprefix + SCROLLLINESMAP)
                    local check = math.floor(#Save.map-ScreenWidth/SQUARESIZE)
                    if State.xprefix > check then
                        State.xprefix = check
                    end
                end
            elseif State.leaf == 6 then
                State.walkingwait = State.walkingwait - dt
                if State.walkingwait <= 0 then
                    State.walkingwait = WALKSPEED
                    local centerw = math.floor(ScreenWidth/SQUARESIZE/2)
                    local centerh = math.floor(ScreenHeight/SQUARESIZE/2)
                    local wentthrough = false
                    if love.keyboard.isDown("w") and love.keyboard.isDown("d") then
                        if Tiles[Save.map[math.min(State.xprefix+centerw+1, MAP_SQUARE)][math.max(State.yprefix+centerh-1, 1)]].obstacle == false then
                            State.yprefix = math.max(State.yprefix - 1,-centerh+1)
                            State.xprefix = math.min(State.xprefix + 1,MAP_SQUARE-centerw-1)
                            State.charchosen = State.charright
                            wentthrough = true
                        end
                    elseif love.keyboard.isDown("w") and love.keyboard.isDown("a") then
                        if Tiles[Save.map[math.max(State.xprefix+centerw-1, 1)][math.max(State.yprefix+centerh-1, 1)]].obstacle == false then
                            State.yprefix = math.max(State.yprefix - 1,-centerh+1)
                            State.xprefix = math.max(State.xprefix - 1,-centerw+1)
                            State.charchosen = State.charleft
                            wentthrough = true
                        end
                    elseif love.keyboard.isDown("s") and love.keyboard.isDown("d") then
                        if Tiles[Save.map[math.min(State.xprefix+centerw+1, MAP_SQUARE)][math.min(State.yprefix+centerh+1,MAP_SQUARE)]].obstacle == false then
                            State.yprefix = math.min(State.yprefix + 1, MAP_SQUARE-centerh-1)
                            State.xprefix = math.min(State.xprefix + 1,MAP_SQUARE-centerw-1)
                            State.charchosen = State.charright
                            wentthrough = true
                        end
                    elseif love.keyboard.isDown("s") and love.keyboard.isDown("a") then
                        if Tiles[Save.map[math.max(State.xprefix+centerw-1, 1)][math.min(State.yprefix+centerh+1,MAP_SQUARE)]].obstacle == false then
                            State.yprefix = math.min(State.yprefix + 1, MAP_SQUARE-centerh-1)
                            State.xprefix = math.max(State.xprefix - 1,-centerw+1)
                            State.charchosen = State.charleft
                            wentthrough = true
                        end
                    end
                    if wentthrough == false then
                        if love.keyboard.isDown("w") then
                            if Tiles[Save.map[State.xprefix+centerw][math.max(State.yprefix+centerh-1, 1)]].obstacle == false then
                                State.yprefix = math.max(State.yprefix - 1,-centerh+1)
                            end
                        end
                        if love.keyboard.isDown("s") then
                            if Tiles[Save.map[State.xprefix+centerw][math.min(State.yprefix+centerh+1,MAP_SQUARE)]].obstacle == false then
                                State.yprefix = math.min(State.yprefix + 1, MAP_SQUARE-centerh-1)
                            end
                        end
                        if love.keyboard.isDown("a") then
                            if Tiles[Save.map[math.max(State.xprefix+centerw-1, 1)][State.yprefix+centerh]].obstacle == false then
                                State.xprefix = math.max(State.xprefix - 1,-centerw+1)
                                State.charchosen = State.charleft
                            end
                        end
                        if love.keyboard.isDown("d") then
                            if Tiles[Save.map[math.min(State.xprefix+centerw+1, MAP_SQUARE)][State.yprefix+centerh]].obstacle == false then
                                State.xprefix = math.min(State.xprefix + 1,MAP_SQUARE-centerw-1)
                                State.charchosen = State.charright
                            end
                        end
                    end
                end

                State.shootwait = State.shootwait - dt
                if State.shootwait <= 0 then
                    State.shootwait = SHOOT_SPAWN

                    if love.mouse.isDown(1) then

                    end
                end
            end
        end

        function love.draw()
            gfx.setCanvas(Canvas)

            gfx.setColor(255, 255, 255, 255)
            if State.leaf == 1 then

                for x = 0, ScreenWidth, State.bg_tile:getWidth() do
                    for y = 0, ScreenHeight, State.bg_tile:getHeight() do
                        gfx.draw(State.bg_tile, x, y)
                    end
                end

                local iconsize, _ = translatexy(0.002, 0)
                gfx.push()
                gfx.scale(iconsize, iconsize)
                for i=1,State.mainmenubgsamount do
                    for j=1, State.mainmenurepeat do
                        gfx.draw(State.mainmenubgs[i], State.mainmenubgslocation[j+(i-1)*State.mainmenurepeat][2]/iconsize, State.mainmenubgslocation[j+(i-1)*State.mainmenurepeat][3]/iconsize)
                    end
                end
                gfx.pop()
                gfx.push()
                local _, my = translatexy(0, 0.166)
                local scalex = ScreenWidth*0.55/State.logo:getWidth()
                gfx.scale(scalex, scalex)
                gfx.draw(State.logo, ScreenWidth/scalex/2-State.logo:getWidth()/2,my/scalex-State.logo:getHeight()/2)
                gfx.draw(State.logo2, ScreenWidth/scalex/2-State.logo2:getWidth()/2,my/scalex-State.logo2:getHeight()/2+State.logo:getHeight()+10)
                gfx.pop()
            elseif State.leaf == 2 then
                local xamount = ScreenWidth/SQUARESIZE
                local yamount = ScreenHeight/SQUARESIZE
                local squarerounded = math.floor(SQUARESIZE+0.5)
                gfx.setColor(255, 255, 255, 255)
                for i=1, math.floor(xamount+0.5)+2 do
                    for j=1, math.floor(yamount+0.5)+2 do
                        gfx.push()
                        local imagefile = Tiles[Save.map[math.min(math.max(1,i+State.xprefix-1),MAP_SQUARE)][math.min(math.max(1,j+State.yprefix-1),MAP_SQUARE)]].file
                        local scale = ScreenWidth/xamount/math.floor(imagefile:getWidth()+0.5)
                        gfx.scale(scale, scale)
                        gfx.draw(imagefile, (i-1)*squarerounded/scale, (j-1)*squarerounded/scale)
                        gfx.pop()
                    end
                end
                gfx.setFont(BigFont)
                gfx.setColor(1,1,1)
                local padx, pady = translatexy(0.02, 0.05)
                for _ =0, 2 do
                    gfx.print("Use W, S, A, D - Don't start on a lake", padx, pady)
                end
            elseif State.leaf == 3 then
                gfx.setColor(0.1,0.45,0.1)
                gfx.rectangle("fill", 0, 0, ScreenWidth, ScreenHeight)
                gfx.setColor(255, 255, 255, 255)
                gfx.push()
                local imagefile = State.lovepotion
                local scale = ScreenHeight/imagefile:getHeight()
                gfx.scale(scale, scale)
                gfx.draw(imagefile, ScreenWidth/scale-imagefile:getWidth(), 0)
                gfx.pop()
            elseif State.leaf == 4 then
                gfx.setColor(0,0,0,1)
                gfx.rectangle("fill", 0, 0, ScreenWidth, ScreenHeight)
                gfx.setColor(0.7,0.1,0.1)
                gfx.push()
                local rotatefile = State.lovepotion
                local rotatescale = ScreenHeight/rotatefile:getHeight()
                gfx.scale(rotatescale, rotatescale)
                gfx.draw(rotatefile, ScreenWidth/rotatescale-rotatefile:getWidth(), math.max(1,ScreenHeight/2-rotatefile:getHeight()/2))
                gfx.pop()
            elseif State.leaf == 5 then
                gfx.setColor(255, 255, 255, 255)
                gfx.push()
                local scalex = ScreenWidth/State.helpbg:getWidth()
                local scaley = ScreenHeight/State.helpbg:getHeight()
                gfx.scale(scalex, scaley)
                gfx.draw(State.helpbg, 0, 0)
                gfx.pop()
                gfx.setColor(0.72,0.59,0.33)
                local beyondbuttonw, beyondbuttonh = translatexy(0.2, 0.2)
                gfx.rectangle("fill", Buttons[State.leaf][2].x-beyondbuttonw, Buttons[State.leaf][2].y+Buttons[State.leaf][2].height, Buttons[State.leaf][2].width+ 2*beyondbuttonw, Buttons[State.leaf][3].y-(Buttons[State.leaf][2].y+Buttons[State.leaf][2].height))
                gfx.setColor(1,1,1)
                gfx.rectangle("line", Buttons[State.leaf][2].x-beyondbuttonw, Buttons[State.leaf][2].y+Buttons[State.leaf][2].height, Buttons[State.leaf][2].width+ 2*beyondbuttonw, Buttons[State.leaf][3].y-(Buttons[State.leaf][2].y+Buttons[State.leaf][2].height))
                gfx.print(State.help_text, Buttons[State.leaf][2].x-beyondbuttonw+State.helppadding, Buttons[State.leaf][2].y+Buttons[State.leaf][2].height+State.helppadding)
            elseif State.leaf == 6 then
                gfx.push()
                gfx.pop()
            elseif State.leaf == 7 then
                gfx.push()
                --gfx.draw(imagefile, (collectbutton.x+collectbutton.width)/scaleankh, (collectbutton.y+ScreenHeight*ALCHEMYWINDOWSIZE)/scaleankh-ankhheight)--good stretching
                gfx.pop()
            end

            local len = table_len(Buttons[State.leaf])
            for i=1,len do
                local button = Buttons[State.leaf][i]
                local width, height
                if button.size == 1 then
                    gfx.setFont(BigFont)
                    width = BigFont:getWidth(button.text)
                    height = BigFont:getHeight(button.text)
                elseif button.size == 2 then
                    gfx.setFont(SmallFont)
                    width = SmallFont:getWidth(button.text)
                    height = SmallFont:getHeight(button.text)
                end
                if State.hoover == i then
                    gfx.setColor(255, 255, 255, 255)
                    love.graphics.draw(State.button_bg_hover, State.button_bg_quad, button.x, button.y, math.rad(0), button.width, button.height, 0, 0)
                    gfx.setColor(BUTTONNORMALCOLOR)
                    gfx.rectangle("line", button.x, button.y, button.width, button.height)
                    gfx.print(button.text, button.x+button.width/2.0-width/2.0, button.y+button.height/2.0-height/2.0)
                else
                    gfx.setColor(255, 255, 255, 255)
                    love.graphics.draw(State.button_bg, State.button_bg_quad, button.x, button.y, math.rad(0), button.width, button.height, 0, 0)
                    gfx.rectangle("line", button.x, button.y, button.width, button.height)
                    gfx.setColor(BUTTONHOOVERCOLOR)
                    gfx.print(button.text, button.x+button.width/2.0-width/2.0, button.y+button.height/2.0-height/2.0)
                end
            end

            --first after custom leaves is banner
            gfx.setFont(SmallFont)
            gfx.setColor(255, 255, 255, 255)
            gfx.push()
            local theheight = ScreenHeight*BANNERH
            local scale = theheight/State.banner:getHeight()
            gfx.scale(scale, scale)
            for i=0,ScreenWidth/scale/(State.banner:getWidth()) do
                gfx.draw(State.banner, i*State.banner:getWidth(), 0)
            end
            gfx.pop()
            gfx.push()
            scale = theheight/State.bannerx:getHeight()
            gfx.scale(scale, scale)
            local boxsize = State.bannerx:getWidth()
            gfx.draw(State.bannerx, ScreenWidth/scale-boxsize, 0)
            gfx.draw(State.bannerm, ScreenWidth/scale-2*boxsize, 0)
            gfx.pop()
            gfx.setColor(1,1,1)
            for _ =1, SMALLFONTDRAWS do
                gfx.print(GAMENAME, ScreenWidth/2.0 - SmallFont:getWidth(GAMENAME)/2.0, theheight/2.0-SmallFont:getHeight(GAMENAME)/2.0)
            end

            print_to_debug(ScreenWidth.."x"..ScreenHeight..", vsync="..love.window.getVSync()..", fps="..love.timer.getFPS()..", mem="..string.format("%.3f", collectgarbage("count")/1000.0).."MB, randomseed="..randomgen:getSeed())

            gfx.setCanvas()
            gfx.setColor(1, 1, 1, 1)
            gfx.draw(Canvas, 0,0)
        end
    end
end
