Save = {}
Save.gamename = "Thousand Oaks: The Mining Empire"

MINIMUM_SCREEN_SCALE = 25
SCREENRATIO = 16/9
TILERATIO = 32/1920

MINIFONT = 0.0095
SMALLFONT = 0.0125
BIGFONT = 0.02
BANNERH = 0.045
NORMAL_SIZE_AT_PX = 1689.6

--remember to fix sizes to current map size eg. CURRENT_MAP_SIZE(200)/MAP_SIZE
MAX_WATER = 0.80
MAP_SIZE = 300
MAX_LAKE_SIZE = 0.1*200/MAP_SIZE
MIN_LAKE_SIZE = 0.2*200/MAP_SIZE
MAPSPEEDSEC = 0.01
MAX_VOLCANO = 0.05
VOLCANISM = 1/7

DELIMITER = "+"

SMALLFONTDRAWS = 3
SCROLLLINES = 8

BUTTONHOOVERCOLOR = {0.5,0,0}
BUTTONNORMALCOLOR = {0.5,0.5,0.5}

SAVEFILE = "savefile" -- +n
COMPRESSION = "zlib"
SAVENAMEFILE = "savenames"
OPTIONSFILE = "options"
SAVEFILEAMOUNT = 11

PLANET_AMOUNT = 20
planet_properties = {
    { name="Solar System", levels={} },
    { name="Planet", levels={} },
    { name="", levels={} },
    { name="Temperature", levels={"Glacial", "Freezing", "Cold", "Temperate", "Warm", "Hot", "Infernal"} },
    { name="Water", levels={"Barren", "Dry", "Damp", "Wet", "Swampy", "Waterlogged", "Flooded"} },
    { name="Radiation", levels={"Zero", "Negligible", "Ambient", "Moderate", "Toxic", "Hazardous", "Lethal"} },
    { name="Volcanism", levels={"Dormant", "Cool", "Stable", "Active", "Unstable", "Magmatic", "Apocalyptic"} },
    { name="Biodiversity", levels={"Lifeless", "Barren", "Sparse", "Balanced", "Vibrant", "Hyperdiverse", "Primordial"} },
    { name="Vegetation", levels={"Cleared", "Scrubland", "Patchy", "Balanced", "Dense", "Jungle", "Choking"} },
    { name="Mineral Richness", levels={"Depleted", "Trace", "Lean", "Standard", "Rich", "Abundant", "Motherlode"} },
    { name="Storm Activity", levels={"Calm", "Mild", "Variable", "Active", "Violent", "Furious", "Apocalyptic"} }
}
local function property_level(name, planet)
    level=nil
    if planet == nil then
        planet = Save.PlanetChoice
    end
    for i=1, #planet_properties do
        if planet_properties[i].name == name then
            level = Save.planets[planet][i].level
            break
        end
    end
    return level
end
local function get_planet_name(planet)
    if planet == nil then
        planet = Save.PlanetChoice
    end
    name = ""
    for i=1, #planet_properties do
        if planet_properties[i].name == "Planet" then
            level_name = Save.planets[planet][i].level_name
            break
        end
    end
    return level_name
end
--temperature decides terrain&water and vegetation type
--radiation decides biodiversity type
severity_colors = {
    { 0.478, 0.545, 0.600, 1.0 }, -- None: Slate Gray (#7A8B99)
    { 0.306, 0.659, 0.871, 1.0 }, -- Minimal: Sky Blue (#4EA8DE)
    { 0.322, 0.718, 0.533, 1.0 }, -- Low: Sage Green (#52B788)
    { 0.914, 0.769, 0.416, 1.0 }, -- Medium: Warm Sand (#E9C46A)
    { 0.957, 0.635, 0.380, 1.0 }, -- High: Amber Orange (#F4A261)
    { 0.906, 0.435, 0.318, 1.0 }, -- Extreme: Burnt Coral (#E76F51)
    { 0.839, 0.157, 0.157, 1.0 }, -- Critical: Crimson Red (#D62828)
}
stat_max = #severity_colors
temperature_colors= {
    {0.0, 0.2, 1.0}, -- 1. Blue
    {0.0, 0.7, 0.6}, -- 2. Teal
    {0.1, 0.8, 0.2}, -- 3. Green
    {0.6, 0.8, 0.0}, -- 4. Lime / Yellow-Green
    {0.9, 0.5, 0.0}, -- 5. Amber / Orange
    {1.0, 0.2, 0.0}, -- 6. Red-Orange
    {1.0, 0.0, 0.0}  -- 7. Bright Red
}

pieces = {
    {name="volcano1", size_max = 8, size_min = 2}, -- keep same
    {name="mountain1", size_max = 8, size_min = 2}, -- keep same
    {name="tree1", size_max = 3, size_min = 1},
    {name="tree2", size_max = 3, size_min = 1},
    {name="forest1", size_max = 4, size_min = 1},
    {name="forest2", size_max = 4, size_min = 1},
}

local function find_pieces_with_prefix(name)
    local node = {}
    for i=1, #pieces do
        if string.sub(pieces[i].name,1,string.len(name)) == name then
            node[#node+1] = pieces[i]
        end
    end
    return node
end

HELP_TEXT = 'REPORTING BUGS\n\n\nPlease report bugs at\n1. Github issues at https://github.com/Skorpion1337/thousand-oaks/issues\n2. Shoutbox at https://tinyurl.com/1000oakz\n\n\nSOMETHING ABOUT CLUTTER\n\n\nLook at folder %APPDATA%/LOVE to save some space! This folder is \nfor starting directly from code.\n \n\nAnd look at folder %APPDATA%/gamename or simply %APPDATA%/game. This folder is \nfor starting from the compiled executable.\n\n\nIn Linux look for these\n$XDG_DATA_HOME/love/ or ~/.local/share/love/\nlove may be replaced by game name or simply "game"\n\n\nIf you corrupt your settings and the game looks wonky, try deleting\nthe "options" file so it is regenerated to its default values.\n\n\nAND NOW FOR LICENSES\n\n\nAdditional licenses not mentioned in the license file in the game folder \nand folder love in the source distribution\n\n\nThis game\nby Skorpion1337\ntinyurl.com/1000oakz\nGPLv3\nhttps://www.gnu.org/licenses/gpl-3.0.html\n\n\n----Libraries----\n\n\nlume\nA collection of functions for Lua, geared towards game development.\nUsing it for serializing data before compression.\nhttps://github.com/rxi/lume\nMIT \n--\n-- lume\n--\n-- Copyright (c) 2020 rxi\n--\n-- Permission is hereby granted, free of charge, to any person obtaining a copy of\n-- this software and associated documentation files (the "Software"), to deal in\n-- the Software without restriction, including without limitation the rights to\n-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies\n-- of the Software, and to permit persons to whom the Software is furnished to do\n-- so, subject to the following conditions:\n--\n-- The above copyright notice and this permission notice shall be included in all\n-- copies or substantial portions of the Software.\n--\n-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n-- SOFTWARE.\n--\n\n\n----Graphics----\n\n\nBackground love potion - graphics/potion.jpg\nhttps://en.wikipedia.org/wiki/File:Filtre_d%27Amour.jpg\nFrom user https://commons.wikimedia.org/wiki/User:Arnaud_25 - Arnaud_25\nCreative Commons Attribution-Share Alike 4.0 International\nhttps://creativecommons.org/licenses/by-sa/4.0/deed.en\n\n\nFrozen Lake winter terrain and water tiles - eg. graphics/terrain/1\nSome of them have been touched to fit different temperature states\nhttps://opengameart.org/content/frozen-lake-lpc\nFrom user https://opengameart.org/users/zapaper - Peter\nCredits to http://www.buko-studios.com/ Commissioned by PlayCraft: www.playcraftapp.com\nCC-BY 3.0\nhttps://creativecommons.org/licenses/by/3.0/deed.en\n\n\n16x16 Overworld Tiles used to create volcano - graphics/terrain/volcano.png\nAnd also mountain - terrain/mountain.png\nAnd also forest tiles - eg. graphics/terrain/1\nhttps://opengameart.org/content/16x16-overworld-tiles\nFrom user https://opengameart.org/users/sharm - Lanea Zimmerman\nCC-BY 4.0\nhttps://creativecommons.org/licenses/by/4.0/deed.en\n\n\nWhispers of Avalon: Desert Tileset  - eg. graphics/terrain/6\nAlso touched to create more desert tiles\nhttps://opengameart.org/content/whispers-of-avalon-desert-tileset\nFrom user https://opengameart.org/users/leonard-pabin - Leonard pabin, Ali-G\nCC-BY 3.0\nhttps://creativecommons.org/licenses/by/3.0/deed.en\n\n\nWhispers of Avalon: Grassland Tileset - graphics/terrain/5/ground1.png\nhttps://opengameart.org/content/whispers-of-avalon-grassland-tileset\nFrom user https://opengameart.org/users/leonard-pabin - Leonard pabin\nCC-BY 3.0\nhttps://creativecommons.org/licenses/by/3.0/deed.en\n\n\n17 Grass Tiles - graphics/terrain/ various\nhttps://opengameart.org/content/17-grass-tiles\nFrom user https://opengameart.org/users/hawkadium - Hawkadium\nCC-BY 3.0\nhttps://creativecommons.org/licenses/by/3.0/deed.en\n\n\n32x32 (and 16x16) RPG Tiles--Forest and some Interior Tiles - graphics/ various forests\nhttps://opengameart.org/content/32x32-and-16x16-rpg-tiles-forest-and-some-interior-tiles\nStephen Challener and the Open Surge team ( http://opensnc.sourceforge.net),\nhosted by OpenGameArt.org\nhttps://opengameart.org/users/redshrike\nCC-BY 3.0\nhttps://creativecommons.org/licenses/by/3.0/deed.en'

check1 = ""
check2 = ""
check3 = ""
check4 = ""
Save.PlanetsGenerated = false
Save.Loaded = false
Save.MapGenerated = false

local love = require("love")
local lume = require("lib.lume")
local utf8 = require("utf8")

local gfx = love.graphics

local randomgen = love.math.newRandomGenerator()
randomgen:setSeed(os.time())
math.randomseed(os.time())

local function savefile(save_number)
    local compressed = love.data.compress("string", COMPRESSION, lume.serialize(Save), 5)

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

local function change_page(n, ignore_old_leaf)
    if ignore_old_leaf == nil then
        State.old_leaf = State.leaf
    else
        State.dialog_leaf = State.leaf
        DialogEntry.text = ""
    end
    State.leaf = n
    State.hoover = 0
    find_hoovered_button(Currentx, Currenty)
end

local function save_n(n)
    savefile(n)
    Buttons[3][n].text = DialogEntry.text
    Buttons[4][n].text = DialogEntry.text
    local names = {}
    for i = 1, SAVEFILEAMOUNT do
        names[i] = Buttons[3][i].text
    end
    love.filesystem.write(SAVENAMEFILE, lume.serialize(names))
    debugbox("Saved slot "..n.."!")
end

local function set_screen_dimension()
    local x, y = love.window.getDesktopDimensions()
    ScreenWidth, ScreenHeight = x*DEFSCREENSPACE/100, x/SCREENRATIO*DEFSCREENSPACE/100

    if ScreenHeight > y*DEFSCREENSPACE/100 then
        ScreenWidth, ScreenHeight = y*SCREENRATIO*DEFSCREENSPACE/100, y*DEFSCREENSPACE/100
    end
end

local function show_dialog(type, params)
    State.dialog_type = type
    State.dialog_param = params
    if type == "save" then
        DialogPrompt.text = "Give the save name, please."
    elseif type == "change_window_scale" then
        DialogPrompt.text = "Give the window scale percentage from the screen ["..MINIMUM_SCREEN_SCALE.."-100], please."
    elseif type == "change_window_x" then
        local x, _ = love.window.getDesktopDimensions()
        local max = x-ScreenWidth
        DialogPrompt.text = "Give the window X position on the screen [0-"..max.."], please."
    elseif type == "change_window_y" then
        local _, y = love.window.getDesktopDimensions()
        local max = y-ScreenHeight
        DialogPrompt.text = "Give the window Y position on the screen [0-"..max.."], please."
    end
    change_page(7, true)
end

local function process_dialog()
    if State.dialog_type == "save" then
        save_n(State.dialog_param.number)
    elseif State.dialog_type == "change_window_scale" then
        local number = tonumber(DialogEntry.text)
        if type(number) == "number" then
            if number < MINIMUM_SCREEN_SCALE then
                number = MINIMUM_SCREEN_SCALE
            elseif number > 100 then
                number = 100
            end
            DEFSCREENSPACE = number

            set_screen_dimension()
            local x, y = love.window.getDesktopDimensions()
            if x-ScreenWidth < ScreenX then
                ScreenX = x-ScreenWidth
            end
            if y-ScreenHeight < ScreenY then
                ScreenY = y-ScreenHeight
            end
            refresh_options_window()
        end
    elseif State.dialog_type == "change_window_x" then
        local number = tonumber(DialogEntry.text)
        if type(number) == "number" then
            local x, _ = love.window.getDesktopDimensions()
            if number < 0 then
                number = 0
            elseif number > x-ScreenWidth then
                number = x-ScreenWidth
            end
            ScreenX = number
            refresh_options_window()
        end
    elseif State.dialog_type == "change_window_y" then
        local number = tonumber(DialogEntry.text)
        if type(number) == "number" then
            local _, y = love.window.getDesktopDimensions()
            if number < 0 then
                number = 0
            elseif number > y-ScreenHeight then
                number = y-ScreenHeight
            end
            ScreenY = number
            refresh_options_window()
        end
    end
end

local function end_dialog()
    State.dialog_type = ""
    State.dialog_param = {}
    change_page(State.dialog_leaf, true)
end

local function dialog_accept()
    process_dialog()
    end_dialog()
end

local function dialog_cancel()
    end_dialog()
end

local function save_game()
    change_page(3)
end

local function save_file(i)
    if Save.PlanetsGenerated == true then
        local pressedbutton = love.window.showMessageBox("Want to save slot "..i.."?", "Old data will be lost.", {"OK", "No!", enterbutton = 2}, "warning", true)
        if pressedbutton == 1 then
            show_dialog("save", {number=i})
        end
    end
end

-- Encapsulate data and functions inside a single table
local StarGen = {
    prefixes = {"Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", "Nova", "Sol", "Kepler", "Orion", "Vega", "Rigel", "Sirius", "Polaris"},
    roots = {"Prime", "Centauri", "Majoris", "Minor", "Draconis", "Cygni", "Eridani", "Persei", "Tauri", "System"},
    numerals = {"I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"},
    consonants = {"b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "r", "s", "t", "v", "w", "x", "z"},
    vowels = {"a", "e", "i", "o", "u", "ae", "oo", "ou"}
}

-- Helper function stored in the namespace
function StarGen.randomChoice(t)
    return t[math.random(#t)]
end

-- Generates a pronounceable alien-sounding word
function StarGen.generateAlienName()
    local name = ""
    local syllableCount = math.random(2, 3)
    for i = 1, syllableCount do
        local part = StarGen.randomChoice(StarGen.consonants):upper() .. StarGen.randomChoice(StarGen.vowels)
        if math.random() > 0.4 then
            part = part .. StarGen.randomChoice(StarGen.consonants)
        end
        name = name .. part
    end
    return name
end

-- Main function to generate a star system name
function StarGen.generateSystemName()
    local style = math.random(1, 3)

    if style == 1 then
        return StarGen.randomChoice(StarGen.prefixes) .. " " .. StarGen.randomChoice(StarGen.roots) .. " " .. StarGen.randomChoice(StarGen.numerals)
    elseif style == 2 then
        local letters = StarGen.randomChoice(StarGen.consonants):upper() .. StarGen.randomChoice(StarGen.consonants):upper()
        local numbers = math.random(100, 999)
        return "Sector " .. letters .. "-" .. numbers
    else
        return StarGen.generateAlienName() .. "-" .. math.random(1, 99)
    end
end

-- Encapsulate planet data and generator functions inside a single table
local PlanetGen = {
    catalogs = {"Kepler", "HD", "GJ", "TRAPPIST", "HIP", "WASP"},
    prefixes = {"Terra", "Aethel", "Xylos", "Valen", "Orion", "Chronos", "Ares", "Helios"},
    adjectives = {"New", "Greater", "Outer", "Inner", "Prime", "Deep"},
    romanNumerals = {"I", "II", "III", "IV", "V", "VI", "VII"},
    exoplanetSuffixes = {"b", "c", "d", "e", "f"},
    consonants = {"b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "r", "s", "t", "v", "w", "x", "z"},
    vowels = {"a", "e", "i", "o", "u", "ae", "oo", "ou"}
}

-- Helper function stored in the namespace
function PlanetGen.randomChoice(t)
    return t[math.random(#t)]
end

-- Generates a pronounceable alien-sounding base word
function PlanetGen.generateAlienWord()
    local name = ""
    local syllableCount = math.random(2, 3)
    for i = 1, syllableCount do
        local part = PlanetGen.randomChoice(PlanetGen.consonants):upper() .. PlanetGen.randomChoice(PlanetGen.vowels)
        if math.random() > 0.4 then
            part = part .. PlanetGen.randomChoice(PlanetGen.consonants)
        end
        name = name .. part
    end
    return name
end

-- Main function to generate a planet name
function PlanetGen.generateName()
    local style = math.random(1, 3)

    if style == 1 then
        -- Style 1: Scientific / Exoplanet Designation (e.g., Kepler-452b)
        local catalog = PlanetGen.randomChoice(PlanetGen.catalogs)
        local number = math.random(10, 999)
        local suffix = PlanetGen.randomChoice(PlanetGen.exoplanetSuffixes)
        return catalog .. "-" .. number .. suffix
    elseif style == 2 then
        -- Style 2: Colonized / Descriptive Name (e.g., New Terra IV or Aethel Prime)
        if math.random() > 0.5 then
            return PlanetGen.randomChoice(PlanetGen.adjectives) .. " " .. PlanetGen.randomChoice(PlanetGen.prefixes) .. " " .. PlanetGen.randomChoice(PlanetGen.romanNumerals)
        else
            return PlanetGen.randomChoice(PlanetGen.prefixes) .. " Prime"
        end
    else
        -- Style 3: Procedural Alien Planet (e.g., Xylos-III)
        return PlanetGen.generateAlienWord() .. "-" .. PlanetGen.randomChoice(PlanetGen.romanNumerals)
    end
end

local function generate_planets()
    Save.planets = {}
    for i=1,PLANET_AMOUNT do
        local planet = {}
        for j=1,#planet_properties do
            planet[j] = {}
            planet[j].name = planet_properties[j].name
            if planet_properties[j].name == "Solar System" then
                planet[j].level_name = StarGen.generateSystemName()
            elseif planet_properties[j].name == "Planet" then
                planet[j].level_name = PlanetGen.generateName()
            elseif planet_properties[j].name == "" then
                planet[j].level_name = ""
            else
                local severity_level = math.random(#planet_properties[j].levels)
                planet[j].level_name=planet_properties[j].levels[severity_level]
                planet[j].level = severity_level
            end
        end
        planet.x = math.random()
        planet.y = math.random()
        Save.planets[i] = planet
    end
    Save.PlanetChoice = 1
    Save.PlanetsGenerated = true
end

local function newgame()
    local pressedbutton = love.window.showMessageBox("Remember to save map first", "Generating a new game formats the current one in memory. Want to continue?", {"OK", "No!", enterbutton = 2}, "warning", true)
    if pressedbutton == 1 then
        change_page(2)
    end

end

local function loadgame()
    change_page(4)
end

local function continuegame()
    if Save.Loaded == true then
        change_page(6)
    end
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

local function load_help_text(prefix)
    local lines = explode(HELP_TEXT, "\n")
    local fits = (Buttons[State.leaf][3].y-(Buttons[State.leaf][2].y+Buttons[State.leaf][2].height+State.helppadding))/SmallFont:getHeight()
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

local function quitgame()
    quitmessage()
end

local function load_n(n)
    if love.filesystem.getInfo(SAVEFILE..n) == nil then
        debugbox("Unloaded Save File")
    else
        local pressedbutton = love.window.showMessageBox("Lose all data when loading", "Loading a game formats the current memory. Want to continue?", {"OK", "No!", enterbutton = 2}, "warning", true)
        if pressedbutton == 1 then
            load_file(n)
            if Save.map ~= nil then
                Save.MapGenerated = true
                Save.Loaded = true
                continuegame()
            else
                change_page(2)
            end
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

local function split(str, sep)
    sep = sep or "%s"
    local t = {}
    for s in string.gmatch(str, "([^" .. sep .. "]+)") do
        t[#t + 1] = s
    end
    return t
end

local function reset_options()
    DEFSCREENSPACE = 88
    set_screen_dimension()
    local x, y = love.window.getDesktopDimensions()
    ScreenX = (x-ScreenWidth)/2
    ScreenY = (y-ScreenHeight)/2
end

local function save_options()
    love.filesystem.write(OPTIONSFILE, tostring(DEFSCREENSPACE)..DELIMITER..tostring(ScreenX)..DELIMITER..tostring(ScreenY))
end

local function load_option_values()
    local contents, _ = love.filesystem.read(OPTIONSFILE)
    contents = split(contents, DELIMITER)
    DEFSCREENSPACE = tonumber(contents[1])
    set_screen_dimension()
    ScreenX = tonumber(contents[2])
    ScreenY = tonumber(contents[3])
end

local function set_options()
    set_screen_dimension()
    refresh_state()
end

local function load_options()
    if love.filesystem.getInfo(OPTIONSFILE) == nil then
        reset_options()
        save_options()
    else
        load_option_values()
    end
    set_options()
end

local function open_options_page()
    local words = split(WindowScaleButton.text, " ")
    words[4] = tostring(DEFSCREENSPACE)
    WindowScaleButton.text = table.concat(words," ")

    words = split(WindowXButton.text, " ")
    words[4] = tostring(ScreenX)
    WindowXButton.text = table.concat(words," ")

    words = split(WindowYButton.text, " ")
    words[4] = tostring(ScreenY)
    WindowYButton.text = table.concat(words," ")

    change_page(8)
end

local function menu_cancel_options()
    load_options()
    backtomain()
end

local function menu_save_options()
    save_options()
    backtomain()
end

refresh_options_window = function()
    set_options()
    open_options_page()
end

local function menu_reset_options()
    reset_options()
    refresh_options_window()
end

local function optionwindow()
    open_options_page()
end

local function menu_change_window_scale()
    show_dialog("change_window_scale")
end

local function menu_change_window_x()
    show_dialog("change_window_x")
end

local function menu_change_window_y()
    show_dialog("change_window_y")

end

local function calculate_property_ratio(name, planet)
    planet = planet or Save.PlanetChoice

   return (property_level(name, planet)-1)/(stat_max-1)
end

local function tiles_with_prefix(prefix)
    tiles = {}
    for i = 1, #Tiles do
        if string.sub(Tiles[i].name,1,string.len(prefix)) == prefix then
            tiles[#tiles+1] = i
        end
    end
    return tiles
end

function random_float(min, max)
    return min + math.random() * (max - min)
end

local function make_noise(size)
    factor = 3
    if factor == nil then
        factor = 1
    end
    size = size/factor

    local weights = {}
    local total_weight = 0

    for i = 1, size do
        -- 1. Lower frequencies (0.01 and 0.04) stretch the mountains out wider
        local major_range = math.abs(math.cos(i * 0.01))
        local jagged_peaks = math.abs(math.sin(i * 0.04))

        local raw_height = (major_range * 0.7) + (jagged_peaks * 0.3)

        -- 2. Widen the valleys by subtracting a threshold (e.g., 0.4)
        -- Everything below 0.4 becomes a flat, zero-weight valley floor
        local valley_threshold = 0.4
        local widened_height = math.max(0, raw_height - valley_threshold)

        -- 3. Power scaling keeps the remaining peaks sharp
        local weight = widened_height ^ 3

        weights[i] = weight
        total_weight = total_weight + weight
    end

    local random_target = math.random() * total_weight
    local running_total = 0

    -- 5. Walk through the weights to find which index `i` wins
    for i = 1, size do
        running_total = running_total + weights[i]

        -- The moment the running total passes our random roll, `i` is our chosen index!
        if random_target <= running_total then
            free = i -- Here is where index `i` gives you your xy_pair
            break
        end
    end
    return free*factor
end

local function generate_lake(start_x, start_y, width,height,limit,visited,tile_n,draw_tiles)
    local cx = start_x + width / 2
    local cy = start_y + height / 2
    local rx = width / 2
    local ry = height / 2

    for x = start_x, start_x + width - 1 do
        for y = start_y, start_y + height - 1 do
            local through = false
            if not (x > 0 and y > 0 and x < MAP_SIZE+1 and y < MAP_SIZE+1) then
                through = true
            elseif not visited[x][y] then
                through = true
            end
            if through then
                -- Normalized distance from center (-1 to 1 range roughly)
                local dx = (x - cx) / rx
                local dy = (y - cy) / ry

                -- Add minor sine/cosine variation for an organic, wavy shoreline
                local noise = math.sin(x * 0.7) * math.cos(y * 0.7) * 0.15
                local distance = (dx * dx) + (dy * dy) + noise

                if distance <= 1.0 then
                    if x > 0 and y > 0 and x < MAP_SIZE+1 and y < MAP_SIZE+1 then
                        Save.map[x][y] = draw_tiles[math.random(#draw_tiles)]
                        visited[x][y] = true
                        limit = limit + 1
                        if limit >= tile_n then
                            return nil, nil, true
                        end
                    end
                end
            end
        end
    end
    return limit, visited, false
end

local function generate_map()
    Save.gamename = get_planet_name()

    Save.mapx = MAP_SIZE/2
    Save.mapy = MAP_SIZE/2

    local ground_tiles = tiles_with_prefix("ground")
    Save.map={}
    for x=1, MAP_SIZE do
        Save.map[x] = {}
        for y=1, MAP_SIZE do
            Save.map[x][y] = ground_tiles[math.random(#ground_tiles)]
        end
    end

    local water_ratio = calculate_property_ratio("Water")*MAX_WATER
    local water_tile_n = water_ratio * MAP_SIZE * MAP_SIZE
    if water_tile_n > 0 then
        local visited = {}
        for i = 1, MAP_SIZE do
            visited[i] = {}
        end
        local tiles = 0
        local breakout_limit = false
        local draw_tiles = tiles_with_prefix("water")
        repeat
            local width = math.floor(MAP_SIZE*random_float(MIN_LAKE_SIZE, MAX_LAKE_SIZE))
            local height = math.floor(MAP_SIZE*random_float(MIN_LAKE_SIZE, MAX_LAKE_SIZE))
            tiles, visited, breakout_limit = generate_lake(
                    math.random(-width,MAP_SIZE+width),
                    math.random(-height,MAP_SIZE+height),
                    width,
                    height,
                    tiles,
                    visited,
                    water_tile_n,
                    draw_tiles)
        until breakout_limit
    end

    local free_lookup = {}
    local free_area = {}
    local free_tiles = 0
    for x = 1, MAP_SIZE do
        free_area[x] = {}
        for y = 1, MAP_SIZE do
            if has_value(ground_tiles, Save.map[x][y]) then
                free_area[x][y] = true
                free_lookup[#free_lookup+1] = {x=x,y=y}
                free_tiles = free_tiles + 1
            else
                free_area[x][y] = false
            end
        end
    end

    local mountain_ratio = calculate_property_ratio("Volcanism")*MAX_VOLCANO
    local volcano1 = find_pieces_with_prefix("volcano")[1]
    local amount_of_mountains = mountain_ratio*free_tiles/( (volcano1.size_min+volcano1.size_max)/2 )

    Save.structure_locations = {}
    for x = 1, MAP_SIZE do
        Save.structure_locations[x] = {}
    end

    Save.structures = {}
    local mountain_tile = tiles_with_prefix("mountain")[1]
    local volcano_tile = tiles_with_prefix("volcano")[1]
    if amount_of_mountains > 0 then
        for i = 1, amount_of_mountains do
            local mountain = {}
            local free
            repeat
                free = free_lookup[make_noise(#free_lookup)]

                --free = free_lookup[math.random(#free_lookup)]
                mountain.size = math.random(volcano1.size_min,volcano1.size_max)
                fits = true
                for x=free.x, math.min(MAP_SIZE,free.x+mountain.size-1) do
                    for y=free.y, math.min(MAP_SIZE,free.y+mountain.size-1) do
                        if free_area[x][y] == false then
                            fits = false
                        end
                    end
                end
            until fits
            if fits then
                local each = 1/VOLCANISM
                local mountainfull = math.random(each)
                if mountainfull == 1 then
                    mountain.tile = volcano_tile
                else
                    mountain.tile = mountain_tile
                end
                mountain.x = free.x
                mountain.y = free.y
                Save.structure_locations[free.x][free.y] = #Save.structures+1
                Save.structures[#Save.structures+1] = mountain

                for x=free.x, math.min(MAP_SIZE,free.x+mountain.size) do
                    for y=free.y, math.min(MAP_SIZE,free.y+mountain.size) do
                        free_area[x][y] = false
                        free_tiles = free_tiles - 1
                    end
                end
            end
        end
    end
    local free_lookup = {}
    for x = 1, MAP_SIZE do
        for y = 1, MAP_SIZE do
            if has_value(ground_tiles, Save.map[x][y]) and free_area[x][y] == true then
                free_lookup[#free_lookup+1] = {x=x,y=y}
            end
        end
    end
end

local function start_game()
    if Save.PlanetsGenerated == true then
        generate_map()
        Save.MapGenerated = true
        Save.Loaded = true
        continuegame()
    end
end

local function calculate_planet_pos(i, x, y, scale)
    posx = (Buttons[2][1].width/scale+Save.planets[i].x*(ScreenWidth/scale-Buttons[2][1].width/scale-x))/ScreenWidth
    posy = (Save.planets[i].y*(ScreenHeight/scale-y))/ScreenHeight
    return posx, posy
end

refresh_state = function()
    love.window.setMode(ScreenWidth, ScreenHeight, {resizable = false, borderless = true, y=ScreenY, x=ScreenX})

    love.window.setTitle(Save.gamename)
    love.window.setVSync(2)
    love.keyboard.setKeyRepeat(true)
    love.window.setIcon(love.image.newImageData("graphics/large_purple.png"))

    Canvas = gfx.newCanvas(ScreenWidth, ScreenHeight)

    local fontsize, _ = translatexy(MINIFONT, 0)
    MiniFont = gfx.newFont(fontsize)
    fontsize, _ = translatexy(SMALLFONT,0)
    SmallFont = gfx.newFont(fontsize)
    fontsize, _ = translatexy(BIGFONT, 0)
    BigFont = gfx.newFont(fontsize)


    local newgamebuttonw, newgamebuttonh = translatexy(0.25, 0.07)
    local newbuttonstartw, newbuttonstarth = translatexy(0.5, 0.3)
    local wt, newgamebuttonpadding = translatexy(0.5, 0.02)

    Buttons = {{}}
    Labels = {{}}
    Buttons[1] = {{size=1, text="Continue", x = ScreenWidth/2.0-newgamebuttonw/2.0, y = newbuttonstarth, width = newgamebuttonw, height=newgamebuttonh, call = continuegame}, {size=1, text="New Game", x = ScreenWidth/2.0-newgamebuttonw/2.0, y = newbuttonstarth+newgamebuttonh+newgamebuttonpadding, width = newgamebuttonw, height=newgamebuttonh, call = newgame},{size=1, text="Save Game", x = ScreenWidth/2.0-newgamebuttonw/2.0, y =  newbuttonstarth+2*newgamebuttonh+2*newgamebuttonpadding, width = newgamebuttonw, height=newgamebuttonh, call = save_game}, {size=1, text="Load Game", x = ScreenWidth/2.0-newgamebuttonw/2.0, y = newbuttonstarth+3*newgamebuttonh+3*newgamebuttonpadding, width = newgamebuttonw, height=newgamebuttonh, call = loadgame}, {size=1, text="Options", x = ScreenWidth/2.0-newgamebuttonw/2.0, y = newbuttonstarth+4*newgamebuttonh+4*newgamebuttonpadding, width = newgamebuttonw, height=newgamebuttonh, call = optionwindow}, {size=1, text="Help", x = ScreenWidth/2.0-newgamebuttonw/2.0, y = newbuttonstarth+5*newgamebuttonh+5*newgamebuttonpadding, width = newgamebuttonw, height=newgamebuttonh, call = helpwindow}, {size=1, text="Quit", x = ScreenWidth/2.0-newgamebuttonw/2.0, y = newbuttonstarth+6*newgamebuttonh+6*newgamebuttonpadding, width = newgamebuttonw, height=newgamebuttonh, call = quitgame}}
    Labels[1] ={}

    local newbuttonwidth, newbuttonheight = translatexy(0.23,0.05)
    local paddingx, paddingy = translatexy(0.01,0.01)
    local startpaddingx, startpaddingy = translatexy(0.1,0.1)
    Buttons[2] = {
        {size=1, text="Generate Star Map", x = 0, y = startpaddingy, width = newbuttonwidth, height=newbuttonheight, call = generate_planets},
        {size=1, text="Start Mining on Planet", x = 0, y = 1*newbuttonheight+1*paddingy+startpaddingy, width = newbuttonwidth, height=newbuttonheight, call = start_game},
        {size=1, text="Back to Main", x = 0, y = 2*newbuttonheight+2*paddingy+startpaddingy, width = newbuttonwidth, height=newbuttonheight, call = backtomain},
    }
    Labels[2] ={}
    State.star_of_dawn_scale = ScreenWidth/State.star_of_dawn:getWidth()*0.05

    Buttons[3] = {{}}
    local buttonwidth, buttonheight = translatexy(0.33, 0.05)
    local continuebuttonx, continuebuttony = translatexy(0.115, 0.035)
    local buttonpadding, __ = translatexy(0.01, 0)
    for i = 1, SAVEFILEAMOUNT do
        Buttons[3][i] = {size=1, text="Empty MAP File "..i, x = continuebuttonx, y = continuebuttony+buttonheight*i+buttonpadding*i, width = buttonwidth, height=buttonheight, call = save_file}
    end
    local amount = SAVEFILEAMOUNT+1
    Buttons[3][amount] = {size=1, text="Back to Main", x = continuebuttonx, y = continuebuttony+buttonheight*amount+buttonpadding*amount, width = buttonwidth, height=buttonheight, call = backtomain}
    Labels[3] ={}

    Buttons[4] = {{}}
    for i = 1, SAVEFILEAMOUNT do
        Buttons[4][i] = {size=1, text="Empty MAP File "..i, x = continuebuttonx, y = continuebuttony+buttonheight*i+buttonpadding*i, width = buttonwidth, height=buttonheight, call = load_n}
    end
    amount = SAVEFILEAMOUNT+1
    Buttons[4][amount] = {size=1, text="Back to Main", x = continuebuttonx, y = continuebuttony+buttonheight*amount+buttonpadding*amount, width = buttonwidth, height=buttonheight, call = backtomain}
    Labels[4] ={}

    local helpbuttonw, helpbuttonh = translatexy(0.3, 0.07)
    local helpbuttonstartx, helpbuttonstarty = translatexy(0, 0.1)
    local centeredx = ScreenWidth/2.0-helpbuttonw/2.0
    Buttons[5] = {{size=1, text="Back to Main", x = centeredx, y = helpbuttonstarty, width = helpbuttonw, height=helpbuttonh, call = backtomain}, {size=1, text="Scroll Up", x = centeredx, y = helpbuttonstarty+helpbuttonh, width = helpbuttonw, height=helpbuttonh, call = scrollhelpup}, {size=1, text="Scroll Down", x = centeredx, y = helpbuttonstarty+10*helpbuttonh, width = helpbuttonw, height=helpbuttonh, call = scrollhelpdown}}
    Labels[5] ={}

    local gamebuttonw, gamebuttonh = translatexy(0.115, 0.03)
    local wpadding, hpadding = translatexy(0,0.15)
    Buttons[6] = {{size=2, text="Alchemy", x = 0, y = 0*gamebuttonh+hpadding, width = gamebuttonw, height=gamebuttonh, call = newalchemy}, {size=2, text="Back to Main", x = 0, y = 1*gamebuttonh+hpadding, width = gamebuttonw, height=gamebuttonh, call = backtomain}}
    Labels[6] ={}

    State.dialog_width, State.dialog_height = translatexy(0.5, 0.4)
    local button_width, button_height = translatexy(0.115, 0.03)
    local padding, _ = translatexy(0.013, 0)
    Buttons[7] = {{size=2, text="OK", x = ScreenWidth/2+State.dialog_width/2-button_width, y = ScreenHeight/2+State.dialog_height/2-button_height, width = button_width, height=button_height, call = dialog_accept}, {size=2, text="CANCEL", x = ScreenWidth/2+State.dialog_width/2-button_width*2-padding, y = ScreenHeight/2+State.dialog_height/2-button_height, width = button_width, height=button_height, call = dialog_cancel},}
    Labels[7] ={{size=2, text="null dialog", color={0.5,0.25,0}, x = ScreenWidth/2-State.dialog_width/2+padding, y = ScreenHeight/2-State.dialog_height/2+padding}, {size=2, text="", color={0.5,0,0}, x = ScreenWidth/2-State.dialog_width/2+3*padding, y = ScreenHeight/2-padding}}

    DialogEntry = Labels[7][2]
    DialogPrompt = Labels[7][1]

    local button_width, button_height = translatexy(0.2, 0.1)
    local padding, _ = translatexy(0.077, 0)
    Buttons[8] = {{size=1, text="Cancel", x = padding, y = ScreenHeight-button_height*1.5, width = button_width, height = button_height, call=menu_cancel_options}, {size=1, text="Save", x = padding+1.1*button_width, y = ScreenHeight-button_height*1.5, width = button_width, height = button_height, call=menu_save_options}, {size=1, text="Reset", x = padding+2*1.1*button_width, y = ScreenHeight-button_height*1.5, width = button_width, height = button_height, call=menu_reset_options}, {size=2, text="Window Scale Percentage: 50", x = padding, y = button_height*5, width = button_width*1.1, height = button_height/2, call=menu_change_window_scale}, {size=2, text="Window X Position: 50", x = padding, y = button_height*6.2, width = button_width*1.1, height = button_height/2, call=menu_change_window_x}, {size=2, text="Window Y Position: 50", x = padding, y = button_height*7.4, width = button_width*1.1, height = button_height/2, call=menu_change_window_y}}
    Labels[8] = {}

    WindowScaleButton = Buttons[8][4]
    WindowXButton = Buttons[8][5]
    WindowYButton = Buttons[8][6]

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

local function separate_spaces(s)
    local chunks = {}
    for substring in s:gmatch("%S+") do
        table.insert(chunks, substring)
    end
    return chunks
end

function love.textinput(key)
    if State.leaf == 7 then
        DialogEntry.text = DialogEntry.text..key
    end
end

function love.keypressed(key)
    if State.leaf == 7 then
        if key == "backspace" then
            local byteoffset = utf8.offset(DialogEntry.text, -1)

            if byteoffset then
                DialogEntry.text = string.sub(DialogEntry.text, 1, byteoffset - 1)
            end
        end
    end
end

function love.keyreleased(key, scancode, isrepeat)
    if key == "escape" then
        if State.leaf == 1 then
            quitmessage()
        else
            backtomain()
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

function love.mousemoved(x, y, dx, dy, istouch )
    find_hoovered_button(x, y)
    Currentx, Currenty = x,y
end

function love.load()
    Save.planets = {}

    State = { leaf = 1, old_leaf = 1, dialog_type = nil, dialog_param=nil, hoover = 0, logo = gfx.newImage("graphics/logo.png"), logo2 = gfx.newImage("graphics/logo2.png"), button_bg = nil, button_bg_quad = nil, button_bg_hover = nil, bg_tile = gfx.newImage("graphics/bg_tile.png"), banner = gfx.newImage("graphics/banner.png"), bannerx = gfx.newImage("graphics/red.png"), bannerm = gfx.newImage("graphics/yellow.png"), red_crystal = gfx.newImage("graphics/crystal.png"), helpbg = gfx.newImage("graphics/forest.png"), helppadding = 0, savedhelpprefix=0, xprefix=0, yprefix=0, walkingwait = WALKSPEED, lovepotion=gfx.newImage("graphics/potion.jpg"), sulphur_mining = gfx.newImage("graphics/sulphur_mining_PD.jpg"), horsehead_nebula = gfx.newImage("graphics/horsehead_PD.jpg"), new_machine = gfx.newImage("graphics/new_machine.png"), star_of_dawn = gfx.newImage("graphics/star_of_dawn.png"), star_of_dawn_scale = 0, aim = gfx.newImage("graphics/aim.png"), mainmenubgs = {}, mainmenubgslocation = {}, mainmenubgsamount= 10, mainmenurepeat = 10, dialog_width = 0, dialog_height = 0}
    Timers = {map=MAPSPEEDSEC}

    local gradientData = love.image.newImageData(2, 1, 'rgba8', '\200\200\200' .. '\255' .. '\050\050\050' .. '\255')
    State.button_bg = gfx.newImage(gradientData)
    State.button_bg:setFilter('linear', 'linear')

    gradientData = love.image.newImageData(2, 1, 'rgba8', '\050\050\050' .. '\255' .. '\200\200\200' .. '\255')
    State.button_bg_hover = gfx.newImage(gradientData)
    State.button_bg_hover:setFilter('linear', 'linear')

    State.button_bg_quad = gfx.newQuad(0.5, 0, 1, 1, 2, 1)

    Tiles = {}
    Tiles[#Tiles+1]={i = #Tiles+1, name="ground1", obstacle = false}
    for i = 1, stat_max do
        Tiles[#Tiles][i] = gfx.newImage("graphics/terrain/"..i.."/ground1.png")
    end
    Tiles[#Tiles+1]={i = #Tiles+1, name="ground2", obstacle = false}
    for i = 1, stat_max do
        Tiles[#Tiles][i] = gfx.newImage("graphics/terrain/"..i.."/ground2.png")
    end
    Tiles[#Tiles+1]={i = #Tiles+1, name="water1", obstacle = false}
    for i = 1, stat_max do
        Tiles[#Tiles][i] = gfx.newImage("graphics/terrain/"..i.."/water1.png")
    end
    Tiles[#Tiles+1]={i = #Tiles+1, name="water2", obstacle = false}
    for i = 1, stat_max do
        Tiles[#Tiles][i] = gfx.newImage("graphics/terrain/"..i.."/water2.png")
    end
    Tiles[#Tiles+1]={i = #Tiles+1, name="forest1", obstacle = true}
    for i = 1, stat_max do
        Tiles[#Tiles][i] = gfx.newImage("graphics/terrain/"..i.."/forest1.png")
    end
    Tiles[#Tiles+1]={i = #Tiles+1, name="forest2", obstacle = true}
    for i = 1, stat_max do
        Tiles[#Tiles][i] = gfx.newImage("graphics/terrain/"..i.."/forest2.png")
    end
    Tiles[#Tiles+1]={i = #Tiles+1, name="tree1", obstacle = true}
    for i = 1, stat_max do
        Tiles[#Tiles][i] = gfx.newImage("graphics/terrain/"..i.."/tree1.png")
    end
    Tiles[#Tiles+1]={i = #Tiles+1, name="tree2", obstacle = true}
    for i = 1, stat_max do
        Tiles[#Tiles][i] = gfx.newImage("graphics/terrain/"..i.."/tree2.png")
    end
    Tiles[#Tiles+1]={i = #Tiles+1, name="mountain1", obstacle = true}
    for i = 1, stat_max do
        Tiles[#Tiles][i] = gfx.newImage("graphics/terrain/mountain1.png")
    end
    Tiles[#Tiles+1]={i = #Tiles+1, name="volcano1", obstacle = true}
    for i = 1, stat_max do
        Tiles[#Tiles][i] = gfx.newImage("graphics/terrain/volcano1.png")
    end

    Hooveredx, Hooveredy = 0, 0

    load_options()
    --Random
    State.helppadding = ScreenWidth*0.2*0.1
end

function love.mousepressed(x, y, button, istouch, presses)
    if State.leaf == 2 then
        for i=#Save.planets, 1, -1 do
            xpos, ypos = calculate_planet_pos(i, State.star_of_dawn:getWidth(), State.star_of_dawn:getHeight(), State.star_of_dawn_scale)
            xpos, ypos = xpos*State.star_of_dawn_scale, ypos*State.star_of_dawn_scale
            if x > xpos*ScreenWidth and x < xpos*ScreenWidth+State.star_of_dawn_scale*State.star_of_dawn:getWidth() and y > ypos*ScreenHeight and y < ypos*ScreenHeight+State.star_of_dawn_scale*State.star_of_dawn:getHeight() then
                Save.PlanetChoice = i
                break
            end
        end
    end
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
    if State.leaf == 6 then
        Timers.map = Timers.map - dt
        if Timers.map < 0 then
            Timers.map = MAPSPEEDSEC
            if love.keyboard.isDown('w') then
                Save.mapy = math.max(1,Save.mapy-1)
            end
            if love.keyboard.isDown('s') then
                Save.mapy = math.min(MAP_SIZE-ScreenHeight/(TILERATIO*ScreenHeight)-1,Save.mapy+1)
            end
            if love.keyboard.isDown('a') then
                Save.mapx = math.max(1,Save.mapx-1)
            end
            if love.keyboard.isDown('d') then
                Save.mapx = math.min(MAP_SIZE-ScreenWidth/(TILERATIO*ScreenWidth)-1,Save.mapx+1)
            end
        end
    end
end

function love.draw()
    gfx.setCanvas(Canvas)

    gfx.setColor(1, 1, 1, 1)
    if State.leaf == 1 then
        gfx.push()
        local scale = ScreenWidth/NORMAL_SIZE_AT_PX
        gfx.scale(scale, scale)
        for x = 0, ScreenWidth/(State.bg_tile:getWidth()*scale) do
            for y = 0, ScreenHeight/(State.bg_tile:getHeight()*scale) do
                gfx.draw(State.bg_tile, x*State.bg_tile:getWidth(), y*State.bg_tile:getHeight())
            end
        end
        gfx.pop()

        local iconsize = ScreenWidth/State.mainmenubgs[1]:getWidth()*0.033
        gfx.push()
        gfx.scale(iconsize, iconsize)
        for i=1,State.mainmenubgsamount do
            for j=1, State.mainmenurepeat do
                gfx.draw(State.mainmenubgs[i], State.mainmenubgslocation[j+(i-1)*State.mainmenurepeat][2]/iconsize, State.mainmenubgslocation[j+(i-1)*State.mainmenurepeat][3]/iconsize)
            end
        end
        gfx.pop()
        gfx.push()
        local padding, my = translatexy(0.007, 0.166)
        local scalex = ScreenWidth*0.55/State.logo:getWidth()
        gfx.scale(scalex, scalex)
        gfx.draw(State.logo, ScreenWidth/scalex/2-State.logo:getWidth()/2,my/scalex-State.logo:getHeight()/2)
        gfx.draw(State.logo2, ScreenWidth/scalex/2-State.logo2:getWidth()/2,my/scalex-State.logo2:getHeight()/2+State.logo:getHeight()+padding/scalex)
        gfx.pop()
    elseif State.leaf == 2 then
        gfx.push()
        scalex = ScreenWidth/State.horsehead_nebula:getWidth()
        scaley = ScreenHeight/State.horsehead_nebula:getHeight()
        gfx.scale(scalex, scaley)
        gfx.draw(State.horsehead_nebula, 0, 0)
        gfx.pop()
        gfx.push()
        gfx.setColor(1, 1, 1, 0.33)
        local round, _ = translatexy(0.01,0)
        gfx.rectangle("fill", 0, ScreenHeight/3, Buttons[2][1].width, ScreenHeight-ScreenHeight/3-SmallFont:getHeight("text"), round, round)
        gfx.setFont(MiniFont)
        gfx.pop()
        if #Save.planets ~= 0 then
            gfx.push()
            local planet = Save.planets[Save.PlanetChoice]
            local xstart, ypad = translatexy(0.015, 0.03)
            local ypadcollect = 0
            for i = 1, #planet do
                gfx.setColor(0.8,0,0)
                if planet[i].name ~= "" then
                    gfx.print(planet[i].name..":", xstart, ScreenHeight/3+round+ypadcollect)
                end
                if planet[i].name == "Solar System" then
                    gfx.setColor(0.8,0.6,0)
                    gfx.print(planet[i].level_name, xstart+MiniFont:getWidth(planet[i].name..": "), ScreenHeight/3+round+ypadcollect)
                elseif planet[i].name == "Planet" then
                    gfx.setColor(0.8,0.6,0)
                    gfx.print(planet[i].level_name, xstart+MiniFont:getWidth(planet[i].name..": "), ScreenHeight/3+round+ypadcollect)
                elseif planet[i].name ~= "" then
                    local shade, _ = translatexy(0.0005, 0)
                    gfx.setColor(0, 0, 0, 1)
                    local textsize = MiniFont:getWidth(planet[i].name..": ")
                    gfx.print(planet[i].level_name, xstart+textsize+shade, ScreenHeight/3+round+ypadcollect+shade)
                    gfx.setColor(severity_colors[planet[i].level])
                    gfx.print(planet[i].level_name, xstart+textsize, ScreenHeight/3+round+ypadcollect)
                end
                ypadcollect = ypadcollect + ypad
            end
            local scale = ScreenWidth/State.new_machine:getWidth()*0.2
            gfx.setColor(1, 1, 1, 1)
            gfx.scale(scale, scale)
            gfx.draw(State.new_machine, xstart/scale, (ScreenHeight/3+round*2+ypadcollect)/scale)
            gfx.pop()
            gfx.push()
            local scale = State.star_of_dawn_scale
            gfx.scale(scale,scale)
            for i=1, PLANET_AMOUNT do
                local planet = Save.planets[i]
                local x, y = calculate_planet_pos(i, State.star_of_dawn:getWidth(), State.star_of_dawn:getHeight(), scale)
                gfx.setColor(temperature_colors[property_level("Temperature",i)])
                gfx.draw(State.star_of_dawn, x*ScreenWidth, y*ScreenHeight)
            end
            gfx.pop()
            gfx.push()
            local scale = ScreenWidth/State.aim:getWidth()*0.05
            gfx.scale(scale, scale)
            gfx.setColor(1, 1, 1)
            local planet = Save.planets[Save.PlanetChoice]
            local offsetx, offsety = translatexy(0.0025,0.03)
            gfx.draw(State.aim,
                    Buttons[2][1].width/scale-offsetx/scale+planet.x*(ScreenWidth/scale-Buttons[2][1].width/scale-offsetx/scale-State.aim:getWidth()),
                    planet.y*(ScreenHeight/scale-offsety/scale-State.aim:getHeight()) )
            gfx.pop()
        end
    elseif State.leaf == 3 then
        gfx.setColor(0.1,0.45,0.1)
        gfx.rectangle("fill", 0, 0, ScreenWidth, ScreenHeight)
        gfx.setColor(1, 1, 1, 1)
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
        gfx.draw(rotatefile, ScreenWidth/rotatescale-rotatefile:getWidth(), math.max(0,ScreenHeight/2-rotatefile:getHeight()/2))
        gfx.pop()
    elseif State.leaf == 5 then
        gfx.setColor(1, 1, 1, 1)
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
        gfx.print(State.help_text, Buttons[State.leaf][2].x-beyondbuttonw+State.helppadding, Buttons[State.leaf][2].y+Buttons[State.leaf][2].height+State.helppadding/3)
    elseif State.leaf == 6 then
        gfx.push()
        local max_width = ScreenWidth/(TILERATIO*ScreenWidth)+1
        local max_height = ScreenHeight/(TILERATIO*ScreenHeight)+1
        for x=Save.mapx,Save.mapx+max_width do
            for y=Save.mapy,Save.mapy+max_height do
                gfx.push()
                local tile = Tiles[Save.map[x][y]][property_level("Temperature")]
                local scale = ScreenWidth/tile:getWidth()*TILERATIO
                gfx.scale(scale, scale)
                gfx.draw(tile, (x-Save.mapx)*ScreenWidth*TILERATIO/scale, (y-Save.mapy)*ScreenWidth*TILERATIO/scale)
                gfx.pop()
            end
        end
        local mountain_max_size = find_pieces_with_prefix("volcano")[1].size_max
        for x=math.max(1,Save.mapx-mountain_max_size),Save.mapx+max_width do
            for y=math.max(1, Save.mapy-mountain_max_size),Save.mapy+max_height do
                gfx.push()
                if Save.structure_locations[x][y] ~= nil then
                    local structure = Save.structures[Save.structure_locations[x][y]]
                    local scale = ScreenWidth/Tiles[structure.tile][1]:getWidth()*TILERATIO*structure.size
                    gfx.scale(scale, scale)
                    gfx.draw(Tiles[structure.tile][1],
                            (x-Save.mapx)*ScreenWidth*TILERATIO/scale,
                            (y-Save.mapy)*ScreenWidth*TILERATIO/scale)
                end
                gfx.pop()
            end
        end
        gfx.pop()
    elseif State.leaf == 7 then
        gfx.push()
        gfx.setColor(0.72,0.59,0.33,1)
        gfx.rectangle("fill", ScreenWidth/2-State.dialog_width/2, ScreenHeight/2-State.dialog_height/2, State.dialog_width, State.dialog_height)
        gfx.setColor(1,1,1,1)
        local _, pos = translatexy(0, 0.1)
        local iconsize = ScreenWidth/State.red_crystal:getWidth()*0.03
        gfx.scale(iconsize, iconsize)
        gfx.draw(State.red_crystal, (ScreenWidth/2-State.dialog_width/2.2)/iconsize, (ScreenHeight/2-State.dialog_height/2+pos)/iconsize)
        gfx.pop()
    elseif State.leaf == 8 then
        gfx.push()
        local scalex = ScreenWidth/State.sulphur_mining:getWidth()
        local scaley = ScreenHeight/State.sulphur_mining:getHeight()
        gfx.scale(scalex, scaley)
        gfx.draw(State.sulphur_mining, 0, 0)
        gfx.pop()
    end

    for i=1,#Buttons[State.leaf] do
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
            gfx.setColor(1, 1, 1, 1)
            love.graphics.draw(State.button_bg_hover, State.button_bg_quad, button.x, button.y, math.rad(0), button.width, button.height, 0, 0)
            gfx.setColor(BUTTONNORMALCOLOR)
            gfx.rectangle("line", button.x, button.y, button.width, button.height)
            gfx.print(button.text, button.x+button.width/2.0-width/2.0, button.y+button.height/2.0-height/2.0)
        else
            gfx.setColor(1, 1, 1, 1)
            love.graphics.draw(State.button_bg, State.button_bg_quad, button.x, button.y, math.rad(0), button.width, button.height, 0, 0)
            gfx.rectangle("line", button.x, button.y, button.width, button.height)
            gfx.setColor(BUTTONHOOVERCOLOR)
            gfx.print(button.text, button.x+button.width/2.0-width/2.0, button.y+button.height/2.0-height/2.0)
        end
    end

    for i=1,#Labels[State.leaf] do
        local label = Labels[State.leaf][i]
        if label.size == 1 then
            gfx.setFont(BigFont)
        elseif label.size == 2 then
            gfx.setFont(SmallFont)
        elseif label.size == 3 then
            gfx.setFont(MiniFont)
        end
        gfx.setColor(label.color)
        gfx.print(label.text, label.x, label.y)
    end

    --first after custom leaves is banner
    gfx.setFont(SmallFont)
    gfx.setColor(1, 1, 1, 1)
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
    gfx.draw(State.bannerx, ScreenWidth/scale-State.bannerx:getWidth(), 0)
    gfx.draw(State.bannerm, ScreenWidth/scale-2*State.bannerm:getWidth(), 0)
    gfx.pop()
    gfx.setColor(1,1,1)
    for _ =1, SMALLFONTDRAWS do
        gfx.print(Save.gamename, ScreenWidth/2.0 - SmallFont:getWidth(Save.gamename)/2.0, theheight/2.0-SmallFont:getHeight(Save.gamename)/2.0)
    end

    print_to_debug(ScreenWidth.."x"..ScreenHeight..", vsync="..love.window.getVSync()..", fps="..love.timer.getFPS()..", mem="..string.format("%.3f", collectgarbage("count")/1000.0).."MB, check1="..check1..", check2="..check2..", check3="..check3..", check4="..check4)

    gfx.setCanvas()
    gfx.setColor(1, 1, 1, 1)
    gfx.draw(Canvas, 0,0)
end