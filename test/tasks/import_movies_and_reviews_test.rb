# test/tasks/import_movies_and_reviews_test.rb

require 'test_helper'
require 'rake'

class ImportMoviesAndReviewsTest < ActiveSupport::TestCase
  def setup
    Rake.application.rake_require 'tasks/import'
    Rake::Task.define_task(:environment)

    @movies_csv_data = <<~CSV
      Movie,Description,Year,Director,Actor,Filming location,Country
      Gone in 60 seconds,A retired master car thief must come back to the industry and steal fifty cars with his crew in one night to save his brother's life.,2000,Dominic Sena,Nicolas Cage,Los Angeles,US
      Inception,A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a CEO.,2010,Christopher Nolan,Leonardo Di Caprio,Los Angeles,US
    CSV

    @reviews_csv_data = <<~CSV
      Movie,User,Stars,Review
      Gone in 60 seconds,John Doe,5,An action-packed thrill ride!
      Inception,Jane Smith,4,Complex and engaging.
    CSV

    @movies_csv_file = Tempfile.new('movies.csv')
    @movies_csv_file.write(@movies_csv_data)
    @movies_csv_file.rewind

    @reviews_csv_file = Tempfile.new('reviews.csv')
    @reviews_csv_file.write(@reviews_csv_data)
    @reviews_csv_file.rewind

    ENV['MOVIES_CSV'] = @movies_csv_file.path
    ENV['REVIEWS_CSV'] = @reviews_csv_file.path
  end

  def teardown
    @movies_csv_file.close
    @movies_csv_file.unlink
    @reviews_csv_file.close
    @reviews_csv_file.unlink

    ENV.delete('MOVIES_CSV')
    ENV.delete('REVIEWS_CSV')

    Rake::Task['import:movies_and_reviews'].reenable
  end

  test "import_movies_and_reviews task imports data correctly with custom parsing" do
    assert_difference [
      'Movie.count',
      'Director.count',
      'Actor.count',
      'Review.count'
    ], 2 do
      assert_difference 'FilmingLocation.count', 1 do
        Rake::Task['import:movies_and_reviews'].invoke
      end
    end

    movie1 = Movie.find_by(title: "Gone in 60 seconds")
    assert_not_nil movie1
    assert_equal "A retired master car thief must come back to the industry and steal fifty cars with his crew in one night to save his brother's life.", movie1.description
    assert_equal 2000, movie1.year
    assert_equal "Dominic Sena", movie1.director.name
    assert_includes movie1.actors.pluck(:name), "Nicolas Cage"
    assert_includes movie1.filming_locations.pluck(:location), "Los Angeles"

    movie2 = Movie.find_by(title: "Inception")
    assert_not_nil movie2
    assert_equal "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a CEO.", movie2.description
    assert_equal 2010, movie2.year
    assert_equal "Christopher Nolan", movie2.director.name
    assert_includes movie2.actors.pluck(:name), "Leonardo Di Caprio"
    assert_includes movie2.filming_locations.pluck(:location), "Los Angeles"

    review1 = movie1.reviews.find_by(reviewer_name: "John Doe")
    assert_not_nil review1
    assert_equal 5, review1.stars
    assert_equal "An action-packed thrill ride!", review1.review_text

    review2 = movie2.reviews.find_by(reviewer_name: "Jane Smith")
    assert_not_nil review2
    assert_equal 4, review2.stars
    assert_equal "Complex and engaging.", review2.review_text
  end
end