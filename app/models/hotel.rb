# == Schema Information
#
# Table name: hotels
#
#  id                 :integer          not null, primary key
#  title              :string
#  breakfast_included :boolean
#  room_description   :text
#  room_price         :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer
#  image              :string
#  rating             :decimal(, )      default(0.0)
#

class Hotel < ActiveRecord::Base
  belongs_to :user
  has_one :address, dependent: :destroy
  has_many :reviews, dependent: :destroy
  mount_uploader :image, ImageUploader

  scope :higher_rating, -> { order(rating: :desc) }


  accepts_nested_attributes_for :address
  validates_associated :address
  validates :title,            presence: true
  validates :room_description, presence: true
  validates :room_price,       presence: true

  def recalculate_rating
    if self.reviews.nil?
      self.rating = 0
    else
      self.rating = self.reviews.average(:rating).round(3)
    end
    self.save
  end
end
