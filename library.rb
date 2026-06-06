books=[]
loop do
    puts "\n === Library Managament System ==="
    puts "1.Add a book"
    puts "2.List first 3 books"
    puts "3.Search for a book"
    puts "4.Update a book"
    puts "5.Delete a book"
    puts "6.Exit"
    puts "7.List all books"
    puts "8.Browse By Genre"
    
    print "Enter your choice: "
    choice = gets.chomp

    case choice
    when "1"
        print "enter title:"
        title = gets.chomp

        print "enter author:"
        author = gets.chomp

        print "enter year:"
        year = gets.chomp

        print "enter genre:"
        genre = gets.chomp
        books.push({
            title:title,
            author:author,
            year:year,
            genre:genre
        })
    
    when "2"
        books.first(3).each_with_index do |book,index|
            puts "#{index+1}.#{book[:title]} by #{book[:author]} was published in #{book[:year]}"
        end
    
    when "3"
        puts "Search for a book-coming soon!"
    
    when "4"
        puts "Update a book-coming soon!"
    
    when "5"
        print "enter title to delete the book:"
        title=gets.chomp

        book_found = books.any? do |book|
            book[:title].downcase == title.downcase
        end

        if book_found
            books.reject! do |book|
                book[:title].downcase == title.downcase
            end
            puts "book deleted successfully!"
        else
            puts "book not found!"
        end
    
    when "6"
        puts "Goodbye!"
        break
    
    when "7"
        books.each_with_index do |book,index|
            puts "#{index+1}.#{book[:title]} by #{book[:author]} was published in #{book[:year]}"
        end
    when "8"
        print "enter genre to browse:"
        genre=gets.chomp

        matching_books = books.select do |book|
            book[:genre].downcase == genre.downcase
        end

        if matching_books.empty?
            puts "No books under the genre #{genre} found!"
        else

            matching_books.each_with_index do |book,index|
                puts "#{index+1}.#{book[:title]} by #{book[:author]} was published in #{book[:year]} and belongs to Genre #{book[:genre]}"
            end
        end
    else
        puts "Invalid Choice"
    end
end