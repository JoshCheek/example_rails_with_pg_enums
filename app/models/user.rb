class User < ApplicationRecord
  validates_enum :status, message: "Invalid enum value"

  def self.statuses
    @statuses ||= connection.enums[:user_status]
  end

  statuses.each do |status|
    scope status, -> { where status: status }
  end
end
