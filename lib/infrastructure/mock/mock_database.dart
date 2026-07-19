import 'dart:math';

import '../../domain/entities/entity_record.dart';
import 'master_data_pools.dart';

/// Ported from `DB` + `genMasterData()` + `genTransactional()` — generates
/// a self-consistent, randomized-but-realistic dataset once at app start,
/// exactly like the prototype does on `initApp()`. Every table is a
/// `List<EntityRecord>` keyed by the same entity `key` used throughout
/// [NavRegistry]/[SchemaRegistry].
class MockDatabase {
  MockDatabase._(this.tables, this.stockLevels);

  final Map<String, List<EntityRecord>> tables;

  /// Ported from `DB.stockLevels[itemId][warehouseId]`.
  final Map<int, Map<int, int>> stockLevels;

  List<EntityRecord> call(String key) => tables[key] ?? const [];
  List<EntityRecord> operator [](String key) => tables[key] ?? const [];

  int itemStockTotal(int itemId) =>
      (stockLevels[itemId] ?? const {}).values.fold(0, (a, b) => a + b);

  EntityRecord? findById(String key, int id) {
    for (final r in this[key]) {
      if (r.id == id) return r;
    }
    return null;
  }

  void insert(String key, EntityRecord record) {
    tables.putIfAbsent(key, () => []).add(record);
  }

  void deleteById(String key, int id) {
    tables[key]?.removeWhere((r) => r.id == id);
  }

  int _runtimeId = 900000;

  /// IDs for records created at runtime via the UI, kept well clear of the
  /// generator's own `_uid` range so they never collide.
  int nextRuntimeId() => ++_runtimeId;

  factory MockDatabase.generate() => _MockDbGenerator().build();
}

class _MockDbGenerator {
  final _rng = Random();
  int _uid = 1000;
  int _nextId() => ++_uid;

  int _randInt(int a, int b) => a + _rng.nextInt(b - a + 1);
  T _choice<T>(List<T> arr) => arr[_randInt(0, arr.length - 1)];
  List<T> _choices<T>(List<T> arr, int n) {
    final pool = List<T>.from(arr);
    final out = <T>[];
    for (var i = 0; i < n && pool.isNotEmpty; i++) {
      out.add(pool.removeAt(_randInt(0, pool.length - 1)));
    }
    return out;
  }

  double _round2(num n) => (n * 100).round() / 100;
  String _pad(int n, int len) => n.toString().padLeft(len, '0');
  DateTime _daysAgo(int n) => DateTime.now().subtract(Duration(days: n));
  DateTime _daysAhead(int n) => DateTime.now().add(Duration(days: n));
  String _randPerson() => '${_choice(kFirstNames)} ${_choice(kLastNames)}';
  String _phone() =>
      '+1 (${_randInt(200, 999)}) ${_randInt(200, 999)}-${_pad(_randInt(0, 9999), 4)}';

  final Map<String, List<EntityRecord>> tables = {};
  final Map<int, Map<int, int>> stockLevels = {};

  List<EntityRecord> _t(String key) => tables.putIfAbsent(key, () => []);

  List<Map<String, dynamic>> _genLine(List<EntityRecord> items, int count) {
    final chosen = _choices(items, count);
    return chosen.map((it) {
      final qty = _randInt(5, 200);
      final rate = (it['sellingPrice'] as num).toDouble();
      return {
        'itemId': it.id,
        'item': it['name'],
        'uom': it['uom'],
        'qty': qty,
        'rate': rate,
        'amount': _round2(qty * rate),
      };
    }).toList();
  }

  List<Map<String, dynamic>> _genPurchaseLine(List<EntityRecord> items, int count) {
    final chosen = _choices(items, count);
    return chosen.map((it) {
      final qty = _randInt(20, 500);
      final rate = (it['standardCost'] as num).toDouble();
      return {
        'itemId': it.id,
        'item': it['name'],
        'uom': it['uom'],
        'qty': qty,
        'rate': rate,
        'amount': _round2(qty * rate),
      };
    }).toList();
  }

  double _lineTotal(List<Map<String, dynamic>> lines) =>
      _round2(lines.fold<double>(0, (a, l) => a + (l['amount'] as num)));

  MockDatabase build() {
    _genMasterData();
    _genTransactional();
    return MockDatabase._(tables, stockLevels);
  }

  // ---------------------------------------------------------------------
  // MASTER DATA
  // ---------------------------------------------------------------------
  void _genMasterData() {
    for (final n in [
      'Key Accounts', 'Retail Chains', 'Wholesale Partners', 'Regional Distributors', 'Government & Institutional',
    ]) {
      _t('customerGroups').add(EntityRecord({'id': _nextId(), 'name': n, 'createdAt': _daysAgo(_randInt(200, 900))}));
    }
    for (final n in [
      'Raw Material Vendors', 'Component Manufacturers', 'Packaging Vendors', 'Logistics Providers', 'Contract Manufacturers',
    ]) {
      _t('supplierGroups').add(EntityRecord({'id': _nextId(), 'name': n, 'createdAt': _daysAgo(_randInt(200, 900))}));
    }
    final itemGroupNames = <String>[];
    for (final it in kItemCatalog) {
      if (!itemGroupNames.contains(it.group)) itemGroupNames.add(it.group);
    }
    for (final n in itemGroupNames) {
      _t('itemGroups').add(EntityRecord({'id': _nextId(), 'name': n, 'createdAt': _daysAgo(_randInt(200, 900))}));
    }
    for (final n in ['PCS', 'KG', 'MTR', 'ROLL', 'SHEET', 'REAM', 'SET', 'PAIR', 'CASE', 'BOX', 'LTR']) {
      _t('uoms').add(EntityRecord({
        'id': _nextId(), 'name': n, 'description': '$n - base unit', 'createdAt': _daysAgo(_randInt(400, 900)),
      }));
    }
    for (final n in kTerritories) {
      _t('salesTerritories').add(EntityRecord({
        'id': _nextId(), 'name': n, 'manager': _randPerson(),
        'targetRevenue': _randInt(400, 900) * 1000, 'createdAt': _daysAgo(_randInt(300, 900)),
      }));
    }
    for (var i = 0; i < 9; i++) {
      final name = _randPerson();
      _t('salesPersons').add(EntityRecord({
        'id': _nextId(), 'name': name,
        'email': '${name.toLowerCase().replaceAll(' ', '.')}@impacgo.com',
        'territory': _choice(kTerritories), 'target': _randInt(180, 420) * 1000,
        'commission': _randInt(3, 8), 'status': 'Active', 'createdAt': _daysAgo(_randInt(100, 900)),
      }));
    }
    final priceListSeeds = [
      ('Standard Retail Price List', 'USD', 'Selling', 'Active'),
      ('Wholesale Tier 1', 'USD', 'Selling', 'Active'),
      ('Key Account Contract Pricing', 'USD', 'Selling', 'Active'),
      ('Export EU Price List', 'EUR', 'Selling', 'Inactive'),
    ];
    for (final (name, ccy, type, status) in priceListSeeds) {
      _t('priceLists').add(EntityRecord({
        'id': _nextId(), 'name': name, 'currency': ccy, 'type': type, 'status': status,
        'createdAt': _daysAgo(_randInt(200, 700)),
      }));
    }

    final customerGroups = _t('customerGroups');
    for (final name in kCustomerNames) {
      final grp = _choice(customerGroups);
      final salesPerson = _choice(_t('salesPersons'));
      final firstWord = name.split(' ').first.toLowerCase().replaceAll(RegExp('[^a-z]'), '');
      _t('customers').add(EntityRecord({
        'id': _nextId(), 'code': 'CUST-${_pad(_nextId(), 4)}', 'name': name, 'group': grp['name'],
        'territory': _choice(kTerritories), 'city': _choice(kCities),
        'email': '${name.toLowerCase().replaceAll(RegExp('[^a-z ]'), '').replaceAll(RegExp(' +'), '.')}@$firstWord.com',
        'phone': _phone(), 'creditLimit': _randInt(10, 120) * 1000, 'salesPerson': salesPerson['name'],
        'status': _choice(['Active', 'Active', 'Active', 'On Hold']), 'createdAt': _daysAgo(_randInt(60, 1000)),
      }));
    }
    for (final cust in _t('customers')) {
      final n = _randInt(1, 2);
      for (var i = 0; i < n; i++) {
        _t('customerContacts').add(EntityRecord({
          'id': _nextId(), 'customer': cust['name'], 'customerId': cust.id, 'name': _randPerson(),
          'designation': _choice(['Procurement Manager', 'Finance Director', 'Operations Lead', 'CEO', 'Supply Chain Manager']),
          'email': 'contact${_randInt(100, 999)}@${(cust['name'] as String).split(' ').first.toLowerCase()}.com',
          'phone': _phone(), 'createdAt': _daysAgo(_randInt(30, 700)),
        }));
      }
    }

    final supplierGroups = _t('supplierGroups');
    for (final name in kSupplierNames) {
      final grp = _choice(supplierGroups);
      final firstWord = name.split(' ').first.toLowerCase().replaceAll(RegExp('[^a-z]'), '');
      _t('suppliers').add(EntityRecord({
        'id': _nextId(), 'code': 'SUPP-${_pad(_nextId(), 4)}', 'name': name, 'group': grp['name'], 'city': _choice(kCities),
        'email': 'sales@$firstWord.com', 'phone': _phone(),
        'paymentTerms': _choice(['Net 30', 'Net 45', 'Net 60', 'Due on Receipt']),
        'rating': _choice(['A - Preferred', 'B - Approved', 'C - Under Review']),
        'status': _choice(['Active', 'Active', 'Active', 'On Hold']), 'createdAt': _daysAgo(_randInt(60, 1000)),
      }));
    }

    for (var idx = 0; idx < kItemCatalog.length; idx++) {
      final it = kItemCatalog[idx];
      final trackBatch = _rng.nextDouble() < 0.4;
      final trackSerial = (it.group == 'Electronics' || it.group == 'Power Tools') && _rng.nextDouble() < 0.5;
      _t('items').add(EntityRecord({
        'id': _nextId(), 'code': 'ITM-${_pad(1000 + idx, 4)}', 'name': it.name, 'group': it.group, 'uom': it.uom,
        'standardCost': it.cost, 'sellingPrice': it.price, 'reorderLevel': _randInt(50, 400), 'status': 'Active',
        'trackBatch': trackBatch, 'trackSerial': trackSerial, 'createdAt': _daysAgo(_randInt(100, 900)),
      }));
    }

    for (final w in kWarehouseSeeds) {
      _t('warehouses').add(EntityRecord({
        'id': _nextId(), 'code': w.code, 'name': w.name, 'city': w.city,
        'type': _choice(['Distribution Center', 'Manufacturing Store', 'Cross-Dock', 'Retail Backstore']),
        'manager': _randPerson(), 'capacity': _randInt(8000, 40000), 'status': 'Active',
        'createdAt': _daysAgo(_randInt(300, 1200)),
      }));
    }

    for (final w in _t('warehouses')) {
      final count = _randInt(4, 6);
      for (var i = 0; i < count; i++) {
        final letter = String.fromCharCode(65 + (i ~/ 2));
        final num = (i % 2) + 1;
        _t('binLocations').add(EntityRecord({
          'id': _nextId(), 'code': '${w['code']}-$letter$num', 'warehouse': w['name'], 'warehouseId': w.id,
          'zone': _choice(['Receiving', 'Bulk Storage', 'Pick Face', 'Staging', 'Returns']),
          'capacityUnits': _randInt(200, 1200), 'occupied': _randInt(20, 90), 'status': 'Active',
          'createdAt': _daysAgo(_randInt(100, 600)),
        }));
      }
    }
    tables['binManagement'] = _t('binLocations');

    for (final it in _t('items')) {
      final levels = <int, int>{};
      final reorder = it['reorderLevel'] as int;
      for (final w in _t('warehouses')) {
        levels[w.id] = _randInt(0, reorder * 3);
      }
      stockLevels[it.id] = levels;
      it['_stockTotal'] = levels.values.fold(0, (a, b) => a + b);
    }

    for (final it in _t('items').where((i) => i['trackBatch'] == true)) {
      final code = it['code'] as String;
      final n = _randInt(1, 3);
      for (var i = 0; i < n; i++) {
        final w = _choice(_t('warehouses'));
        _t('batches').add(EntityRecord({
          'id': _nextId(), 'batchNo': 'BAT-${code.substring(4)}-${_pad(_randInt(1, 999), 3)}',
          'item': it['name'], 'itemId': it.id, 'warehouse': w['name'], 'warehouseId': w.id,
          'qty': _randInt(50, 600), 'mfgDate': _daysAgo(_randInt(30, 300)), 'expDate': _daysAhead(_randInt(60, 700)),
          'status': _choice(['Active', 'Active', 'Quarantine', 'Expiring Soon']), 'createdAt': _daysAgo(_randInt(30, 300)),
        }));
      }
    }

    for (final it in _t('items').where((i) => i['trackSerial'] == true)) {
      final code = it['code'] as String;
      final n = _randInt(3, 7);
      for (var i = 0; i < n; i++) {
        final w = _choice(_t('warehouses'));
        _t('serialNumbers').add(EntityRecord({
          'id': _nextId(), 'serialNo': 'SN-${code.substring(4)}-${_pad(_randInt(10000, 99999), 5)}',
          'item': it['name'], 'itemId': it.id, 'warehouse': w['name'], 'warehouseId': w.id,
          'status': _choice(['In Stock', 'In Stock', 'Delivered', 'Reserved', 'Under Repair']),
          'createdAt': _daysAgo(_randInt(20, 400)),
        }));
      }
    }
  }

  // ---------------------------------------------------------------------
  // TRANSACTIONAL DATA
  // ---------------------------------------------------------------------
  void _genTransactional() {
    final items = _t('items');
    final customers = _t('customers');
    final suppliers = _t('suppliers');
    final warehouses = _t('warehouses');
    final salesPersons = _t('salesPersons');

    const leadStatuses = ['New', 'Contacted', 'Qualified', 'Unqualified', 'Converted'];
    const oppStatuses = ['Prospecting', 'Proposal Sent', 'Negotiation', 'Won', 'Lost'];

    for (var i = 0; i < 22; i++) {
      final companyRaw = '${_choice(kCustomerNames)} ${_choice([
        '(New Prospect)', '', '', '', '',
      ])}'.trim();
      final contact = _randPerson();
      final status = _choice(leadStatuses);
      final firstWord = companyRaw.split(' ').first.toLowerCase().replaceAll(RegExp('[^a-z]'), '');
      _t('leads').add(EntityRecord({
        'id': _nextId(), 'code': 'LEAD-${_pad(_nextId(), 5)}', 'company': companyRaw, 'contact': contact,
        'email': '${contact.toLowerCase().replaceAll(' ', '.')}@$firstWord.com', 'phone': _phone(),
        'source': _choice(['Website', 'Trade Show', 'Referral', 'Cold Call', 'Partner Channel']),
        'territory': _choice(kTerritories), 'salesPerson': _choice(salesPersons)['name'],
        'estimatedValue': _randInt(5, 80) * 1000, 'status': status, 'createdAt': _daysAgo(_randInt(1, 180)),
      }));
    }

    for (var i = 0; i < 18; i++) {
      final cust = _choice(customers);
      final status = _choice(oppStatuses);
      _t('opportunities').add(EntityRecord({
        'id': _nextId(), 'code': 'OPP-${_pad(_nextId(), 5)}', 'customer': cust['name'], 'customerId': cust.id,
        'salesPerson': cust['salesPerson'], 'territory': cust['territory'], 'stage': status,
        'value': _randInt(8, 150) * 1000,
        'probability': status == 'Won' ? 100 : (status == 'Lost' ? 0 : _randInt(20, 80)),
        'closeDate': _daysAhead(_randInt(-10, 90)), 'status': status, 'createdAt': _daysAgo(_randInt(5, 200)),
      }));
    }

    List<EntityRecord> mkDoc({
      required String prefix,
      required int count,
      required List<String> statuses,
      required Map<String, dynamic> Function(EntityRecord base) extra,
    }) {
      final out = <EntityRecord>[];
      for (var i = 0; i < count; i++) {
        final cust = _choice(customers);
        final lines = _genLine(items, _randInt(2, 5));
        final status = _choice(statuses);
        final base = EntityRecord({
          'id': _nextId(), 'code': '$prefix-${_pad(_nextId(), 5)}', 'customer': cust['name'], 'customerId': cust.id,
          'salesPerson': cust['salesPerson'], 'territory': cust['territory'], 'date': _daysAgo(_randInt(1, 150)),
          'lines': lines, 'amount': _lineTotal(lines), 'currency': 'USD', 'status': status,
          'createdAt': _daysAgo(_randInt(1, 150)),
        });
        for (final entry in extra(base).entries) {
          base[entry.key] = entry.value;
        }
        out.add(base);
      }
      return out;
    }

    final quotations = mkDoc(
      prefix: 'QTN', count: 22,
      statuses: const ['Draft', 'Pending Approval', 'Approved', 'Sent', 'Expired', 'Converted'],
      extra: (b) => {'validTill': _daysAhead(_randInt(10, 45))},
    );
    tables['quotations'] = quotations;

    final salesOrders = mkDoc(
      prefix: 'SO', count: 26,
      statuses: const ['Draft', 'Pending Approval', 'Approved', 'In Fulfillment', 'Partially Delivered', 'Delivered', 'Closed', 'Cancelled'],
      extra: (b) => {
        'deliveryDate': _daysAhead(_randInt(3, 30)),
        'quotationRef': _rng.nextDouble() < 0.6 ? _choice(quotations)['code'] : null,
      },
    );
    tables['salesOrders'] = salesOrders;

    final deliveryNotes = mkDoc(
      prefix: 'DN', count: 24,
      statuses: const ['Draft', 'Pending Approval', 'Approved', 'Dispatched', 'In Transit', 'Delivered', 'Cancelled'],
      extra: (b) => {
        'warehouse': _choice(warehouses)['name'],
        'salesOrderRef': _rng.nextDouble() < 0.7 ? _choice(salesOrders)['code'] : null,
        'vehicle': _choice(kVehicles),
      },
    );
    tables['deliveryNotes'] = deliveryNotes;

    final salesInvoices = mkDoc(
      prefix: 'SINV', count: 24,
      statuses: const ['Draft', 'Pending Approval', 'Approved', 'Sent', 'Partially Paid', 'Paid', 'Overdue'],
      extra: (b) => {
        'dueDate': _daysAhead(_randInt(-10, 45)),
        'deliveryRef': _rng.nextDouble() < 0.7 ? _choice(deliveryNotes)['code'] : null,
        'paidAmount': 0,
      },
    );
    for (final inv in salesInvoices) {
      if (inv.status == 'Paid') {
        inv['paidAmount'] = inv['amount'];
      } else if (inv.status == 'Partially Paid') {
        inv['paidAmount'] = _round2((inv['amount'] as num) * 0.5);
      }
    }
    tables['salesInvoices'] = salesInvoices;

    tables['salesReturns'] = mkDoc(
      prefix: 'SRTN', count: 9,
      statuses: const ['Draft', 'Pending Approval', 'Approved', 'Received', 'Refunded'],
      extra: (b) => {
        'reason': _choice(['Damaged in transit', 'Wrong item shipped', 'Customer changed mind', 'Quality issue']),
      },
    );
    tables['creditNotes'] = mkDoc(
      prefix: 'CRN', count: 9,
      statuses: const ['Draft', 'Pending Approval', 'Approved', 'Applied'],
      extra: (b) => {
        'reason': _choice(['Sales return', 'Pricing correction', 'Goodwill adjustment']),
      },
    );

    for (var i = 0; i < 22; i++) {
      final inv = _choice(salesInvoices);
      _t('customerPayments').add(EntityRecord({
        'id': _nextId(), 'code': 'CPMT-${_pad(_nextId(), 5)}', 'customer': inv['customer'], 'customerId': inv['customerId'],
        'invoiceRef': inv['code'], 'amount': _round2((inv['amount'] as num) * _choice([1, 1, 0.5])),
        'mode': _choice(['Bank Transfer', 'Check', 'Credit Card', 'ACH']), 'date': _daysAgo(_randInt(1, 120)),
        'status': _choice(['Received', 'Cleared', 'Pending Clearance', 'Bounced']), 'createdAt': _daysAgo(_randInt(1, 120)),
      }));
    }

    final dispatchSchedule = <EntityRecord>[];
    for (var i = 0; i < 16; i++) {
      final dn = _choice(deliveryNotes);
      dispatchSchedule.add(EntityRecord({
        'id': _nextId(), 'code': 'DSP-${_pad(_nextId(), 5)}', 'deliveryRef': dn['code'], 'customer': dn['customer'],
        'warehouse': dn['warehouse'], 'scheduledDate': _daysAhead(_randInt(-3, 20)), 'vehicle': _choice(kVehicles),
        'driver': _randPerson(), 'status': _choice(['Scheduled', 'Loading', 'Dispatched', 'Delivered', 'Delayed']),
        'createdAt': _daysAgo(_randInt(1, 60)),
      }));
    }
    tables['dispatchSchedule'] = dispatchSchedule;
    tables['deliverySchedule'] = dispatchSchedule;

    List<EntityRecord> mkPDoc({
      required String prefix,
      required int count,
      required List<String> statuses,
      required Map<String, dynamic> Function(EntityRecord base) extra,
    }) {
      final out = <EntityRecord>[];
      for (var i = 0; i < count; i++) {
        final supp = _choice(suppliers);
        final lines = _genPurchaseLine(items, _randInt(2, 5));
        final status = _choice(statuses);
        final base = EntityRecord({
          'id': _nextId(), 'code': '$prefix-${_pad(_nextId(), 5)}', 'supplier': supp['name'], 'supplierId': supp.id,
          'date': _daysAgo(_randInt(1, 150)), 'lines': lines, 'amount': _lineTotal(lines), 'currency': 'USD',
          'status': status, 'createdAt': _daysAgo(_randInt(1, 150)),
        });
        for (final entry in extra(base).entries) {
          base[entry.key] = entry.value;
        }
        out.add(base);
      }
      return out;
    }

    tables['purchaseRequests'] = mkPDoc(
      prefix: 'PR', count: 18,
      statuses: const ['Draft', 'Pending Approval', 'Approved', 'Rejected', 'Converted to RFQ', 'Closed'],
      extra: (b) => {
        'requestedBy': _randPerson(),
        'department': _choice(['Operations', 'Manufacturing', 'Warehouse', 'Procurement']),
      },
    );

    final rfqs = mkPDoc(
      prefix: 'RFQ', count: 14,
      statuses: const ['Draft', 'Sent to Suppliers', 'Quotes Received', 'Closed'],
      extra: (b) => {
        'responseDeadline': _daysAhead(_randInt(5, 20)),
        'invitedSuppliers': _choices(suppliers, 3).map((s) => s['name']).join(', '),
      },
    );
    tables['rfqs'] = rfqs;

    tables['supplierQuotations'] = mkPDoc(
      prefix: 'SQTN', count: 14,
      statuses: const ['Received', 'Under Review', 'Selected', 'Rejected'],
      extra: (b) => {
        'rfqRef': _rng.nextDouble() < 0.7 ? _choice(rfqs)['code'] : null,
        'validTill': _daysAhead(_randInt(10, 40)),
      },
    );

    final purchaseOrders = mkPDoc(
      prefix: 'PO', count: 22,
      statuses: const ['Draft', 'Pending Approval', 'Approved', 'Sent to Supplier', 'Partially Received', 'Received', 'Closed', 'Cancelled'],
      extra: (b) => {
        'expectedDate': _daysAhead(_randInt(3, 40)),
        'rfqRef': _rng.nextDouble() < 0.5 ? _choice(rfqs)['code'] : null,
      },
    );
    tables['purchaseOrders'] = purchaseOrders;

    final purchaseReceipts = mkPDoc(
      prefix: 'GRN', count: 20,
      statuses: const ['Draft', 'Pending Approval', 'Approved', 'Quality Check', 'Accepted', 'Putaway Complete'],
      extra: (b) => {
        'warehouse': _choice(warehouses)['name'],
        'poRef': _rng.nextDouble() < 0.8 ? _choice(purchaseOrders)['code'] : null,
      },
    );
    tables['purchaseReceipts'] = purchaseReceipts;

    final purchaseInvoices = mkPDoc(
      prefix: 'PINV', count: 20,
      statuses: const ['Draft', 'Pending Approval', 'Approved', 'Partially Paid', 'Paid', 'Overdue'],
      extra: (b) => {
        'dueDate': _daysAhead(_randInt(-10, 45)),
        'grnRef': _rng.nextDouble() < 0.8 ? _choice(purchaseReceipts)['code'] : null,
        'paidAmount': 0,
      },
    );
    for (final inv in purchaseInvoices) {
      if (inv.status == 'Paid') {
        inv['paidAmount'] = inv['amount'];
      } else if (inv.status == 'Partially Paid') {
        inv['paidAmount'] = _round2((inv['amount'] as num) * 0.5);
      }
    }
    tables['purchaseInvoices'] = purchaseInvoices;

    tables['purchaseReturns'] = mkPDoc(
      prefix: 'PRTN', count: 7,
      statuses: const ['Draft', 'Pending Approval', 'Approved', 'Shipped', 'Completed'],
      extra: (b) => {
        'reason': _choice(['Defective goods', 'Incorrect specification', 'Excess quantity received']),
      },
    );
    tables['debitNotes'] = mkPDoc(
      prefix: 'DBN', count: 7,
      statuses: const ['Draft', 'Pending Approval', 'Approved', 'Applied'],
      extra: (b) => {
        'reason': _choice(['Purchase return', 'Price discrepancy', 'Freight claim']),
      },
    );

    for (var i = 0; i < 20; i++) {
      final it = _choice(items);
      final w = _choice(warehouses);
      _t('stockEntries').add(EntityRecord({
        'id': _nextId(), 'code': 'SE-${_pad(_nextId(), 5)}',
        'type': _choice(['Material Receipt', 'Material Issue', 'Manufacture', 'Repack']),
        'item': it['name'], 'itemId': it.id, 'warehouse': w['name'], 'warehouseId': w.id,
        'qty': _randInt(10, 300), 'date': _daysAgo(_randInt(1, 120)),
        'status': _choice(['Draft', 'Submitted', 'Completed']), 'createdAt': _daysAgo(_randInt(1, 120)),
      }));
    }

    for (var i = 0; i < 14; i++) {
      final it = _choice(items);
      var from = _choice(warehouses);
      var to = _choice(warehouses);
      while (to.id == from.id) {
        to = _choice(warehouses);
      }
      _t('stockTransfers').add(EntityRecord({
        'id': _nextId(), 'code': 'STR-${_pad(_nextId(), 5)}', 'item': it['name'], 'itemId': it.id,
        'fromWarehouse': from['name'], 'toWarehouse': to['name'], 'qty': _randInt(10, 200),
        'date': _daysAgo(_randInt(1, 90)), 'status': _choice(['Draft', 'Pending Approval', 'In Transit', 'Completed']),
        'createdAt': _daysAgo(_randInt(1, 90)),
      }));
    }

    for (var i = 0; i < 7; i++) {
      final w = _choice(warehouses);
      _t('stockReconciliations').add(EntityRecord({
        'id': _nextId(), 'code': 'SRC-${_pad(_nextId(), 5)}', 'warehouse': w['name'],
        'itemsCounted': _randInt(20, 80), 'discrepanciesFound': _randInt(0, 6),
        'date': _daysAgo(_randInt(1, 90)), 'status': _choice(['Draft', 'In Progress', 'Completed']),
        'createdAt': _daysAgo(_randInt(1, 90)),
      }));
    }

    for (var i = 0; i < 11; i++) {
      final it = _choice(items);
      final w = _choice(warehouses);
      _t('inventoryAdjustments').add(EntityRecord({
        'id': _nextId(), 'code': 'ADJ-${_pad(_nextId(), 5)}', 'item': it['name'], 'itemId': it.id, 'warehouse': w['name'],
        'adjustmentType': _choice(['Increase', 'Decrease']), 'qty': _randInt(1, 50),
        'reason': _choice(['Damaged stock', 'Cycle count variance', 'Expired goods', 'Theft/Loss', 'System correction']),
        'date': _daysAgo(_randInt(1, 90)), 'status': _choice(['Draft', 'Pending Approval', 'Approved']),
        'createdAt': _daysAgo(_randInt(1, 90)),
      }));
    }

    for (var i = 0; i < 15; i++) {
      final so = _choice(salesOrders);
      final w = _choice(warehouses);
      _t('pickingLists').add(EntityRecord({
        'id': _nextId(), 'code': 'PICK-${_pad(_nextId(), 5)}', 'salesOrderRef': so['code'], 'customer': so['customer'],
        'warehouse': w['name'], 'itemsCount': _randInt(2, 6), 'assignedTo': _randPerson(),
        'date': _daysAgo(_randInt(0, 20)), 'status': _choice(['Pending', 'In Progress', 'Picked', 'Short Picked']),
        'createdAt': _daysAgo(_randInt(0, 20)),
      }));
    }

    final pickingLists = _t('pickingLists');
    for (var i = 0; i < 15; i++) {
      final pk = _choice(pickingLists);
      _t('packingLists').add(EntityRecord({
        'id': _nextId(), 'code': 'PACK-${_pad(_nextId(), 5)}', 'pickingRef': pk['code'], 'customer': pk['customer'],
        'cartons': _randInt(1, 10), 'weightKg': _randInt(5, 400), 'packedBy': _randPerson(),
        'date': _daysAgo(_randInt(0, 18)), 'status': _choice(['Pending', 'Packed', 'Ready to Ship']),
        'createdAt': _daysAgo(_randInt(0, 18)),
      }));
    }

    final binLocations = _t('binLocations');
    for (var i = 0; i < 11; i++) {
      final grn = _choice(purchaseReceipts);
      final bin = _choice(binLocations);
      _t('putAway').add(EntityRecord({
        'id': _nextId(), 'code': 'PA-${_pad(_nextId(), 5)}', 'grnRef': grn['code'], 'warehouse': bin['warehouse'],
        'binLocation': bin['code'], 'itemsCount': _randInt(1, 5), 'assignedTo': _randPerson(),
        'date': _daysAgo(_randInt(0, 25)), 'status': _choice(['Pending', 'In Progress', 'Completed']),
        'createdAt': _daysAgo(_randInt(0, 25)),
      }));
    }

    for (var i = 0; i < 9; i++) {
      final bin = _choice(binLocations);
      _t('cycleCounting').add(EntityRecord({
        'id': _nextId(), 'code': 'CC-${_pad(_nextId(), 5)}', 'warehouse': bin['warehouse'], 'binLocation': bin['code'],
        'countedBy': _randPerson(), 'itemsCounted': _randInt(5, 40), 'variance': _randInt(-8, 8),
        'date': _daysAgo(_randInt(0, 45)), 'status': _choice(['Scheduled', 'In Progress', 'Completed', 'Variance Review']),
        'createdAt': _daysAgo(_randInt(0, 45)),
      }));
    }

    for (var i = 0; i < 22; i++) {
      final it = _choice(items);
      final w = _choice(warehouses);
      _t('inventoryMovement').add(EntityRecord({
        'id': _nextId(), 'code': 'MOV-${_pad(_nextId(), 5)}', 'item': it['name'], 'itemId': it.id, 'warehouse': w['name'],
        'movementType': _choice(['Inbound', 'Outbound', 'Transfer', 'Adjustment']), 'qty': _randInt(1, 300),
        'refDoc': '${_choice(['GRN', 'SO', 'STR', 'ADJ'])}-${_pad(_randInt(10000, 99999), 5)}',
        'date': _daysAgo(_randInt(0, 90)), 'createdAt': _daysAgo(_randInt(0, 90)),
      }));
    }

    for (var i = 0; i < 18; i++) {
      final dn = _choice(deliveryNotes);
      _t('shipments').add(EntityRecord({
        'id': _nextId(), 'code': 'SHP-${_pad(_nextId(), 5)}', 'deliveryRef': dn['code'], 'customer': dn['customer'],
        'carrier': _choice(kCouriers), 'trackingNo': 'TRK${_randInt(1000000000, 2000000000)}',
        'origin': _choice(warehouses)['city'], 'destination': _choice(kCities),
        'shipDate': _daysAgo(_randInt(0, 20)), 'eta': _daysAhead(_randInt(0, 10)),
        'status': _choice(['Booked', 'Picked Up', 'In Transit', 'Out for Delivery', 'Delivered', 'Delayed']),
        'createdAt': _daysAgo(_randInt(0, 20)),
      }));
    }
    final shipments = _t('shipments');

    for (var i = 0; i < 11; i++) {
      _t('transportManagement').add(EntityRecord({
        'id': _nextId(), 'code': 'TMS-${_pad(_nextId(), 5)}', 'route': '${_choice(kCities)} → ${_choice(kCities)}',
        'carrier': _choice(kCouriers), 'vehicle': _choice(kVehicles), 'capacityUsedPct': _randInt(40, 100),
        'plannedDate': _daysAhead(_randInt(-5, 15)), 'status': _choice(['Planned', 'Dispatched', 'In Transit', 'Completed']),
        'createdAt': _daysAgo(_randInt(0, 40)),
      }));
    }

    for (var i = 0; i < 11; i++) {
      final w = _choice(warehouses);
      _t('dispatchPlanning').add(EntityRecord({
        'id': _nextId(), 'code': 'DPL-${_pad(_nextId(), 5)}', 'warehouse': w['name'], 'ordersConsolidated': _randInt(2, 12),
        'vehicle': _choice(kVehicles), 'route': '${_choice(kCities)} Route', 'plannedDate': _daysAhead(_randInt(-3, 12)),
        'status': _choice(['Draft', 'Confirmed', 'Dispatched']), 'createdAt': _daysAgo(_randInt(0, 30)),
      }));
    }

    for (var i = 0; i < 14; i++) {
      final shp = _choice(shipments);
      _t('courierTracking').add(EntityRecord({
        'id': _nextId(), 'code': 'CT-${_pad(_nextId(), 5)}', 'shipmentRef': shp['code'], 'carrier': shp['carrier'],
        'trackingNo': shp['trackingNo'], 'lastLocation': _choice(kCities), 'lastUpdate': _daysAgo(_randInt(0, 5)),
        'status': shp['status'], 'createdAt': _daysAgo(_randInt(0, 20)),
      }));
    }

    for (var i = 0; i < 9; i++) {
      _t('vehicleAllocation').add(EntityRecord({
        'id': _nextId(), 'code': 'VA-${_pad(_nextId(), 5)}', 'vehicle': _choice(kVehicles), 'driver': _randPerson(),
        'warehouse': _choice(warehouses)['name'], 'allocatedDate': _daysAgo(_randInt(0, 20)),
        'route': '${_choice(kCities)} Route', 'status': _choice(['Allocated', 'On Route', 'Returned', 'Under Maintenance']),
        'createdAt': _daysAgo(_randInt(0, 20)),
      }));
    }
  }
}
