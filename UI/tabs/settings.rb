def settings_init(settingsH, key)
    configuration = read_conf
    # SMTP options ############################################################
    group = UI.new_group('SMTP options')
    UI.group_set_margined(group, 1)
    UI.box_append(settingsH, group, 1) # OSX bug?

    inner = UI.new_vertical_box
    UI.box_set_padded(inner, 0)
    UI.group_set_child(group, inner)
    ##==========================    SMTP Config    ==========================
    # SMTP Host and Port
    hbox_smtp = UI.new_horizontal_box
    UI.box_set_padded(hbox_smtp, 1)
    UI.box_append(inner, hbox_smtp, 1)  

    # SMTP Host
    vbox_host = UI.new_vertical_box
    UI.box_set_padded(vbox_host, 1)
    UI.box_append(hbox_smtp, vbox_host, 1)  

    label_host = UI.new_label('SMTP Host')
    UI.box_append(vbox_host, label_host, 0)

    host_smtp = UI.new_entry
    UI.entry_set_text(host_smtp, configuration['host'])
    UI.entry_on_changed(host_smtp) do |ptr|
        data = UI.entry_text(ptr)
        puts "smtp server url: '#{data}'"
        write_conf('host', data.to_s)

    end
    UI.box_append(vbox_host, host_smtp, 1)

    # SMTP Port
    vbox_port = UI.new_vertical_box
    UI.box_set_padded(vbox_port, 1)
    UI.box_append(hbox_smtp, vbox_port, 0)

    label_port = UI.new_label('SMTP Port')
    UI.box_append(vbox_port, label_port, 0)

    port_smtp = UI.new_spinbox(0, 65535)
    UI.spinbox_set_value(port_smtp, configuration['port'])
    UI.spinbox_on_changed(port_smtp) do |ptr|
        data = UI.spinbox_value(ptr)
        puts "SMTP Port: #{data}"
        write_conf('port', data.to_i)
    end
    UI.box_append(vbox_port, port_smtp, 0)
    #=== Domain ===
    hbox_domain = UI.new_horizontal_box
    UI.box_set_padded(hbox_domain, 1)
    UI.box_append(inner, hbox_domain, 0)

    UI.box_append(hbox_domain, UI.new_label('Service domain'), 0)

    textbox_domain = UI.new_entry
    UI.entry_set_text(textbox_domain, configuration['domain'])
    UI.entry_on_changed(textbox_domain) do |ptr|
        data = UI.entry_text(ptr)
        puts "service domain: '#{data}'"
        write_conf('domain', data.to_s)
    end
    UI.box_append(inner, textbox_domain, 0)
    #==============
    ##========================== Username / Password ==========================
    # Email Label and Textbox
    hbox_email = UI.new_horizontal_box
    UI.box_set_padded(hbox_email, 1)
    UI.box_append(inner, hbox_email, 0)

    UI.box_append(hbox_email, UI.new_label('Sender Email'), 0)

    textbox_email = UI.new_entry
    UI.entry_set_text(textbox_email, configuration['emailhost'])
    UI.entry_on_changed(textbox_email) do |ptr|
        data = UI.entry_text(ptr)
        puts "Sender EMAIL: '#{data}'"
        write_conf('emailhost', data.to_s)
    end
    UI.box_append(inner, textbox_email, 0)

    # Password Label and Textbox
    hbox_password = UI.new_horizontal_box
    UI.box_set_padded(hbox_password, 1)
    UI.box_append(inner, hbox_password, 0)

    UI.box_append(hbox_password, UI.new_label('Sender Password'), 0)

    textbox_password = UI.new_entry
    UI.entry_set_text(textbox_password, '')
    UI.entry_on_changed(textbox_password) do |ptr|
        encrypt(UI.entry_text(ptr).to_s, key)
    end
    UI.box_append(inner, textbox_password, 0)
end
