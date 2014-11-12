# namespace :db do

#   desc "Create a database dump (options: file=db/db.dump, database=vvz_dev)"
#   task :backup, :file, :database do |t, args|
#     args.with_defaults(file: "db/db.dump", database: "vvz_dev")
#     system "pg_dump --clean -U postgres --inserts --column-inserts --format=custom -f #{args.file} #{args.database}"
#   end

#   desc "Resotres the database form a database dump (options: file=db/db.dump, database=vvz_dev)"
#   task :restore, :file, :database do |t, args|
#     args.with_defaults(file: "db/db.dump", database: "vvz_dev")
#     system "pg_restore --clean -U postgres --no-acl --no-owner -d #{args.database} #{args.file} >/dev/null 2>&1"
#   end



# end

namespace :db do

  desc "Dumps the database to db/APP_NAME.dump"
  task :dump => :environment do
    cmd = nil
    with_config do |app, host, db, user|
      cmd = "pg_dump --username #{user} --host #{host} --verbose --clean --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/#{app}.dump"
    end
    puts cmd
    exec cmd
  end

  desc "Restores the database dump at db/APP_NAME.dump."
  task :restore => :environment do
    cmd = nil
    with_config do |app, host, db, user|
      cmd = "pg_restore --verbose --host #{host} --username #{user} --clean --no-owner --no-acl --dbname #{db} #{Rails.root}/db/#{app}.dump"
    end
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    puts cmd
    exec cmd
  end

  task :clear_user => :environment do
    User.destroy_all
  end

  task :seed_user => :environment do
    user = User.create({
      uid: "test@user.edu",
      name: "Test User",
      disciplines: [Discipline.first],
      data: {}
    })
    user.events << Event.find(:all, :order => "RANDOM()", :limit => 6)
  end

  private

  def with_config
    yield Rails.application.class.parent_name.underscore,
      ActiveRecord::Base.connection_config[:host],
      ActiveRecord::Base.connection_config[:database],
      ActiveRecord::Base.connection_config[:username]
  end

end
