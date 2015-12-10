export function loadGoodsReceivedNotices(weekNum) {
  const goodsReceivedNotices = [{ id: '0001', brandName: 'The North Face', status: 'delivered', deliveryDate: '7/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0002', brandName: 'The North Face', status: 'late', deliveryDate: '7/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0003', brandName: 'The North Face', status: 'delivered', deliveryDate: '7/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0014', brandName: 'Adidas', status: 'delivered', deliveryDate: '7/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0015', brandName: 'Hunter', status: 'late', deliveryDate: '7/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0004', brandName: 'Adidas', status: 'delivered', deliveryDate: '8/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0005', brandName: 'Adidas', status: 'delivered', deliveryDate: '8/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0016', brandName: 'Hunter', status: 'delivered', deliveryDate: '8/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0017', brandName: 'Nike', status: 'delivered', deliveryDate: '8/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0006', brandName: 'Adidas', status: 'delivered', deliveryDate: '9/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0007', brandName: 'Adidas', status: 'delivered', deliveryDate: '9/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0008', brandName: 'The North Face', status: 'delivered', deliveryDate: '9/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0009', brandName: 'Adidas', status: 'late', deliveryDate: '9/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0018', brandName: 'Hunter', status: 'delivered', deliveryDate: '9/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0019', brandName: 'Hunter', status: 'delivered', deliveryDate: '9/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0020', brandName: 'The North Face', status: 'late', deliveryDate: '9/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0021', brandName: 'The North Face', status: 'late', deliveryDate: '9/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0022', brandName: 'Trespass', status: 'late', deliveryDate: '9/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0023', brandName: 'The North Face', status: 'balance', deliveryDate: '10/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0024', brandName: 'The North Face', status: 'balance', deliveryDate: '10/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0010', brandName: 'The North Face', status: 'balance', deliveryDate: '10/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0011', brandName: 'The North Face', status: 'balance', deliveryDate: '10/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0012', brandName: 'The North Face', status: 'balance', deliveryDate: '10/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0013', brandName: 'The North Face', status: 'balance', deliveryDate: '11/12/2015', units: 5, cartons: 1, pallets: 1 },
                                { id: '0025', brandName: 'The North Face', status: 'balance', deliveryDate: '11/12/2015', units: 5, cartons: 1, pallets: 1 }];

  return { type: 'SET_GOODS_RECEIVED_NOTICES', goodsReceivedNotices };
}
