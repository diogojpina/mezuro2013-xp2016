class LocationBlock < Block

  settings_items :zoom, :type => :integer, :default => 4
  settings_items :map_type, :type => :string, :default => 'roadmap'

  def self.description
    _('Location map')
  end

  def help
    _('Shows where the profile is on the material world.')
  end

  def content(args={})
    block = self
    profile = self.owner
    lambda do
      render :file => 'blocks/location', :locals => {:block => block, :profile => profile}
    end
  end

end
