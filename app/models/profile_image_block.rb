class ProfileImageBlock < Block

  settings_items :show_name, :type => :boolean, :default => false

  def self.description
    _('Profile Image')
  end

  def help
    _('This block presents the profile image')
  end

  def content(args={})
    block = self
    s = show_name
    lambda do
      render :file => 'blocks/profile_image', :locals => { :block => block, :show_name => s}
    end
  end

  def editable?
    true
  end

  def cacheable?
    false
  end

end
