import psycopg2
import csv
import sys
import os
from databases import DataBases

class Capabilities():
	__conn_string = ''
	__con = None
	__cur = None
	__conn_string2 = ''
	__con2 = None
	__cur2 = None
	__process = "loader_capacidades"
	__total = 0
	__filename = ''

	def __init__(self):
		print "Conectado python"
		db = DataBases()
		self.__conn_string = db.get_conn_loader()
		self.__con = psycopg2.connect(self.__conn_string)
		self.__cur = self.__con.cursor()
		self.__conn_string2 = db.get_conn_rds()
		self.__con2 = psycopg2.connect(self.__conn_string2)
		self.__cur2 = self.__con2.cursor()
		self.__truncate_process()
		pass

	def truncate(self):
		query = """TRUNCATE TABLE loader_capacidades"""
		self.__cur.execute(query);
		self.__con.commit();
		pass

	def load_file(self, filename):
		i = 0
		self.__filename = filename
		self.__total = sum(1 for line in open(filename)) - 1
		self.__create_process()
		with open(filename, 'rU') as csvfile:
			rows = csv.reader(csvfile, delimiter="\t", quotechar='|')
			for row in rows:
				if i > 0:
					vessel = None
					service_code = None
					vessel_code = None
					operator = None
					port = None
					bound = None
					average_weight_cap = None
					average_teus_cap = None
					average_reefer = None
					ttl_wt_bb = None
					ttl_vol_bb = None
					voyage = None
					if row[0] != '':
						vessel = row[0].strip()
					if row[1] != '':
						service_code = row[1].strip()
					if row[2] != '':
						vessel_code = row[2].strip()
					if row[3] != '':
						operator = row[3].strip()
					if row[4] != '':
						port = row[4].strip()
					if row[5] != '':
						bound = row[5].strip()
					if row[6] != '':
						average_weight_cap = row[6].strip()
					if row[7] != '':
						average_teus_cap = row[7].strip()
					if row[8] != '':
						average_reefer = row[8].strip()
					if row[9] != '':
						ttl_wt_bb = row[9].strip()
					if row[10] != '':
						ttl_vol_bb = row[10].strip()
					if row[11] != '':
						voyage = row[11].strip()
					query = """INSERT INTO loader_capacidades (
								vessel,
								service_code,
								vessel_code,
								operator,
								port,
								bound,
								average_weight_cap,
								average_teus_cap,
								average_reefer,
								ttl_wt_bb,
								ttl_vol_bb,
								voyage
							) VALUES (
								%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
							);
					"""
					values = (vessel,service_code,vessel_code,operator,port,bound,average_weight_cap,average_teus_cap,average_reefer,ttl_wt_bb,ttl_vol_bb,voyage)
					self.__cur.execute(query, values)
					self.__con.commit();
					self.__update_status(i)
				i += 1
		print "Cerrando python"
		self.__con.close()
		self.__cur.close()
		self.__con2.close()
		self.__cur2.close()
		pass

	def __truncate_process(self):
		query = """DELETE FROM iz_status_python WHERE process like '%s'"""
		self.__cur2.execute(query % self.__process)
		self.__con2.commit()
		pass

	def __create_process(self):
		query = """INSERT INTO iz_status_python(process, actual, limite, total, ready, filename)
					VALUES (%s, 0, %s, %s, 0, %s)"""
		values = (self.__process, self.__total, self.__total, self.__filename)
		self.__cur2.execute(query, values)
		self.__con2.commit()
		pass

	def __update_status(self, actual):
		query = """ UPDATE iz_status_python set 
				actual = %s,
				total = %s
				WHERE
				process = %s """
		values = (actual, self.__total, self.__process)
		self.__cur2.execute(query, values)
		self.__con2.commit()

	def generate_format_log(self, py, filename):
		path = '/'.join(py.split('/')[:-1])
		os.system("echo 'Archivo: %s' > /tmp/karguroo.log" % (filename.split('/').pop()))
		os.system("python %s/validate/capacities.py %s >> /tmp/karguroo.log" % (path, filename))
		pass


filename  = sys.argv[1]
c = Capabilities()
c.truncate()
c.load_file(filename)
