import '../entities/entity_record.dart';
import '../../infrastructure/mock/mock_database.dart';
import 'column_def.dart';
import 'report_schema.dart';

double _round2(num n) => (n * 100).round() / 100;

/// Ported from the `REPORTS` map's 16 entries — columns + `compute()` for
/// every read-only report. Label/icon/group live in
/// [NavRegistry.reportsByKey]; this registry adds the data shape.
abstract final class ReportRegistry {
  static final Map<String, ReportSchema> all = {
    'salesRegister': ReportSchema(
      key: 'salesRegister',
      columns: const [
        ColumnDef(key: 'code', label: 'Invoice'),
        ColumnDef(key: 'customer', label: 'Customer'),
        ColumnDef(key: 'date', label: 'Date', type: ColumnType.date),
        ColumnDef(key: 'amount', label: 'Amount', type: ColumnType.money),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      compute: (db) => db['salesInvoices'],
    ),
    'salesAnalysis': ReportSchema(
      key: 'salesAnalysis',
      columns: const [
        ColumnDef(key: 'customer', label: 'Customer'),
        ColumnDef(key: 'orders', label: 'Orders', type: ColumnType.numraw),
        ColumnDef(key: 'totalValue', label: 'Total Value', type: ColumnType.money),
        ColumnDef(key: 'avgOrderValue', label: 'Avg Order Value', type: ColumnType.money),
      ],
      compute: (db) {
        final rows = <EntityRecord>[];
        for (final c in db['customers']) {
          final orders = db['salesOrders'].where((o) => o['customerId'] == c.id).toList();
          if (orders.isEmpty) continue;
          final total = _round2(orders.fold<double>(0, (a, o) => a + (o['amount'] as num)));
          rows.add(EntityRecord({
            'id': c.id, 'customer': c['name'], 'orders': orders.length,
            'totalValue': total, 'avgOrderValue': _round2(total / orders.length),
          }));
        }
        rows.sort((a, b) => (b['totalValue'] as num).compareTo(a['totalValue'] as num));
        return rows;
      },
    ),
    'customerLedger': ReportSchema(
      key: 'customerLedger',
      columns: const [
        ColumnDef(key: 'customer', label: 'Customer'),
        ColumnDef(key: 'code', label: 'Document'),
        ColumnDef(key: 'type', label: 'Type'),
        ColumnDef(key: 'date', label: 'Date', type: ColumnType.date),
        ColumnDef(key: 'amount', label: 'Amount', type: ColumnType.money),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      compute: (db) {
        final rows = [
          for (final d in db['salesInvoices'])
            EntityRecord({'id': d.id, 'customer': d['customer'], 'code': d['code'], 'type': 'Invoice', 'date': d['date'], 'amount': d['amount'], 'status': d.status}),
          for (final d in db['customerPayments'])
            EntityRecord({'id': d.id, 'customer': d['customer'], 'code': d['code'], 'type': 'Payment', 'date': d['date'], 'amount': -(d['amount'] as num), 'status': d.status}),
        ];
        rows.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
        return rows;
      },
    ),
    'outstandingSalesOrders': ReportSchema(
      key: 'outstandingSalesOrders',
      columns: const [
        ColumnDef(key: 'code', label: 'Sales Order'),
        ColumnDef(key: 'customer', label: 'Customer'),
        ColumnDef(key: 'deliveryDate', label: 'Delivery Date', type: ColumnType.date),
        ColumnDef(key: 'amount', label: 'Amount', type: ColumnType.money),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      compute: (db) => db['salesOrders'].where((o) => !['Closed', 'Cancelled', 'Delivered'].contains(o.status)).toList(),
    ),
    'pendingDeliveries': ReportSchema(
      key: 'pendingDeliveries',
      columns: const [
        ColumnDef(key: 'code', label: 'Delivery Note'),
        ColumnDef(key: 'customer', label: 'Customer'),
        ColumnDef(key: 'date', label: 'Date', type: ColumnType.date),
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      compute: (db) => db['deliveryNotes'].where((d) => !['Delivered', 'Cancelled'].contains(d.status)).toList(),
    ),
    'purchaseRegister': ReportSchema(
      key: 'purchaseRegister',
      columns: const [
        ColumnDef(key: 'code', label: 'Invoice'),
        ColumnDef(key: 'supplier', label: 'Supplier'),
        ColumnDef(key: 'date', label: 'Date', type: ColumnType.date),
        ColumnDef(key: 'amount', label: 'Amount', type: ColumnType.money),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      compute: (db) => db['purchaseInvoices'],
    ),
    'supplierLedger': ReportSchema(
      key: 'supplierLedger',
      columns: const [
        ColumnDef(key: 'supplier', label: 'Supplier'),
        ColumnDef(key: 'code', label: 'Document'),
        ColumnDef(key: 'type', label: 'Type'),
        ColumnDef(key: 'date', label: 'Date', type: ColumnType.date),
        ColumnDef(key: 'amount', label: 'Amount', type: ColumnType.money),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      compute: (db) {
        final rows = [
          for (final d in db['purchaseInvoices'])
            EntityRecord({'id': d.id, 'supplier': d['supplier'], 'code': d['code'], 'type': 'Invoice', 'date': d['date'], 'amount': d['amount'], 'status': d.status}),
        ];
        rows.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
        return rows;
      },
    ),
    'outstandingPurchaseOrders': ReportSchema(
      key: 'outstandingPurchaseOrders',
      columns: const [
        ColumnDef(key: 'code', label: 'Purchase Order'),
        ColumnDef(key: 'supplier', label: 'Supplier'),
        ColumnDef(key: 'expectedDate', label: 'Expected', type: ColumnType.date),
        ColumnDef(key: 'amount', label: 'Amount', type: ColumnType.money),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      compute: (db) => db['purchaseOrders'].where((o) => !['Closed', 'Cancelled', 'Received'].contains(o.status)).toList(),
    ),
    'purchaseAnalysis': ReportSchema(
      key: 'purchaseAnalysis',
      columns: const [
        ColumnDef(key: 'supplier', label: 'Supplier'),
        ColumnDef(key: 'orders', label: 'Orders', type: ColumnType.numraw),
        ColumnDef(key: 'totalValue', label: 'Total Value', type: ColumnType.money),
      ],
      compute: (db) {
        final rows = <EntityRecord>[];
        for (final s in db['suppliers']) {
          final orders = db['purchaseOrders'].where((o) => o['supplierId'] == s.id).toList();
          if (orders.isEmpty) continue;
          rows.add(EntityRecord({
            'id': s.id, 'supplier': s['name'], 'orders': orders.length,
            'totalValue': _round2(orders.fold<double>(0, (a, o) => a + (o['amount'] as num))),
          }));
        }
        rows.sort((a, b) => (b['totalValue'] as num).compareTo(a['totalValue'] as num));
        return rows;
      },
    ),
    'stockLedger': ReportSchema(
      key: 'stockLedger',
      columns: const [
        ColumnDef(key: 'code', label: 'Movement'),
        ColumnDef(key: 'item', label: 'Item'),
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'movementType', label: 'Type'),
        ColumnDef(key: 'qty', label: 'Qty', type: ColumnType.numraw),
        ColumnDef(key: 'date', label: 'Date', type: ColumnType.date),
      ],
      compute: (db) => db['inventoryMovement'],
    ),
    'stockValuation': ReportSchema(
      key: 'stockValuation',
      columns: const [
        ColumnDef(key: 'item', label: 'Item'),
        ColumnDef(key: 'group', label: 'Group'),
        ColumnDef(key: 'qty', label: 'Total Qty', type: ColumnType.numraw),
        ColumnDef(key: 'unitCost', label: 'Unit Cost', type: ColumnType.money),
        ColumnDef(key: 'value', label: 'Stock Value', type: ColumnType.money),
      ],
      compute: (db) {
        final rows = [
          for (final it in db['items'])
            EntityRecord({
              'id': it.id, 'item': it['name'], 'group': it['group'],
              'qty': db.itemStockTotal(it.id), 'unitCost': it['standardCost'],
              'value': _round2(db.itemStockTotal(it.id) * (it['standardCost'] as num)),
            }),
        ];
        rows.sort((a, b) => (b['value'] as num).compareTo(a['value'] as num));
        return rows;
      },
    ),
    'stockAging': ReportSchema(
      key: 'stockAging',
      columns: const [
        ColumnDef(key: 'batchNo', label: 'Batch No.'),
        ColumnDef(key: 'item', label: 'Item'),
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'ageDays', label: 'Age (days)', type: ColumnType.numraw),
        ColumnDef(key: 'expDate', label: 'Expiry', type: ColumnType.date),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      compute: (db) {
        final now = DateTime.now();
        final rows = [
          for (final b in db['batches'])
            EntityRecord({...b.toMap(), 'ageDays': now.difference(b['mfgDate'] as DateTime).inDays}),
        ];
        rows.sort((a, b) => (b['ageDays'] as int).compareTo(a['ageDays'] as int));
        return rows;
      },
    ),
    'inventoryMovementReport': ReportSchema(
      key: 'inventoryMovementReport',
      columns: const [
        ColumnDef(key: 'code', label: 'Movement'),
        ColumnDef(key: 'item', label: 'Item'),
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'movementType', label: 'Type'),
        ColumnDef(key: 'qty', label: 'Qty', type: ColumnType.numraw),
        ColumnDef(key: 'date', label: 'Date', type: ColumnType.date),
      ],
      compute: (db) => db['inventoryMovement'],
    ),
    'batchReport': ReportSchema(
      key: 'batchReport',
      columns: const [
        ColumnDef(key: 'batchNo', label: 'Batch No.'),
        ColumnDef(key: 'item', label: 'Item'),
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'qty', label: 'Qty', type: ColumnType.numraw),
        ColumnDef(key: 'expDate', label: 'Expiry', type: ColumnType.date),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      compute: (db) => db['batches'],
    ),
    'serialNumberReport': ReportSchema(
      key: 'serialNumberReport',
      columns: const [
        ColumnDef(key: 'serialNo', label: 'Serial No.'),
        ColumnDef(key: 'item', label: 'Item'),
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      compute: (db) => db['serialNumbers'],
    ),
    'warehouseStockSummary': ReportSchema(
      key: 'warehouseStockSummary',
      columns: const [
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'itemsStocked', label: 'Items Stocked', type: ColumnType.numraw),
        ColumnDef(key: 'totalUnits', label: 'Total Units', type: ColumnType.numraw),
        ColumnDef(key: 'totalValue', label: 'Total Value', type: ColumnType.money),
      ],
      compute: (db) {
        return [
          for (final w in db['warehouses'])
            EntityRecord(() {
              var itemsStocked = 0, totalUnits = 0;
              double totalValue = 0;
              for (final it in db['items']) {
                final q = db.stockLevels[it.id]?[w.id] ?? 0;
                if (q > 0) itemsStocked++;
                totalUnits += q;
                totalValue += q * (it['standardCost'] as num);
              }
              return {
                'id': w.id, 'warehouse': w['name'], 'itemsStocked': itemsStocked,
                'totalUnits': totalUnits, 'totalValue': _round2(totalValue),
              };
            }()),
        ];
      },
    ),
  };

  static ReportSchema of(String key) => all[key]!;
}
