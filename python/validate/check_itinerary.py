#loader cargar demanda en purchase activiy
#
#
#
#writter guillermo.wood@inzpiral.com
#
import psycopg2
import sys
import pprint
import datetime
import time
from databases import DataBases

conn_string = ""
#conn_string = "host = '127.0.0.1' dbname='ccni' user='postgres'"

global con
global cur
try:
	db = DataBases()
	conn_string = db.get_conn_loader()
	con = psycopg2.connect(conn_string)
except:
	print "I am unable to connect to the database"
	sys.exit()
cur = con.cursor()
print "Connected!\n"


def main():
	count_zarpe_menor_igual_arribo = 0
	count_zarpe_conf_dest_diff_fecha_zarpe_conf = 0
	count_discontinuidad = 0
	count_duplicidad_de_zarpe = 0
	a = 0
	b = 0
	c = 0
	d = 0
	query = """ SELECT * from loader_itinerario
			ORDER BY fecha_zarpe_conf
		"""
		 
	cur.execute(query)
	records = cur.fetchall()
	con.commit() 
	for record in records:
		if record[18] <= record[17]:
			a = 1
			count_zarpe_menor_igual_arribo += 1
		
		query = """ SELECT * from loader_itinerario
			WHERE nave = %s AND codigo_pais = %s AND codigo_puerto = %s AND fecha_zarpe_conf >= %s
			ORDER BY fecha_zarpe_conf ;
		"""		 
		values = (record[27],record[21],record[22], str(record[26]) )#nave, pais_origen, ciudad_origen, zarpe_conf_dest
		cur.execute(query,values)
		nextrecord = cur.fetchone()
		con.commit() 

		query = """ SELECT MAX(fecha_zarpe_conf) from loader_itinerario
			WHERE nave = '%s' """		 
		cur.execute(query%record[27])
		lastrecord = cur.fetchone()
		con.commit() 
		if record[18] != lastrecord[0]:
			if nextrecord:
				if record[26] != nextrecord[18]:
					b = 1
					count_zarpe_conf_dest_diff_fecha_zarpe_conf += 1
				if record[18] == nextrecord[18]:
					d = 1
					count_duplicidad_de_zarpe += 1
			else: 
				c = 1
				count_discontinuidad += 1

		if a == 1:
			print "Error for: " + str(record[3])+":"+str(record[27])+":"+str(record[11])+str(record[12])+":"+str(record[21])+str(record[22])+':'+str(record[18])
			print "		Fecha de zarpe menor o igual que arribo, fila: " + str(record[28])
		if b == 1:
			if a != 1:
				print "Error for: " + str(record[3])+":"+str(record[27])+":"+str(record[11])+str(record[12])+":"+str(record[21])+str(record[22])+':'+str(record[18])
			print "		next record: " + str(nextrecord[3])+":"+str(nextrecord[27])+":"+str(nextrecord[11])+str(nextrecord[12])+":"+str(nextrecord[21])+str(nextrecord[22])
			print "			fecha de zarpe_conf_dest difiere a fecha_zarpe_conf, fila: " + str(nextrecord[28])
		if c == 1:
			if a != 1 and b != 1:
				print "Error for: " + str(record[3])+":"+str(record[27])+":"+str(record[11])+str(record[12])+":"+str(record[21])+str(record[22])+':'+str(record[18])
			# if b != 1:
			# 	print "		next record: " + str(nextrecord[3])+":"+str(nextrecord[27])+":"+str(nextrecord[11])+str(nextrecord[12])+":"+str(nextrecord[21])+str(nextrecord[22])
			print "			 discontinuidad en itinerario, fila: " + str(record[28])
		if d == 1:
			if a != 1 and b != 1 and c != 1:
				print "Error for: " + str(record[3])+":"+str(record[27])+":"+str(record[11])+str(record[12])+":"+str(record[21])+str(record[22])+':'+str(record[18])
			# if b != 1:
			# 	print "		next record: " + str(nextrecord[3])+":"+str(nextrecord[27])+":"+str(nextrecord[11])+str(nextrecord[12])+":"+str(nextrecord[21])+str(nextrecord[22])
			print "			 duplicidad de zarpe en itinerario, fila: " + str(record[28])
		a = 0
		b = 0
		c = 0
		d = 0
	print "Total errores fecha zarpe menor o igual a fecha de arribo: " + str(count_zarpe_menor_igual_arribo)
	print "Total errores zarpe_conf_dest difiere a fecha_zarpe_conf: " + str(count_zarpe_conf_dest_diff_fecha_zarpe_conf)
	print "Total errores discontinuidad de itinerario: " + str(count_discontinuidad)
	print "Total errores duplicidad de zarpe en itinerario: " + str(count_duplicidad_de_zarpe)

	
if __name__ == "__main__":
	main()