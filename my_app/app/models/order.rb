class Order < ApplicationRecord
  belongs_to :founder, class_name: 'User', foreign_key: 'founder_id'
  has_and_belongs_to_many :purchasers, -> { distinct }, join_table: 'purchasers', foreign_key: 'order_id', class_name: 'User', uniq: true
end
