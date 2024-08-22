class Organization < ApplicationRecord
    has_many :articles
    has_many :memberships, dependent: :destroy
    has_many :users, through: :memberships 
end
