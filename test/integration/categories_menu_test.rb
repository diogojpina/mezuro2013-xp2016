require "#{File.dirname(__FILE__)}/../test_helper"

class CategoriesMenuTest < ActionController::IntegrationTest

  def setup
    HomeController.any_instance.stubs(:get_layout).returns('application')
    SearchController.any_instance.stubs(:get_layout).returns('application')

    Category.delete_all
    @cat1 = Category.create!(:display_in_menu => true, :name => 'Food', :environment => Environment.default, :display_color => 1)
    @cat2 = Category.create!(:display_in_menu => true, :name => 'Vegetables', :environment => Environment.default, :parent => @cat1)

    # all categories must be shown for these tests 
    Category.any_instance.stubs(:display_in_menu?).returns(true)
  end

  should 'display link to categories' do
    get '/'
    assert_tag :attributes => { :id => 'cat_menu' }, :descendant => { :tag => 'a', :attributes => { :href => '/cat/food/vegetables' } }
  end

  should 'display link to sub-categories' do
    get '/cat/food'
    # there must be a link to the subcategory
    assert_tag :attributes => { :id => 'cat_menu' }, :descendant => { :tag => 'a', :attributes => { :href => '/cat/food/vegetables' } }
  end

  should "always link to category's initial page in category menu" do
    get '/search/products/food/vegetables'
    assert_tag :attributes => { :id => 'cat_menu' }, :descendant => { :tag => 'a', :attributes => { :href => '/cat/food/vegetables' } }
    assert_no_tag :attributes => { :id => 'cat_menu' }, :descendant => { :tag => 'a', :attributes => { :href => '/searchh/products/food/vegetables' } }
  end

  should 'cache the categories menu' do
    ActionView::Base.any_instance.expects(:cache).with(Environment.default.id.to_s + "_categories_menu")
    get '/'
  end

end
