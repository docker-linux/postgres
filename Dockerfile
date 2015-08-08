FROM linuxkonsult/chef-solo

MAINTAINER Tom Eklöf tom@linux-konsult.com

# Expose the Postgresql port
EXPOSE 5432

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Add the postgres init script
ADD ./postgres.sh /postgres.sh
# Add chef files
ADD ./solo.rb /etc/chef/solo.rb
ADD ./node.json /etc/chef/node.json
# Add Berksfile to install cookbooks
ADD ./Berksfile /Berksfile
ADD ./install_cmds.sh /install_cmds.sh
# Add a custom cookbook to create a database
ADD ./create-db.rb /create-db.rb

# Run cookbooks
RUN /install_cmds.sh

# Start the service
CMD ["/postgres.sh"]
