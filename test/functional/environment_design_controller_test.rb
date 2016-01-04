require File.dirname(__FILE__) + '/../test_helper'
require 'environment_design_controller'

# Re-raise errors caught by the controller.
class EnvironmentDesignController; def rescue_action(e) raise e end; end

class EnvironmentDesignControllerTest < ActionController::TestCase

  ALL_BLOCKS = [ArticleBlock, LoginBlock, EnvironmentStatisticsBlock, RecentDocumentsBlock, EnterprisesBlock, CommunitiesBlock, PeopleBlock, SellersSearchBlock, LinkListBlock, FeedReaderBlock, SlideshowBlock, HighlightsBlock, FeaturedProductsBlock, CategoriesBlock, RawHTMLBlock, TagsBlock ]

  def setup
    @controller = EnvironmentDesignController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    Noosfero::Plugin::Manager.any_instance.stubs(:enabled_plugins).returns([])
  end

  def test_local_files_reference
    assert_local_files_reference
  end

  def test_valid_xhtml
    assert_valid_xhtml
  end

  should 'indicate only actual blocks as such' do
    assert(@controller.available_blocks.all? {|item| item.new.is_a? Block})
  end

  ALL_BLOCKS.map do |block|
    define_method "test_should_#{block.to_s}_is_available" do
      assert_includes @controller.available_blocks,block
    end
  end

  should 'all available block in test' do
    assert_equal ALL_BLOCKS, @controller.available_blocks
  end

  should 'be able to edit LinkListBlock' do
    login_as(create_admin_user(Environment.default))
    l = LinkListBlock.create!(:links => [{:name => 'link 1', :address => '/address_1'}])
    Environment.default.boxes.create!
    Environment.default.boxes.first.blocks << l
    get :edit, :id => l.id
    assert_tag :tag => 'input', :attributes => { :name => 'block[links][][name]' }
    assert_tag :tag => 'input', :attributes => { :name => 'block[links][][address]' }
  end

  should 'be able to save LinkListBlock' do
    login_as(create_admin_user(Environment.default))
    l = LinkListBlock.create!()
    Environment.default.boxes.create!
    Environment.default.boxes.first.blocks << l
    post :save, :id => l.id, :block => { :links => [{:name => 'link 1', :address => '/address_1'}] }
    l.reload
    assert_equal [{'name' => 'link 1', 'address' => '/address_1'}], l.links
  end

  should 'be able to edit ArticleBlock with portal community' do
    login_as(create_admin_user(Environment.default))
    l = ArticleBlock.create!
    e = Environment.default
    e.boxes.create!
    e.boxes.first.blocks << l
    community = mock()
    Environment.any_instance.stubs(:portal_community).returns(community)
    article = fast_create(Article)
    community.stubs(:articles).returns([article])
    get :edit, :id => l.id
    assert_tag :tag => 'select', :attributes => { :name => 'block[article_id]' }
  end

  should 'be able to edit ArticleBlock without portal community' do
    login_as(create_admin_user(Environment.default))
    l = ArticleBlock.create!
    e = Environment.default
    e.boxes.create!
    e.boxes.first.blocks << l
    community = mock()
    Environment.any_instance.expects(:portal_community).returns(nil)
    get :edit, :id => l.id
    assert_tag :tag => 'p', :attributes => { :id => 'no_portal_community' }
  end

  should 'be able to edit EnvironmentStatisticsBlock' do
    login_as(create_admin_user(Environment.default))
    b = EnvironmentStatisticsBlock.create!
    e = Environment.default
    e.boxes.create!
    e.boxes.first.blocks << b
    get :edit, :id => b.id
    assert_tag :tag => 'input', :attributes => { :id => 'block_title' }
  end

  should 'be able to edit EnterprisesBlock' do
    login_as(create_admin_user(Environment.default))
    b = EnterprisesBlock.create!
    e = Environment.default
    e.boxes.create!
    e.boxes.first.blocks << b
    get :edit, :id => b.id
    assert_tag :tag => 'input', :attributes => { :id => 'block_limit' }
  end

  should 'be able to edit PeopleBlock' do
    login_as(create_admin_user(Environment.default))
    b = PeopleBlock.create!
    e = Environment.default
    e.boxes.create!
    e.boxes.first.blocks << b
    get :edit, :id => b.id
    assert_tag :tag => 'input', :attributes => { :id => 'block_limit' }
  end

  should 'be able to edit SlideshowBlock' do
    login_as(create_admin_user(Environment.default))
    b = SlideshowBlock.create!
    e = Environment.default
    e.boxes.create!
    e.boxes.first.blocks << b
    get :edit, :id => b.id
    assert_tag :tag => 'select', :attributes => { :id => 'block_gallery_id' }
  end

  should 'be able to edit LoginBlock' do
    login_as(create_admin_user(Environment.default))
    b = LoginBlock.create!
    e = Environment.default
    e.boxes.create!
    e.boxes.first.blocks << b
    get :edit, :id => b.id
    assert_tag :tag => 'input', :attributes => { :id => 'block_title' }
  end

  should 'be able to edit RecentDocumentsBlock' do
    login_as(create_admin_user(Environment.default))
    b = RecentDocumentsBlock.create!
    e = Environment.default
    e.boxes.create!
    e.boxes.first.blocks << b
    get :edit, :id => b.id
    assert_tag :tag => 'input', :attributes => { :id => 'block_limit' }
  end

  should 'be able to edit CommunitiesBlock' do
    login_as(create_admin_user(Environment.default))
    b = CommunitiesBlock.create!
    e = Environment.default
    e.boxes.create!
    e.boxes.first.blocks << b
    get :edit, :id => b.id
    assert_tag :tag => 'input', :attributes => { :id => 'block_limit' }
  end

  should 'be able to edit SellersSearchBlock' do
    login_as(create_admin_user(Environment.default))
    b = SellersSearchBlock.create!
    e = Environment.default
    e.boxes.create!
    e.boxes.first.blocks << b
    get :edit, :id => b.id
    assert_tag :tag => 'input', :attributes => { :id => 'block_title' }
  end

  should 'be able to edit FeedReaderBlock' do
    login_as(create_admin_user(Environment.default))
    b = FeedReaderBlock.create!
    e = Environment.default
    e.boxes.create!
    e.boxes.first.blocks << b
    get :edit, :id => b.id
    assert_tag :tag => 'input', :attributes => { :id => 'block_address' }
  end

  should 'be able to edit TagsBlock' do
    login_as(create_admin_user(Environment.default))
    b = TagsBlock.create!
    e = Environment.default
    e.boxes.create!
    e.boxes.first.blocks << b
    get :edit, :id => b.id
    assert_tag :tag => 'input', :attributes => { :id => 'block_title' }
  end

  should 'create back link to environment control panel' do
    Environment.default.boxes.create!.blocks << CommunitiesBlock.new
    Environment.default.boxes.create!.blocks << EnterprisesBlock.new
    Environment.default.boxes.create!.blocks << LoginBlock.new
    login_as(create_admin_user(Environment.default))
    get :index

    assert_tag :tag => 'a', :attributes => {:href => '/admin'}, :child => {:tag => 'span', :content => "Back to control panel"}
  end

  should 'render add a new block functionality' do
    login_as(create_admin_user(Environment.default))
    get :add_block

    assert_response :success
    assert_template 'add_block'
  end

  should 'a environment block plugin add new blocks for environments' do
    class CustomBlock1 < Block; end;

    class TestBlockPlugin < Noosfero::Plugin
      def self.extra_blocks
        {
          CustomBlock1 => {:type => Environment},
        }
      end
    end

    Noosfero::Plugin::Manager.any_instance.stubs(:enabled_plugins).returns([TestBlockPlugin.new])
    assert @controller.available_blocks.include?(CustomBlock1)
  end

  should 'a person, enterprise and community blocks plugins do not add new blocks for environments' do
    class CustomBlock1 < Block; end;
    class CustomBlock2 < Block; end;
    class CustomBlock3 < Block; end;
    class CustomBlock4 < Block; end;

    class TestBlockPlugin < Noosfero::Plugin
      def self.extra_blocks
        {
          CustomBlock1 => {:type => Environment},
          CustomBlock2 => {:type => Enterprise},
          CustomBlock3 => {:type => Community},
          CustomBlock4 => {:type => Person},
        }
      end
    end

    Noosfero::Plugin::Manager.any_instance.stubs(:enabled_plugins).returns([TestBlockPlugin.new])
    assert @controller.available_blocks.include?(CustomBlock1)
    assert !@controller.available_blocks.include?(CustomBlock2)
    assert !@controller.available_blocks.include?(CustomBlock3)
    assert !@controller.available_blocks.include?(CustomBlock4)
  end

  should 'a block plugin with center position add new blocks only in this position' do
    class CustomBlock1 < Block; end;
    class CustomBlock2 < Block; end;
    class CustomBlock3 < Block; end;
    class CustomBlock4 < Block; end;
    class CustomBlock5 < Block; end;
    class CustomBlock6 < Block; end;
    class CustomBlock7 < Block; end;
    class CustomBlock8 < Block; end;
    class CustomBlock9 < Block; end;

    class TestBlockPlugin < Noosfero::Plugin
      def self.extra_blocks
        {
          CustomBlock1 => {:type => Environment, :position => [1]},
          CustomBlock2 => {:type => Environment, :position => 1},
          CustomBlock3 => {:type => Environment, :position => '1'},
          CustomBlock4 => {:type => Environment, :position => [2]},
          CustomBlock5 => {:type => Environment, :position => 2},
          CustomBlock6 => {:type => Environment, :position => '2'},
          CustomBlock7 => {:type => Environment, :position => [3]},
          CustomBlock8 => {:type => Environment, :position => 3},
          CustomBlock9 => {:type => Environment, :position => '3'},
        }
      end
    end

    Noosfero::Plugin::Manager.any_instance.stubs(:enabled_plugins).returns([TestBlockPlugin.new])
    login_as(create_admin_user(Environment.default))
    get :add_block

    assert_response :success
    assert @controller.instance_variable_get('@center_block_types').include?(CustomBlock1)
    assert @controller.instance_variable_get('@center_block_types').include?(CustomBlock2)
    assert @controller.instance_variable_get('@center_block_types').include?(CustomBlock3)
    assert !@controller.instance_variable_get('@center_block_types').include?(CustomBlock4)
    assert !@controller.instance_variable_get('@center_block_types').include?(CustomBlock5)
    assert !@controller.instance_variable_get('@center_block_types').include?(CustomBlock6)
    assert !@controller.instance_variable_get('@center_block_types').include?(CustomBlock7)
    assert !@controller.instance_variable_get('@center_block_types').include?(CustomBlock8)
    assert !@controller.instance_variable_get('@center_block_types').include?(CustomBlock9)
  end

  should 'a block plugin with side position add new blocks only in this position' do
    class CustomBlock1 < Block; end;
    class CustomBlock2 < Block; end;
    class CustomBlock3 < Block; end;
    class CustomBlock4 < Block; end;
    class CustomBlock5 < Block; end;
    class CustomBlock6 < Block; end;
    class CustomBlock7 < Block; end;
    class CustomBlock8 < Block; end;
    class CustomBlock9 < Block; end;

    class TestBlockPlugin < Noosfero::Plugin
      def self.extra_blocks
        {
          CustomBlock1 => {:type => Environment, :position => [1]},
          CustomBlock2 => {:type => Environment, :position => 1},
          CustomBlock3 => {:type => Environment, :position => '1'},
          CustomBlock4 => {:type => Environment, :position => [2]},
          CustomBlock5 => {:type => Environment, :position => 2},
          CustomBlock6 => {:type => Environment, :position => '2'},
          CustomBlock7 => {:type => Environment, :position => [3]},
          CustomBlock8 => {:type => Environment, :position => 3},
          CustomBlock9 => {:type => Environment, :position => '3'},
        }
      end
    end

    Noosfero::Plugin::Manager.any_instance.stubs(:enabled_plugins).returns([TestBlockPlugin.new])
    login_as(create_admin_user(Environment.default))
    get :add_block
    assert_response :success

    assert !@controller.instance_variable_get('@side_block_types').include?(CustomBlock1)
    assert !@controller.instance_variable_get('@side_block_types').include?(CustomBlock2)
    assert !@controller.instance_variable_get('@side_block_types').include?(CustomBlock3)
    assert @controller.instance_variable_get('@side_block_types').include?(CustomBlock4)
    assert @controller.instance_variable_get('@side_block_types').include?(CustomBlock5)
    assert @controller.instance_variable_get('@side_block_types').include?(CustomBlock6)
    assert @controller.instance_variable_get('@side_block_types').include?(CustomBlock7)
    assert @controller.instance_variable_get('@side_block_types').include?(CustomBlock8)
    assert @controller.instance_variable_get('@side_block_types').include?(CustomBlock9)
  end

  should 'a block plugin cannot be listed for unspecified types' do
    class CustomBlock1 < Block; end;
    class CustomBlock2 < Block; end;
    class CustomBlock3 < Block; end;
    class CustomBlock4 < Block; end;
    class CustomBlock5 < Block; end;
    class CustomBlock6 < Block; end;
    class CustomBlock7 < Block; end;
    class CustomBlock8 < Block; end;

    class TestBlockPlugin < Noosfero::Plugin
      def self.extra_blocks
        {
          CustomBlock1 => {:type => Person, :position => 1},
          CustomBlock2 => {:type => Community, :position => 1},
          CustomBlock3 => {:type => Enterprise, :position => 1},
          CustomBlock4 => {:type => Environment, :position => 1},
          CustomBlock5 => {:type => Person, :position => 2},
          CustomBlock6 => {:type => Community, :position => 3},
          CustomBlock7 => {:type => Enterprise, :position => 2},
          CustomBlock8 => {:type => Environment, :position => 3},
        }
      end
    end

    Noosfero::Plugin::Manager.any_instance.stubs(:enabled_plugins).returns([TestBlockPlugin.new])
    login_as(create_admin_user(Environment.default))
    get :add_block
    assert_response :success

    assert !@controller.instance_variable_get('@center_block_types').include?(CustomBlock1)
    assert !@controller.instance_variable_get('@center_block_types').include?(CustomBlock2)
    assert !@controller.instance_variable_get('@center_block_types').include?(CustomBlock3)
    assert @controller.instance_variable_get('@center_block_types').include?(CustomBlock4)
    assert !@controller.instance_variable_get('@side_block_types').include?(CustomBlock5)
    assert !@controller.instance_variable_get('@side_block_types').include?(CustomBlock6)
    assert !@controller.instance_variable_get('@side_block_types').include?(CustomBlock7)
    assert @controller.instance_variable_get('@side_block_types').include?(CustomBlock8)
  end

end
