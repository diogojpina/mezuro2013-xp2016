if File.writable?(Rails.root)
  # create the symlink to the default theme if it does not exist
  default = File.join(RAILS_ROOT, 'public', 'designs', 'icons', 'default')
  if !File.exists?(default)
    File.symlink('tango', default)
  end

  # create a symlink to system-wide Tango icon set if it does not exist
  tango_symlink = File.join(RAILS_ROOT, 'public', 'designs', 'icons', 'tango', 'Tango')
  if !File.exist?(tango_symlink)
    File.symlink('/usr/share/icons/Tango', tango_symlink)
  end
end
