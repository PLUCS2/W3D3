# == Schema Information
#
# Table name: shortened_urls
#
#  id        :bigint           not null, primary key
#  long_url  :string           not null
#  short_url :string           not null
#  user_id   :integer          not null
#

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

  def num_clicks
    self.visits.count
  end

  def num_uniques
  #   is_ids = self.id
  # result = ApplicationRecord.connection.execute(<<-SQL, id: self.id)
  # SELECT
  #   *
  # FROM
  #   visits 
  # WHERE
  #   visits.short_url_id = :id ;
  # SQL
  # result
    # self.visitors.uniq.count

    self.visitors.select(:user_id).distinct.count
  end

  def num_recent_uniques
    self.visits.where("created_at < ?", 10.minutes.ago).distinct.count
  end


  belongs_to :submitter, 
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
    primary_key: :id, 
    foreign_key: :short_url_id, 
    class_name: :Visit
    
  has_many :visitors, 
    through: :visits, 
    source: :visitor

end
