#config/schedule.rb
every 1.day, at: '12:00 am' do
  runner "ScheduleDisbursements.call"
end