# Hmmm

``` SQL
update $db_order_template.`order` set status='20' where OrderID in ('$OrderID')
```

``` SQL
select
  BrandID,
  venCompany as BrandName,
  selling_window_from as startDate,
  selling_window_to as closingDate,
  s.SeasonNickname as Season,
  Discount
  from
  $db_order_template.order o
  inner join $db_order_template.ds_vendors v on v.venID=o.BrandID
  inner join $db_order_template.order_data od on od.OrderID=o.OrderID
  inner join wavehouse.seasons s on s.SeasonID = od.SeasonID
  where o.OrderID='$OrderID'
```

``` SQL
select min(id) id,DropDate,OrderType
  from $db_order_template.order_dropdates
  where OrderID='$OrderID'
  group by DropDate
```

``` SQL
select id,DropDate,OrderType
  from $db_order_template.order_dropdates
  where OrderID='$OrderID'
```

``` SQL
# checks that the dropdate ID actually contains products that belong in the order
# - this is to combat the occasions when we get duplciate drop dates.
select od.id,od.DropDate,od.OrderType
  from $db_order_template.order_dropdates od
  left join  $db_order_template.order_dropdate_value odv on odv.DropDateID = od.id
  inner join  $db_order_template.order_data_details_temp oddt on oddt.id = odv.OrderDetailID and oddt.orderID = od.orderID
  where od.OrderID = '$OrderID'
  group by od.id
```

``` SQL
select ll.id
  from order_template.order_data od
  left join order_template.line_lists ll on ll.supplierID = od.supplierID
    and ll.seasonID = od.seasonID
  where od.OrderID='$OrderID'
```

``` php
<?php
  if(count($matchedlinelists) > 0) {
    $matchlinelistSQL = " and lineListID in (".implode(",",$matchedlinelists).") ";
  }
?>

$lines = OrderTemplate::getTransitItemsForPOCreate($OrderID, 0);
```

## For each line

build manufacturer sku:

``` sql
select BrandProductColour
  from $db_order_template.order_data_details_temp
  where Sku='" . $line['Sku'] . "'
    and BrandColourCode='" . $line['ColorCode'] . "'
    and OrderID='" . $OrderID . "'
```

``` php
  $lines[$key]['ColorName'] = query_value($sql_2);
  $lines[$key]['Sku'] = $lines[$key]['Sku'] . '-' . $lines[$key]['ColorCode'];
```

get product details:

``` sql
select
  ProductName,
  id,
  Subcategory1,
  ReportingColour,
  PressDayProducts,
  VolumeLine,
  Width,
  Depth,
  Height,
  Volume,
  FitsLaptopSize,
  UploadName,
  TradeCostPrice,
  SurfdomePrice,
  BrandProductColour as ColorName,
  CostPriceAfterDiscount,
  RRP as OT_RRP
  from $db_order_template.order_data_details_temp
  where Sku='" . $line['Sku'] . "'
    and BrandColourCode='" . $line['ColorCode'] . "'
    and OrderID='$OrderID'
```

get cost price:

```sql
select CostPrice
  from order_template.line_list_data
  where Sku ='".$line['Sku']."'
    and ColourCode='".$line['ColorCode']."'
    and Size='".mysql_real_escape_string(($line['BrandSize']))."' ".$matchlinelistSQL."
  order by id Desc
```

Category name:

``` sql
select cn.catName
  from $db_wavehouse_r.ds_categories c
  left join $db_wavehouse_r.ds_language_categories cn  on cn.catID = c.catID
  where  cn.langID = 1
    and c.catID = '" . $lines[$key]['ReportingCategory'] . "'
```

### For each drop date

Get size information:

``` sql
select distinct SurfdomeSize,BrandSize
  from $db_order_template.order_size_qty
  where  Sku='" . $line['Sku'] . "'
    and BrandColourCode='" . $line['ColorCode'] . "'
  group by SurfdomeSize
```

if less than one size or only one size:

``` sql
select id,Value as QPO
  from $db_order_template.order_dropdate_value
  where DropdateID='" . $DropDate['id'] . "'
    and OrderDetailID='" . $lines[$key]['ItemLineID'] . "'
```

else:

``` sql
select id,QPO
  from $db_order_template.order_size_qty
  where DropdateID='" . $dr_id . "'
    and Sku='" . $line['Sku'] . "'
    and BrandColourCode='" . $line['ColorCode'] . "'
    and SurfdomeSize='" . mysql_real_escape_string($line['SurfdomeSize']) . "'
    and BrandSize='" . mysql_real_escape_string($line['BrandSize']) . "'
    and orderID = '".$OrderID."'
```

if single size:

```
  $lines[$key]['orderTool_MultiLineID'] = NULL;
  $lines[$key]['orderTool_SingleLineID'] = $r['id'];
```

else

```
  $lines[$key]['orderTool_MultiLineID'] = $r['id'];
  $lines[$key]['orderTool_SingleLineID'] = NULL;
```

then:

``` php
    $Qty_added = $Qty_added + $QPO;
    $lines[$key]['DropDates'][$DropDate['DropDate']]['Type'] = $DropDate['OrderType'];
    $lines[$key]['DropDates'][$DropDate['DropDate']]['Value'] = $QPO;
    $lines[$key][$DropDate['DropDate'] . '-' . 'DropdateLineID'] = $dr_line_id;

    $lines[$key][$DropDate['DropDate']] = $QPO;
```

## After foreach for lines

``` sql
select catID,catName
  from wavehouse.ds_language_categories
  where langid='1'
```

## Massive insert

For each drop date:

For each lines:

``` sql
insert into purchase_orders (
     pID,
     oID,
     qty,
     qtyAdded,
     qtyDone,
     `status`,
     added,
     order_date,
     drop_date,
     arrived_date,
     inv_date,
     po_number,
     operator,
     `comment`,
     cost,
     report_status,
     cancelled_date,
     spare2,
     inPVX,
     po_season,
     reporting_pID,
     original_pID,
     original_oID,
     orderToolLine,
     orderTool_RC,
     orderTool_LG,
     orderTool_venID,
     orderToolItemID,
     orderTool_productName,
     orderTool_SKU,
     orderTool_SDsize,
     orderTool_barcode,
     orderTool_sellPrice,
     orderTool_sizeSort,
     orderTool_MultiLineID,
     orderTool_SingleLineID,
     orderTool_brandSize,
     orderTool_RRP,
     orderTool_SupplierListPrice)
  VALUES (
                  '" . $newpid . "',													/**pID,**/
                  '" . $newoid . "',													/**oID,**/
                  '" . $lines[$key]['DropDates'][$DropDate['DropDate']]['Value'] . "',/**qty,**/
                  '0',																/**qtyAdded,**/
                  '0',																/**qtyDone,**/
                  '2',																/**`status`,**/
                  '" . date('Y-m-d') . " 00:00:00',									/**added,**/
                  '',																	/**order_date,**/
                  '" . $DropDate['DropDate'] . "',									/**drop_date,**/
                  '',																	/**arrived_date,**/
                  '',																	/**inv_date,**/
                  '',																	/**po_number,**/
                  'OT_" . $OrderID . "',												/**operator,**/
                  '" . addslashes($thisrow['comments']) . "',							/**`comment`,**/
                  '" . round( $lines[$key]['BrandCostPrice'] * ((100-$orderDiscount)/100), 2) . "',				/**cost,**/
                  '',																	/**report_status,**/
                  '',																	/**cancelled_date,**/
                  '',																	/**spare2,**/
                  '',																	/**inPVX,**/
                  '" . addslashes($thisrow['Season']) . "',							/**po_season,**/
                  '',																	/**reporting_pID,**/
                  '',																	/**original_pID,**/
                  '',																	/**original_oID,**/
                  '" . $thisrow[$DropDate['DropDate'] . '-' . 'DropdateLineID'] . "', /**orderToolLine,**/
                  '" . $thisrow['ReportingCategory'] . "',							/**orderTool_RC,**/
                  '" . $thisrow['LeadGender'] . "',									/**orderTool_LG,**/
                  '" . $BrandID . "',													/**orderTool_venID,**/
                  '" . $thisrow['ItemLineID'] . "',									/**orderToolItemID,**/
                  '" . addslashes($thisrow['UploadName']) . "',						/**orderTool_productName,**/
                  '" . $thisrow['Sku'] . "',											/**orderTool_SKU,**/
                  '" . mysql_real_escape_string($thisrow['SurfdomeSize']) . "',									/**orderTool_SDsize,**/
                  '" . $thisrow['Barcode'] . "',										/**orderTool_barcode,**/
                  '" . $thisrow['SurfdomePrice'] . "',								/**orderTool_sellPrice,**/
                  '',																	/**orderTool_sizeSort,**/
                  '" . $lines[$key]['orderTool_MultiLineID'] . "',					/**orderTool_MultiLineID,**/
                  '" . $lines[$key]['orderTool_SingleLineID'] . "',					/**orderTool_SingleLineID,**/
                  '" . mysql_real_escape_string($lines[$key]['BrandSize']) . "'									/**orderTool_brandSize**/,
                  '" . $lines[$key]['RRP'] . "'									/**orderTool_RRP**/,
                  '" . $lines[$key]['BrandCostPrice'] . "'									/**orderTool_Supplier List Price**/
                )
```

after insert

if ex_ItemLineID isnt the same as the current item line ID, createnew product details

``` sql
insert into sd_product_details (pID,brandProductCode,brandProductName,brandColourCode,brandColourName,orderToolItemID,startDate,closingDate,subcatID1,volumeLine,PRList,REALRRP)
  values
              ('" . (($thisrow['ItemLineID']) * -1) . "','" . $tmp_prod_code . "','" . $thisrow['ProductName'] . "','" . $tmp_color_code . "','" . $thisrow['ColorName'] . "','" . $thisrow['ItemLineID'] . "','" . $startDate . "','" . $closingDate . "','" . $thisrow['Subcategory1ID'] . "','" . $thisrow['VolumeLine'] . "','" . $thisrow['PressDayProducts'] . "','" .  $lines[$key]['RRP'] . "')
```

## For each purchase order line item created

for each drop date


``` sql
insert into po_summary values('','" . addslashes($BrandName) . "','" . $dropdate . "','1','" . $poDate . "','Order_Tool','','" . $type . "','" . $BrandID . "','','" . addslashes($BrandName . "_" . $dropdate) . "')
```

``` sql
update purchase_orders set order_date = '" . $poDate . "',po_number = '" . $newPONUM . "' where id = '" . $orderline[8] . "'
```
