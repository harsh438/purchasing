export function loadGoodsReceivedNotices(query) {
  const goodsReceivedNotices = [{ id: '0001', deliveryDate: '7/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0002', deliveryDate: '7/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0003', deliveryDate: '7/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0004', deliveryDate: '8/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0005', deliveryDate: '8/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0006', deliveryDate: '9/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0007', deliveryDate: '9/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0008', deliveryDate: '9/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0009', deliveryDate: '9/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0010', deliveryDate: '10/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0011', deliveryDate: '10/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0012', deliveryDate: '10/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0013', deliveryDate: '11/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0014', deliveryDate: '14/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0015', deliveryDate: '14/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0016', deliveryDate: '14/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0017', deliveryDate: '14/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0018', deliveryDate: '15/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0019', deliveryDate: '15/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0020', deliveryDate: '15/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0021', deliveryDate: '16/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0022', deliveryDate: '16/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0023', deliveryDate: '16/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0024', deliveryDate: '17/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0025', deliveryDate: '18/12/2015', units: 5, cartons: 1, pallets: 1 }];

  return { type: 'SET_GOODS_RECEIVED_NOTICES', goodsReceivedNotices };
}
