require "#{File.dirname(__FILE__)}/../test_helper"

class BlocksTest < ActionController::IntegrationTest
  def blog_on_article_block_bootstrap
    profile = fast_create(Profile)
    blog = fast_create(Blog, :name => 'Blog', :profile_id => profile.id)
    fast_create(TinyMceArticle, :name => "First Post", :profile_id => profile.id, :parent_id => blog.id, :body => '<p> Wasserstoffbombe </p>')
    fast_create(TinyMceArticle, :name => "A Post", :profile_id => profile.id, :parent_id => blog.id, :body => '<p>Lorem ipsum dolor sit amet</p> <p>Second paragraph</p>')
    block = ArticleBlock.new
    block.article = blog
    profile.boxes << Box.new
    profile.boxes.first.blocks << block
    return block
  end

  should 'allow blog as article block content' do
    block = blog_on_article_block_bootstrap
    get "/profile/#{block.owner.identifier}"
    assert_match(/Lorem ipsum dolor sit amet/, @response.body)
  end

  should 'display short version for block posts on article block' do
    block = blog_on_article_block_bootstrap
    get "/profile/#{block.owner.identifier}"
    assert_no_match(/Second paragraph/, @response.body)
  end

  should 'display full version for block posts on article block' do
    block = blog_on_article_block_bootstrap
    block.visualization_format = 'full'
    block.save!
    get "/profile/#{block.owner.identifier}"
    assert_match(/Second paragraph/, @response.body)
  end

  should 'display configured number of blog posts on article block' do
    block = blog_on_article_block_bootstrap
    block.posts_per_page = 2
    block.save!
    get "/profile/#{block.owner.identifier}"
    assert_match(/Lorem ipsum dolor sit amet/, @response.body)
    assert_match(/Wasserstoffbombe/, @response.body)
  end

  should 'link correctly in pagination' do
    block = blog_on_article_block_bootstrap
    p = block.owner
    b = block.article
    f = fast_create(Folder, :name => 'Folder1', :profile_id => p.id)
    b.parent = f
    b.save!
    get "/profile/#{block.owner.identifier}"
    assert_tag :tag => 'a', :attributes => { :href => "/#{p.identifier}/#{f.slug}/#{b.slug}?npage=2" }
  end

end
