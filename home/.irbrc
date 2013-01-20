# Use Pry everywhere
begin
  require 'rubygems'
  require 'pry'
  Pry.start
  exit
rescue LoadError => e
  puts "Pry not installed, using vanilla IRB..."
end
