task :display_all_user => :environment do
  User.All.each do |user|
    puts "#{user.email} #{user.name} #{user.city}"
  end
end