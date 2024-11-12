# test/controllers/movies_controller_test.rb

require 'test_helper'

class MoviesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @director1 = Director.create!(name: "Christopher Nolan")
    @director2 = Director.create!(name: "Dominic Sena")

    @actor1 = Actor.create!(name: "Leonardo Di Caprio")
    @actor2 = Actor.create!(name: "Nicolas Cage")

    @location1 = FilmingLocation.create!(location: "Los Angeles", country: "US")
    @location2 = FilmingLocation.create!(location: "Bedfordshire", country: "UK")

    @movie1 = Movie.create!(
      title: "Inception",
      description: "A thief who steals corporate secrets...",
      year: 2010,
      director: @director1
    )
    @movie1.actors << @actor1
    @movie1.filming_locations << @location1

    @movie2 = Movie.create!(
      title: "Gone in 60 Seconds",
      description: "A retired master car thief...",
      year: 2000,
      director: @director2
    )
    @movie2.actors << @actor2
    @movie2.filming_locations << @location1

    Review.create!(movie: @movie1, stars: 5)
    Review.create!(movie: @movie1, stars: 4)
    Review.create!(movie: @movie2, stars: 3)
    Review.create!(movie: @movie2, stars: 2)
  end

  test "should get index and display movies" do
    get movies_url
    assert_response :success
    assert_select 'h1', 'Movies Overview'

    assert_select 'td', text: @movie1.title
    assert_select 'td', text: @movie2.title

    assert_select 'td', text: @movie1.year.to_s
    assert_select 'td', text: @director1.name
    assert_select 'td', text: @actor1.name
    assert_select 'td', text: @location1.location
  end

  test "should search movies by actor" do
    get movies_url, params: { actor: "Leonardo" }
    assert_response :success

    assert_select 'table' do
      assert_select 'tbody tr', 1
      assert_select 'td', text: @movie1.title
      assert_select 'td', text: @movie2.title, count: 0
    end

    get movies_url, params: { actor: "Nicolas" }
    assert_response :success

    assert_select 'table' do
      assert_select 'tbody tr', 1
      assert_select 'td', text: @movie2.title
      assert_select 'td', text: @movie1.title, count: 0
    end

    get movies_url, params: { actor: "Tom Hanks" }
    assert_response :success

    assert_select 'table' do
      assert_select 'tbody tr', 0
    end
    assert_select 'p', text: 'No movies available.', count: 1
  end

  test "should sort movies by average stars ascending" do
    get movies_url, params: { sort: 'stars_asc' }
    assert_response :success

    movie_titles = css_select('table tbody tr td:first-child').map(&:text)

    assert_equal [@movie2.title, @movie1.title], movie_titles
  end

  test "should sort movies by average stars descending" do
    get movies_url, params: { sort: 'stars_desc' }
    assert_response :success

    movie_titles = css_select('table tbody tr td:first-child').map(&:text)

    assert_equal [@movie1.title, @movie2.title], movie_titles
  end
end
