class User < ActiveRecord::Base
  ROLES = %w(admin admin_1 admin_2 partner partner_1 partner_2 contractor).freeze

  validates_presence_of :first_name, :last_name, :email

  belongs_to :creator, :class_name => "User"
  attr_protected :creator

  acts_as_authentic
  acts_as_authorization_subject

  def role
    ROLES.detect { |role| self.has_role?(role) }
  end

  def admin?
    !!(role =~ /admin/)
  end

  def partner?
    !!(role =~ /partner/)
  end
  
  def contractor?
    has_role? :contractor
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
end
