class SpaminatorPlugin::Report < Noosfero::Plugin::ActiveRecord
  serialize :failed, Hash

  belongs_to :environment

  validates_presence_of :environment

  named_scope :from, lambda { |environment| {:conditions => {:environment_id => environment}}}

  def after_initialize
    self.failed ||= {:people => [], :comments => []}
  end

  def spams
    spams_by_no_network + spams_by_content
  end

  def spammers
    spammers_by_no_network + spammers_by_comments
  end

  def formated_date
    created_at.strftime("%Y-%m-%d")
  end

  def details
    # TODO Implement some decent visualization
    inspect
  end
end
