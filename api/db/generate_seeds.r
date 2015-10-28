#
# This script can be run on a local mysql instance.
# It requires all the tables that were provided to us originally within the `ordertool.tar.gz` file.
# It cleans up all the data in those tables ***IN PLACE***.
# This script makes the data fit for use in local and staging development of the order tool.
#
# Requirements
# - Uses local mysql
# - install.packages("RMySQL")
#

library("RMySQL")

conn <- dbConnect(MySQL(),
                 user='root',
                 password='',
                 dbname='surfdome',
                 host='127.0.0.1')

# Generates initials from a string vector
initials <- function(v) {
  v <- substr(v, 1, 1)
  v <- head(v[!(v %in% c('(','',',',NA))], 3)
  paste(toupper(v), collapse='.')
}

# Redacts a name by initialing all substrings, split by space.
redact_to_initials <- function(name, use = '') {
  if (is.na(name)) {
    return(NA)
  }
  Encoding(name) <- 'latin1'
  name <- strsplit(name, ' ')
  name <- initials(unlist(name[1]))
  if (nchar(use) > 0) {
    name <- paste(name, use, sep=' - ')
  }
  name
}

# Partially redacts an email
redact_email <- function(email) {
  paste(unlist(strsplit(email, '@'))[1], 'example.com', sep='@')
}

####################
# TABLE: suppliers #
####################

resource <- dbSendQuery(conn, 'select * from suppliers')

suppliers_in <- fetch(resource, n=-1)
suppliers_in['SupplierName'] <- unlist(lapply(suppliers_in$SupplierName, redact_to_initials))
suppliers_in['cName'] <- unlist(lapply(suppliers_in$cName, redact_to_initials))
suppliers_in['cNumber'] <- unlist(lapply(suppliers_in$cNumber, redact_to_initials))
suppliers_in['cAddress1'] <- unlist(lapply(suppliers_in$cAddress1, redact_to_initials))
suppliers_in['cAddress2'] <- unlist(lapply(suppliers_in$cAddress2, redact_to_initials))
suppliers_in['cAddress3'] <- unlist(lapply(suppliers_in$cAddress3, redact_to_initials))
suppliers_in['cDiscrepancies'] <- unlist(lapply(suppliers_in$cDiscrepancies, redact_to_initials, use='Often stores postcodes'))

# cPostcode is never used.
suppliers_in['cPostcode'] <- unlist(lapply(suppliers_in$cPostcode, redact_to_initials))

dbClearResult(resource)

##########################
# TABLE: purchase_orders #
##########################

resource <- dbSendQuery(conn, 'select * from purchase_orders')

purchase_orders_in <- fetch(resource, n=-1)
purchase_orders_in$cost <- '1.00'
purchase_orders_in$orderTool_sellPrice <- '2.00'
purchase_orders_in$orderTool_SupplierListPrice <- '3.00'
purchase_orders_in$orderTool_RRP <- '4.00'

poCount <- nrow(purchase_orders_in)
purchase_orders_in <- purchase_orders_in[sample(poCount, as.integer(poCount / 5)), ]

dbClearResult(resource)

#####################
# TABLE: po_summary #
#####################

resource <- dbSendQuery(conn, 'select * from po_summary')

po_summary_in <- fetch(resource, n=-1)
po_summary_in['Brand'] <- unlist(lapply(po_summary_in$Brand, redact_to_initials))
po_summary_in['operator'] <- unlist(lapply(po_summary_in$operator, redact_to_initials))

dbClearResult(resource)

##########################
# TABLE: order_suppliers #
##########################

resource <- dbSendQuery(conn, 'select * from order_suppliers')

order_suppliers_in <- fetch(resource, n=-1)
order_suppliers_in['supplierName'] <- unlist(lapply(order_suppliers_in$supplierName, redact_to_initials))

dbClearResult(resource)

#####################
# TABLE: ds_vendors #
#####################

resource <- dbSendQuery(conn, 'select * from ds_vendors')

ds_vendors_in <- fetch(resource, n=-1)
ds_vendors_in['venEmail'] <- unlist(lapply(ds_vendors_in$venEmail, redact_email))
ds_vendors_in['venCompany'] <- unlist(lapply(ds_vendors_in$venCompany, redact_to_initials))
ds_vendors_in['venAddress1'] <- unlist(lapply(ds_vendors_in$venAddress1, redact_to_initials))
ds_vendors_in['venAddress2'] <- unlist(lapply(ds_vendors_in$venAddress2, redact_to_initials))
ds_vendors_in['venCity'] <- unlist(lapply(ds_vendors_in$venCity, redact_to_initials))
ds_vendors_in['venState'] <- unlist(lapply(ds_vendors_in$venState, redact_to_initials))
ds_vendors_in['venZip'] <- unlist(lapply(ds_vendors_in$venZip, redact_to_initials))
ds_vendors_in['venFax'] <- unlist(lapply(ds_vendors_in$venFax, redact_to_initials, use='Seems to store brand info.'))
ds_vendors_in$venUser <- '*** REDACTED *** (Always blank or null)'
ds_vendors_in$venPass <- '*** REDACTED ***'
ds_vendors_in$venPhone <- '*** REDACTED *** (Sometimes stores country instead of phone)'
ds_vendors_in$venString <- '*** REDACTED *** (Some kind of MD5)'

dbClearResult(resource)

######################
# TABLE: ds_products #
######################

resource <- dbSendQuery(conn, 'select * from ds_products')

ds_products_in <- fetch(resource, n=-1)
ds_products_in$pPrice <- '1.00'
ds_products_in$pSalesPrice <- '2.00'
ds_products_in$pCost <- '3.00'

dbClearResult(resource)

#####################
# TABLE: ds_options #
#####################

resource <- dbSendQuery(conn, 'select * from ds_options')

ds_options_in <- fetch(resource, n=-1)
ds_options_in$oPrice <- '500.00'

dbClearResult(resource)

####################
# WRITE ALL TABLES #
####################
dbDisconnect(conn)
conn2 <- dbConnect(MySQL(),
                 user='root',
                 password='',
                 dbname='surf_out_main',
                 host='127.0.0.1')

cat('writing suppliers... ')
dbWriteTable(conn2, 'suppliers', suppliers_in, overwrite=FALSE, append=TRUE, row.names=FALSE)
print('done.')

cat('writing ds_options... ')
dbWriteTable(conn2, 'ds_options', ds_options_in, overwrite=FALSE, append=TRUE, row.names=FALSE)
print('done.')

cat('writing ds_products... ')
dbWriteTable(conn2, 'ds_products', ds_products_in, overwrite=FALSE, append=TRUE, row.names=FALSE)
print('done.')

cat('writing purchase_orders... ')
dbWriteTable(conn2, 'purchase_orders', purchase_orders_in, overwrite=FALSE, append=TRUE, row.names=FALSE)
print('done.')

cat('writing order_suppliers... ')
dbWriteTable(conn2, 'order_suppliers', order_suppliers_in, overwrite=FALSE, append=TRUE, row.names=FALSE)
print('done.')

cat('writing po_summary... ')
dbWriteTable(conn2, 'po_summary', po_summary_in, overwrite=FALSE, append=TRUE, row.names=FALSE)
print('done.')

cat('writing ds_vendors... ')
dbWriteTable(conn2, 'ds_vendors', ds_vendors_in, overwrite=FALSE, append=TRUE, row.names=FALSE)
print('done.')

dbDisconnect(conn2)