require 'json'

def srunning_init(srunningH)
    #=========================================
    group = UI.new_group('Top 10 Cryptocurrency')
    UI.group_set_margined(group, 1)
    UI.box_append(srunningH, group, 1)

    inner = UI.new_vertical_box
    UI.box_set_padded(inner, 1)
    UI.group_set_child(group, inner)
    #=========================================
    # Checkbox
    
    data = read_coins[:data]
    data.each { |key, val|
        checkbox = UI.new_checkbox(val[0][0])
        UI.checkbox_set_checked(checkbox, val[1] == true ? 1 : 0) # Set the checkbox state
        UI.checkbox_on_toggled(checkbox) do |ptr|
            checked = UI.checkbox_checked(ptr) == 1
            p "Checkbox #{key} is clicked: status -- #{checked}"
            update_checked_value(key, checked)
        end
        UI.box_append(inner, checkbox, 0)
    }
end