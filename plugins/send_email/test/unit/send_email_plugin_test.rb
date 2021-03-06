require File.dirname(__FILE__) + '/../../../../test/test_helper'

class SendEmailPluginTest < ActiveSupport::TestCase

  def setup
    @plugin = SendEmailPlugin.new
    @context = mock()
    @plugin.context = @context
  end

  should 'return true to stylesheet?' do
    assert @plugin.stylesheet?
  end

  should 'have admin controller' do
    assert SendEmailPlugin.has_admin_url?
  end

  should 'expand macro in parse_content event' do
    @plugin.context.stubs(:profile).returns(nil)
    assert_match /plugin\/send_email\/deliver/, @plugin.parse_content("expand this macro {sendemail}")
  end

  should 'expand macro in parse_content event on profile context' do
    @plugin.context.stubs(:profile).returns(fast_create(Community))
    assert_match /profile\/#{@plugin.context.profile.identifier}\/plugin\/send_email\/deliver/, @plugin.parse_content("expand this macro {sendemail}")
  end

end
