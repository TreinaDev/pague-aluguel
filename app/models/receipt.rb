class Receipt < ApplicationRecord
  belongs_to :bill
  has_one_attached :file

  validates :file, attached: true,
                   content_type: { in: ['image/jpeg', 'image/png', 'application/pdf'],
                                   message: I18n.t('file_must_be_png_jpg_or_pdf') },
                   size: { less_than: 5.megabytes,
                           message: I18n.t('file_too_large') }

  def self.follow_redirects(url)
    connection = Faraday.new do |conn|
      conn.response :follow_redirects
      conn.adapter Faraday.default_adapter
    end

    connection.get(url)
  end
end
