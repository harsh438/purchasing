<?php
  $opts = array( 'manufacturer_sku' => 'DA-DET-WHT',
                 'manufacturer_color' => 'Pale Blue',
                 'manufacturer_size' => '12',
                 'season' => 'ss15',
                 'color' => 'Blue',
                 'size' => '06-9 mths',
                 'cost_price' => 12.06,
                 'price' => 18.00,
                 'lead_gender' => 'M',
                 'product_name' => 'Clarks Originals Boots - Clarks Originals Baby Warm  - Pale Blue',
                 'vendor_id' => 919,
                 // New fields
                 'category_id' => 12,
                 'category_name' => 'Whatever',
                 'vendor_id' => 232,
                 'inv_track' => 'P');

  $endpoint = 'http://localhost:5000/api/skus.json';

                $ch = curl_init();
                curl_setopt($ch, CURLOPT_URL, $endpoint);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
                curl_setopt($ch, CURLOPT_USERPWD, 'purchasing' . ":" . 'lastordersplease');
                curl_setopt($ch, CURLOPT_POST, 1);
                curl_setopt($ch, CURLOPT_VERBOSE, true);
                curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($opts));

  $output = curl_exec($ch);

  var_dump($output);

  curl_close($ch);
?>
