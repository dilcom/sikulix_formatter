# encoding: UTF-8
require "sikulix"
require "rspec-expectations"
include SikuliX4Ruby

ImagePath.setBundlePath "#{File.dirname(__FILE__)}\/..\/..\/imgs.sikuli"

CAPTURE_PATTERN = Transform /("[A-Za-z@_0-9\.-\/]+\.png"|Pattern.*)/ do |pattern|
  eval pattern
end

Given /click on (#{CAPTURE_PATTERN})$/ do |img|
  wait(img, 3)
  click(img)
end

Given /opened by hover (#{CAPTURE_PATTERN})$/ do |img|
  hover(img)
end

Given /^I should see (#{CAPTURE_PATTERN})$/ do |img|
  expect(wait(img,4)).to_not raise_exception
end

Given /^I should not see (#{CAPTURE_PATTERN})$/ do |img|
  expect(waitVanish(img,4)).to_not raise_exception
end

Given /^I fill in (#{CAPTURE_PATTERN}) with (.+)$/ do |field, text|
  doubleClick(field)
  type(text)
end

Given /^(#{CAPTURE_PATTERN}) is found by scrolling (#{CAPTURE_PATTERN})$/ do |element, area|
  el = Pattern(element).similar(0.85)
  pattern = Pattern(area).targetOffset(-20 ,45)
  wheel(pattern, Button.WHEEL_UP, 100)
  i = 0
  while !exists(el, 0) && i <= 100
    wheel(pattern, Button.WHEEL_DOWN, 3)
    i += 1
  end
end

Given /^text fragment selected$/ do
  click("steps/1400351083105.png")
  hover(Pattern("steps/1400351083105.png").targetOffset(-23,18))
  mouseDown(Button.LEFT)
  hover(Pattern("steps/1400351093763.png").targetOffset(-29,-23))
  mouseUp(Button.LEFT)
end
