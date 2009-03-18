namespace :radiant do
  namespace :extensions do
    namespace :reader_group do
      
      desc "Runs the migration of the Reader Group extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          ReaderGroupExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          ReaderGroupExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Reader Group to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from ReaderGroupExtension"
        Dir[ReaderGroupExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(ReaderGroupExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
