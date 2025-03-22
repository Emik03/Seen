if not CardSleeves then
    return
end

local function sleeve_effect()
    attention_text {
        hold = 2,
        major = G.play,
        offset = {x = 0, y = -2.7},
        text = G.GAME.current_round.hands_left .. ' left.',
        scale = 2 * (2 ^ -G.GAME.current_round.hands_left) + 1,
    }

    play_sound('gong', 0.3 + (G.GAME.current_round.hands_left * 0.1))

    -- The reason not to use infinity here is to make it worth with OmegaNum.
    G.GAME.blind.chips = G.GAME.current_round.hands_left == 0 and 0 or 1.7976931348623157e+308

    if G.GAME.current_round.hands_left == 0 then
        G.GAME.current_round.hands_left = G.GAME.round_resets.hands - 1
    end

    return true
end

SMODS.Atlas {
    key = "SeenSleeve",
    path = "SeenSleeve.png",
    px = 73,
    py = 95
}

CardSleeves.Sleeve {
    key = "Seen",
    atlas = "SeenSleeve",
    pos = {x = 0, y = 0},
    calculate = function(_, _, args)
        if args.context ~= "Seen_after_press_play" then
            return
        end

        G.E_MANAGER:add_event(Event {
            trigger = 'before',
            delay = 0.8125,
            func = sleeve_effect
        })
    end,
}
