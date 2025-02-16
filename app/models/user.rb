class User < ApplicationRecord
  has_many :posted_bounties, class_name: "Bounty", foreign_key: "posted_by_id"

  validates :name, presence: true, uniqueness: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
end
