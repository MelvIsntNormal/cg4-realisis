namespace :db do
  desc "Reset and seed single table"
  task :reset_table, [:table] => :environment do |t, args|
    table = args[:table].to_s
    puts table
    table.singularize.classify.constantize.delete_all
    table.singularize.classify.constantize.create(YAML.load_file("#{Rails.root}/db/seeds/#{:table.singularize.downcase}.yml").values.each { |hash| hash.symbolize_keys! })
  end
end