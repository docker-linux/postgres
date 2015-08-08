Introduction
------------

This image is based on the ~~Trusted build~~ **[linuxkonsult/chef-solo][1]** which in turn is based on the **ubuntu** base image.

The service is installed and configured with Chef. You can read [here][2] how to edit `/etc/chef/node.json` and run chef-solo to configure the service.

Installation
------------

Edit create-db.rb to your liking. You can read more on how to customize/optimize your database [here][3].

Bugs / Contributing
-------------------

> Any kind of feedback is highly appreciated!

Make contributions the usual way through GitHub, request changes and ask questions in comments below or email me directly at tom@linux-konsult.com.


  [1]: https://index.docker.io/u/linux/chef-solo/
  [2]: https://github.com/hw-cookbooks/postgresql
  [3]: https://github.com/opscode-cookbooks/database
