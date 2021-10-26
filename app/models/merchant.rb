class Merchant < ApplicationRecord
  has_many :items

  def self.find_by_name(query)
    where("name ilike ?", "%#{query}%").order(:name).first
  end
end
