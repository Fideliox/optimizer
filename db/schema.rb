# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140117170406) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "iz_capacity_results", id: false, force: true do |t|
    t.string "resource"
    t.float  "max_teu"
    t.float  "used_teu"
    t.float  "max_plugs_teu"
    t.float  "used_plugs"
    t.float  "max_weight"
    t.float  "used_weight"
  end

  create_table "iz_ccni_stocks", force: true do |t|
    t.string   "port",           limit: 5
    t.string   "container_type", limit: 5
    t.date     "date"
    t.float    "in_full"
    t.float    "in_empty"
    t.float    "buy"
    t.float    "out_full"
    t.float    "out_empty"
    t.float    "stock"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "iz_countries", force: true do |t|
    t.string   "code",       limit: 2
    t.string   "name",       limit: 200
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "iz_dda_final_results", id: false, force: true do |t|
    t.string "dda"
    t.float  "cost_per_teu"
    t.float  "sol_units_teu"
  end

  create_table "iz_dda_final_results_detail", id: false, force: true do |t|
    t.string "dda"
    t.float  "cost_per_teu"
    t.float  "sol_units_teu"
    t.string "leg"
  end

  create_table "iz_empty_od", force: true do |t|
    t.string "fecha",           limit: 20
    t.string "origen",          limit: 5
    t.string "destino",         limit: 5
    t.float  "contenedores"
    t.string "tipo_contenedor", limit: 10
    t.string "nave",            limit: 50
  end

  create_table "iz_file_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  create_table "iz_files", force: true do |t|
    t.string   "name"
    t.integer  "iz_file_type_id"
    t.boolean  "activated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "iz_files", ["iz_file_type_id"], name: "index_iz_files_on_iz_file_type_id", using: :btree

  create_table "iz_list_ports", force: true do |t|
    t.string   "name",          limit: 200
    t.string   "code",          limit: 3
    t.integer  "iz_country_id"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "ccni"
  end

  create_table "iz_loader_caps", force: true do |t|
    t.string   "location",     limit: 5
    t.string   "destination",  limit: 5
    t.string   "sentido",      limit: 2
    t.string   "nave",         limit: 100
    t.string   "servicio",     limit: 3
    t.integer  "viaje"
    t.datetime "fecha_arribo"
    t.datetime "fecha_zarpe"
    t.float    "max_teu"
    t.float    "max_plugs"
    t.float    "max_weight"
    t.string   "resource"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "iz_poly_lines", force: true do |t|
    t.integer  "ori"
    t.integer  "des"
    t.text     "coo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "distance"
  end

  create_table "iz_query_results", force: true do |t|
    t.string "object_name"
    t.string "from_location"
    t.string "to_location"
    t.string "material"
    t.string "process_description"
    t.string "resource"
    t.float  "solution_units"
    t.float  "cost_per_unit"
    t.float  "solution_units_1"
    t.float  "cost_per_unit1"
    t.string "object_name_1"
  end

  create_table "iz_query_transit_empty", id: false, force: true do |t|
    t.string "object_name"
    t.string "to_location"
    t.string "material"
    t.string "process_description"
    t.float  "cost_per_unit"
    t.float  "solution_units"
    t.float  "opp_value_per_unit"
  end

  create_table "iz_status_python", id: false, force: true do |t|
    t.string  "process",  limit: 50
    t.integer "actual"
    t.integer "total"
    t.integer "ready"
    t.integer "limite"
    t.string  "filename", limit: nil
  end

  create_table "loader_capacidades", force: true do |t|
    t.text  "vessel"
    t.text  "service_code"
    t.text  "vessel_code"
    t.text  "operator"
    t.text  "port"
    t.text  "bound"
    t.float "average_weight_cap"
    t.float "average_teus_cap"
    t.float "average_reefer"
    t.float "ttl_wt_bb"
    t.float "ttl_vol_bb"
  end

  create_table "loader_demanda", force: true do |t|
    t.string "servicio1"
    t.string "sentido1"
    t.string "nave1"
    t.float  "viaje1"
    t.string "por_onu"
    t.string "pol_onu"
    t.string "pod_onu"
    t.string "podl_onu"
    t.string "direct_ts"
    t.string "item_type"
    t.string "cnt_type_iso"
    t.string "comm_name"
    t.string "issuer_name"
    t.string "customer_type"
    t.float  "cantidad"
    t.float  "freight_tons_un"
    t.float  "weight_un"
    t.float  "teus"
    t.float  "lost_teus"
    t.float  "flete_all_in_us_un"
    t.float  "other_cost"
  end

  create_table "loader_itinerario", force: true do |t|
    t.float    "viaje"
    t.text     "ccni_code"
    t.float    "numero_viaje"
    t.text     "codigo_servicio"
    t.text     "sentido"
    t.float    "viaje_ant"
    t.float    "viaje_sig"
    t.datetime "fecha_inicio"
    t.datetime "fecha_termino"
    t.text     "codigo_operador"
    t.float    "id_recalada"
    t.text     "codigo_pais"
    t.text     "codigo_puerto"
    t.text     "tipo_recalada"
    t.float    "secuencia"
    t.datetime "fecha_arribo_plani"
    t.datetime "fecha_zarpe_planif"
    t.datetime "fecha_arribo_conf"
    t.datetime "fecha_zarpe_conf"
    t.text     "enlazado_con"
    t.float    "secuencia_1"
    t.text     "pais_dest"
    t.text     "puerto_dest"
    t.datetime "arribo_plan_dest"
    t.datetime "zarpe_plan_dest"
    t.datetime "arribo_conf_dest"
    t.datetime "zarpe_conf_dest"
    t.text     "nave"
  end

  create_table "loader_rutas_factibles", force: true do |t|
    t.string "pol_onu",           limit: nil
    t.string "pod_onu",           limit: nil
    t.string "start_date",        limit: nil
    t.string "puertos_factibles", limit: nil
  end

  create_table "loader_rutas_naves_factibles", force: true do |t|
    t.string "pol_onu",           limit: nil
    t.string "pod_onu",           limit: nil
    t.string "start_date",        limit: nil
    t.string "rutas_factibles",   limit: nil
    t.string "puertos_factibles", limit: nil
    t.string "direct_ts",         limit: nil
    t.string "nave",              limit: nil
    t.string "nave_ini",          limit: nil
  end

  create_table "notifications", force: true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "flash"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rbo_files", force: true do |t|
    t.string  "name",      limit: 150
    t.string  "file_type", limit: nil
    t.boolean "activated"
  end

  create_table "rbo_roles", force: true do |t|
    t.string   "name",       limit: 100, null: false
    t.boolean  "activated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "open_path",  limit: 200
  end

  create_table "rbo_users", force: true do |t|
    t.string   "name",                   limit: 50,              null: false
    t.string   "username",               limit: 50,              null: false
    t.string   "password",               limit: 25
    t.string   "encrypted_password",     limit: 250
    t.string   "salt",                   limit: 200
    t.integer  "access",                             default: 0
    t.string   "email",                  limit: 100
    t.string   "signature",              limit: 100
    t.boolean  "online"
    t.integer  "rbo_role_id",                                    null: false
    t.boolean  "activated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "rbo_users", ["email"], name: "index_rbo_users_on_email", unique: true, using: :btree
  add_index "rbo_users", ["rbo_role_id"], name: "index_rbo_users_on_rbo_role_id", using: :btree
  add_index "rbo_users", ["reset_password_token"], name: "index_rbo_users_on_reset_password_token", unique: true, using: :btree

  create_table "settings", force: true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
