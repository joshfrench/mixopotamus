class RakeHelper
  def self.new_swap
    Swap.create :deadline => SWAP_LENGTH.from_now.at_midnight
  end

  def self.make_sets
    swap = Swap.current
    swap.make_sets
    # fill short set, if it exists
    swap.swapsets.reject { |set| SWAPSET_SIZE == set.users.size }.each do |short_set|
      swap.fill_set short_set
    end
  end

  def self.hassle_slowpokes
    Swap.current.users.each { |user| UserNotifier.deliver_mailing_reminder(user) }
  end

  def self.remind_registration
    Swap.current.users.each { |user| UserNotifier.deliver_registration_reminder(user) }
  end
  
  def self.send_signup_report
    AdminNotifier.deliver_new_users
  end
  
end