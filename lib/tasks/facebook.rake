namespace :facebook do
	task :notify => :environment do
		FacebookAccount.notify!
	end
end