/// Ported verbatim from the prototype's `CUSTOMER_NAMES` / `SUPPLIER_NAMES`
/// / `ITEM_CATALOG` / `WAREHOUSES` / name pools / `TERRITORIES` / `CITIES` /
/// `COURIERS` / `VEHICLES` constants.
class ItemCatalogEntry {
  const ItemCatalogEntry({
    required this.name,
    required this.group,
    required this.uom,
    required this.cost,
    required this.price,
  });

  final String name;
  final String group;
  final String uom;
  final double cost;
  final double price;
}

class WarehouseSeed {
  const WarehouseSeed({required this.code, required this.name, required this.city});

  final String code;
  final String name;
  final String city;
}

const kCustomerNames = [
  'Alden Retail Group', 'Brightpoint Electronics', 'Cascadia Foods Inc.', 'Delmarva Hardware Co.',
  'Everstone Industrial', 'Falcon Ridge Supermarkets', 'Grantline Manufacturing', 'Harbor & Vine Distributors',
  'Ionic Components Ltd.', 'Junction Apparel Co.', 'Kestrel Home Furnishings', 'Lakeshore Pharmacy Group',
  'Meridian Auto Parts', 'Norwood Office Supply', 'Orchard Fresh Markets', 'Pioneer Steel Traders',
  'Quantum Appliance Retail', 'Riverton Building Supply', 'Solaris Consumer Goods', 'Trailhead Sports Co.',
  'Union Bay Wholesale', 'Vanguard Tech Retail', 'Westfield Toy & Hobby', 'Yellowstone Outfitters',
];

const kSupplierNames = [
  'Anchor Steel Mills', 'Bluepeak Electronics Mfg', 'Continental Packaging Co.', 'Dynatech Components',
  'Everline Textiles Ltd.', 'Frontier Plastics Group', 'Global Circuit Supply', 'Highland Timber & Lumber',
  'Ironclad Fasteners Inc.', 'Jasper Chemical Works', 'Keystone Precision Parts', 'Lumino Glass Industries',
  'Meritline Rubber Co.', 'Nordic Paper Mills', 'Omega Motors & Gears', 'Prime Foods Ingredients',
  'Quarrystone Aggregates', 'Redwood Adhesives Co.', 'Summit Alloy Casting', 'Titanium Fabricators LLC',
];

const kItemCatalog = [
  ItemCatalogEntry(name: 'Steel Hex Bolt M8x40', group: 'Fasteners', uom: 'PCS', cost: 0.18, price: 0.42),
  ItemCatalogEntry(name: 'Galvanized Washer 10mm', group: 'Fasteners', uom: 'PCS', cost: 0.03, price: 0.09),
  ItemCatalogEntry(name: 'Stainless Steel Nut M8', group: 'Fasteners', uom: 'PCS', cost: 0.06, price: 0.15),
  ItemCatalogEntry(name: 'Industrial Ball Bearing 6204', group: 'Mechanical Parts', uom: 'PCS', cost: 2.10, price: 4.75),
  ItemCatalogEntry(name: 'Hydraulic Hose 1/2in', group: 'Mechanical Parts', uom: 'MTR', cost: 3.40, price: 7.20),
  ItemCatalogEntry(name: 'Aluminum Sheet 4x8 3mm', group: 'Raw Materials', uom: 'SHEET', cost: 48.00, price: 82.00),
  ItemCatalogEntry(name: 'Cold Rolled Steel Coil', group: 'Raw Materials', uom: 'KG', cost: 1.15, price: 1.85),
  ItemCatalogEntry(name: 'HDPE Plastic Granules', group: 'Raw Materials', uom: 'KG', cost: 1.60, price: 2.60),
  ItemCatalogEntry(name: 'Corrugated Shipping Box M', group: 'Packaging', uom: 'PCS', cost: 0.45, price: 0.95),
  ItemCatalogEntry(name: 'Stretch Wrap Film 500mm', group: 'Packaging', uom: 'ROLL', cost: 6.20, price: 11.50),
  ItemCatalogEntry(name: 'Pallet Wrap Strapping', group: 'Packaging', uom: 'ROLL', cost: 9.80, price: 16.90),
  ItemCatalogEntry(name: 'LED Panel Light 40W', group: 'Electronics', uom: 'PCS', cost: 11.40, price: 24.90),
  ItemCatalogEntry(name: 'Circuit Board Controller X2', group: 'Electronics', uom: 'PCS', cost: 22.00, price: 48.50),
  ItemCatalogEntry(name: 'USB-C Power Adapter 65W', group: 'Electronics', uom: 'PCS', cost: 6.80, price: 16.99),
  ItemCatalogEntry(name: 'Lithium Battery Pack 18650', group: 'Electronics', uom: 'PCS', cost: 4.10, price: 9.50),
  ItemCatalogEntry(name: 'Cordless Drill 18V', group: 'Power Tools', uom: 'PCS', cost: 38.00, price: 79.00),
  ItemCatalogEntry(name: 'Angle Grinder 850W', group: 'Power Tools', uom: 'PCS', cost: 29.50, price: 64.00),
  ItemCatalogEntry(name: 'Safety Helmet Class E', group: 'Safety Equipment', uom: 'PCS', cost: 5.20, price: 12.50),
  ItemCatalogEntry(name: 'Nitrile Work Gloves L', group: 'Safety Equipment', uom: 'PAIR', cost: 1.10, price: 2.90),
  ItemCatalogEntry(name: 'Hi-Vis Safety Vest', group: 'Safety Equipment', uom: 'PCS', cost: 3.60, price: 8.90),
  ItemCatalogEntry(name: 'Office Chair Ergo Mesh', group: 'Office Furniture', uom: 'PCS', cost: 64.00, price: 139.00),
  ItemCatalogEntry(name: 'Adjustable Standing Desk', group: 'Office Furniture', uom: 'PCS', cost: 120.00, price: 249.00),
  ItemCatalogEntry(name: 'A4 Copy Paper 80gsm', group: 'Office Supplies', uom: 'REAM', cost: 3.10, price: 5.60),
  ItemCatalogEntry(name: 'Toner Cartridge Black HY', group: 'Office Supplies', uom: 'PCS', cost: 24.00, price: 49.90),
  ItemCatalogEntry(name: 'Organic Rolled Oats 1kg', group: 'FMCG - Food', uom: 'PCS', cost: 1.90, price: 3.75),
  ItemCatalogEntry(name: 'Extra Virgin Olive Oil 1L', group: 'FMCG - Food', uom: 'PCS', cost: 5.40, price: 9.99),
  ItemCatalogEntry(name: 'Sparkling Water 12-Pack', group: 'FMCG - Beverage', uom: 'CASE', cost: 4.20, price: 7.99),
  ItemCatalogEntry(name: 'Roasted Coffee Beans 500g', group: 'FMCG - Beverage', uom: 'PCS', cost: 6.10, price: 12.50),
  ItemCatalogEntry(name: 'Cotton Bath Towel Set', group: 'Home Textiles', uom: 'SET', cost: 9.80, price: 22.00),
  ItemCatalogEntry(name: 'Memory Foam Pillow', group: 'Home Textiles', uom: 'PCS', cost: 7.40, price: 16.90),
  ItemCatalogEntry(name: 'Stainless Cookware Set 5pc', group: 'Kitchenware', uom: 'SET', cost: 34.00, price: 69.90),
  ItemCatalogEntry(name: 'Non-Stick Frying Pan 28cm', group: 'Kitchenware', uom: 'PCS', cost: 8.90, price: 18.50),
  ItemCatalogEntry(name: 'Kids Building Blocks Set', group: 'Toys & Games', uom: 'SET', cost: 6.50, price: 14.90),
  ItemCatalogEntry(name: 'Remote Control Car', group: 'Toys & Games', uom: 'PCS', cost: 11.20, price: 24.90),
  ItemCatalogEntry(name: 'Trail Running Shoes', group: 'Sportswear', uom: 'PAIR', cost: 22.00, price: 54.90),
  ItemCatalogEntry(name: 'Insulated Water Bottle 1L', group: 'Sportswear', uom: 'PCS', cost: 4.30, price: 11.90),
  ItemCatalogEntry(name: 'Ceramic Brake Pad Set', group: 'Auto Parts', uom: 'SET', cost: 18.60, price: 39.90),
  ItemCatalogEntry(name: 'Synthetic Engine Oil 5W-30', group: 'Auto Parts', uom: 'CASE', cost: 26.00, price: 48.00),
  ItemCatalogEntry(name: 'Car Battery 12V 60Ah', group: 'Auto Parts', uom: 'PCS', cost: 41.00, price: 79.00),
  ItemCatalogEntry(name: 'PVC Conduit Pipe 20mm', group: 'Building Materials', uom: 'MTR', cost: 0.55, price: 1.10),
];

const kWarehouseSeeds = [
  WarehouseSeed(code: 'WH-EAST-01', name: 'East Coast Distribution Center', city: 'Newark, NJ'),
  WarehouseSeed(code: 'WH-WEST-01', name: 'Pacific Fulfillment Hub', city: 'Ontario, CA'),
  WarehouseSeed(code: 'WH-CTRL-01', name: 'Central Regional Warehouse', city: 'Columbus, OH'),
  WarehouseSeed(code: 'WH-SOU-01', name: 'Southern Distribution Depot', city: 'Dallas, TX'),
  WarehouseSeed(code: 'WH-MFG-01', name: 'Manufacturing Plant Store', city: 'Charlotte, NC'),
  WarehouseSeed(code: 'WH-RET-01', name: 'Metro Retail Cross-Dock', city: 'Chicago, IL'),
];

const kFirstNames = [
  'James', 'Maria', 'David', 'Linda', 'Robert', 'Susan', 'Michael', 'Karen', 'William', 'Jessica',
  'Thomas', 'Amanda', 'Daniel', 'Nicole', 'Kevin', 'Rachel', 'Brian', 'Laura', 'Steven', 'Emily',
  'Carlos', 'Priya', 'Wei', 'Fatima', 'Anders',
];

const kLastNames = [
  'Bennett', 'Carter', 'Diaz', 'Ellison', 'Foster', 'Grant', 'Harmon', 'Ibrahim', 'Jansen', 'Kowalski',
  'Lindqvist', 'Mercer', 'Nakamura', 'Ortega', 'Patel', 'Quintero', 'Reyes', 'Sorensen', 'Thackeray', 'Vance',
];

const kTerritories = ['Northeast', 'Southeast', 'Midwest', 'Southwest', 'Pacific Northwest', 'Mountain West'];

const kCities = [
  'New York, NY', 'Los Angeles, CA', 'Chicago, IL', 'Houston, TX', 'Phoenix, AZ', 'Philadelphia, PA',
  'San Antonio, TX', 'San Diego, CA', 'Dallas, TX', 'Columbus, OH', 'Charlotte, NC', 'Seattle, WA',
  'Denver, CO', 'Boston, MA', 'Atlanta, GA',
];

const kCouriers = [
  'FedEx Freight', 'UPS Ground', 'DHL Express', 'XPO Logistics', 'Old Dominion Freight', 'J.B. Hunt Transport',
];

const kVehicles = [
  'Truck 40ft Trailer #TX-1042', 'Box Truck 24ft #OH-2210', 'Refrigerated Truck #CA-3387',
  'Flatbed Trailer #NJ-5521', 'Van Delivery #IL-8890', 'Truck 20ft #NC-1173',
];
