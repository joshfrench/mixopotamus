BATCH_SIZE = 4

class Time
  def just_passed?
    (Time.now-self).between?(0, 24.hours)
  end
end

def new_swap
  Swap.create :deadline => SWAP_LENGTH.from_now.at_midnight
end

def make_sets
  swap = Swap.current
  swap.make_sets
  # fill short set, if it exists
  swap.swapsets.reject { |set| SWAPSET_SIZE == set.users.size }.each do |short_set|
    swap.fill_set short_set
  end
end

def hassle_slowpokes
  Swap.current.users.each { |user| UserNotifier.deliver_mailing_reminder(user) }
end

def remind_registration
  Swap.current.users.each { |user| UserNotifier.deliver_registration_reminder(user) }
end

desc "Check swap for expiry"
task :check_expire => [:environment] do
  @swap = Swap.current
  new_swap if @swap.deadline.just_passed?
  make_sets if @swap.registration_deadline.just_passed?
  hassle_slowpokes if @swap.mailing_reminder.just_passed?
  remind_registration if @swap.registration_reminder.just_passed?
end


task :make_sets => :new_swap

desc "Send mail from queue"
task :sendmail => [:environment] do
  system "ruby #{RAILS_ROOT}/vendor/ar_mailer-1.1.0/bin/ar_sendmail -b #{BATCH_SIZE} -o"
end