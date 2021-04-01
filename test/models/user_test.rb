require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "the default status is 'active'" do
    assert_equal 'active', User.new.status
  end

  test "status can't be nil" do
    refute User.new(status: nil).valid?
  end


  # annoyingly, couldn't get the message to be nice, it seems to ignore %{value}, for example
  test "only accepts valid status values" do
    User.connection.enums[:user_status].each do |status|
      assert User.new(status: status).valid?
    end

    user = User.new(status: "nonsense").tap &:valid?
    assert_equal ["Invalid enum value"], user.errors[:status]
  end


  test "has scopes to query for the enum types" do
    User.delete_all # b/c we don't have database cleaner in this example app

    now    = Time.zone.now
    common = { created_at: now, updated_at: now }
    User.insert_all [
      { name: 'a', status: 'active',   **common },
      { name: 'b', status: 'inactive', **common },
      { name: 'c', status: 'active',   **common },
      { name: 'd', status: 'inactive', **common },
    ]
    assert_equal %w[a c], User.active.pluck(:name)
    assert_equal %w[b d], User.inactive.pluck(:name)
  end
end
