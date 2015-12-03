<?php
  $opts = array( 'manufacturer_sku' => 261040,
                 'manufacturer_color' => 'Pale Blue',
                 'manufacturer_size' => 'LRG',
                 'season' => 'ss15',
                 'color' => 'Blue',
                 'size' => '06-9 mths',
                 'cost_price' => 12.06,
                 'price' => 18.00,
                 'lead_gender' => 'm',
                 'product_name' => 'Clarks Originals Boots - Clarks Originals Baby Warm  - Pale Blue',
                 'vendor_id' => 919);

  $endpoint = 'https://purchasing.surfdome.cc/api/skus.json';

                $ch = curl_init();
                curl_setopt($ch, CURLOPT_URL, $endpoint);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
                curl_setopt($ch, CURLOPT_USERPWD, 'purchasing' . ":" . 'lastordersplease');
                curl_setopt($ch, CURLOPT_POST, 1);
                curl_setopt($ch, CURLOPT_VERBOSE, true);
                curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($opts));
                $output = curl_exec($ch);

  $output = curl_exec($ch);

  var_dump($output);

  curl_close($ch);
?>
