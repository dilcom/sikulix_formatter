# encoding: UTF-8

require 'sikulix'
include SikuliX4Ruby
require 'rspec-expectations'

Settings.MinSimilarity = 0.85
ImagePath.setBundlePath "#{File.dirname(__FILE__)}\/..\/..\/imgs.sikuli"

SHORT_WAITING_TIME = 1
MED_WAITING_TIME = 5
LONG_WAITING_TIME = 200
WHEEL_TO_TOP = 20
WHEEL_DOWN_STEP = 1

def cyr_type(str)
  cyr_str = %{ЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮёйцукенгшщзхъфывапролджэячсмитьбю}
  lat_str = %{~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>`qwertyuiop[]asdfghjkl;'zxcvbnm,.}
  str.scan(/([А-Яа-я 0-9!\*\(\)_\+\-=]+|[^А-Яа-я]+)/).each do |el|
    el = el[0]
    lang = :eng
    if el.match(/[А-Яа-я]+/)
      el.tr!(cyr_str, lat_str)
      lang = :rus
    end
    hover Pattern("support/1403618719647.png").targetOffset(164,0)
    if lang == :rus && exists(Pattern("support/1403678585166.png").similar(0.90))
      click Pattern("support/1403678585166.png").similar(0.90)
    end
    if lang == :eng && exists(Pattern("support/1404283849480.png").similar(0.90))
      click Pattern("support/1404283849480.png").similar(0.90)
    end
    sleep 1
    write(el)
  end
end

def keyDownFromOptions(options)
  if options.include?("ctrl") || options.include?("контрол")
    keyDown(Key.CTRL)
  end
  if options.include?("shift") || options.include?("шифт")
    keyDown(Key.SHIFT)
  end
  if options.include?("alt") || options.include?("альт")
    keyDown(Key.ALT)
  end
end

def keyModFromOptions(options)
  mod = 0
  if options.include?("ctrl") || options.include?("контрол")
    mod += KeyModifier.CTRL
  end
  if options.include?("shift") || options.include?("шифт")
    mod += KeyModifier.SHIFT
  end
  if options.include?("alt") || options.include?("альт")
    mod += KeyModifier.ALT
  end
  mod
end

CAPTURE_PATTERN = Transform /("[A-Za-z_0-9@\.\/\-]+\.png"|Pattern[^ ]+)/ do |pattern|
  $DEFAULT_LOC ||= Location(10,10)
  eval(pattern)
end

Transform /(пустаястрока)/ do |arg|
  ""
end

Если (/вв[а-я]*( в #{CAPTURE_PATTERN})? строку(.*)/) do |field, str|
  str = str.strip || str
  if field
    def_delay = Settings.MoveMouseDelay
    Settings.MoveMouseDelay = 0.1
    field = find field 
    click(field)
    click(field)
    click(field)
    Settings.MoveMouseDelay = def_delay
  end
  cyr_type(str)
end

Если (/(.*)пере(ме|та)[а-я]+ (#{CAPTURE_PATTERN}) в (#{CAPTURE_PATTERN})/) do |options, nothing, el, target|
  el = wait el,MED_WAITING_TIME
  target = wait target,MED_WAITING_TIME
  keyDownFromOptions(options)
  hover(el)
  sleep 0.5
  mouseDown(Button.LEFT)
  sleep 0.5
  hover(target)
  sleep 0.5
  mouseUp(Button.LEFT)
  keyUp()
end

Если (/выб[а-я]+ в выпадающем меню со скроллом (#{CAPTURE_PATTERN}) пункт (#{CAPTURE_PATTERN})/) do |area, element|
  hover($DEFAULT_LOC)
  delta = Location(0,0)
  if area.is_a? Pattern
    delta = area.getTargetOffset
  end
  area = wait area,MED_WAITING_TIME
  click(area)
  sleep(SHORT_WAITING_TIME)
  area = area.offset(Location(0,20).offset(delta))
  wheel(area, Button.WHEEL_UP, WHEEL_TO_TOP)
  i = 0
  while (!exists(element) && i < 100) do
    wheel(area, Button.WHEEL_DOWN, WHEEL_DOWN_STEP)
    i += 1
  end
  click(element)
end

Если (/выб[а-я]+ в выпадающем меню без скролла (#{CAPTURE_PATTERN}) пункт (#{CAPTURE_PATTERN})/) do |area, element|
  hover($DEFAULT_LOC)
  sleep(SHORT_WAITING_TIME)
  click(area)
  sleep(SHORT_WAITING_TIME)
  click(element)
end

Если (/(обл.* #{CAPTURE_PATTERN})?([A-Za-zА-Яа-я \-\,]*)клик.* (#{CAPTURE_PATTERN})$/) do |reg, options, img|
  context = $SIKULI_SCREEN
  keyUp()
  if reg
    context = wait reg,MED_WAITING_TIME
  end
  double = options.include?("двой") || options.include?("double")
  right = options.include?("прав") || options.include?("right")
  wait(img,MED_WAITING_TIME)
  keyDownFromOptions(options)
  sleep 0.5
  if double 
    context.doubleClick(img)
  else
    if right
	  context.rightClick(img)
	else
      context.click(img)
	end
  end
  sleep 0.5
  keyUp()
end


Тогда(/(.*должен .*)у?ви(:?д|ж)[а-я]+ (#{CAPTURE_PATTERN})$/) do |option, img|
  hover($DEFAULT_LOC) 
  if option.include?('не ')
    expect(waitVanish(img,MED_WAITING_TIME)).to equal(true)
  else
    wait(img,MED_WAITING_TIME)
  end
end

Тогда(/жд[а-я]+ появления (#{CAPTURE_PATTERN})$/) do |img|
  hover($DEFAULT_LOC)    
  expect(wait(img, LONG_WAITING_TIME)).to_not raise_exception 
end

Тогда /ничего не делать/ do
 # :D I`d like to replace all the steps with that
end

Если /пропустить сценарий,? если я (.*)ви.+ (#{CAPTURE_PATTERN})/ do |option, pattern|
  hover($DEFAULT_LOC)
  sleep(SHORT_WAITING_TIME)
  how_long = SHORT_WAITING_TIME
  if (option.include? 'долго ')
    how_long = LONG_WAITING_TIME
  end
  wait_result = true
  begin
    if (option.include?('не '))
      wait(pattern, how_long)
    else
      wait_result = waitVanish(pattern, how_long)
    end
  rescue
    pending #Ignore other steps of scenario
  end
  if !wait_result
    pending #Ignore other steps of scenario
  end
end

Тогда /использ[а-я]* (.*) с выводом отчета в (.*)$/ do |feature_file, report_name|
  feature_file = "./features/" + feature_file
  if feature_file.scan(/\.nested_feature/).empty?
    feature_file += ".nested_feature"
  end
  @last_report_name = '.\\reports\\' + report_name.gsub(/ /){"_"} + '_report.html'
  result = system 'cucumber ./' + feature_file + ' --format Sikulix::Html --out ' + @last_report_name + ' --guess'
  expect(result).to eq(true), 'Ошибка при завершении вложенного теста! Смотри подробности в ' + @last_report_name
end

То /нав[а-я]* курсор на (#{CAPTURE_PATTERN})/ do |img|
  wait(img, SHORT_WAITING_TIME)
  hover(img)
end

Если /устан[а-я]* указатель (#{CAPTURE_PATTERN}) слайдера (#{CAPTURE_PATTERN}) в положение ([0-9]+)\%/ do |slider, area, value|
  hover($DEFAULT_LOC)    
  area = wait area,MED_WAITING_TIME
  width = area.getTopRight.getX - area.getTopLeft.getX
  height = area.getBottomRight.getY - area.getTopRight.getY
  hover(slider)
  sleep SHORT_WAITING_TIME
  mouseDown(Button.LEFT)
  sleep SHORT_WAITING_TIME
  if width>=height
    hover(area.getTopLeft.offset(width*value.to_i/100,0))
  else
    hover(area.getTopLeft.offset(0,height*value.to_i/100))
  end
  sleep SHORT_WAITING_TIME
  mouseUp(Button.LEFT)
end

Если /выб[а-я]+ в области со скроллом (#{CAPTURE_PATTERN}) пункт (#{CAPTURE_PATTERN})/ do |area, element|
  sleep 1
  area = wait area,MED_WAITING_TIME
  hover(area)
  wheel(Button.WHEEL_UP,10)
  while !exists(element) do
    wheel(Button.WHEEL_DOWN,1)
  end
  click(element)
end

Если /выб[а-я]+ в контекстном меню (#{CAPTURE_PATTERN}) пункт (#{CAPTURE_PATTERN})/ do |element, option|
  sleep 1
  rightClick element 
  wait(option,MED_WAITING_TIME)
  click option
end

Если /наж[а-я]+ клавишу ([A-Za-z0-9]+)/ do |key|
  if key.size > 1
    write eval("Key.#{key}")
  else
    write key.downcase
  end
end

Если /наж[а-я]+ сочетание ([A-Z0-9]+)[\+\-]([A-Za-z0-9]+)/ do |mod, key|
  if mod.size > 1
    keyDown eval("Key.#{mod}")
  else
    keyDown mod
  end
  step %{ * нажать клавишу #{key} }
  keyUp
end
