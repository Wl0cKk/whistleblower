def tracking_init(trackingH)
    configuration = read_conf
    #========================================= 
    group = UI.new_group('Tracking options')
    UI.group_set_margined(group, 1)
    UI.box_append(trackingH, group, 1)

    inner = UI.new_vertical_box
    UI.box_set_padded(inner, 1)
    UI.group_set_child(group, inner)
    #================= Recipiest address =================
    hbox_email = UI.new_horizontal_box
    UI.box_set_padded(hbox_email, 1)
    UI.box_append(inner, hbox_email, 0)

    UI.box_append(hbox_email, UI.new_label('Recipiest Email'), 0)

    textbox_email = UI.new_entry
    UI.entry_set_text(textbox_email, configuration['recipient'])
    UI.entry_on_changed(textbox_email) do |ptr|
        data = UI.entry_text(ptr)
        puts "recipiest: '#{data}'"
        write_conf('recipient', data.to_s)
    end
    UI.box_append(inner, textbox_email, 0)
    ########  Directions and count of tries. ######## 
    hbox_market = UI.new_horizontal_box
    UI.box_set_padded(hbox_market, 1)
    UI.box_append(inner, hbox_market, 1) 

    vbox_cbox = UI.new_vertical_box
    UI.box_set_padded(vbox_cbox, 1)
    UI.box_append(hbox_market, vbox_cbox, 1)

    UI.box_append(vbox_cbox, UI.new_label('Market movement direction'), 0)

    cbox = UI.new_combobox
    # UI.combobox_set_value(cbox, read_conf['movement']) :( 
    # Gonna use <<Glimmer DSL for LibUI>> next time
    ['Goes UP', 'Goes DOWN', 'Bidirectional', 'Any direction'].each {|direction| # used multiple times :(
        UI.combobox_append(cbox, direction)
    }
    UI.box_append(vbox_cbox, cbox, 1)
    UI.combobox_on_selected(cbox) do |ptr|
        data = UI.combobox_selected(ptr)
        puts "Crypto movement side: #{data}"
        write_conf('movement', data.to_i)
    end

    vbox_value = UI.new_vertical_box
    UI.box_set_padded(vbox_value, 1)
    UI.box_append(hbox_market, vbox_value, 0)

    UI.box_append(vbox_value, UI.new_label('Times'), 0)

    spinbox_val = UI.new_spinbox(1, 100)
    UI.spinbox_set_value(spinbox_val, configuration['times'])
    UI.spinbox_on_changed(spinbox_val) do |ptr|
        data = UI.spinbox_value(ptr)
        puts "Movement times: #{data}"
        write_conf('times', data.to_i)
    end
    UI.box_append(vbox_value, spinbox_val, 0)
    #################################################

    ############## Time Range Picker ################
    vbox_time_picker = UI.new_vertical_box
    UI.box_set_padded(vbox_time_picker, 1)
    UI.box_append(inner, vbox_time_picker, 0)

    hbox_time_labels = UI.new_horizontal_box
    UI.box_set_padded(hbox_time_labels, 1)
    UI.box_append(vbox_time_picker, hbox_time_labels, 0)

    time = ['Days', 'Hours', 'Minutes', 'Seconds']

    hbox_time_spinboxes = UI.new_horizontal_box
    UI.box_set_padded(hbox_time_spinboxes, 1)
    UI.box_append(vbox_time_picker, hbox_time_spinboxes, 0)

    spinboxes = []

    time.each_with_index { |unit, actual_value|
        UI.box_append(hbox_time_labels, UI.new_label(unit), 1)
        spinbox = UI.new_spinbox(0, 10000)
        UI.spinbox_set_value(spinbox, configuration['dtime'][actual_value])
        spinboxes << spinbox
        UI.spinbox_on_changed(spinbox) do |ptr|
            data = UI.spinbox_value(ptr)
            puts "#{unit}: #{UI.spinbox_value(ptr)}"
            write_conf('dtime', data.to_i, actual_value)
        end
        UI.box_append(hbox_time_spinboxes, spinbox, 0)
    }
    #################################################
end






















