class Holding < ApplicationRecord
    validates :crypto, presence: true
    validates :amount, presence: true, numericality: true
end
