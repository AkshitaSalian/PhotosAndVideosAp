class Upload < ApplicationRecord
	validates_presence_of :title, :description
	belongs_to :user
	has_one_attached :attachment
	searchkick word_middle: [:title, :description]
	scope :videos, -> { where(type: 'Video') } 
	scope :images, -> { where(type: 'Image') } 

end
