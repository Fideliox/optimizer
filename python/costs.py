import psycopg2
import csv
import sys
from databases import DataBases

class Costs():
	__conn_string = ''
	__con = None
	__cur = None
	__conn_string2 = ''
	__con2 = None
	__cur2 = None
	__process = "loader_costos"
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
		query = """TRUNCATE TABLE loader_costos"""
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
					por = None
					pol = None
					pot = None
					pod = None
					podl = None
					bl_move_type = None
					ship_cond = None
					bl_service = None
					bl_bound = None
					bl_item_type = None
					blk_item_type = None
					comm_code = None
					pieces_cnt = None
					pieces_bb = None					
					pieces_mty = None
					wt = None
					vol = None
					c_cleaning = None
					c_repair = None
					c_handling = None
					c_uld_fee_load = None
					c_uld_fee_disc = None
					c_uld = None
					c_storage = None
					c_repo_load = None
					c_repo_disc = None
					c_comm = None
					c_disch_c = None
					c_disc = None
					c_fwd = None
					c_inl_d = None
					c_inl_e_d = None
					c_inl_o = None
					c_load_c = None
					c_load = None
					c_pst_d = None
					c_pre_l = None
					c_strp = None
					c_stuf = None
					c_tax_p = None
					c_tran_c = None
					c_vess = None
					if row[0] != '':
						por = row[0]
					if row[1] != '':
						pol = row[1]
					if row[2] != '':
						pot = row[2]
					if row[3] != '':
						pod = row[3]
					if row[4] != '':
						podl = row[4]
					if row[5] != '':
						bl_move_type = row[5]
					if row[6] != '':
						ship_cond = row[6]
					if row[7] != '':
						bl_service = row[7]
					if row[8]	!= '':
						bl_bound = row[8]
					if row[9] != '':
						bl_item_type = row[9]
					if row[10] != '':
						blk_item_type = row[10]
					if row[11] != '':
						comm_code = row[11]
					if row[12] != '':
						pieces_cnt = row[12]
					if row[13] != '':
						pieces_bb = row[13]
					if row[14] != '':
						pieces_mty = row[14]
					if row[15] != '':
						wt = row[15]
					if row[16] != '':
						vol = row[16]
					if row[17] != '':
						c_cleaning = row[17]
					if row[18] != '':
						c_repair = row[18]
					if row[19] != '':
						c_handling = row[19]
					if row[20] != '':
						c_uld_fee_load = row[20]
					if row[21] != '':
						c_uld_fee_disc = row[21]
					if row[22] != '':
						c_uld = row[22]
					if row[23] != '':
						c_storage = row[23]
					if row[24] != '':
						c_repo_load = row[24]
					if row[25] != '':
						c_repo_disc = row[25]
					if row[26] != '':
						c_comm = row[26]
					if row[27] != '':
						c_disch_c = row[27]
					if row[28] != '':
						c_disc = row[28]
					if row[29] != '':
						c_fwd = row[29]
					if row[30] != '':
						c_inl_d = row[30]
					if row[31] != '':
						c_inl_e_d = row[31]
					if row[32] != '':
						c_inl_o = row[32]
					if row[33] != '':
						c_load_c = row[33]
					if row[34] != '':
						c_load = row[34]
					if row[35] != '':
						c_pst_d = row[35]
					if row[36] != '':
						c_pre_l = row[36]
					if row[37] != '':
						c_strp = row[37]
					if row[38] != '':
						c_stuf = row[38]
					if row[39] != '':
						c_tax_p = row[39]
					if row[40] != '':
						c_tran_c = row[40]
					if row[41] != '':
						c_vess = row[41]

					query = """INSERT INTO loader_costos (				
											por,
											pol,
											pot,
											pod,
											podl,
											bl_move_type,
											ship_cond,
											bl_service,
											bl_bound,
											bl_item_type,
											blk_item_type,
											comm_code,
											pieces_cnt,
											pieces_bb,					
											pieces_mty,
											wt,
											vol,
											c_cleaning,
											c_repair,
											c_handling,
											c_uld_fee_load,
											c_uld_fee_disc,
											c_uld,
											c_storage,
											c_repo_load,
											c_repo_disc,
											c_comm,
											c_disch_c,
											c_disc,
											c_fwd,
											c_inl_d,
											c_inl_e_d,
											c_inl_o,
											c_load_c,
											c_load,
											c_pst_d,
											c_pre_l,
											c_strp,
											c_stuf,
											c_tax_p,
											c_tran_c,
											c_vess
							) VALUES (
								%s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
								%s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
								%s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
								%s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
								%s, %s
							);
					"""
					values = (por.strip().replace(':', '..'),pol.strip().replace(':', '..'),pot.strip().replace(':', '..'),pod.strip().replace(':', '..'),podl.strip().replace(':', '..'),bl_move_type.strip().replace(':', '..'),ship_cond.strip().replace(':', '..'),bl_service.strip().replace(':', '..'),bl_bound.strip().replace(':', '..'),bl_item_type.strip().replace(':', '..'),blk_item_type.strip().replace(':', '..'),comm_code.strip().replace(':', '..'), pieces_cnt, pieces_bb,pieces_mty, wt, vol, c_cleaning, c_repair, c_handling, c_uld_fee_load, c_uld_fee_disc, c_uld, c_storage, c_repo_load, c_repo_disc, c_comm, c_disch_c, c_disc, c_fwd, c_inl_d, c_inl_e_d, c_inl_o, c_load_c, c_load, c_pst_d, c_pre_l, c_strp, c_stuf, c_tax_p, c_tran_c, c_vess)
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

filename  = sys.argv[1]
quit()
c = Costs()
c.truncate()
c.load_file(filename)
