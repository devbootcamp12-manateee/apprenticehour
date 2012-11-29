namespace :db do
  desc "Erase and fill the database"
  task :populate => :environment do

    module ActiveModel
      module MassAssignmentSecurity
        class Sanitizer
          def sanitize(attributes, authorizer)
            attributes
          end
        end
      end
    end

    [Topic, User, Meeting].each(&:delete_all)

    TIMES = 10
    TOPICS = %w(Ruby Rails DBC FrenchJonathan)
    STATUSES = %w(cancelled completed available matched)

    TOPICS.each do |word|
      Topic.create(:description => word)
    end

    TIMES.times do |n|
      User.create(:uid => "#{n}",
                  :provider => 'Github',
                  :name => Faker::Name.name,
                  :email => Faker::Internet.email,
                  :gravatar => 'http://www.brandoncole.com/profile%20photos/MANATEE/ki1892-florida_manatee_swimmer_brandon_cole.jpg',
                  :oauth_token => "#{n}",
                  :oauth_expires_at => 1.year.from_now)
    end

    TIMES.times do |m|
      Meeting.create(:mentee => User.find_by_uid("#{rand(10) + 1}"),
                     :mentor => User.find_by_uid("#{rand(10) + 1}"),
                     :topic  => Topic.find_by_description(TOPICS[rand(4)]),
                     :description => Faker::Lorem.words(10).join(' '),
                     :neighborhood => Faker::Address.street_name,
                     :status => STATUSES[rand(4)])
    end
  end
end