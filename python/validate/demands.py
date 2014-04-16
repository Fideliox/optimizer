import csv, sys
from datetime import datetime

class Demands:
	__column_name = ['servicio 1', 'sentido 1', 'nave 1', 'viaje 1', 'por_onu', 'pol_onu', 'pod_onu', 'podl_onu', 'direct_ts', 'item_type', 'cnt_type_iso', 'comm_name', 'issuer_name', 'custumer_type', 'cantidad', 'freight_tons_un', 'weight_un', 'teus', 'lost_teus', 'flete_all_in_us_un', 'other_cost']
	__column_type = ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '']
	__column_length = [3, 2, 0, 0, 5, 5, 5, 5, 0, 0, 4, 25, 20, 20, 0, 0, 0, 0, 0, 0, 0]
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
		if length >= 2:
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
					print "\tSe esperaba %s columnas y existen %s" % (len(self.__column_name), len(row))
					if  len(row) > len(self.__column_name):
						print "\t[%s] Solo se analizaran las %s primeras columnas" % (datetime.now(), len(self.__column_name))
						print "\t[Warn]"
					else:
						print "\t[Fail]"
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
							#print "\t[%s] linea: %s, Campo %s excede del tamano permitido (%s)." % (datetime.now(), linea, self.__column_name[i], length)
							sw = False
						i += 1
				linea += 1
		if sw:
			print "\t[Ok]"
		else:
			print "\t[Warn]"
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
								print "\t[%s] linea: %s, Formato fecha desconocido campo %s." % (datetime.now(), linea, self.__column_name[i])
						i += 1
				linea += 1
		if sw:
			print "\t[Ok]"
		else:
			print "\t[Fail]"
		pass

	def validate_weight_un(self):
		sw = True
		print "7) Validando weight_un: weight_un >= 1 and weight_un =< 50"		
		with open(self.__filename, 'rU') as csvfile:
			spamreader = csv.reader(csvfile, delimiter="\t", quotechar='|')
			linea = 1			
			for row in spamreader:
				if linea>1:
					if row[16] != '':
						if float(row[16].replace(',', '')) > 0:
							num = float(row[16].replace(',', '')) / float(row[17].replace(',', ''))
							if not (num >= 1 and num <= 50):
								print  "\t[%s] linea: %s, valor fuera de rango (%s)" % (datetime.now(), linea, num)
								sw = False
						else:
							print  "\t[%s] linea: %s, error en la cantidad de contenedores " % (datetime.now(), linea)
							sw = False
					else:
						print "\t[%s] linea: %s, valor vacio" % (datetime.now(), linea)
						sw = False
				linea += 1
		if sw:
			print "\t[Ok]"
		else:
			print "\t[Fail]"
		pass

	def validate_flete_all_in_us_un(self):
		sw = True
		print "7) Validando flete_all_in_us_un: flete_all_in_us_un >= 200 and flete_all_in_us_un =< 200000"		
		with open(self.__filename, 'rU') as csvfile:
			spamreader = csv.reader(csvfile, delimiter="\t", quotechar='|')
			linea = 1			
			for row in spamreader:
				if linea>1:
					if row[19] != '':
						if float(row[19].replace(',', '')) > 0:
							num = float(row[19].replace(',', ''))							
							if not (num >= 200 and num <= 200000):
								print  "\t[%s] linea: %s, valor fuera de rango (%s)" % (datetime.now(), linea, num)
								sw = False
						else:
							print  "\t[%s] linea: %s, error fuera de rango" % (datetime.now(), linea)
							sw = False
					else:
						print "\t[%s] linea: %s, valor vacio" % (datetime.now(), linea)
						sw = False
				linea += 1
		if sw:
			print "\t[Ok]"
		else:
			print "\t[Fail]"
		pass		
		pass
filename  = sys.argv[1]
print filename
d = Demands()
d.set_filename(filename)
if d.open_itinerary():
	d.cont_rows()
	d.count_columns()	
	d.fields()
	d.column_length()
	d.column_type()
	d.validate_weight_un();	
	d.validate_flete_all_in_us_un()