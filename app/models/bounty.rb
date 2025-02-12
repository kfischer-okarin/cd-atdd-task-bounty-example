class Bounty < ApplicationRecord
  belongs_to :posted_by, class_name: "User"

  validates :title, presence: true
  validates :reward, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :posted_by, presence: true
end
