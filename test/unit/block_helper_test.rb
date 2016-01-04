require File.dirname(__FILE__) + '/../test_helper'

class BlockHelperTest < ActiveSupport::TestCase

  include BlockHelper
  include ActionView::Helpers::TagHelper

  should 'escape title html' do
    assert_no_match /<b>/, block_title('<b>test</b>')
    assert_match /&lt;b&gt;test&lt;\/b&gt;/, block_title('<b>test</b>')
  end

end
