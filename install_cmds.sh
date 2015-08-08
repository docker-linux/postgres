#!/bin/bash
# Copyright 2014, Tom Eklöf, Mogul AB
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

function COOK-1406()
# Work around the omnibus pg gem issue as suggested by Joshua Timberman in COOK-1406
{
	apt-get install -y build-essential
	apt-get build-dep -y postgresql
	cd /opt/chef/embedded/
	curl -o postgresql-9.2.1.tar.gz http://ftp.postgresql.org/pub/source/v9.2.1/postgresql-9.2.1.tar.gz
	tar xzf /opt/chef/embedded/postgresql-9.2.1.tar.gz -C /opt/chef/embedded/
	cd postgresql-9.2.1
	export MAJOR_VER=9.2
	./configure --prefix=/opt/chef/embedded \
		--mandir=/opt/chef/embedded/share/postgresql/${MAJOR_VER}/man \
		--docdir=/opt/chef/embedded/share/doc/postgresql-doc-${MAJOR_VER} \
		--sysconfdir=/etc/postgresql-common \
		--datarootdir=/opt/chef/embedded/share/ \
		--datadir=/opt/chef/embedded/share/postgresql/${MAJOR_VER} \
		--bindir=/opt/chef/embedded/lib/postgresql/${MAJOR_VER}/bin \
		--libdir=/opt/chef/embedded/lib/ \
		--libexecdir=/opt/chef/embedded/lib/postgresql/ \
		--includedir=/opt/chef/embedded/include/postgresql/ \
		--enable-integer-datetimes \
		--enable-thread-safety \
		--enable-debug \
		--with-gnu-ld \
		--with-pgport=5432 \
		--with-openssl \
		--with-libedit-preferred \
		--with-includes=/opt/chef/embedded/include \
		--with-libs=/opt/chef/embedded/lib
	make
	make install
	/opt/chef/embedded/bin/gem install pg -- --with-pg-config=/opt/chef/embedded/lib/postgresql/9.2/bin/pg_config
	rm -f /opt/chef/embedded/postgresql-9.2.1.tar.gz
	cd -
}

apt-get -y update

COOK-1406		# This is currently needed to use the database cookbook

# Change the dbpassword string below to something good.
sed -i "s%md5sumhash%$(echo -n 'dbpassword' | openssl md5 | sed -e 's/.* /md5/')%g" /etc/chef/node.json

# Install cookbooks defined in Berkshelf file
cd /
/opt/chef/embedded/bin/berks vendor /etc/chef/cookbooks/

# Add our custom cookbook to create the database
mv /create-db.rb /etc/chef/cookbooks/database/recipes/create-db.rb

# Run cookbooks
chef-solo
