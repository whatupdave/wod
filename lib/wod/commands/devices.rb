
module Wod::Command
  class Devices < Base
    def index
      page = wod.get "https://developer.apple.com/ios/manage/devices/index.action"
      
      names = page.search("td.name span").map(&:text)
      udids = page.search("td.id").map(&:text)
    
      devices_left = page.search(".devicesannounce strong").first.text
      devices = names.map.with_index{|name, i| {:name => name, :udid => udids[i] } }
      
      display_formatted devices, [:name, :udid]
      puts
      puts "#{devices.size} devices registered. #{devices_left}"
    end
    
    def add
      name = args.shift
      udid = args.shift
      
      page = wod.get "https://developer.apple.com/ios/manage/devices/add.action"
      
      form = page.form "add"
      form["deviceNameList[0]"] = name
      form["deviceNumberList[0]"] = udid
      
      form.submit
    end
    
    def remove
      name = args.shift
      
      page = wod.get "http://developer.apple.com/ios/manage/devices/index.action"
      
      device_span = page.search("span:contains('#{name}')")
      if device_span.empty?
        error "Device not found"
      end
      
      tr = device_span.first.parent.parent
      row_identifier = tr.search("input[name='__checkbox_selectedValues']").first[:value]
      
      form = page.form "removeDevice"
      checkbox = form.checkboxes.find {|c| c[:value] == row_identifier}
      checkbox.check
      form.submit
    end
  end
end