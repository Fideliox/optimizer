import psycopg2

class DataBases:
	__conn_rds = None
	__conn_loader = None
	__con = None
	__cur = None

	def __init__(self):
		self.__con = psycopg2.connect("host = 'ccni.cck1k1sag20f.us-east-1.rds.amazonaws.com' port='5432' dbname='ccni' user='inzpiral' password='Planeta2014'")
		#self.__con = psycopg2.connect("host = 'localhost' port='5432' dbname='ccni' user='fidel' password='pqr1015'")
		self.__cur = self.__con.cursor()
		query = """SELECT key, value FROM settings WHERE key like %s or key like %s"""
		values = ("postgresql%", "rds%")
		self.__cur.execute(query, values)
		self.__con.commit()
		rows = self.__cur.fetchall()
		host = ''
		port = ''
		dbname = ''
		user = ''
		password = ''
		rhost = ''
		rport = ''
		rdbname = ''
		ruser = ''
		rpassword = ''
		for row in rows:
			if row[0] == 'rds_ip':
				rhost = row[1]
			if row[0] == 'rds_port':
				rport = row[1]
			if row[0] == 'rds_dbname':
				rdbname = row[1]
			if row[0] == 'rds_user':
				ruser = row[1]
			if row[0] == 'rds_password':
				rpassword = row[1]
			self.__conn_rds = "host = '%s' port='%s' dbname='%s' user='%s' password='%s'" % (rhost, rport, rdbname, ruser, rpassword)
			if row[0] == 'postgresql_ip':
				host = row[1]
			if row[0] == 'postgresql_port':
				port = row[1]
			if row[0] == 'postgresql_dbname':
				dbname = row[1]
			if row[0] == 'postgresql_user':
				user = row[1]
			if row[0] == 'postgresql_password':
				password = row[1]
			self.__conn_loader = "host = '%s' port='%s' dbname='%s' user='%s' password='%s'" % (host, port, dbname, user, password)
		pass

	def get_conn_loader(self):
		return self.__conn_loader
		pass

	def get_conn_rds(self):
		return self.__conn_rds
		pass