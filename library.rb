def show_menu
    puts "\n === Library Managament System ==="
    puts "1.Add a book"
    puts "2.List first 3 books"
    puts "3.List all the books"
    puts "4.delete a book"
    puts "5.search for a book"
    puts "6.exit"
end

def add_book(books)
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
end

def list_books(books)
    books.first(3).each_with_index do |book,index|
            puts "#{index+1}.#{book[:title]} by #{book[:author]} was published in #{book[:year]}"
    end
end

def list_all_books(books)
    books.each_with_index do |book,index|
            puts "#{index+1}.#{book[:title]} by #{book[:author]} was published in #{book[:year]}"
    end
end

def delete_book(books)
    print "enter title to delete book:"
    title = gets.chomp

    book_found=books.any? do |book|
        book[:title].downcase == title.downcase
    end

    if !book_found
        puts "book not found!"
    else
        books.reject! do |book|
            book[:title].downcase == title.downcase
        end
        puts "book deleted"
    end
end

def search_book(books)
    print "enter title to search for a book:"
    title = gets.chomp

    found_book = books.find do |book|
        book[:title].downcase == title.downcase
    end

    if found_book.empty?
        puts "book bot found"
    else
        puts "title: #{found_book[:title]}"
        puts "author: #{found_book[:author]}"
        puts "year: #{found_book[:year]}"
        puts "genre: #{found_book[:genre]}"
    end
end

books=[]
loop do
    show_menu
    print "Enter your choice: "
    choice = gets.chomp

    case choice
    when "1"
        add_book(books)
    
    when "2"
        list_books(books)
    
    when "3"
        list_all_books(books)
    
    when "4"
        delete_book(books)
    
    when "5"
        search_book(books)

    when "6"
        puts "Goodbye!"
        break
    else
        puts "Invalid Choice"
    end
end