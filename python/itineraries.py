import psycopg2
import csv
import sys
from databases import DataBases
import os

class Itineraries():
	__conn_string = ''
	__con = None
	__cur = None
	__conn_string2 = ''
	__con2 = None
	__cur2 = None
	__process = 'loader_itinerarios'
	__total = 0
	__filename = ''

	def __init__(self):
		print "Conectado"
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
		query = """TRUNCATE TABLE loader_itinerario"""
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
					ccni_code	= None
					numero_viaje	= None
					codigo_servicio	= None
					sentido	= None
					viaje_ant	= None
					viaje_sig	= None
					fecha_inicio	= '2000-1-1'
					fecha_termino	= '2000-1-1'
					codigo_operador	= None
					id_recalada	= None
					codigo_pais	= None
					codigo_puerto	= None
					tipo_recalada	= None
					secuencia	= None
					fecha_arribo_plani	= '2000-1-1'
					fecha_zarpe_planif	= '2000-1-1'
					fecha_arribo_conf	= '2000-1-1'
					fecha_zarpe_conf	= '2000-1-1'
					enlazado_con	= None
					secuencia_1	= None
					pais_dest	= None
					puerto_dest	= None
					arribo_plan_dest	= '2000-1-1'
					zarpe_plan_dest	= '2000-1-1'
					arribo_conf_dest	= '2000-1-1'
					zarpe_conf_dest	= '2000-1-1'
					nave	= None
					viaje	= None
					query = """INSERT INTO loader_itinerario (
							ccni_code,
							numero_viaje,
							codigo_servicio,
							sentido,
							viaje_ant,
							viaje_sig,
							fecha_inicio,
							fecha_termino,
							codigo_operador,
							id_recalada,
							codigo_pais,
							codigo_puerto,
							tipo_recalada,
							secuencia,
							fecha_arribo_plani,
							fecha_zarpe_planif,
							fecha_arribo_conf,
							fecha_zarpe_conf,
							enlazado_con,
							secuencia_1,
							pais_dest,
							puerto_dest,
							arribo_plan_dest,
							zarpe_plan_dest,
							arribo_conf_dest,
							zarpe_conf_dest,
							nave
						) VALUES (
							'%s', '%s', '%s', '%s', %s, %s, '%s', '%s', '%s', '%s',
							'%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', %s, '%s',
							'%s', '%s', '%s', '%s', '%s', '%s', '%s'
						);
				"""
					if row[1] != '' and row[1] != None:
						ccni_code = row[1].strip().replace(':', '..').replace("'", " ")
					if row[2] != '' and row[2] != None:
						numero_viaje = row[2].strip().replace(':', '..').replace("'", " ")
					if row[3] != '' and row[3] != None:
						codigo_servicio = row[3].strip().replace(':', '..').replace("'", " ")
					if row[4] != '' and row[4] != None:
						sentido = row[4].strip().replace(':', '..').replace("'", " ")
					if row[5] != '' and row[5] != None:
						viaje_ant = row[5].strip().replace(':', '..').replace("'", " ")
					if row[6] != '' and row[6] != None:
						viaje_sig = row[6].strip().replace(':', '..').replace("'", " ")
					if row[7] != '':
						fecha_inicio = self.__date_format(row[7])
					if row[8] != '':
						fecha_termino = self.__date_format(row[8])
					if row[9] != '' and row[9] != None:
						codigo_operador = row[9].strip().replace(':', '..').replace("'", " ")
					if row[10] != '' and row[10] != None:
						id_recalada = row[10].strip().replace(':', '..').replace("'", " ")
					if row[11] != '' and row[11] != None:
						codigo_pais = row[11].strip().replace(':', '..').replace("'", " ")
					if row[12] != '' and row[12] != None:
						codigo_puerto = row[12].strip().replace(':', '..').replace("'", " ")
					if row[13] != '' and row[13] != None:
						tipo_recalada = row[13].strip().replace(':', '..').replace("'", " ")
					if row[14] != '' and row[14] != None:
						secuencia = row[14].strip().replace(':', '..').replace("'", " ")
					if row[15] != '':
						fecha_arribo_plani = self.__date_format(row[15])
					if row[16] != '':
						fecha_zarpe_planif = self.__date_format(row[16])
					if row[17] != '':
						fecha_arribo_conf = self.__date_format(row[17])
					if row[18] != '':
						fecha_zarpe_conf = self.__date_format(row[18])
					if len(row[19].strip())>0:
						enlazado_con = row[19]
					if row[20] != '' and row[20] != None:
						secuencia_1 = row[20].strip().replace(':', '..').replace("'", " ")
					if row[21] != '' and row[21] != None:
						pais_dest = row[21].strip().replace(':', '..').replace("'", " ")
					if row[22] != '' and row[22] != None:
						puerto_dest = row[22].strip().replace(':', '..').replace("'", " ")
					if row[23] != '':
						arribo_plan_dest = self.__date_format(row[23])
					if row[24] != '':
						zarpe_plan_dest = self.__date_format(row[24])
					if row[25] != '':
						arribo_conf_dest = self.__date_format(row[25])
					if row[26] != '':
						zarpe_conf_dest = self.__date_format(row[26])
					if row[27] != '' and row[27] != None:
						nave = row[27].strip().replace(':', '..').replace("'", " ")
					"""if row[28] != '':
						viaje = 'NULL' #row[28]"""
					values = (ccni_code,numero_viaje,codigo_servicio,sentido,viaje_ant,viaje_sig,fecha_inicio,fecha_termino,codigo_operador,id_recalada,codigo_pais,codigo_puerto,tipo_recalada,secuencia,fecha_arribo_plani,fecha_zarpe_planif,fecha_arribo_conf,fecha_zarpe_conf,enlazado_con,secuencia_1,pais_dest,puerto_dest,arribo_plan_dest,zarpe_plan_dest,arribo_conf_dest,zarpe_conf_dest,nave)
					self.__cur.execute(query % values);
					self.__con.commit();
					self.__update_status(i)
				i += 1
		print "Cerrando python"
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
				ano =b [2]
			fecha = ano + '-' + b[0] + '-' + b[1] + ' ' + a[1]
			return fecha
		except:
			return None

	def null_date(self):
		query = """	UPDATE loader_itinerario SET zarpe_conf_dest = NULL WHERE zarpe_conf_dest = '2000-01-01 00:00:00';
					UPDATE loader_itinerario SET arribo_conf_dest = NULL WHERE arribo_conf_dest = '2000-01-01 00:00:00';
					UPDATE loader_itinerario SET arribo_plan_dest = NULL WHERE arribo_plan_dest = '2000-01-01 00:00:00';
					UPDATE loader_itinerario SET fecha_zarpe_conf = NULL WHERE fecha_zarpe_conf = '2000-01-01 00:00:00';
					UPDATE loader_itinerario SET fecha_arribo_conf = NULL WHERE fecha_arribo_conf = '2000-01-01 00:00:00';
					UPDATE loader_itinerario SET fecha_zarpe_planif = NULL WHERE fecha_zarpe_planif = '2000-01-01 00:00:00';
					UPDATE loader_itinerario SET fecha_arribo_plani = NULL WHERE fecha_arribo_plani = '2000-01-01 00:00:00';
					UPDATE loader_itinerario SET fecha_termino = NULL WHERE fecha_termino = '2000-01-01 00:00:00';
					UPDATE loader_itinerario SET fecha_inicio = NULL WHERE fecha_inicio = '2000-01-01 00:00:00';"""
		self.__cur.execute(query);
		self.__con.commit();
		self.__con.close()
		self.__cur.close()
		self.__con2.close()
		self.__cur2.close()		

	def generate_log(self, py):
		path = '/'.join(py.split('/')[:-1])
		os.system("echo 'CHECK 2' >> /tmp/karguroo.log")
		os.system("python %s/validate/check_itineraries.py %s >> /tmp/karguroo.log" % (path))
		pass


filename  = sys.argv[1]
py = sys.argv[0]
i = Itineraries()
i.truncate()
i.load_file(filename)
i.null_date()
i.generate_log(py)