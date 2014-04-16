delete_alters = false

#menu
puts 'Menus'
#ActiveRecord::Base.connection.execute("ALTER TABLE menus ADD UNIQUE unq_menus(name);") if !delete_alters
# ActiveRecord::Base.connection.execute("ALTER TABLE menus DROP INDEX unq_menus;") if delete_alters

#roles
puts 'Roles'
#ActiveRecord::Base.connection.execute("ALTER TABLE roles ADD UNIQUE unq_roles(name);") if !delete_alters
#ActiveRecord::Base.connection.execute("ALTER TABLE roles DROP INDEX unq_roles;") if delete_alters

#down_menus
puts 'Down Menus'
#ActiveRecord::Base.connection.execute("ALTER TABLE rbo_down_menus ADD CONSTRAINT fk_rbo_down_menus_rbo_menus FOREIGN  KEY(rbo_menu_id) REFERENCES rbo_menus(id);") if !delete_alters
#ActiveRecord::Base.connection.execute("ALTER TABLE rbo_down_menus ADD CONSTRAINT fk_rbo_down_menus_rbo_roles FOREIGN  KEY(rbo_role_id) REFERENCES rbo_roles(id);") if !delete_alters
#ActiveRecord::Base.connection.execute("ALTER TABLE rbo_down_menus DROP FOREIGN KEY fk_rbo_down_menus_rbo_menus") if delete_alters
#ActiveRecord::Base.connection.execute("ALTER TABLE rbo_down_menus DROP FOREIGN KEY fk_rbo_down_menus_rbo_roles") if delete_alters


#users
puts 'Users'
#ActiveRecord::Base.connection.execute("ALTER TABLE rbo_users ADD CONSTRAINT fk_rbo_users_roles FOREIGN  KEY(rbo_role_id) REFERENCES rbo_roles(id);") if !delete_alters
#ActiveRecord::Base.connection.execute("ALTER TABLE users ADD UNIQUE unq_users(username);") if !delete_alters
#ActiveRecord::Base.connection.execute("ALTER TABLE rbo_users DROP FOREIGN KEY fk_rbo_users_rbo_roles;") if delete_alters
#ActiveRecord::Base.connection.execute("ALTER TABLE users DROP INDEX unq_users;") if delete_alters

Setting.create(key: 'postgresql_user', value: 'fidel')
Setting.create(key: 'postgresql_password', value: 'pqr1015')
Setting.create(key: 'postgresql_ip', value: '127.0.0.1')
Setting.create(key: 'postgresql_port', value: '5432')
Setting.create(key: 'postgresql_dbname', value: 'ccni')

Setting.create(key: 'socket_ip', value: '127.0.0.1')
Setting.create(key: 'socket_port', value: '8080')


