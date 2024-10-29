class ShortenedUrl < ApplicationRecord
  validates :path, presence: true, uniqueness: true
  validates :target_url, presence: true, url: true

  has_many :clicks, dependent: :destroy

  before_validation :generate_path, if: -> { path.blank? }

  private

  def generate_path
    loop do
      self.path = to_base62(Counters::UrlCounter.increment!.value)
      break unless self.class.exists?(path: path)
    end
  end

  def to_base62(number)
    alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    base62 = ""
    while number.positive?
      number, remainder = number.divmod(62)
      base62.prepend(alphabet[remainder])
    end
    base62.empty? ? "0" : base62
  end
end
