class Group < ApplicationRecord
  has_and_belongs_to_many :users, join_table: 'memberships', foreign_key: 'group_id'
end
