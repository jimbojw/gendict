#!ruby
# 
# Given a term on the command line, generate a video from end-to-end.
# 

require 'yaml'
require './scripts/common.rb'

term = ARGV[0]

term_arg = command_arg(term)
yaml_file = command_arg("terms/#{term}/#{term}-slides.yaml")

procedure = [
  "ruby scripts/make-slides.rb #{term_arg}",
  "ruby scripts/make-images.rb",
  "ruby scripts/make-audio.rb",
  "ruby scripts/make-video.rb"
].join(' | ') + " > #{yaml_file}"

puts "Running procedure: #{procedure}"
`#{procedure}`
