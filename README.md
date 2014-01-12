Docker + Chef Solo

To create a new docker postgresql database:
1. Edit create-db.rb to your liking. You can read more on how to customize your database here https://github.com/opscode-cookbooks/database
2. Run chef-solo (the database must be running or it will fail)

Use node.json as a template, For example you can change the password string in Dockerfile to a good password but naturally you'll have to change pg_hba config then.
