namespace :import do
    desc "Import movies and reviews from CSV files"
    task movies_and_reviews: :environment do
      require 'csv'
  
      movies_csv_path = ENV['MOVIES_CSV'] || Rails.root.join('movies.csv')
      reviews_csv_path = ENV['REVIEWS_CSV'] || Rails.root.join('reviews.csv')
  
      puts "Starting import of movies from #{movies_csv_path}"
      File.foreach(movies_csv_path).with_index do |line, index|
        if index == 0
          next
        end
  
        line = line.chomp
  
        fields = line.split(',')
  
        if fields.size < 7
          puts "Skipping invalid line #{index + 1}: #{line}"
          next
        end
  
        country_name = fields.pop.strip
        filming_location_name = fields.pop.strip
        actor_name = fields.pop.strip
        director_name = fields.pop.strip
        year = fields.pop.strip
  
        movie_title = fields.shift.strip
        description = fields.join(',').strip
  
        puts "Processing movie: #{movie_title}"
        puts "Description: #{description}"
        puts "Year: #{year}"
        puts "Director: #{director_name}"
        puts "Actor: #{actor_name}"
        puts "Filming Location: #{filming_location_name}"
        puts "Country: #{country_name}"
        puts "-----"
  
        director = Director.find_or_create_by(name: director_name)
        movie = Movie.find_or_create_by(
          title: movie_title,
          description: description,
          year: year.to_i,
          director: director
        )
  
        unless movie.persisted?
          puts "Failed to save movie: #{movie.errors.full_messages.join(', ')}"
          next
        end
  
        actor = Actor.find_or_create_by(name: actor_name)
        movie.actors << actor unless movie.actors.include?(actor)
  
        filming_location = FilmingLocation.find_or_create_by(
          location: filming_location_name,
          country: country_name
        )
        movie.filming_locations << filming_location unless movie.filming_locations.include?(filming_location)
      end
  
      puts "Starting import of reviews from #{reviews_csv_path}"
      CSV.foreach(reviews_csv_path, headers: true, col_sep: ",") do |row|
        movie = Movie.find_by(title: row['Movie'])
        if movie
          movie.reviews.create(
            reviewer_name: row['User'],
            stars: row['Stars'].to_i,
            review_text: row['Review']
          )
          puts "Added review for movie: #{movie.title}"
        else
          puts "Movie not found for review: #{row['Movie']}"
        end
      end
  
      puts "Import completed successfully."
    end
  end