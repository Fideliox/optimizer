import psycopg2
import csv
import sys
import os
from databases import DataBases

class Demands():
	__conn_string = ''
	__con = None
	__cur = None
	__conn_string2 = ''
	__con2 = None
	__cur2 = None
	__process = 'loader_demandas'
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
		query = """TRUNCATE TABLE loader_demanda"""
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
					servicio1	= None
					sentido1	= None
					nave1	= None
					viaje = None
					por_onu	= None
					pol_onu	= None
					pod_onu	= None
					podl_onu	= None
					direct_ts	= None
					item_type	= None
					cnt_type_iso = None
					comm_name	= None
					issuer_name	= None
					customer_type = None
					cantidad	= None
					freight_tons_un	= None
					weight_un	= None
					teus	= None
					lost_teus	= None
					flete_all_in_us_un	= None
					other_cost	= None

					if row[0] != '' and row[0] != None:
						servicio1 = row[0][:3].strip().replace(':', '..').replace("'", " ")
					if row[1] != '' and row[1] != None:
						sentido1 = row[1][:2].strip().replace(':', '..').replace("'", " ")
					if row[2] != '' and row[2] != None:
						nave1 = row[2].strip().replace(':', '..').replace("'", " ")
					if row[3] != '' and row[3] != None:
						viaje1 = row[3].strip().replace(':', '..').replace("'", " ")
					if row[4] != '' and row[4] != None:
						por_onu = row[4][:5].strip().replace(':', '..').replace("'", " ")
					if row[5] != '' and row[5] != None:
						pol_onu = row[5][:5].strip().replace(':', '..').replace("'", " ")
					if row[6] != '' and row[6] != None:
						pod_onu = row[6][:5].strip().replace(':', '..').replace("'", " ")
					if row[7] != '' and row[7] != None:
						podl_onu = row[7][:5].strip().replace(':', '..').replace("'", " ")
					if row[8] != '' and row[8] != None:
						direct_ts = row[8].strip().replace(':', '..').replace("'", " ")
					if row[9] != '' and row[9] != None:
						item_type = row[9].strip().replace(':', '..').replace("'", " ")
					if row[10] != '' and row[10] != None:
						cnt_type_iso = row[10][:4].strip().replace(':', '..').replace("'", " ")
					if row[11] != '' and row[11] != None:
						comm_name = row[11][:25].strip().replace(':', '..').replace("'", " ")
					if row[12] != '' and row[12] != None:
						issuer_name = row[12][:20].strip().replace(':', '..').replace("'", " ")
					if row[13] != '' and row[13] != None:
						customer_type = row[13][:20].strip().replace(':', '..').replace("'", " ")
					if row[14] != '' and row[14] != None:
						cantidad = row[14].strip().replace(':', '..').replace("'", " ").replace(',','')
					if row[15] != '' and row[15] != None:
						freight_tons_un = row[15].strip().replace(':', '..').replace("'", " ").replace(',','')
					if row[16] != '' and row[16] != None:
						weight_un = row[16].strip().replace(':', '..').replace("'", " ").replace(',','')
					if row[17] != '' and row[17] != None:
						teus = row[17].strip().replace(':', '..').replace("'", " ").replace(',','')
					if row[18] != '' and row[18] != None:
						lost_teus = row[18].strip().replace(':', '..').replace("'", " ").replace(',','')
					if row[19] != '' and row[19] != None:
						flete_all_in_us_un = row[19].strip().replace(':', '..').replace("'", " ").replace(',','')
					if row[20] != '' and row[20] != None:
						other_cost = row[20].strip().replace(':', '..').replace("'", " ").replace(',','')
					query = """INSERT INTO loader_demanda (
							servicio1,
							sentido1,
							nave1,
							viaje1,
							por_onu,
							pol_onu,
							pod_onu,
							podl_onu,
							direct_ts,
							item_type,
							cnt_type_iso,
							comm_name,
							issuer_name,
							customer_type,
							cantidad,
							freight_tons_un,
							weight_un,
							teus,
							lost_teus,
							flete_all_in_us_un,
							other_cost
						) VALUES (
							%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
							%s, %s, %s, %s, %s, %s, %s, %s, %s, %s
						);
				"""
					values = (servicio1,sentido1,nave1,viaje1,por_onu,pol_onu,pod_onu,podl_onu,direct_ts,item_type,cnt_type_iso,comm_name,issuer_name,customer_type,cantidad,freight_tons_un,weight_un,teus,lost_teus,flete_all_in_us_un,other_cost)
					self.__cur.execute(query, values)
					self.__con.commit();
					self.__update_status(i)
				i += 1
		print "Cerrando python"
		self.__null_direct_ts()
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
		query = """UPDATE iz_status_python set 
				actual = %s,
				total = %s
				WHERE
				process = %s """
		values = (actual, self.__total,  self.__process)
		self.__cur2.execute(query, values)
		self.__con2.commit()

	def __null_direct_ts(self):
		query = """UPDATE loader_demanda set direct_ts = NULL WHERE direct_ts = 'NULL'"""
		self.__cur2.execute(query)
		self.__con2.commit();
		pass

	def generate_format_log(self, py, filename):
		path = '/'.join(py.split('/')[:-1])
		os.system("echo 'Archivo: %s' > /tmp/karguroo.log" % (filename.split('/').pop()))
		os.system("python %s/validate/demands.py %s >> /tmp/karguroo.log" % (path, filename))
		pass



filename  = sys.argv[1]
d = Demands()
d.truncate()
d.load_file(filename)
