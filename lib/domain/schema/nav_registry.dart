import 'entity_nav_item.dart';

/// Ported from `MODULE_TREE` + each entity's `defEntity(key, {label, icon,
/// group})` — the sidebar's module tree and the source of truth for entity
/// route metadata (label/icon/group) used by the sidebar, breadcrumb, and
/// router. Phase 6+ extends per-entity data (columns/fields/workflow)
/// keyed off the same `key` values.
///
/// Icon values are the prototype's exact `ICON_PATHS` keys (see
/// `AppIconPaths`), copied verbatim from each `defEntity(...)`/`MODULE_TREE`
/// entry — not a Material/Feather icon-font approximation.
abstract final class NavRegistry {
  static const List<NavGroup> moduleTree = [
    NavGroup(
      label: 'CRM',
      icon: 'users',
      items: [
        EntityNavItem(key: 'leads', label: 'Leads', icon: 'target', group: 'CRM'),
        EntityNavItem(key: 'opportunities', label: 'Opportunities', icon: 'briefcase', group: 'CRM'),
        EntityNavItem(key: 'customers', label: 'Customers', icon: 'building2', group: 'CRM'),
        EntityNavItem(key: 'customerGroups', label: 'Customer Groups', icon: 'tag', group: 'CRM'),
        EntityNavItem(key: 'customerContacts', label: 'Customer Contacts', icon: 'contact', group: 'CRM'),
        EntityNavItem(key: 'salesPersons', label: 'Sales Persons', icon: 'badge', group: 'CRM'),
        EntityNavItem(key: 'salesTerritories', label: 'Sales Territories', icon: 'map', group: 'CRM'),
        EntityNavItem(key: 'priceLists', label: 'Price Lists', icon: 'dollar', group: 'CRM'),
      ],
    ),
    NavGroup(
      label: 'Sales Management',
      icon: 'cart',
      items: [
        EntityNavItem(key: 'quotations', label: 'Quotations', icon: 'fileText', group: 'Sales Management'),
        EntityNavItem(key: 'salesOrders', label: 'Sales Orders', icon: 'cart', group: 'Sales Management'),
        EntityNavItem(key: 'deliveryNotes', label: 'Delivery Notes', icon: 'truck', group: 'Sales Management'),
        EntityNavItem(key: 'salesInvoices', label: 'Sales Invoices', icon: 'receipt', group: 'Sales Management'),
        EntityNavItem(key: 'salesReturns', label: 'Sales Returns', icon: 'undo', group: 'Sales Management'),
        EntityNavItem(key: 'creditNotes', label: 'Credit Notes', icon: 'creditCard', group: 'Sales Management'),
        EntityNavItem(key: 'dispatchSchedule', label: 'Dispatch Schedule', icon: 'calendar', group: 'Sales Management'),
        EntityNavItem(key: 'customerPayments', label: 'Customer Payments', icon: 'dollar', group: 'Sales Management'),
      ],
    ),
    NavGroup(
      label: 'Purchase Management',
      icon: 'briefcase',
      items: [
        EntityNavItem(key: 'suppliers', label: 'Suppliers', icon: 'building', group: 'Purchase Management'),
        EntityNavItem(key: 'supplierGroups', label: 'Supplier Groups', icon: 'tag', group: 'Purchase Management'),
        EntityNavItem(key: 'purchaseRequests', label: 'Purchase Requests', icon: 'clipboardList', group: 'Purchase Management'),
        EntityNavItem(key: 'rfqs', label: 'Request for Quotation (RFQ)', icon: 'fileText', group: 'Purchase Management'),
        EntityNavItem(key: 'supplierQuotations', label: 'Supplier Quotations', icon: 'fileText', group: 'Purchase Management'),
        EntityNavItem(key: 'purchaseOrders', label: 'Purchase Orders', icon: 'cart', group: 'Purchase Management'),
        EntityNavItem(key: 'purchaseReceipts', label: 'Purchase Receipts (GRN)', icon: 'packageCheck', group: 'Purchase Management'),
        EntityNavItem(key: 'purchaseInvoices', label: 'Purchase Invoices', icon: 'receipt', group: 'Purchase Management'),
        EntityNavItem(key: 'purchaseReturns', label: 'Purchase Returns', icon: 'undo', group: 'Purchase Management'),
        EntityNavItem(key: 'debitNotes', label: 'Debit Notes', icon: 'creditCard', group: 'Purchase Management'),
      ],
    ),
    NavGroup(
      label: 'Inventory Management',
      icon: 'box',
      items: [
        EntityNavItem(key: 'items', label: 'Item Master', icon: 'box', group: 'Inventory Management'),
        EntityNavItem(key: 'itemGroups', label: 'Item Groups', icon: 'layers', group: 'Inventory Management'),
        EntityNavItem(key: 'uoms', label: 'Units of Measure', icon: 'ruler', group: 'Inventory Management'),
        EntityNavItem(key: 'warehouses', label: 'Warehouses', icon: 'warehouse', group: 'Inventory Management'),
        EntityNavItem(key: 'binLocations', label: 'Bin Locations', icon: 'bin', group: 'Inventory Management'),
        EntityNavItem(key: 'stockEntries', label: 'Stock Entry', icon: 'clipboard', group: 'Inventory Management'),
        EntityNavItem(key: 'stockTransfers', label: 'Stock Transfer', icon: 'shuffle', group: 'Inventory Management'),
        EntityNavItem(key: 'stockReconciliations', label: 'Stock Reconciliation', icon: 'sliders', group: 'Inventory Management'),
        EntityNavItem(key: 'batches', label: 'Batch Management', icon: 'layers', group: 'Inventory Management'),
        EntityNavItem(key: 'serialNumbers', label: 'Serial Number Tracking', icon: 'hash', group: 'Inventory Management'),
        EntityNavItem(key: 'inventoryAdjustments', label: 'Inventory Adjustment', icon: 'sliders', group: 'Inventory Management'),
      ],
    ),
    NavGroup(
      label: 'Warehouse Management',
      icon: 'warehouse',
      items: [
        EntityNavItem(key: 'pickingLists', label: 'Picking Lists', icon: 'clipboardList', group: 'Warehouse Management'),
        EntityNavItem(key: 'packingLists', label: 'Packing Lists', icon: 'package', group: 'Warehouse Management'),
        EntityNavItem(key: 'putAway', label: 'Put-away', icon: 'move', group: 'Warehouse Management'),
        EntityNavItem(key: 'cycleCounting', label: 'Cycle Counting', icon: 'clipboard', group: 'Warehouse Management'),
        EntityNavItem(key: 'inventoryMovement', label: 'Inventory Movement', icon: 'move', group: 'Warehouse Management'),
        EntityNavItem(key: 'binManagement', label: 'Bin Management', icon: 'bin', group: 'Warehouse Management'),
      ],
    ),
    NavGroup(
      label: 'Logistics',
      icon: 'ship',
      items: [
        EntityNavItem(key: 'shipments', label: 'Shipments', icon: 'ship', group: 'Logistics'),
        EntityNavItem(key: 'deliverySchedule', label: 'Delivery Schedule', icon: 'calendar', group: 'Logistics'),
        EntityNavItem(key: 'transportManagement', label: 'Transport Management', icon: 'route', group: 'Logistics'),
        EntityNavItem(key: 'dispatchPlanning', label: 'Dispatch Planning', icon: 'compass', group: 'Logistics'),
        EntityNavItem(key: 'courierTracking', label: 'Courier Tracking', icon: 'navigation', group: 'Logistics'),
        EntityNavItem(key: 'vehicleAllocation', label: 'Vehicle Allocation', icon: 'truck', group: 'Logistics'),
      ],
    ),
  ];

  static const List<ReportNavSection> reportTree = [
    ReportNavSection(
      group: 'Sales Reports',
      items: [
        ReportNavItem(key: 'salesRegister', label: 'Sales Register', icon: 'fileText', reportGroup: 'Sales Reports'),
        ReportNavItem(key: 'salesAnalysis', label: 'Sales Analysis', icon: 'barChart', reportGroup: 'Sales Reports'),
        ReportNavItem(key: 'customerLedger', label: 'Customer Ledger', icon: 'contact', reportGroup: 'Sales Reports'),
        ReportNavItem(key: 'outstandingSalesOrders', label: 'Outstanding Sales Orders', icon: 'cart', reportGroup: 'Sales Reports'),
        ReportNavItem(key: 'pendingDeliveries', label: 'Pending Deliveries', icon: 'truck', reportGroup: 'Sales Reports'),
      ],
    ),
    ReportNavSection(
      group: 'Purchase Reports',
      items: [
        ReportNavItem(key: 'purchaseRegister', label: 'Purchase Register', icon: 'fileText', reportGroup: 'Purchase Reports'),
        ReportNavItem(key: 'supplierLedger', label: 'Supplier Ledger', icon: 'building', reportGroup: 'Purchase Reports'),
        ReportNavItem(key: 'outstandingPurchaseOrders', label: 'Outstanding Purchase Orders', icon: 'cart', reportGroup: 'Purchase Reports'),
        ReportNavItem(key: 'purchaseAnalysis', label: 'Purchase Analysis', icon: 'barChart', reportGroup: 'Purchase Reports'),
      ],
    ),
    ReportNavSection(
      group: 'Inventory Reports',
      items: [
        ReportNavItem(key: 'stockLedger', label: 'Stock Ledger', icon: 'fileText', reportGroup: 'Inventory Reports'),
        ReportNavItem(key: 'stockValuation', label: 'Stock Valuation', icon: 'dollar', reportGroup: 'Inventory Reports'),
        ReportNavItem(key: 'stockAging', label: 'Stock Aging', icon: 'clock', reportGroup: 'Inventory Reports'),
        ReportNavItem(key: 'inventoryMovementReport', label: 'Inventory Movement', icon: 'move', reportGroup: 'Inventory Reports'),
        ReportNavItem(key: 'batchReport', label: 'Batch Report', icon: 'layers', reportGroup: 'Inventory Reports'),
        ReportNavItem(key: 'serialNumberReport', label: 'Serial Number Report', icon: 'hash', reportGroup: 'Inventory Reports'),
        ReportNavItem(key: 'warehouseStockSummary', label: 'Warehouse Stock Summary', icon: 'warehouse', reportGroup: 'Inventory Reports'),
      ],
    ),
  ];

  static final Map<String, EntityNavItem> entitiesByKey = {
    for (final group in moduleTree)
      for (final item in group.items) item.key: item,
  };

  static final Map<String, ReportNavItem> reportsByKey = {
    for (final section in reportTree)
      for (final item in section.items) item.key: item,
  };

  static NavGroup groupOf(String entityKey) =>
      moduleTree.firstWhere((g) => g.items.any((i) => i.key == entityKey));

  /// Ported from each `defEntity(...).color` + `renderHome()`'s
  /// `colorVarMap` — the tile-icon color key for an entity, used on the
  /// home workspace's "All Modules" grid. `leads`/`opportunities` are
  /// `purple` in the prototype; every other CRM/Sales entity is `blue`
  /// (which `colorVarMap` itself maps to the `info` palette).
  static String tileColorKey(String entityKey) {
    if (entityKey == 'leads' || entityKey == 'opportunities') return 'purple';
    final group = entitiesByKey[entityKey]?.group;
    return switch (group) {
      'CRM' || 'Sales Management' => 'blue',
      'Purchase Management' => 'amber',
      'Inventory Management' => 'teal',
      'Warehouse Management' => 'info',
      'Logistics' => 'red',
      _ => 'blue',
    };
  }
}
