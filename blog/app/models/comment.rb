class Comment < ApplicationRecord
  include Visible

  belongs_to :article
  validates :commenter, presence: true

end
