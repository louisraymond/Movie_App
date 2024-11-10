# test/controllers/movies_controller_test.rb

require 'test_helper'

class MoviesControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Create sample directors
    @director1 = Director.create!(name: "Christopher Nolan")
    @director2 = Director.create!(name: "Dominic Sena")

    # Create sample actors
    @actor1 = Actor.create!(name: "Leonardo Di Caprio")
    @actor2 = Actor.create!(name: "Nicolas Cage")

    # Create sample filming locations
    @location1 = FilmingLocation.create!(location: "Los Angeles", country: "US")
    @location2 = FilmingLocation.create!(location: "Bedfordshire", country: "UK")

    # Create sample movies
    @movie1 = Movie.create!(
      title: "Inception",
      description: "A thief who steals corporate secrets...",
      year: 2010,
      director: @director1
    )
    @movie1.actors << @actor1
    @movie1.filming_locations << @location1

    @movie2 = Movie.create!(
      title: "Gone in 60 seconds",
      description: "A retired master car thief...",
      year: 2000,
      director: @director2
    )
    @movie2.actors << @actor2
    @movie2.filming_locations << @location1
  end

  # Existing test for displaying movies
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

  # New test for searching movies by actor
  test "should search movies by actor" do
    # Search for Leonardo Di Caprio
    get movies_url, params: { actor: "Leonardo" }
    assert_response :success

    # Check that only "Inception" is displayed
    assert_select 'table' do
      assert_select 'tbody tr', 1
      assert_select 'td', text: @movie1.title
      assert_select 'td', text: @movie2.title, count: 0
    end

    # Search for Nicolas Cage
    get movies_url, params: { actor: "Nicolas" }
    assert_response :success

    # Check that only "Gone in 60 seconds" is displayed
    assert_select 'table' do
      assert_select 'tbody tr', 1
      assert_select 'td', text: @movie2.title
      assert_select 'td', text: @movie1.title, count: 0
    end

    # Search for an actor not present
    get movies_url, params: { actor: "Tom Hanks" }
    assert_response :success

    # Check that no movies are displayed and a message is shown
    assert_select 'table' do
      assert_select 'tbody tr', 0
    end
    assert_select 'p', text: 'No movies available.', count: 1
  end
end
