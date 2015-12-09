export function loadGoodsReceivedNotices(query) {
  const goodsReceivedNotices = [{ id: '0001', status: 'delivered', deliveryDate: '7/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0002', status: 'late', deliveryDate: '7/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0003', status: 'delivered', deliveryDate: '7/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0004', status: 'delivered', deliveryDate: '8/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0005', status: 'delivered', deliveryDate: '8/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0006', status: 'balance', deliveryDate: '9/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0007', status: 'balance', deliveryDate: '9/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0008', status: 'balance', deliveryDate: '9/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0009', status: 'balance', deliveryDate: '9/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0010', status: 'balance', deliveryDate: '10/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0011', status: 'balance', deliveryDate: '10/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0012', status: 'balance', deliveryDate: '10/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0013', status: 'balance', deliveryDate: '11/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0014', status: 'balance', deliveryDate: '14/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0015', status: 'balance', deliveryDate: '14/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0016', status: 'balance', deliveryDate: '14/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0017', status: 'balance', deliveryDate: '14/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0018', status: 'balance', deliveryDate: '15/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0019', status: 'balance', deliveryDate: '15/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0020', status: 'balance', deliveryDate: '15/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0021', status: 'balance', deliveryDate: '16/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0022', status: 'balance', deliveryDate: '16/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0023', status: 'balance', deliveryDate: '16/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0024', status: 'balance', deliveryDate: '17/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0025', status: 'balance', deliveryDate: '18/12/2015', units: 5, cartons: 1, pallets: 1 }];

  return { type: 'SET_GOODS_RECEIVED_NOTICES', goodsReceivedNotices };
}
