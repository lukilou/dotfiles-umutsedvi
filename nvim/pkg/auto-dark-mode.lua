local current_theme = true
local function is_dark_mode()
    local f = io.open("/tmp/.cs", "r")
    if f == nil then
        vim.cmd [[ set background=dark ]]
        return true
    end
    io.input(f)
    local str = io.read()
    io.close(f)
    return str == "true"
end

function SetColors()
    local d = is_dark_mode()
    if d ~= current_theme then
        current_theme = d
        if d == true then
            vim.cmd [[ set background=dark ]]
            current_theme = true
        else
            vim.cmd [[ set background=light ]]
            current_theme = false
        end
    end
end

