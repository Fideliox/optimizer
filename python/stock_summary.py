import psycopg2
import csv
import sys
from databases import DataBases

class Stock():
	__conn_string = ''
	__con = None
	__cur = None
	__conn_string2 = ''
	__con2 = None
	__cur2 = None
	__process = "loader_inventario_contenedores"
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
		query = """TRUNCATE TABLE loader_inventario_contenedores"""
		self.__cur.execute(query); 
		self.__con.commit();
		pass

	def load_file(self, filename):
		i = 0		
		self.__filename = filename
		self.__total = sum(1 for line in open(filename)) - 1
		self.__create_process()		
		with open(filename, 'rU') as csvfile:
			spamreader = csv.reader(csvfile, delimiter="\t", quotechar='|')
			for row in spamreader:
				if i > 0:
					eqty_iso_fk	= None
					localidad	= None
					unidades	= None
					fecha_disp	= None
					minimo	= None
					query = """INSERT INTO loader_inventario_contenedores (
									eqty_iso_fk,
									localidad,
									unidades,
									fecha_disp,
									minimo
								) VALUES (
									%s, %s, %s, %s, %s
								);
							"""
					print row
					if row[0] != '' and row[0] != None:
						eqty_iso_fk = row[0].strip().replace(':', '..').replace("'", " ")
					if row[1] != '' and row[1] != None:
						localidad = row[1].strip().replace(':', '..').replace("'", " ")
					if row[2] != '' and row[2] != None:
						unidades = row[2].strip().replace(':', '..').replace("'", " ")
					if row[3] != '' and row[3] != None:
						fecha_disp = self.__date_format(row[3])
					if row[4] != '' and row[4] != None:
						minimo = row[4].strip().replace(':', '..').replace("'", " ")
					values = (eqty_iso_fk,localidad,unidades,fecha_disp,minimo)
					self.__cur.execute(query, values); 
					self.__con.commit();
					self.__update_status(i)
				i += 1
		pass

	def __date_format(self, str_date):
		try:
			a = str_date.split(" ")
			if str_date.find('/') >= 0:
				b = a[0].split("/")
			else:
				b = a[0].split("-")
			if (len(b[2])<3):
				ano = "20" + b[2]
			else:
				ano = b[2]
			fecha = ano + '-' + b[0] + '-' + b[1]
			return fecha
		except:
			return None

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

filename  = sys.argv[1]
c = Stock()
c.truncate()
c.load_file(filename)
