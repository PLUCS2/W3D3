require 'securerandom'

class ShortenedUrl < ApplicationRecord
  validates :short_url, presence: true
  validates :short_url, uniqueness: true
  validates :long_url, presence: true
  validates :user_id, presence: true

  def self.random_code
    code = SecureRandom.base64
    until !ShortenedUrl.exists?(short_url: code)
      code = SecureRandom.base64
    end 
    code 
  end

  def self.url_shortener(long_url, user)
    code = ShortenedUrl.random_code
    ShortenedUrl.create!(short_url: code, long_url: long_url, user_id: user.id)
    code 
  end 

  belongs_to :submitter, 
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User
end