#!/usr/bin/env ruby
require 'libui'
require_relative 'logic/driver.rb'
require_relative 'logic/vault.rb'
require_relative 'UI/tabs/settings.rb'
require_relative 'UI/tabs/tracking.rb'
require_relative 'UI/tabs/srunning.rb'
require_relative 'UI/common.rb'

UI = LibUI
UI.init

NAME = 'Whistleblower'
SESSION = session()
MAIN_WINDOW = UI.new_window(NAME, 500, 240, 0) # X Y
UI.window_on_closing(MAIN_WINDOW) do
  puts 'Closing.'
  File.delete($VAULT) if File.exist?($VAULT)
  UI.quit
  1
end

hbox = UI.new_horizontal_box
UI.window_set_child(MAIN_WINDOW, hbox)

vbox = UI.new_vertical_box
UI.box_set_padded(vbox, 1)
UI.box_append(hbox, vbox, 1)

# Tab
tab = UI.new_tab
settingsH = UI.new_horizontal_box
trackingH = UI.new_horizontal_box
srunningH = UI.new_horizontal_box

UI.tab_append(tab, 'Settings',     settingsH)
UI.tab_append(tab, 'Tracking',     trackingH)
UI.tab_append(tab, 'Select Coins', srunningH)
UI.box_append(vbox, tab, 1)

path = File.join(__dir__, '../..', 'cryptocurrency.json')
aisle = String.new
settings_init(settingsH, SESSION) # Settings Tab
tracking_init(trackingH) # Tracking Tab
srunning_init(srunningH) # Coin Picker Tab

buttons_init(vbox, SESSION) # Common Bottom Buttons 

END {
  UI.control_show(MAIN_WINDOW)
  UI.main
  UI.uninit 
}
