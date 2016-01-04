class ChangePassword < Task

  attr_accessor :login, :email, :password, :password_confirmation, :environment_id

  def self.human_attribute_name(attrib)
    case attrib.to_sym
    when :login:
      _('Username')
    when :email
      _('e-mail')
    when :password
      _('Password')
    when :password_confirmation
      _('Password Confirmation')
    else
      _(self.superclass.human_attribute_name(attrib))
    end
  end

  ###################################################
  # validations for creating a ChangePassword task 
  
  validates_presence_of :login, :email, :environment_id, :on => :create, :message => _('must be filled in')

  validates_format_of :email, :on => :create, :with => Noosfero::Constants::EMAIL_FORMAT, :if => (lambda { |obj| !obj.email.blank? })

  validates_each :login, :on => :create do |data,attr,value|
    unless data.login.blank? || data.email.blank?
      user = User.find_by_login_and_environment_id(data.login, data.environment_id)
      if user.nil? 
        data.errors.add(:login, _('is invalid or user does not exists.'))
      else
        if user.email != data.email
          data.errors.add(:email, _('does not match the username you filled in'))
        end
      end
    end
  end

  before_validation_on_create do |change_password|
    change_password.requestor = Person.find_by_identifier_and_environment_id(change_password.login, change_password.environment_id)
  end

  ###################################################
  # validations for updating a ChangePassword task 

  # only require the new password when actually changing it.
  validates_presence_of :password, :on => :update, :if => lambda { |change| change.status != Task::Status::CANCELLED }
  validates_presence_of :password_confirmation, :on => :update, :if => lambda { |change| change.status != Task::Status::CANCELLED }
  validates_confirmation_of :password, :if => lambda { |change| change.status != Task::Status::CANCELLED }

  def title
    _("Change password")
  end

  def information
    {:message => _('%{requestor} wants to change its password.')}
  end

  def icon
    {:type => :profile_image, :profile => requestor, :url => requestor.url}
  end

  def perform
    user = self.requestor.user
    user.force_change_password!(self.password, self.password_confirmation)
  end

  def target_notification_description
    _('%{requestor} wants to change its password.') % {:requestor => requestor.name}
  end

  # overriding messages
  
  def task_cancelled_message
    _('Your password change request was cancelled at %s.') % Time.now.to_s
  end

  def task_finished_message
    _('Your password was changed successfully.')
  end

  include ActionController::UrlWriter
  def task_created_message
    hostname = self.requestor.environment.default_hostname
    code = self.code
    url = url_for(:host => hostname, :controller => 'account', :action => 'new_password', :code => code)

    lambda do
      _("In order to change your password, please visit the following address:\n\n%s") % url 
    end
  end

  def environment
    self.requestor.environment
  end

end
