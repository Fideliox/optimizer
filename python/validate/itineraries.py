import csv, sys
from datetime import datetime

class Itineraries:
	__column_name = ['id', 'ccni_code', 'numero_viaje', 'codigo_servicio', 'sentido', 'viaje_ant', 'viaje_sig', 'fecha_inicio', 'fecha_termino', 'codigo_operador', 'id_recalada', 'codigo_pais', 'codigo_puerto', 'tipo_recalada', 'secuencia', 'fecha_arribo_plani', 'fecha_zarpe_planif', 'fecha_arribo_conf', 'fecha_zarpe_conf', 'enlazado_con', 'secuencia', 'pais_dest', 'puerto_dest', 'arribo_plan_dest', 'zarpe_plan_dest', 'arribo_conf_dest', 'zarpe_conf_dest', 'nombre']
	__column_type = ['', '', '', '', '', '', '', 'M-D-Y H:M', 'M-D-Y H:M', '', '', '', '', '', '', 'M-D-Y H:M', 'M-D-Y H:M', 'M-D-Y H:M', 'M-D-Y H:M', '', '', '', '', 'M-D-Y H:M', 'M-D-Y H:M', 'M-D-Y H:M', 'M-D-Y H:M', '']
	__column_length = [0, 4, 0, 3, 2, 0, 0, 0, 0, 0, 0, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 2, 3, 0, 0, 0, 0, 0]
	__filename = None

	def set_filename(self, filename):
		self.__filename = filename
		pass
	def open_itinerary(self):
		sw = True
		print "1) Abriendo archivo"
		with open(self.__filename, 'rU') as csvfile:
			spamreader = csv.reader(csvfile, delimiter="\t", quotechar='|')
			for row in spamreader:
				if not len(row) > 1:
					print "\t[%s] Se esperaba un archivo separado por tabulacion TAB 'txt or tcv'" % datetime.now()
					sw = False
				break
			csvfile.close()
		if sw:
			print "\t[Ok]"
		else:
			print "\t[Fail]"
		return sw
		pass

	def cont_rows(self):
		print "2) Contando filas"
		length = sum(1 for line in open(self.__filename)) - 1		
		print "\t[%s] Cantidad de filas: %s" % (datetime.now(), str(length))
		if length > 2:
			print "\t[Ok]"
		else:
			print "\t[Fail]"
		pass

	def count_columns(self):
		print "3) Contando columnas"
		with open(self.__filename, 'rU') as csvfile:
			spamreader = csv.reader(csvfile, delimiter="\t", quotechar='|')
			for row in spamreader:
				if  len(row) != len(self.__column_name):
					print "\t[%s] Se esperaba %s columnas y existen %s" % (datetime.now(), len(self.__column_name), len(row))
					if  len(row) > len(self.__column_name):
						print "\t[%s] Solo se analizaran las %s primeras columnas" % (datetime.now(),  len(self.__column_name))
						print "\t[Warn]"
				else:
					print "\t[Ok]"
				break
			csvfile.close()
		pass

	def fields(self):
		print "4) Revisando nombres de columnas"
		i = 0
		sw = True
		with open(self.__filename, 'rU') as csvfile:
			spamreader = csv.reader(csvfile, delimiter="\t", quotechar='|')
			for row in spamreader:
				for col in self.__column_name:
					if col != row[i]:
						print "\t[%s] Se esperaba la columna %s y encontro la columna %s el la posicion %s" % (datetime.now(), col, row[i], str(i+1))
						print "\t[Warn]"
						sw = False
					i += 1
				break		
			csvfile.close()
		if sw:
			sw = True
			print "\t[Ok]"			
		return sw
		pass
	
	def column_length(self):
		print "5) Revisando tamano de datos"
		sw = True
		with open(self.__filename, 'rU') as csvfile:
			spamreader = csv.reader(csvfile, delimiter="\t", quotechar='|')
			linea = 1			
			for row in spamreader:				
				if linea>1:
					i = 0
					for length in self.__column_length:
						if len(row[i]) > length and length > 0:
							print "\t[%s] linea: %s, Campo %s excede del tamano permitido (%s)." % (datetime.now(), linea, self.__column_name[i], length)
							sw = False
						i += 1
				linea += 1
		if sw:
			print "\t[Ok]"
		else:
			print "\t[Fail]"
		pass

	def column_type(self):
		sw = True
		print "6) Revisando tipos de campos"
		with open(self.__filename, 'rU') as csvfile:
			spamreader = csv.reader(csvfile, delimiter="\t", quotechar='|')
			linea = 1			
			for row in spamreader:				
				if linea>1:
					i = 0
					for tipo in self.__column_type:
						if tipo == 'M-D-Y H:M':
							fecha = row[i]
							if fecha.find('/')>=0:
								a = fecha.split(" ")
								if (len(a)!=2):
									sw = False
									#print "\t[%s] linea: %s, Formato fecha desconocido campo %s." % (datetime.now(), linea, self.__column_name[i])
								else:
									if int(a[0].split('/')[0])>12:
										sw = False
										#print "\t[%s] linea: %s, Formato fecha desconocido campo %s." % (datetime.now(), linea, self.__column_name[i])	
									elif int(a[0].split('/')[1])>31:
										sw = False
										#print "\t[%s] linea: %s, Formato fecha desconocido campo %s." % (datetime.now(), linea, self.__column_name[i])	
							elif fecha.find('-')>=0:
								a = fecha.split(" ")
								if (len(a)!=2):
									sw = False
									#print "\t[%s] linea: %s, Formato fecha desconocido campo %s." % (datetime.now(), linea, self.__column_name[i])
								else:
									if int(a[0].split('-')[0])>12:
										sw = False
										#print "\t[%s] linea: %s, Formato fecha desconocido campo %s." % (datetime.now(), linea, self.__column_name[i])	
									elif int(a[0].split('-')[1])>31:
										sw = False
										#print "\t[%s] linea: %s, Formato fecha desconocido campo %s." % (datetime.now(), linea, self.__column_name[i])	
							else:
								sw = False
								#print "\t[%s] linea: %s, Formato fecha desconocido campo %s." % (datetime.now(), linea, self.__column_name[i])
						i += 1
				linea += 1
		if sw:
			print "\t[Ok]"
		else:
			print "\t[Fail]"
		pass

filename  = sys.argv[1]
print filename
i = Itineraries()
i.set_filename(filename)
if i.open_itinerary():
	i.cont_rows()
	i.count_columns()	
	i.fields()
	i.column_length()
	i.column_type()