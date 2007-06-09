#require 'lib/rake_helper'

desc "Check swap for expiry"
task :check_expire => [:environment] do
  @swap = Swap.current
  RakeHelper.new_swap if @swap.deadline.just_passed?
  RakeHelper.make_sets if @swap.registration_deadline.just_passed?
  RakeHelper.hassle_slowpokes if @swap.mailing_reminder.just_passed?
  RakeHelper.remind_registration if @swap.registration_reminder.just_passed?
end

desc "Send mail from queue"
task :sendmail => [:environment] do
  system "ruby #{RAILS_ROOT}/vendor/ar_mailer-1.1.0/bin/ar_sendmail -b #{SENDMAIL_BATCH_SIZE} -o"
end