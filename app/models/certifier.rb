class Certifier < ActiveRecord::Base

  SEARCHABLE_FIELDS = {
    :name => 10,
    :description => 3,
    :link => 1,
  }

  belongs_to :environment

  has_many :qualifier_certifiers, :dependent => :destroy
  has_many :qualifiers, :through => :qualifier_certifiers

  has_many :product_qualifiers
  has_many :products, :through => :product_qualifiers, :source => :product

  validates_presence_of :environment_id
  validates_presence_of :name

  def destroy
    product_qualifiers.each { |pq| pq.update_attributes! :certifier => nil }
    super
  end

  def link
    self[:link] || ''
  end

  def <=>(b)
    self.name.downcase.transliterate <=> b.name.downcase.transliterate
  end

end
