namespace :svn do
  desc "Adds all files with an svn status flag of '?'" 
  task(:add) { `svn status | awk '/\\?/ {print }' | xargs svn add` }
end