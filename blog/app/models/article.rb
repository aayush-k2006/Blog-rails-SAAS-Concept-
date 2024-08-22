class Article < ApplicationRecord
    include Visible
    
    belongs_to :user
    belongs_to :organization

    has_many :comments, dependent: :destroy
    
    validates :title, presence: true, length: { minimum: 5 }
    validates :text, presence: true
end
