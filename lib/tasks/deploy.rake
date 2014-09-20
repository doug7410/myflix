require 'paratrooper'

 namespace :deploy do
   desc 'Deploy app in staging environment'
   task :staging do
     deployment = Paratrooper::Deploy.new("doug-myflix-staging", tag: 'staging')

     deployment.deploy
   end

   desc 'Deploy app in production environment'
   task :production do
     deployment = Paratrooper::Deploy.new("pacific-badlands-4137") do |deploy|
       deploy.tag              = 'production'
       deploy.match_tag        = 'staging'
       # deploy.maintenance_mode = !ENV['NO_MAINTENANCE']
     end

     deployment.deploy

     #this is a small change so I can test if redis is working on the staging environment
   end
 end