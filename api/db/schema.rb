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

ActiveRecord::Schema.define(version: 20151110151047) do

  create_table "ds_language_categories", force: :cascade do |t|
    t.integer "langID",  limit: 4,   default: 0,  null: false
    t.integer "catID",   limit: 4,   default: 0,  null: false
    t.string  "catName", limit: 80,  default: "", null: false
    t.string  "catDesc", limit: 128
  end

  add_index "ds_language_categories", ["catID"], name: "catID", using: :btree
  add_index "ds_language_categories", ["langID", "catID"], name: "catid and langid", using: :btree
  add_index "ds_language_categories", ["langID"], name: "langID", using: :btree

  create_table "ds_language_products", primary_key: "lpID", force: :cascade do |t|
    t.integer "pID",               limit: 4,     default: 0, null: false
    t.integer "langID",            limit: 4,     default: 0, null: false
    t.text    "pName",             limit: 65535,             null: false
    t.text    "pTeaser",           limit: 65535,             null: false
    t.text    "pDesc",             limit: 65535,             null: false
    t.text    "pCallEmailDisplay", limit: 65535,             null: false
  end

  add_index "ds_language_products", ["langID"], name: "langID", using: :btree
  add_index "ds_language_products", ["pID", "langID"], name: "productlang", using: :btree
  add_index "ds_language_products", ["pID"], name: "pID", using: :btree
  add_index "ds_language_products", ["pName"], name: "productname", length: {"pName"=>128}, using: :btree

  create_table "ds_options", primary_key: "oID", force: :cascade do |t|
    t.integer "pID",                limit: 4,   default: 0,   null: false
    t.integer "parentID",           limit: 4,   default: 0,   null: false
    t.string  "oNum",               limit: 40,  default: "",  null: false
    t.integer "oInvLevel",          limit: 4,   default: 0,   null: false
    t.integer "oNotifyLevel",       limit: 4,   default: 0,   null: false
    t.float   "oPrice",             limit: 24,  default: 0.0, null: false
    t.float   "oWeight",            limit: 24,  default: 0.0, null: false
    t.integer "oGroup",             limit: 2,   default: 0,   null: false
    t.integer "inventory_notified", limit: 4,   default: 0,   null: false
    t.string  "oSizeL",             limit: 32
    t.string  "oSizeC",             limit: 16,  default: "0"
    t.integer "oSizeW",             limit: 4,   default: 0
    t.integer "oSizeH",             limit: 4,   default: 0
    t.integer "oSizeN",             limit: 4,   default: 0
    t.integer "oSizeS",             limit: 4,   default: 0
    t.integer "oSizeOL",            limit: 4,   default: 0
    t.integer "oSizeIL",            limit: 4,   default: 0
    t.string  "oSizeB",             limit: 16
    t.float   "oCost",              limit: 24
    t.string  "oDownloadFile",      limit: 150, default: "",  null: false
  end

  add_index "ds_options", ["pID"], name: "pID", using: :btree
  add_index "ds_options", ["parentID"], name: "parentID", using: :btree

  create_table "ds_products", primary_key: "pID", force: :cascade do |t|
    t.integer "venID",                  limit: 4,     default: 0,   null: false
    t.string  "pNum",                   limit: 40,    default: "",  null: false
    t.float   "pPrice",                 limit: 24,    default: 0.0, null: false
    t.float   "pSalesPrice",            limit: 24,    default: 0.0, null: false
    t.string  "pSale",                  limit: 1,                   null: false
    t.string  "pThumb",                 limit: 70
    t.integer "pThumbWidth",            limit: 4,     default: 0,   null: false
    t.integer "pThumbHeight",           limit: 4,     default: 0,   null: false
    t.string  "pPhoto",                 limit: 70,    default: "",  null: false
    t.integer "pPhotoWidth",            limit: 4,     default: 0,   null: false
    t.integer "pPhotoHeight",           limit: 4,     default: 0,   null: false
    t.string  "pPhoto2",                limit: 70,    default: "",  null: false
    t.integer "pPhoto2Width",           limit: 4,     default: 0,   null: false
    t.integer "pPhoto2Height",          limit: 4,     default: 0,   null: false
    t.string  "pPhoto3",                limit: 70,    default: "",  null: false
    t.integer "pPhoto3Width",           limit: 4,     default: 0,   null: false
    t.integer "pPhoto3Height",          limit: 4,     default: 0,   null: false
    t.string  "pPhoto4",                limit: 70,    default: "",  null: false
    t.integer "pPhoto4Width",           limit: 4,     default: 0,   null: false
    t.integer "pPhoto4Height",          limit: 4,     default: 0,   null: false
    t.string  "pPhoto5",                limit: 70,    default: "",  null: false
    t.integer "pPhoto5Width",           limit: 4,     default: 0,   null: false
    t.integer "pPhoto5Height",          limit: 4,     default: 0,   null: false
    t.string  "pPhoto6",                limit: 70,    default: "",  null: false
    t.integer "pPhoto6Width",           limit: 4,     default: 0,   null: false
    t.integer "pPhoto6Height",          limit: 4,     default: 0,   null: false
    t.string  "pSize",                  limit: 64,    default: "",  null: false
    t.string  "pAvail",                 limit: 1,     default: "N", null: false
    t.integer "invLevel",               limit: 4,     default: 0,   null: false
    t.integer "notifyLevel",            limit: 4,     default: 0,   null: false
    t.string  "invTrack",               limit: 1,     default: "",  null: false
    t.string  "pUDFName1",              limit: 70,    default: "",  null: false
    t.string  "pUDFValue1",             limit: 70,    default: "",  null: false
    t.string  "pUDFName2",              limit: 70,    default: "",  null: false
    t.string  "pUDFValue2",             limit: 70,    default: "",  null: false
    t.string  "pUDFName3",              limit: 70,    default: "",  null: false
    t.string  "pUDFValue3",             limit: 70,    default: "",  null: false
    t.string  "pUDFName4",              limit: 70,    default: "",  null: false
    t.string  "pUDFValue4",             limit: 70,    default: "",  null: false
    t.string  "pUDFName5",              limit: 70
    t.string  "pUDFValue5",             limit: 70,    default: "",  null: false
    t.integer "pRelate1",               limit: 4,     default: 0,   null: false
    t.integer "pRelate2",               limit: 4,     default: 0,   null: false
    t.integer "pRelate3",               limit: 4,     default: 0,   null: false
    t.string  "taxable",                limit: 1,     default: "Y", null: false
    t.string  "pFeature",               limit: 1,     default: "",  null: false
    t.string  "pNew",                   limit: 1,     default: "",  null: false
    t.float   "pWeight",                limit: 24,    default: 0.0, null: false
    t.string  "pFreeShip",              limit: 1,     default: "",  null: false
    t.float   "domMethod1",             limit: 24,    default: 0.0, null: false
    t.float   "domMethod2",             limit: 24,    default: 0.0, null: false
    t.float   "domMethod3",             limit: 24,    default: 0.0, null: false
    t.float   "domMethod4",             limit: 24,    default: 0.0, null: false
    t.float   "intMethod1",             limit: 24,    default: 0.0, null: false
    t.float   "intMethod2",             limit: 24,    default: 0.0, null: false
    t.string  "giftCert",               limit: 1,     default: "",  null: false
    t.string  "extraField",             limit: 1,     default: "",  null: false
    t.string  "extraFieldName",         limit: 55,    default: "",  null: false
    t.string  "extraFieldRequired",     limit: 1,     default: "",  null: false
    t.float   "extraFieldPrice",        limit: 24,    default: 0.0, null: false
    t.text    "meta_description",       limit: 65535
    t.string  "meta_keywords",          limit: 512,   default: ""
    t.string  "meta_title",             limit: 200
    t.integer "inventory_notified",     limit: 1,     default: 0,   null: false
    t.float   "pBoxHeight",             limit: 24
    t.float   "pBoxWidth",              limit: 24
    t.float   "pBoxLength",             limit: 24
    t.float   "pCost",                  limit: 24,    default: 0.0, null: false
    t.string  "pCondition",             limit: 30
    t.date    "pExpiration"
    t.integer "pFlag",                  limit: 4,     default: 0
    t.string  "pProductType",           limit: 30
    t.float   "pBoxGirth",              limit: 24
    t.string  "pFirstClassMailType",    limit: 25
    t.string  "pContainerType",         limit: 25
    t.string  "pRewardsEligible",       limit: 1,     default: "Y"
    t.string  "shippingExempt",         limit: 1,     default: "",  null: false
    t.string  "pShipExempt",            limit: 1,     default: "N", null: false
    t.date    "pCreated"
    t.string  "pGiftWrapAvail",         limit: 1,     default: "",  null: false
    t.float   "pSubscriptionPrice",     limit: 24
    t.string  "pFileUploadEligible",    limit: 1,     default: "N"
    t.string  "pCheckoutId",            limit: 64
    t.string  "pQuickbooksID",          limit: 100
    t.string  "pCallEmailDisplayPrice", limit: 1,     default: "N"
    t.string  "pDownloadFile",          limit: 4,     default: "",  null: false
  end

  add_index "ds_products", ["giftCert"], name: "giftCert", using: :btree
  add_index "ds_products", ["invLevel"], name: "invLevel", using: :btree
  add_index "ds_products", ["invTrack", "invLevel"], name: "idx_invTrack_oInvLevel", using: :btree
  add_index "ds_products", ["meta_keywords"], name: "metakeywords", using: :btree
  add_index "ds_products", ["pContainerType"], name: "pContainerType", using: :btree
  add_index "ds_products", ["pFirstClassMailType"], name: "bestseller", using: :btree
  add_index "ds_products", ["pFlag"], name: "pFlag", using: :btree
  add_index "ds_products", ["pGiftWrapAvail"], name: "pGiftWrapAvail", using: :btree
  add_index "ds_products", ["pNum"], name: "pNum", using: :btree
  add_index "ds_products", ["pPhoto3Width"], name: "bargain", using: :btree
  add_index "ds_products", ["pPhoto4"], name: "Coming soon", using: :btree
  add_index "ds_products", ["pPrice"], name: "price", using: :btree
  add_index "ds_products", ["pProductType"], name: "pProductType", using: :btree
  add_index "ds_products", ["pRelate1"], name: "prelate1", using: :btree
  add_index "ds_products", ["pRelate2"], name: "prelate2", using: :btree
  add_index "ds_products", ["pRelate3"], name: "prelate3", using: :btree
  add_index "ds_products", ["pSale", "pAvail"], name: "idx_psale_pavail", using: :btree
  add_index "ds_products", ["pSalesPrice"], name: "saleprice", using: :btree
  add_index "ds_products", ["pUDFName5"], name: "wentlive", using: :btree
  add_index "ds_products", ["pUDFValue2"], name: "colour", using: :btree
  add_index "ds_products", ["pUDFValue3"], name: "gender", using: :btree
  add_index "ds_products", ["pUDFValue4"], name: "season", using: :btree
  add_index "ds_products", ["pUDFValue5"], name: "location", using: :btree
  add_index "ds_products", ["shippingExempt"], name: "shippingExempt", using: :btree
  add_index "ds_products", ["venID"], name: "venID", using: :btree

  create_table "ds_vendors", primary_key: "venID", force: :cascade do |t|
    t.string "venActNum",         limit: 35
    t.string "venCompany",        limit: 50
    t.string "venContact",        limit: 80
    t.string "venAddress1",       limit: 50
    t.string "venAddress2",       limit: 50
    t.string "venCity",           limit: 40
    t.string "venState",          limit: 40
    t.string "venZip",            limit: 25
    t.string "venCountry",        limit: 2
    t.string "venPhone",          limit: 25
    t.text   "venFax",            limit: 65535
    t.string "venUniqueShipping", limit: 1
    t.string "memo",              limit: 35
    t.text   "note",              limit: 65535
    t.string "venEmail",          limit: 80
    t.string "venUser",           limit: 15
    t.string "venPass",           limit: 15
    t.string "venString",         limit: 35,    default: "", null: false
  end

  add_index "ds_vendors", ["venActNum", "venPass"], name: "venActNum", using: :btree
  add_index "ds_vendors", ["venCompany"], name: "venCompany", using: :btree

  create_table "order_line_items", force: :cascade do |t|
    t.string   "internal_sku", limit: 255
    t.integer  "quantity",     limit: 4
    t.decimal  "cost",                     precision: 8, scale: 2
    t.decimal  "discount",                 precision: 8, scale: 4
    t.integer  "order_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "drop_date"
  end

  add_index "order_line_items", ["order_id"], name: "index_order_line_items_on_order_id", using: :btree

  create_table "order_suppliers", force: :cascade do |t|
    t.string  "orderID",      limit: 12
    t.integer "supplierID",   limit: 4
    t.string  "supplierName", limit: 64
  end

  add_index "order_suppliers", ["orderID"], name: "orderID", unique: true, using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "status",     limit: 255, default: "new"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["status"], name: "index_orders_on_status", using: :btree

  create_table "po_summary", primary_key: "po_num", force: :cascade do |t|
    t.string  "Brand",         limit: 64,  default: "", null: false
    t.date    "drop_date",                              null: false
    t.integer "status",        limit: 4,   default: 0,  null: false
    t.date    "po_date",                                null: false
    t.string  "operator",      limit: 64,  default: "", null: false
    t.string  "orderGrouping", limit: 8,                null: false
    t.string  "orderType",     limit: 8,   default: "", null: false
    t.integer "venID",         limit: 4,   default: 0,  null: false
    t.string  "comments",      limit: 255, default: "", null: false
    t.string  "brandRef",      limit: 64,  default: "", null: false
  end

  add_index "po_summary", ["orderGrouping"], name: "grouping", using: :btree
  add_index "po_summary", ["orderType"], name: "orderTpye", using: :btree
  add_index "po_summary", ["venID"], name: "vendorID", using: :btree

  create_table "product_supplier", primary_key: "pid", force: :cascade do |t|
    t.integer "supplierID", limit: 4, null: false
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.integer  "pID",                         limit: 4,   default: 0,   null: false
    t.integer  "oID",                         limit: 4,   default: 0,   null: false
    t.integer  "qty",                         limit: 4,   default: 0,   null: false
    t.integer  "qtyAdded",                    limit: 4,   default: 0
    t.integer  "qtyDone",                     limit: 4,   default: 0,   null: false
    t.integer  "status",                      limit: 4,   default: 0,   null: false
    t.datetime "added",                                                 null: false
    t.date     "order_date",                                            null: false
    t.date     "drop_date",                                             null: false
    t.date     "arrived_date",                                          null: false
    t.date     "inv_date",                                              null: false
    t.string   "po_number",                   limit: 40,  default: "",  null: false
    t.string   "operator",                    limit: 40,  default: "",  null: false
    t.string   "comment",                     limit: 128
    t.float    "cost",                        limit: 24,  default: 0.0, null: false
    t.string   "report_status",               limit: 16,  default: "",  null: false
    t.date     "cancelled_date",                                        null: false
    t.string   "spare2",                      limit: 16,  default: "",  null: false
    t.integer  "inPVX",                       limit: 4,   default: 0
    t.string   "po_season",                   limit: 8,                 null: false
    t.integer  "reporting_pID",               limit: 4,                 null: false
    t.integer  "original_pID",                limit: 4,                 null: false
    t.integer  "original_oID",                limit: 4,                 null: false
    t.integer  "orderToolLine",               limit: 4
    t.integer  "orderTool_RC",                limit: 4
    t.string   "orderTool_LG",                limit: 4,                 null: false
    t.integer  "orderTool_venID",             limit: 4
    t.integer  "orderToolItemID",             limit: 4,                 null: false
    t.string   "orderTool_productName",       limit: 255
    t.string   "orderTool_SKU",               limit: 64
    t.string   "orderTool_SDsize",            limit: 64
    t.string   "orderTool_barcode",           limit: 32
    t.float    "orderTool_sellPrice",         limit: 24
    t.integer  "orderTool_sizeSort",          limit: 4
    t.integer  "orderTool_MultiLineID",       limit: 4
    t.integer  "orderTool_SingleLineID",      limit: 4
    t.string   "orderTool_brandSize",         limit: 32
    t.float    "orderTool_SupplierListPrice", limit: 24
    t.float    "orderTool_RRP",               limit: 24
  end

  add_index "purchase_orders", ["inv_date"], name: "invoicedate", using: :btree
  add_index "purchase_orders", ["oID"], name: "OptionId", using: :btree
  add_index "purchase_orders", ["operator"], name: "operator", using: :btree
  add_index "purchase_orders", ["orderToolItemID"], name: "orderToolItemID", using: :btree
  add_index "purchase_orders", ["orderTool_LG"], name: "OT_gender", using: :btree
  add_index "purchase_orders", ["orderTool_MultiLineID"], name: "orderTool_MultiLineID", using: :btree
  add_index "purchase_orders", ["orderTool_RC"], name: "orderTool_RC", using: :btree
  add_index "purchase_orders", ["orderTool_SKU"], name: "OrderTool_SKU", using: :btree
  add_index "purchase_orders", ["orderTool_SingleLineID"], name: "orderTool_SingleLineID", using: :btree
  add_index "purchase_orders", ["orderTool_venID"], name: "orderTool_venID", using: :btree
  add_index "purchase_orders", ["pID"], name: "Product index", using: :btree
  add_index "purchase_orders", ["po_number"], name: "ponumber", using: :btree
  add_index "purchase_orders", ["po_season"], name: "po_season", using: :btree
  add_index "purchase_orders", ["reporting_pID"], name: "reporting_pID", using: :btree
  add_index "purchase_orders", ["status"], name: "status", using: :btree

  create_table "sd_product_details", primary_key: "pID", force: :cascade do |t|
    t.string  "colour",             limit: 20, null: false
    t.string  "subCategory",        limit: 64, null: false
    t.string  "volumeLine",         limit: 8,  null: false
    t.string  "PRList",             limit: 32, null: false
    t.float   "avgCost",            limit: 24, null: false
    t.float   "plannedWeeksOnSale", limit: 24, null: false
    t.date    "closingDate",                   null: false
    t.string  "shop1",              limit: 32, null: false
    t.string  "shop2",              limit: 32, null: false
    t.string  "shop3",              limit: 32, null: false
    t.string  "theme1",             limit: 32, null: false
    t.string  "theme2",             limit: 32, null: false
    t.string  "theme3",             limit: 32, null: false
    t.string  "theme4",             limit: 32, null: false
    t.string  "theme5",             limit: 32, null: false
    t.string  "leadGender",         limit: 4,  null: false
    t.integer "BuyingOffice",       limit: 4,  null: false
    t.string  "supplier",           limit: 32, null: false
    t.string  "departmentLevel1",   limit: 32, null: false
    t.string  "departmentLevel2",   limit: 32, null: false
    t.integer "subcatID1",          limit: 4,  null: false
    t.string  "topLevelCategory",   limit: 32, null: false
    t.string  "subCategoryName2",   limit: 32, null: false
    t.integer "subCatID2",          limit: 4,  null: false
    t.integer "subCatID3",          limit: 2
    t.integer "subCatID4",          limit: 2
    t.integer "subCatID5",          limit: 2
    t.string  "matpart1",           limit: 4
    t.string  "mattype1",           limit: 32
    t.string  "matpart2",           limit: 4
    t.string  "mattype2",           limit: 32
    t.string  "matpart3",           limit: 4
    t.string  "mattype3",           limit: 32
    t.string  "matpart4",           limit: 4
    t.string  "mattype4",           limit: 32
    t.string  "matpart5",           limit: 4
    t.string  "mattype5",           limit: 32
    t.float   "width",              limit: 24
    t.float   "depth",              limit: 24
    t.float   "height",             limit: 24
    t.float   "volume",             limit: 24
    t.float   "laptopsize",         limit: 24
    t.float   "REALRRP",            limit: 24
    t.string  "brandProductCode",   limit: 16, null: false
    t.string  "brandProductName",   limit: 64, null: false
    t.string  "brandColourCode",    limit: 16, null: false
    t.string  "brandColourName",    limit: 64, null: false
    t.integer "orderToolItemID",    limit: 4,  null: false
    t.date    "startDate",                     null: false
    t.string  "discontinued",       limit: 1
  end

  add_index "sd_product_details", ["PRList"], name: "PRlist", using: :btree
  add_index "sd_product_details", ["closingDate"], name: "closingDate", using: :btree
  add_index "sd_product_details", ["colour"], name: "colour", using: :btree
  add_index "sd_product_details", ["orderToolItemID"], name: "orderToolItemID", using: :btree
  add_index "sd_product_details", ["startDate"], name: "startSellingDate", using: :btree
  add_index "sd_product_details", ["subCategory"], name: "subcategory", using: :btree
  add_index "sd_product_details", ["volumeLine"], name: "volumeline", using: :btree

  create_table "suppliers", primary_key: "SupplierID", force: :cascade do |t|
    t.string "SupplierName",      limit: 500
    t.string "cName",             limit: 500
    t.string "cNumber",           limit: 100
    t.string "cAddress1",         limit: 500
    t.string "cAddress2",         limit: 500
    t.string "cAddress3",         limit: 500
    t.string "cPostCode",         limit: 10
    t.string "cDiscrepancies",    limit: 1000
    t.string "cReturnProcedures", limit: 1000
  end

  add_index "suppliers", ["SupplierID"], name: "sadsad", using: :btree
  add_index "suppliers", ["SupplierName"], name: "qewqwqe", using: :btree

  create_table "suppliers_to_brands", primary_key: "SupplierToBrandsID", force: :cascade do |t|
    t.integer "BrandID",    limit: 4
    t.integer "SupplierID", limit: 4
    t.integer "InvoicerID", limit: 4
  end

  create_table "suppliers_to_contacts", primary_key: "SuppliersToContactsID", force: :cascade do |t|
    t.integer "ContactsToDetailsID", limit: 4
    t.integer "SupplierToBrandsID",  limit: 4
  end

  add_foreign_key "order_line_items", "orders"
end
