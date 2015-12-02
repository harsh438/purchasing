<?php
  $endpoint = 'http://localhost:5000/api/skus.json';
  $ch = curl_init();

  $opts = array('manufacturer_sku' => 'MANU-FACTURER-SKU-14',
                'product_name' => 'A nice little shirt',
                'lead_gender' => 'M',
                'manufacturer_color' => 'blueish',
                'manufacturer_size' => 'smallish',
                'season' => 'witch',
                'color' => 'blue',
                'size' => 'small',
                'color_family' => 'blues',
                'cost_price' => 10.00,
                'price' => 5.00);

  curl_setopt($ch, CURLOPT_URL, $endpoint);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($opts));
  $output = curl_exec($ch);

  var_dump($output);

  curl_close($ch);
?>
