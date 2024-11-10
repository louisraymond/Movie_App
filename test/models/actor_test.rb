require 'test_helper'

class ActorTest < ActiveSupport::TestCase
  test "should be valid with a name" do
    actor = Actor.new(name: "Leonardo Di Caprio")
    assert actor.valid?
  end

  test "should be invalid without a name" do
    actor = Actor.new
    assert_not actor.valid?
    assert_includes actor.errors[:name], "can't be blank"
  end

  test "should have many movies" do
    actor = Actor.new
    assert_respond_to actor, :movies
  end
end