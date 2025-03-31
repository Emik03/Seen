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

        -- This is set here, because calculate is called before end_round
        G.GAME.current_round.end_round_zero_hands = true
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
        if args.ending_shop then
            G.GAME.current_round.prevent_end_round_call = false
            G.GAME.current_round.end_round_zero_hands = false
            return
        end

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

local orig_press_play = Blind.press_play

function Blind:press_play()
    orig_press_play(self)

    local sleeve = CardSleeves and CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve or "sleeve_casl_none")

    if sleeve and type(sleeve.calculate) == "function" then
        sleeve:calculate(sleeve, {context = 'Seen_after_press_play'})
    end
end

local orig_init_game_object = Game.init_game_object

function Game:init_game_object()
    local ret = orig_init_game_object(self)
    ret.current_round.prevent_end_round_call = false
    ret.current_round.end_round_zero_hands = false
    return ret
end

local orig_end_round = end_round

function end_round()
    if not G.GAME.selected_sleeve or G.GAME.selected_sleeve ~= "sleeve_Seen_Seen" then
        orig_end_round()
        return
    end

    if not G.GAME.current_round.prevent_end_round_call then
        if #G.deck.cards < 1 and not G.GAME.current_round.end_round_zero_hands then
            G.GAME.blind.chips = 0
            G.GAME.current_round.prevent_end_round_call = true
            G.GAME.current_round.hands_left = G.GAME.round_resets.hands - 1

            attention_text {
                hold = 2,
                major = G.play,
                offset = {x = 0, y = -2.7},
                text = "Out of Cards",
                scale = 2 * (2 ^ -5) + 1,
            }
        
            play_sound("gong", 0.3)
        end

        orig_end_round()
    end
end
