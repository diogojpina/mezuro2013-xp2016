class FavoriteEnterprisesBlock < ProfileListBlock

  def default_title
    __('Favorite Enterprises')
  end

  def help
    __('This block lists your favorite enterprises.')
  end

  def self.description
    __('Favorite Enterprises')
  end

  def footer
    owner = self.owner
    return '' unless owner.kind_of?(Person)
    lambda do
      link_to __('View all'), :profile => owner.identifier, :controller => 'profile', :action => 'favorite_enterprises'
    end
  end

  def profiles
    owner.favorite_enterprises
  end

end
