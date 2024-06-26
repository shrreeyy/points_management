class Configuration < ApplicationRecord
  validates :burn_ratio, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :earn_ratio, numericality: { greater_than_or_equal_to: 0 }, presence: true

  def self.current
    Configuration.first_or_initialize
  end
end
