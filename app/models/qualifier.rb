class Qualifier < ActiveRecord::Base

  SEARCHABLE_FIELDS = {
    :name => 1,
  }

  belongs_to :environment

  has_many :qualifier_certifiers, :dependent => :destroy
  has_many :certifiers, :through => :qualifier_certifiers

  has_many :product_qualifiers, :dependent => :destroy
  has_many :products, :through => :product_qualifiers, :source => :product

  validates_presence_of :environment_id
  validates_presence_of :name

  def <=>(b)
    self.name.downcase.transliterate <=> b.name.downcase.transliterate
  end

end
