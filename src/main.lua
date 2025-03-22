assert(SMODS.load_file('src/back.lua'))()
assert(SMODS.load_file('src/util.lua'))()

SMODS.Atlas {
    px = 34,
    py = 34,
    key = "modicon",
    -- every version of Balatro is personalized
    path = "Icon" .. math.random(1, 9) .. ".png",
}
