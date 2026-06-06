def show_menu_in_spanish
    puts "\n=== Sistema de Gestión de Biblioteca ==="
    puts "1. Agregar un libro"
    puts "2. Listar libros"
    puts "3. Buscar un libro"
    puts "4. Actualizar un libro"
    puts "5. Eliminar un libro"
    puts "6. Salir"
    
    puts "\nPress Enter to return to the main menu..."
    gets
end
loop do
    puts "\n === Library Managament System ==="
    puts "0.Show menu in Spanish"
    puts "1.Add a book"
    puts "2.List books"
    puts "3.Search for a book"
    puts "4.Update a book"
    puts "5.Delete a book"
    puts "6.Exit"
    
    print "Enter your choice: "
    choice = gets.chomp

    case choice
    when "0"
        show_menu_in_spanish
    when "1"
        puts "Add a book-coming soon!"
    when "2"
        puts "List books-coming soon!"
    when "3"
        puts "Search for a book-coming soon!"
    when "4"
        puts "Update a book-coming soon!"
    when "5"
        puts "Delete a book-coming soon!"
    when "6"
        puts "Goodbye!"
        break
    else
        puts "Invalid Choice"
    end
end