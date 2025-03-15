local orig_press_play = Blind.press_play

function Blind:press_play()
    orig_press_play(self)

    local sleeve = CardSleeves and CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve or "sleeve_casl_none")
    if sleeve and type(sleeve.calculate) == "function" then
        sleeve:calculate(sleeve, {context = 'Seen_after_press_play'})
    end
end

sendInfoMessage("Blind:press_play() patched. Reason: Seen Sleeve", "Seen")
