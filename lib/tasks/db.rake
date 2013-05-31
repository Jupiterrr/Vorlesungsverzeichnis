namespace :db do

  desc "Create a database dump (options: file=db/db.dump, database=vvz_dev)"
  task :backup, :file, :database do |t, args|
    args.with_defaults(file: "db/db.dump", database: "vvz_dev")
    system "pg_dump --clean -U postgres --inserts --column-inserts --format=custom -f #{args.file} #{args.database}"
  end

  desc "Resotres the database form a database dump (options: file=db/db.dump, database=vvz_dev)"
  task :restore, :file, :database do |t, args|
    args.with_defaults(file: "db/db.dump", database: "vvz_dev")
    system "pg_restore --clean -U postgres --no-acl --no-owner -d #{args.database} #{args.file} >/dev/null 2>&1"
  end

  task :clear_user => :environment do
    User.destroy_all
  end

  task :seed_user => :environment do
    user = User.create({
      uid: "test@user.edu",
      name: "Test User",
      disciplines: [Discipline.first]
    })
    user.events << Event.find(:all, :order => "RANDOM()", :limit => 6)
  end

end