require 'test_helper'

class DirectorTest < ActiveSupport::TestCase
  test "should be valid with a name" do
    director = Director.new(name: "Christopher Nolan")
    assert director.valid?
  end

  test "should be invalid without a name" do
    director = Director.new
    assert_not director.valid?
    assert_includes director.errors[:name], "can't be blank"
  end

  test "should have many movies" do
    director = Director.new
    assert_respond_to director, :movies
  end
end