namespace :svn do
  
  desc "Adds all files with an svn status flag of '?'" 
  task :add do
    system "svn status | grep '^\?' | sed -e 's/? *//' | sed -e 's/ /\ /g' | xargs svn add"
  end

end