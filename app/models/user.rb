class User < ApplicationRecord
  has_many :posted_bounties, class_name: "Bounty", foreign_key: "posted_by_id"

  validates :name, presence: true, uniqueness: true
end
