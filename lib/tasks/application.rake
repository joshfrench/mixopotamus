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

desc "Report new users"
task :send_signup_report => [:environment] do
  RakeHelper.send_signup_report if User.recent_signups.size > 0
end

desc "Remove dead sessions"
task :prune_sessions => [:environment] do
  ActiveRecord::Base.connection.execute 'DELETE FROM sessions WHERE updated_at < ADDDATE(NOW(), INTERVAL -1 DAY)'
end

desc "Trim log files"
task :trim_logs => [:environment] do
  log_dir = "#{RAILS_ROOT}/log"
  trim_logs = ['production.log', 'mongrel.log']
  trim_logs.each do |logfile|
    %x{ tail -10000 #{log_dir}/#{logfile} > #{log_dir}/tmp.log; mv -f #{log_dir}/tmp.log #{log_dir}/#{logfile} }
  end
end