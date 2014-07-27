# Scenario: rename all the images inside ../imgs.sikuli and inside features, step_deinitions too
#   Given there are an image named as "284_398img.png" in "example_1.11.feature" file
#   If I run jruby ./rename_imgs.rb
#   Then I should see image in file named as "example_1.11#284_398img.png"
#   And "example_1.11#284_398img.png" inside ../imgs.sikuli folder

require 'fileutils'

def renameImages (files, prefix = "")
  files.each do |fname|
    if !File.directory?(fname)
      if block_given?
        prefix = yield fname
      end
	  Dir.mkdir "../imgs.sikuli/#{prefix}" unless File.exists? "../imgs.sikuli/#{prefix}"
      ftext = ""
      File.open(fname) do |file|
        ftext = file.read
      end
      imgs = []
      ftext.scan(/"([0-9A-Za-z_]+\.png)"/) { imgs << $1 }
      imgs.uniq.each do |img|
        ftext.gsub!(img, "#{prefix}/#{img}")
        FileUtils.cp("../imgs.sikuli/#{img}", "../imgs.sikuli/#{prefix}/#{img}")
      end
      File.open(fname, 'w') do |file|
        file.puts ftext
      end
    end
  end
end

renameImages Dir.glob("../features/step_definitions/**"), "steps"
renameImages Dir.glob("../features/support/**"), "support"
renameImages Dir.glob("../features/*") do |fname|
  if fname =~ /\.feature/
    File.basename(fname, ".feature")
  else
    File.basename(fname, ".nested_feature")
  end
end

# Remove unused imgs

puts "Do you want to remove unused images? [yN]:"
answer = gets
if answer =~ /[Yy]/n
  # TODO remove unused imgs here
end