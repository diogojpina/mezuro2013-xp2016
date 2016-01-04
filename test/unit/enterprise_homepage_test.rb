require File.dirname(__FILE__) + '/../test_helper'

class EnterpriseHomepageTest < ActiveSupport::TestCase
  
  def setup
    @profile = create_user('testing').person
    @product_category = fast_create(ProductCategory, :name => 'Products')
  end
  attr_reader :profile

  should 'provide a proper short description' do
    assert_kind_of String, EnterpriseHomepage.short_description
  end

  should 'provide a proper description' do
    assert_kind_of String, EnterpriseHomepage.description
  end

  should 'return a valid body' do
    e = EnterpriseHomepage.new(:name => 'sample enterprise homepage')
    assert_not_nil e.to_html
  end

  should 'can display hits' do
    a = EnterpriseHomepage.new(:name => 'Test article')
    assert_equal false, a.can_display_hits?
  end

end
