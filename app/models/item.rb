class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates :name, presence: true, format: {with: /[a-zA-Z]/}
  validates :description, presence: true, format: {with: /[a-zA-Z]/}
  validates :unit_price, presence: true, numericality: true
  validates :merchant_id, presence: true, numericality: true
end
