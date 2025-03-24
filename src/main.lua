SMODS.Atlas {
    px = 34,
    py = 34,
    key = "modicon",
    -- every version of Balatro is personalized
    path = "Icon" .. math.random(1, 9) .. ".png",
}

SMODS.Atlas {
    px = 73,
    py = 95,
    key = "SeenSleeve",
    path = "SeenSleeve.png",
}

CardSleeves.Sleeve {
    key = "Seen",
    atlas = "SeenSleeve",
    pos = {x = 0, y = 0},
    apply = function(_)
        G.GAME.seen_sleeve = true
    end,
}

local function sleeve_effect()
    attention_text {
        hold = 2,
        major = G.play,
        offset = {x = 0, y = -2.7},
        text = G.GAME.current_round.hands_left .. " left.",
        scale = 2 * (2 ^ -G.GAME.current_round.hands_left) + 1,
    }

    play_sound("gong", G.GAME.current_round.hands_left * 0.1 + 0.3)

    if G.GAME.current_round.hands_left == 0 then
        ease_dollars(G.GAME.round_resets.hands - 1)
        G.STATE = G.STATES.ROUND_EVAL
    else
        G.STATE = G.STATES.DRAW_TO_HAND
    end

    return true
end

local orig_play = Blind.press_play

---@diagnostic disable-next-line: duplicate-set-field
function Blind:press_play()
    orig_play(self)

    if G.GAME.seen_sleeve then
        G.E_MANAGER:add_event(Event {
            delay = 0.5,
            trigger = "before",
            func = sleeve_effect
        })
    end
end
