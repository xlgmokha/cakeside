namespace :deploy do

  desc "deploy to staging server"
  task :staging do
    sh "cap staging deploy:migrations"
    sh "cap staging deploy:cleanup"
    sh "curl http://staging.cakeside.com/ > /dev/null"
  end

  desc "deploy to production server"
  task :production, :tag do |t, args|
    tag_to_deploy = args.tag
    if tag_to_deploy.blank?
      sh "cap production deploy:migrations"
    else
      sh "cap production deploy:migrations -s tag=#{tag_to_deploy}"
    end
    sh "curl http://cakeside.com/ > /dev/null"
  end
end

