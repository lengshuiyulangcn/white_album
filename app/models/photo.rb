class Photo < ActiveRecord::Base
  validates :title, presence: true
  mount_uploader :image, ImageUploader
  belongs_to :album
  self.per_page = 10

  def self.parse_filename(filename)
    filename.gsub!(/(.jpg|.png|.jpeg)/, '')
    return {title: "no_name"} unless filename =~ /^\w*-(([a-zA-Z])*(_|$))*/
    filename.split('_').join(' ')
    {title: filename}
  end
end
