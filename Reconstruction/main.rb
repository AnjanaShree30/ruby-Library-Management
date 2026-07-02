
require_relative "models/book"
require_relative "models/digital_book"
require_relative "models/audio_book"
require_relative "models/errors"
require_relative "models/library"

require_relative "modules/displayable"
require_relative "modules/searchable"
require_relative "modules/exportable"

require_relative "ui/validators"
require_relative "ui/menu"


library = Library.new

puts "Before loading: #{library.all_books.size}"

load_library(library)

puts "After loading: #{library.all_books.size}"


at_exit do
  backup_library
  save_library(library)
end

begin
  run_menu(library)

rescue BookNotFoundError => e
  puts "Error: #{e.message}"

rescue InvalidInputError => e
  puts "Invalid Input: #{e.message}"

rescue Interrupt
  puts "\nGoodbye!"

ensure
  puts "Session ended."
end