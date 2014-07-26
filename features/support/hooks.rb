require "sikulix"
include SikuliX4Ruby

ImagePath.setBundlePath "#{File.dirname(__FILE__)}\/..\/..\/imgs.sikuli"

def on_start
  click("1400320382234.png")
  hover("1400932378494.png")
  click("1400932390382.png")
end

After do
  click("1400320382234.png")
  click("1400320394450.png")
  if exists("1400320449100.png") then
    click("1400320432142.png")
  end
end

on_start