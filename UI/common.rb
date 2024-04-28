def buttons_init(vbox, key)
  require_relative '../logic/cook.rb'
  hbox_buttons = UI.new_horizontal_box
  UI.box_set_padded(hbox_buttons, 1)
  UI.box_append(vbox, hbox_buttons, 0)

  ['Start', 'Stop'].each do |button_text|
    button = UI.new_button(button_text)
    UI.button_on_clicked(button) do
      if button_text == 'Start'
        UI.msg_box(MAIN_WINDOW, "#{Time.now.strftime("%d %B %r")}", 'Running...')
        result(key)
      elsif button_text == 'Stop'
        # if t.alive?
          # UI.msg_box(MAIN_WINDOW, 'Stop', '...')
          # exit
        # else
          UI.msg_box(MAIN_WINDOW, 'Nothing to stop', 'Run it before stoping')
        # end
      end
    end
    UI.box_append(hbox_buttons, button, 1)
  end
end
