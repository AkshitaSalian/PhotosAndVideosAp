class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :uploads, dependent: :destroy
  has_many :favourites, dependent: :destroy

  has_one_attached :profile_photo

  delegate :videos, :images, to: :uploads
end
