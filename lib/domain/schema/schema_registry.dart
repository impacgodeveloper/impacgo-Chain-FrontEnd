import '../../infrastructure/mock/master_data_pools.dart';
import '../../infrastructure/mock/mock_database.dart';
import 'column_def.dart';
import 'entity_schema.dart';
import 'field_def.dart';

List<String> _opt(MockDatabase db, String table, String field) =>
    db[table].map((r) => r[field] as String).toList();

/// Ported from `docColumns(docLabel)` — the common 5-column shape shared by
/// every Sales Management document entity.
List<ColumnDef> _docColumns(String label) => [
      ColumnDef(key: 'code', label: label),
      const ColumnDef(key: 'customer', label: 'Customer'),
      const ColumnDef(key: 'date', label: 'Date', type: ColumnType.date),
      const ColumnDef(key: 'amount', label: 'Amount', type: ColumnType.money),
      const ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
    ];

/// Ported from `docFields(extra)`.
List<FieldDef> _docFields(List<FieldDef> extra, List<String> statusOptions) => [
      FieldDef(
        key: 'customer', label: 'Customer', type: FieldType.select, required: true,
        optionsFn: (db) => _opt(db, 'customers', 'name'),
      ),
      FieldDef(
        key: 'salesPerson', label: 'Sales Person', type: FieldType.select,
        optionsFn: (db) => _opt(db, 'salesPersons', 'name'),
      ),
      const FieldDef(key: 'date', label: 'Date', type: FieldType.date),
      const FieldDef(key: 'amount', label: 'Amount', type: FieldType.number),
      ...extra,
      FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: statusOptions),
    ];

/// Ported from `pdocColumns(docLabel)`.
List<ColumnDef> _pdocColumns(String label) => [
      ColumnDef(key: 'code', label: label),
      const ColumnDef(key: 'supplier', label: 'Supplier'),
      const ColumnDef(key: 'date', label: 'Date', type: ColumnType.date),
      const ColumnDef(key: 'amount', label: 'Amount', type: ColumnType.money),
      const ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
    ];

/// Ported from `pdocFields(extra, statusOpts)`.
List<FieldDef> _pdocFields(List<FieldDef> extra, List<String> statusOptions) => [
      FieldDef(
        key: 'supplier', label: 'Supplier', type: FieldType.select, required: true,
        optionsFn: (db) => _opt(db, 'suppliers', 'name'),
      ),
      const FieldDef(key: 'date', label: 'Date', type: FieldType.date),
      const FieldDef(key: 'amount', label: 'Amount', type: FieldType.number),
      ...extra,
      FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: statusOptions),
    ];

List<String> _warehouseNames(MockDatabase db) => _opt(db, 'warehouses', 'name');
List<String> _customerNames(MockDatabase db) => _opt(db, 'customers', 'name');

/// Ported from the 49 `defEntity(key, {...})` calls — columns/fields/
/// approval/workflow metadata for every entity. Label/icon/group already
/// live in [NavRegistry]; this registry adds everything the Phase 6
/// list/detail/form engine needs.
abstract final class SchemaRegistry {
  static final Map<String, EntitySchema> all = {
    // ---------------- CRM ----------------
    'leads': EntitySchema(
      key: 'leads', primaryKey: 'company', subKey: 'code', numberKey: 'code',
      columns: const [
        ColumnDef(key: 'code', label: 'Lead'),
        ColumnDef(key: 'company', label: 'Company'),
        ColumnDef(key: 'contact', label: 'Contact'),
        ColumnDef(key: 'source', label: 'Source'),
        ColumnDef(key: 'territory', label: 'Territory'),
        ColumnDef(key: 'estimatedValue', label: 'Est. Value', type: ColumnType.money),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
        ColumnDef(key: 'createdAt', label: 'Created', type: ColumnType.date),
      ],
      fields: [
        const FieldDef(key: 'company', label: 'Company Name', required: true),
        const FieldDef(key: 'contact', label: 'Contact Person', required: true),
        const FieldDef(key: 'email', label: 'Email'),
        const FieldDef(key: 'phone', label: 'Phone'),
        const FieldDef(key: 'source', label: 'Lead Source', type: FieldType.select, options: ['Website', 'Trade Show', 'Referral', 'Cold Call', 'Partner Channel']),
        const FieldDef(key: 'territory', label: 'Territory', type: FieldType.select, options: kTerritories),
        FieldDef(key: 'salesPerson', label: 'Sales Person', type: FieldType.select, optionsFn: (db) => _opt(db, 'salesPersons', 'name')),
        const FieldDef(key: 'estimatedValue', label: 'Estimated Value', type: FieldType.number),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['New', 'Contacted', 'Qualified', 'Unqualified', 'Converted']),
      ],
    ),
    'opportunities': EntitySchema(
      key: 'opportunities', primaryKey: 'code', subKey: 'customer', numberKey: 'code',
      columns: const [
        ColumnDef(key: 'code', label: 'Opportunity'),
        ColumnDef(key: 'customer', label: 'Customer'),
        ColumnDef(key: 'salesPerson', label: 'Sales Person'),
        ColumnDef(key: 'value', label: 'Value', type: ColumnType.money),
        ColumnDef(key: 'probability', label: 'Probability', type: ColumnType.pct),
        ColumnDef(key: 'closeDate', label: 'Close Date', type: ColumnType.date),
        ColumnDef(key: 'status', label: 'Stage', type: ColumnType.status),
      ],
      fields: [
        FieldDef(key: 'customer', label: 'Customer', type: FieldType.select, required: true, optionsFn: _customerNames),
        FieldDef(key: 'salesPerson', label: 'Sales Person', type: FieldType.select, optionsFn: (db) => _opt(db, 'salesPersons', 'name')),
        const FieldDef(key: 'value', label: 'Opportunity Value', type: FieldType.number),
        const FieldDef(key: 'probability', label: 'Probability %', type: FieldType.number),
        const FieldDef(key: 'closeDate', label: 'Expected Close Date', type: FieldType.date),
        const FieldDef(key: 'status', label: 'Stage', type: FieldType.select, options: ['Prospecting', 'Proposal Sent', 'Negotiation', 'Won', 'Lost']),
      ],
    ),
    'customers': EntitySchema(
      key: 'customers', primaryKey: 'name', subKey: 'code', numberKey: 'code',
      columns: const [
        ColumnDef(key: 'code', label: 'Code'),
        ColumnDef(key: 'name', label: 'Customer'),
        ColumnDef(key: 'group', label: 'Group'),
        ColumnDef(key: 'territory', label: 'Territory'),
        ColumnDef(key: 'city', label: 'City'),
        ColumnDef(key: 'creditLimit', label: 'Credit Limit', type: ColumnType.money),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        const FieldDef(key: 'name', label: 'Customer Name', required: true),
        FieldDef(key: 'group', label: 'Customer Group', type: FieldType.select, optionsFn: (db) => _opt(db, 'customerGroups', 'name')),
        const FieldDef(key: 'territory', label: 'Territory', type: FieldType.select, options: kTerritories),
        const FieldDef(key: 'city', label: 'City', type: FieldType.select, options: kCities),
        const FieldDef(key: 'email', label: 'Email'),
        const FieldDef(key: 'phone', label: 'Phone'),
        const FieldDef(key: 'creditLimit', label: 'Credit Limit', type: FieldType.number),
        FieldDef(key: 'salesPerson', label: 'Sales Person', type: FieldType.select, optionsFn: (db) => _opt(db, 'salesPersons', 'name')),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Active', 'On Hold', 'Inactive']),
      ],
    ),
    'customerGroups': EntitySchema(
      key: 'customerGroups', primaryKey: 'name', numberKey: 'name',
      columns: const [
        ColumnDef(key: 'name', label: 'Group Name'),
        ColumnDef(key: 'createdAt', label: 'Created', type: ColumnType.date),
      ],
      fields: const [FieldDef(key: 'name', label: 'Group Name', required: true)],
    ),
    'customerContacts': EntitySchema(
      key: 'customerContacts', primaryKey: 'name', subKey: 'customer', numberKey: 'name',
      columns: const [
        ColumnDef(key: 'name', label: 'Contact'),
        ColumnDef(key: 'customer', label: 'Customer'),
        ColumnDef(key: 'designation', label: 'Designation'),
        ColumnDef(key: 'email', label: 'Email'),
        ColumnDef(key: 'phone', label: 'Phone'),
      ],
      fields: [
        const FieldDef(key: 'name', label: 'Contact Name', required: true),
        FieldDef(key: 'customer', label: 'Customer', type: FieldType.select, required: true, optionsFn: _customerNames),
        const FieldDef(key: 'designation', label: 'Designation'),
        const FieldDef(key: 'email', label: 'Email'),
        const FieldDef(key: 'phone', label: 'Phone'),
      ],
    ),
    'salesPersons': EntitySchema(
      key: 'salesPersons', primaryKey: 'name', numberKey: 'name',
      columns: const [
        ColumnDef(key: 'name', label: 'Name'),
        ColumnDef(key: 'territory', label: 'Territory'),
        ColumnDef(key: 'target', label: 'Annual Target', type: ColumnType.money),
        ColumnDef(key: 'commission', label: 'Commission %', type: ColumnType.pct),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: const [
        FieldDef(key: 'name', label: 'Name', required: true),
        FieldDef(key: 'email', label: 'Email'),
        FieldDef(key: 'territory', label: 'Territory', type: FieldType.select, options: kTerritories),
        FieldDef(key: 'target', label: 'Annual Target', type: FieldType.number),
        FieldDef(key: 'commission', label: 'Commission %', type: FieldType.number),
        FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Active', 'Inactive']),
      ],
    ),
    'salesTerritories': EntitySchema(
      key: 'salesTerritories', primaryKey: 'name', numberKey: 'name',
      columns: const [
        ColumnDef(key: 'name', label: 'Territory'),
        ColumnDef(key: 'manager', label: 'Manager'),
        ColumnDef(key: 'targetRevenue', label: 'Target Revenue', type: ColumnType.money),
      ],
      fields: const [
        FieldDef(key: 'name', label: 'Territory Name', required: true),
        FieldDef(key: 'manager', label: 'Territory Manager'),
        FieldDef(key: 'targetRevenue', label: 'Target Revenue', type: FieldType.number),
      ],
    ),
    'priceLists': EntitySchema(
      key: 'priceLists', primaryKey: 'name', numberKey: 'name',
      columns: const [
        ColumnDef(key: 'name', label: 'Price List'),
        ColumnDef(key: 'currency', label: 'Currency'),
        ColumnDef(key: 'type', label: 'Type'),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: const [
        FieldDef(key: 'name', label: 'Price List Name', required: true),
        FieldDef(key: 'currency', label: 'Currency', type: FieldType.select, options: ['USD', 'EUR', 'GBP']),
        FieldDef(key: 'type', label: 'Type', type: FieldType.select, options: ['Selling', 'Buying']),
        FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Active', 'Inactive']),
      ],
    ),

    // ---------------- Sales Management ----------------
    'quotations': EntitySchema(
      key: 'quotations', primaryKey: 'code', subKey: 'customer', numberKey: 'code', approval: true,
      workflow: 'orderToCash', step: 'Quotation',
      columns: [..._docColumns('Quotation'), const ColumnDef(key: 'validTill', label: 'Valid Till', type: ColumnType.date)],
      fields: _docFields(
        const [FieldDef(key: 'validTill', label: 'Valid Till', type: FieldType.date)],
        const ['Draft', 'Pending Approval', 'Approved', 'Sent', 'Expired', 'Converted'],
      ),
    ),
    'salesOrders': EntitySchema(
      key: 'salesOrders', primaryKey: 'code', subKey: 'customer', numberKey: 'code', approval: true,
      workflow: 'orderToCash', step: 'Sales Order',
      columns: [..._docColumns('Sales Order'), const ColumnDef(key: 'deliveryDate', label: 'Delivery Date', type: ColumnType.date)],
      fields: _docFields(
        const [FieldDef(key: 'deliveryDate', label: 'Delivery Date', type: FieldType.date)],
        const ['Draft', 'Pending Approval', 'Approved', 'In Fulfillment', 'Partially Delivered', 'Delivered', 'Closed', 'Cancelled'],
      ),
    ),
    'deliveryNotes': EntitySchema(
      key: 'deliveryNotes', primaryKey: 'code', subKey: 'customer', numberKey: 'code', approval: true,
      workflow: 'orderToCash', step: 'Delivery Note',
      columns: [..._docColumns('Delivery Note'), const ColumnDef(key: 'warehouse', label: 'Warehouse')],
      fields: _docFields(
        [
          FieldDef(key: 'warehouse', label: 'Warehouse', type: FieldType.select, optionsFn: _warehouseNames),
          const FieldDef(key: 'vehicle', label: 'Vehicle', type: FieldType.select, options: kVehicles),
        ],
        const ['Draft', 'Pending Approval', 'Approved', 'Dispatched', 'In Transit', 'Delivered', 'Cancelled'],
      ),
    ),
    'salesInvoices': EntitySchema(
      key: 'salesInvoices', primaryKey: 'code', subKey: 'customer', numberKey: 'code', approval: true,
      workflow: 'orderToCash', step: 'Sales Invoice',
      columns: [
        ..._docColumns('Sales Invoice'),
        const ColumnDef(key: 'dueDate', label: 'Due Date', type: ColumnType.date),
        const ColumnDef(key: 'paidAmount', label: 'Paid', type: ColumnType.money),
      ],
      fields: _docFields(
        const [FieldDef(key: 'dueDate', label: 'Due Date', type: FieldType.date)],
        const ['Draft', 'Pending Approval', 'Approved', 'Sent', 'Partially Paid', 'Paid', 'Overdue'],
      ),
    ),
    'salesReturns': EntitySchema(
      key: 'salesReturns', primaryKey: 'code', subKey: 'customer', numberKey: 'code', approval: true,
      columns: [..._docColumns('Sales Return'), const ColumnDef(key: 'reason', label: 'Reason')],
      fields: _docFields(
        const [FieldDef(key: 'reason', label: 'Reason', type: FieldType.select, options: ['Damaged in transit', 'Wrong item shipped', 'Customer changed mind', 'Quality issue'])],
        const ['Draft', 'Pending Approval', 'Approved', 'Received', 'Refunded'],
      ),
    ),
    'creditNotes': EntitySchema(
      key: 'creditNotes', primaryKey: 'code', subKey: 'customer', numberKey: 'code', approval: true,
      columns: [..._docColumns('Credit Note'), const ColumnDef(key: 'reason', label: 'Reason')],
      fields: _docFields(
        const [FieldDef(key: 'reason', label: 'Reason', type: FieldType.select, options: ['Sales return', 'Pricing correction', 'Goodwill adjustment'])],
        const ['Draft', 'Pending Approval', 'Approved', 'Applied'],
      ),
    ),
    'dispatchSchedule': EntitySchema(
      key: 'dispatchSchedule', primaryKey: 'code', subKey: 'customer', numberKey: 'code',
      columns: const [
        ColumnDef(key: 'code', label: 'Dispatch'),
        ColumnDef(key: 'deliveryRef', label: 'Delivery Note'),
        ColumnDef(key: 'customer', label: 'Customer'),
        ColumnDef(key: 'scheduledDate', label: 'Scheduled', type: ColumnType.date),
        ColumnDef(key: 'vehicle', label: 'Vehicle'),
        ColumnDef(key: 'driver', label: 'Driver'),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        const FieldDef(key: 'deliveryRef', label: 'Delivery Note Ref'),
        FieldDef(key: 'customer', label: 'Customer', type: FieldType.select, optionsFn: _customerNames),
        const FieldDef(key: 'scheduledDate', label: 'Scheduled Date', type: FieldType.date),
        const FieldDef(key: 'vehicle', label: 'Vehicle', type: FieldType.select, options: kVehicles),
        const FieldDef(key: 'driver', label: 'Driver'),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Scheduled', 'Loading', 'Dispatched', 'Delivered', 'Delayed']),
      ],
    ),
    'customerPayments': EntitySchema(
      key: 'customerPayments', primaryKey: 'code', subKey: 'customer', numberKey: 'code',
      workflow: 'orderToCash', step: 'Customer Payment',
      columns: const [
        ColumnDef(key: 'code', label: 'Payment'),
        ColumnDef(key: 'customer', label: 'Customer'),
        ColumnDef(key: 'invoiceRef', label: 'Invoice'),
        ColumnDef(key: 'amount', label: 'Amount', type: ColumnType.money),
        ColumnDef(key: 'mode', label: 'Mode'),
        ColumnDef(key: 'date', label: 'Date', type: ColumnType.date),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        FieldDef(key: 'customer', label: 'Customer', type: FieldType.select, optionsFn: _customerNames),
        const FieldDef(key: 'invoiceRef', label: 'Invoice Reference'),
        const FieldDef(key: 'amount', label: 'Amount', type: FieldType.number),
        const FieldDef(key: 'mode', label: 'Payment Mode', type: FieldType.select, options: ['Bank Transfer', 'Check', 'Credit Card', 'ACH']),
        const FieldDef(key: 'date', label: 'Date', type: FieldType.date),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Received', 'Cleared', 'Pending Clearance', 'Bounced']),
      ],
    ),

    // ---------------- Purchase Management ----------------
    'suppliers': EntitySchema(
      key: 'suppliers', primaryKey: 'name', subKey: 'code', numberKey: 'code',
      columns: const [
        ColumnDef(key: 'code', label: 'Code'),
        ColumnDef(key: 'name', label: 'Supplier'),
        ColumnDef(key: 'group', label: 'Group'),
        ColumnDef(key: 'city', label: 'City'),
        ColumnDef(key: 'paymentTerms', label: 'Terms'),
        ColumnDef(key: 'rating', label: 'Rating'),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        const FieldDef(key: 'name', label: 'Supplier Name', required: true),
        FieldDef(key: 'group', label: 'Supplier Group', type: FieldType.select, optionsFn: (db) => _opt(db, 'supplierGroups', 'name')),
        const FieldDef(key: 'city', label: 'City', type: FieldType.select, options: kCities),
        const FieldDef(key: 'email', label: 'Email'),
        const FieldDef(key: 'phone', label: 'Phone'),
        const FieldDef(key: 'paymentTerms', label: 'Payment Terms', type: FieldType.select, options: ['Net 30', 'Net 45', 'Net 60', 'Due on Receipt']),
        const FieldDef(key: 'rating', label: 'Rating', type: FieldType.select, options: ['A - Preferred', 'B - Approved', 'C - Under Review']),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Active', 'On Hold', 'Inactive']),
      ],
    ),
    'supplierGroups': EntitySchema(
      key: 'supplierGroups', primaryKey: 'name', numberKey: 'name',
      columns: const [
        ColumnDef(key: 'name', label: 'Group Name'),
        ColumnDef(key: 'createdAt', label: 'Created', type: ColumnType.date),
      ],
      fields: const [FieldDef(key: 'name', label: 'Group Name', required: true)],
    ),
    'purchaseRequests': EntitySchema(
      key: 'purchaseRequests', primaryKey: 'code', subKey: 'requestedBy', numberKey: 'code', approval: true,
      workflow: 'procureToPay', step: 'Purchase Request',
      columns: const [
        ColumnDef(key: 'code', label: 'Request'),
        ColumnDef(key: 'requestedBy', label: 'Requested By'),
        ColumnDef(key: 'department', label: 'Department'),
        ColumnDef(key: 'date', label: 'Date', type: ColumnType.date),
        ColumnDef(key: 'amount', label: 'Est. Amount', type: ColumnType.money),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: const [
        FieldDef(key: 'requestedBy', label: 'Requested By'),
        FieldDef(key: 'department', label: 'Department', type: FieldType.select, options: ['Operations', 'Manufacturing', 'Warehouse', 'Procurement']),
        FieldDef(key: 'date', label: 'Date', type: FieldType.date),
        FieldDef(key: 'amount', label: 'Estimated Amount', type: FieldType.number),
        FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Draft', 'Pending Approval', 'Approved', 'Rejected', 'Converted to RFQ', 'Closed']),
      ],
    ),
    'rfqs': EntitySchema(
      key: 'rfqs', primaryKey: 'code', subKey: 'supplier', numberKey: 'code',
      workflow: 'procureToPay', step: 'RFQ',
      columns: const [
        ColumnDef(key: 'code', label: 'RFQ'),
        ColumnDef(key: 'invitedSuppliers', label: 'Invited Suppliers'),
        ColumnDef(key: 'date', label: 'Date', type: ColumnType.date),
        ColumnDef(key: 'responseDeadline', label: 'Deadline', type: ColumnType.date),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: const [
        FieldDef(key: 'invitedSuppliers', label: 'Invited Suppliers'),
        FieldDef(key: 'date', label: 'Date', type: FieldType.date),
        FieldDef(key: 'responseDeadline', label: 'Response Deadline', type: FieldType.date),
        FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Draft', 'Sent to Suppliers', 'Quotes Received', 'Closed']),
      ],
    ),
    'supplierQuotations': EntitySchema(
      key: 'supplierQuotations', primaryKey: 'code', subKey: 'supplier', numberKey: 'code',
      workflow: 'procureToPay', step: 'Supplier Quotation',
      columns: [..._pdocColumns('Supplier Quotation'), const ColumnDef(key: 'validTill', label: 'Valid Till', type: ColumnType.date)],
      fields: _pdocFields(
        const [FieldDef(key: 'validTill', label: 'Valid Till', type: FieldType.date)],
        const ['Received', 'Under Review', 'Selected', 'Rejected'],
      ),
    ),
    'purchaseOrders': EntitySchema(
      key: 'purchaseOrders', primaryKey: 'code', subKey: 'supplier', numberKey: 'code', approval: true,
      workflow: 'procureToPay', step: 'Purchase Order',
      columns: [..._pdocColumns('Purchase Order'), const ColumnDef(key: 'expectedDate', label: 'Expected', type: ColumnType.date)],
      fields: _pdocFields(
        const [FieldDef(key: 'expectedDate', label: 'Expected Date', type: FieldType.date)],
        const ['Draft', 'Pending Approval', 'Approved', 'Sent to Supplier', 'Partially Received', 'Received', 'Closed', 'Cancelled'],
      ),
    ),
    'purchaseReceipts': EntitySchema(
      key: 'purchaseReceipts', primaryKey: 'code', subKey: 'supplier', numberKey: 'code', approval: true,
      workflow: 'procureToPay', step: 'Purchase Receipt',
      columns: [..._pdocColumns('GRN'), const ColumnDef(key: 'warehouse', label: 'Warehouse')],
      fields: _pdocFields(
        [FieldDef(key: 'warehouse', label: 'Warehouse', type: FieldType.select, optionsFn: _warehouseNames)],
        const ['Draft', 'Pending Approval', 'Approved', 'Quality Check', 'Accepted', 'Putaway Complete'],
      ),
    ),
    'purchaseInvoices': EntitySchema(
      key: 'purchaseInvoices', primaryKey: 'code', subKey: 'supplier', numberKey: 'code', approval: true,
      workflow: 'procureToPay', step: 'Purchase Invoice',
      columns: [
        ..._pdocColumns('Purchase Invoice'),
        const ColumnDef(key: 'dueDate', label: 'Due Date', type: ColumnType.date),
        const ColumnDef(key: 'paidAmount', label: 'Paid', type: ColumnType.money),
      ],
      fields: _pdocFields(
        const [FieldDef(key: 'dueDate', label: 'Due Date', type: FieldType.date)],
        const ['Draft', 'Pending Approval', 'Approved', 'Partially Paid', 'Paid', 'Overdue'],
      ),
    ),
    'purchaseReturns': EntitySchema(
      key: 'purchaseReturns', primaryKey: 'code', subKey: 'supplier', numberKey: 'code', approval: true,
      columns: [..._pdocColumns('Purchase Return'), const ColumnDef(key: 'reason', label: 'Reason')],
      fields: _pdocFields(
        const [FieldDef(key: 'reason', label: 'Reason', type: FieldType.select, options: ['Defective goods', 'Incorrect specification', 'Excess quantity received'])],
        const ['Draft', 'Pending Approval', 'Approved', 'Shipped', 'Completed'],
      ),
    ),
    'debitNotes': EntitySchema(
      key: 'debitNotes', primaryKey: 'code', subKey: 'supplier', numberKey: 'code', approval: true,
      columns: [..._pdocColumns('Debit Note'), const ColumnDef(key: 'reason', label: 'Reason')],
      fields: _pdocFields(
        const [FieldDef(key: 'reason', label: 'Reason', type: FieldType.select, options: ['Purchase return', 'Price discrepancy', 'Freight claim'])],
        const ['Draft', 'Pending Approval', 'Approved', 'Applied'],
      ),
    ),

    // ---------------- Inventory Management ----------------
    'items': EntitySchema(
      key: 'items', primaryKey: 'name', subKey: 'code', numberKey: 'code',
      columns: [
        const ColumnDef(key: 'code', label: 'Code'),
        const ColumnDef(key: 'name', label: 'Item'),
        const ColumnDef(key: 'group', label: 'Group'),
        const ColumnDef(key: 'uom', label: 'UOM'),
        const ColumnDef(key: 'standardCost', label: 'Cost', type: ColumnType.money),
        const ColumnDef(key: 'sellingPrice', label: 'Price', type: ColumnType.money),
        ColumnDef(key: 'stock', label: 'Total Stock', type: ColumnType.numraw, compute: (rec) => rec['_stockTotal'] ?? 0),
        const ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        const FieldDef(key: 'name', label: 'Item Name', required: true),
        FieldDef(key: 'group', label: 'Item Group', type: FieldType.select, optionsFn: (db) => _opt(db, 'itemGroups', 'name')),
        FieldDef(key: 'uom', label: 'Unit of Measure', type: FieldType.select, optionsFn: (db) => _opt(db, 'uoms', 'name')),
        const FieldDef(key: 'standardCost', label: 'Standard Cost', type: FieldType.number),
        const FieldDef(key: 'sellingPrice', label: 'Selling Price', type: FieldType.number),
        const FieldDef(key: 'reorderLevel', label: 'Reorder Level', type: FieldType.number),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Active', 'Inactive']),
      ],
    ),
    'itemGroups': EntitySchema(
      key: 'itemGroups', primaryKey: 'name', numberKey: 'name',
      columns: const [
        ColumnDef(key: 'name', label: 'Group Name'),
        ColumnDef(key: 'createdAt', label: 'Created', type: ColumnType.date),
      ],
      fields: const [FieldDef(key: 'name', label: 'Group Name', required: true)],
    ),
    'uoms': EntitySchema(
      key: 'uoms', primaryKey: 'name', numberKey: 'name',
      columns: const [
        ColumnDef(key: 'name', label: 'Unit'),
        ColumnDef(key: 'description', label: 'Description'),
      ],
      fields: const [
        FieldDef(key: 'name', label: 'Unit Symbol', required: true),
        FieldDef(key: 'description', label: 'Description'),
      ],
    ),
    'warehouses': EntitySchema(
      key: 'warehouses', primaryKey: 'name', subKey: 'code', numberKey: 'code',
      columns: const [
        ColumnDef(key: 'code', label: 'Code'),
        ColumnDef(key: 'name', label: 'Warehouse'),
        ColumnDef(key: 'city', label: 'City'),
        ColumnDef(key: 'type', label: 'Type'),
        ColumnDef(key: 'manager', label: 'Manager'),
        ColumnDef(key: 'capacity', label: 'Capacity', type: ColumnType.numraw),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: const [
        FieldDef(key: 'name', label: 'Warehouse Name', required: true),
        FieldDef(key: 'city', label: 'City', type: FieldType.select, options: kCities),
        FieldDef(key: 'type', label: 'Type', type: FieldType.select, options: ['Distribution Center', 'Manufacturing Store', 'Cross-Dock', 'Retail Backstore']),
        FieldDef(key: 'manager', label: 'Manager'),
        FieldDef(key: 'capacity', label: 'Capacity (units)', type: FieldType.number),
        FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Active', 'Inactive']),
      ],
    ),
    'binLocations': EntitySchema(
      key: 'binLocations', primaryKey: 'code', subKey: 'warehouse', numberKey: 'code',
      columns: const [
        ColumnDef(key: 'code', label: 'Bin Code'),
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'zone', label: 'Zone'),
        ColumnDef(key: 'capacityUnits', label: 'Capacity', type: ColumnType.numraw),
        ColumnDef(key: 'occupied', label: 'Occupied %', type: ColumnType.pct),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        FieldDef(key: 'warehouse', label: 'Warehouse', type: FieldType.select, optionsFn: _warehouseNames),
        const FieldDef(key: 'zone', label: 'Zone', type: FieldType.select, options: ['Receiving', 'Bulk Storage', 'Pick Face', 'Staging', 'Returns']),
        const FieldDef(key: 'capacityUnits', label: 'Capacity (units)', type: FieldType.number),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Active', 'Inactive']),
      ],
    ),
    'stockEntries': EntitySchema(
      key: 'stockEntries', primaryKey: 'code', subKey: 'item', numberKey: 'code', approval: true,
      columns: const [
        ColumnDef(key: 'code', label: 'Entry'),
        ColumnDef(key: 'type', label: 'Type'),
        ColumnDef(key: 'item', label: 'Item'),
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'qty', label: 'Qty', type: ColumnType.numraw),
        ColumnDef(key: 'date', label: 'Date', type: ColumnType.date),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        const FieldDef(key: 'type', label: 'Entry Type', type: FieldType.select, options: ['Material Receipt', 'Material Issue', 'Manufacture', 'Repack']),
        FieldDef(key: 'item', label: 'Item', type: FieldType.select, optionsFn: (db) => _opt(db, 'items', 'name')),
        FieldDef(key: 'warehouse', label: 'Warehouse', type: FieldType.select, optionsFn: _warehouseNames),
        const FieldDef(key: 'qty', label: 'Quantity', type: FieldType.number),
        const FieldDef(key: 'date', label: 'Date', type: FieldType.date),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Draft', 'Submitted', 'Completed']),
      ],
    ),
    'stockTransfers': EntitySchema(
      key: 'stockTransfers', primaryKey: 'code', subKey: 'item', numberKey: 'code', approval: true,
      workflow: 'inventoryFlow', step: 'Stock Transfer',
      columns: const [
        ColumnDef(key: 'code', label: 'Transfer'),
        ColumnDef(key: 'item', label: 'Item'),
        ColumnDef(key: 'fromWarehouse', label: 'From'),
        ColumnDef(key: 'toWarehouse', label: 'To'),
        ColumnDef(key: 'qty', label: 'Qty', type: ColumnType.numraw),
        ColumnDef(key: 'date', label: 'Date', type: ColumnType.date),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        FieldDef(key: 'item', label: 'Item', type: FieldType.select, optionsFn: (db) => _opt(db, 'items', 'name')),
        FieldDef(key: 'fromWarehouse', label: 'From Warehouse', type: FieldType.select, optionsFn: _warehouseNames),
        FieldDef(key: 'toWarehouse', label: 'To Warehouse', type: FieldType.select, optionsFn: _warehouseNames),
        const FieldDef(key: 'qty', label: 'Quantity', type: FieldType.number),
        const FieldDef(key: 'date', label: 'Date', type: FieldType.date),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Draft', 'Pending Approval', 'In Transit', 'Completed']),
      ],
    ),
    'stockReconciliations': EntitySchema(
      key: 'stockReconciliations', primaryKey: 'code', subKey: 'warehouse', numberKey: 'code', approval: true,
      columns: const [
        ColumnDef(key: 'code', label: 'Reconciliation'),
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'itemsCounted', label: 'Items Counted', type: ColumnType.numraw),
        ColumnDef(key: 'discrepanciesFound', label: 'Discrepancies', type: ColumnType.numraw),
        ColumnDef(key: 'date', label: 'Date', type: ColumnType.date),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        FieldDef(key: 'warehouse', label: 'Warehouse', type: FieldType.select, optionsFn: _warehouseNames),
        const FieldDef(key: 'itemsCounted', label: 'Items Counted', type: FieldType.number),
        const FieldDef(key: 'discrepanciesFound', label: 'Discrepancies Found', type: FieldType.number),
        const FieldDef(key: 'date', label: 'Date', type: FieldType.date),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Draft', 'In Progress', 'Completed']),
      ],
    ),
    'batches': EntitySchema(
      key: 'batches', primaryKey: 'batchNo', subKey: 'item', numberKey: 'batchNo',
      columns: const [
        ColumnDef(key: 'batchNo', label: 'Batch No.'),
        ColumnDef(key: 'item', label: 'Item'),
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'qty', label: 'Qty', type: ColumnType.numraw),
        ColumnDef(key: 'mfgDate', label: 'Mfg Date', type: ColumnType.date),
        ColumnDef(key: 'expDate', label: 'Exp. Date', type: ColumnType.date),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        FieldDef(key: 'item', label: 'Item', type: FieldType.select, optionsFn: (db) => db['items'].where((i) => i['trackBatch'] == true).map((i) => i['name'] as String).toList()),
        FieldDef(key: 'warehouse', label: 'Warehouse', type: FieldType.select, optionsFn: _warehouseNames),
        const FieldDef(key: 'qty', label: 'Quantity', type: FieldType.number),
        const FieldDef(key: 'mfgDate', label: 'Manufacture Date', type: FieldType.date),
        const FieldDef(key: 'expDate', label: 'Expiry Date', type: FieldType.date),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Active', 'Quarantine', 'Expiring Soon']),
      ],
    ),
    'serialNumbers': EntitySchema(
      key: 'serialNumbers', primaryKey: 'serialNo', subKey: 'item', numberKey: 'serialNo',
      columns: const [
        ColumnDef(key: 'serialNo', label: 'Serial No.'),
        ColumnDef(key: 'item', label: 'Item'),
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
        ColumnDef(key: 'createdAt', label: 'Registered', type: ColumnType.date),
      ],
      fields: [
        FieldDef(key: 'item', label: 'Item', type: FieldType.select, optionsFn: (db) => db['items'].where((i) => i['trackSerial'] == true).map((i) => i['name'] as String).toList()),
        FieldDef(key: 'warehouse', label: 'Warehouse', type: FieldType.select, optionsFn: _warehouseNames),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['In Stock', 'Delivered', 'Reserved', 'Under Repair']),
      ],
    ),
    'inventoryAdjustments': EntitySchema(
      key: 'inventoryAdjustments', primaryKey: 'code', subKey: 'item', numberKey: 'code', approval: true,
      columns: const [
        ColumnDef(key: 'code', label: 'Adjustment'),
        ColumnDef(key: 'item', label: 'Item'),
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'adjustmentType', label: 'Type'),
        ColumnDef(key: 'qty', label: 'Qty', type: ColumnType.numraw),
        ColumnDef(key: 'reason', label: 'Reason'),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        FieldDef(key: 'item', label: 'Item', type: FieldType.select, optionsFn: (db) => _opt(db, 'items', 'name')),
        FieldDef(key: 'warehouse', label: 'Warehouse', type: FieldType.select, optionsFn: _warehouseNames),
        const FieldDef(key: 'adjustmentType', label: 'Adjustment Type', type: FieldType.select, options: ['Increase', 'Decrease']),
        const FieldDef(key: 'qty', label: 'Quantity', type: FieldType.number),
        const FieldDef(key: 'reason', label: 'Reason', type: FieldType.select, options: ['Damaged stock', 'Cycle count variance', 'Expired goods', 'Theft/Loss', 'System correction']),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Draft', 'Pending Approval', 'Approved']),
      ],
    ),

    // ---------------- Warehouse Management ----------------
    'pickingLists': EntitySchema(
      key: 'pickingLists', primaryKey: 'code', subKey: 'customer', numberKey: 'code',
      columns: const [
        ColumnDef(key: 'code', label: 'Picking List'),
        ColumnDef(key: 'salesOrderRef', label: 'Sales Order'),
        ColumnDef(key: 'customer', label: 'Customer'),
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'assignedTo', label: 'Assigned To'),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        const FieldDef(key: 'salesOrderRef', label: 'Sales Order Ref'),
        FieldDef(key: 'customer', label: 'Customer', type: FieldType.select, optionsFn: _customerNames),
        FieldDef(key: 'warehouse', label: 'Warehouse', type: FieldType.select, optionsFn: _warehouseNames),
        const FieldDef(key: 'assignedTo', label: 'Assigned To'),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Pending', 'In Progress', 'Picked', 'Short Picked']),
      ],
    ),
    'packingLists': EntitySchema(
      key: 'packingLists', primaryKey: 'code', subKey: 'customer', numberKey: 'code',
      columns: const [
        ColumnDef(key: 'code', label: 'Packing List'),
        ColumnDef(key: 'pickingRef', label: 'Picking List'),
        ColumnDef(key: 'customer', label: 'Customer'),
        ColumnDef(key: 'cartons', label: 'Cartons', type: ColumnType.numraw),
        ColumnDef(key: 'weightKg', label: 'Weight (kg)', type: ColumnType.numraw),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        const FieldDef(key: 'pickingRef', label: 'Picking List Ref'),
        FieldDef(key: 'customer', label: 'Customer', type: FieldType.select, optionsFn: _customerNames),
        const FieldDef(key: 'cartons', label: 'Cartons', type: FieldType.number),
        const FieldDef(key: 'weightKg', label: 'Weight (kg)', type: FieldType.number),
        const FieldDef(key: 'packedBy', label: 'Packed By'),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Pending', 'Packed', 'Ready to Ship']),
      ],
    ),
    'putAway': EntitySchema(
      key: 'putAway', primaryKey: 'code', subKey: 'warehouse', numberKey: 'code',
      columns: const [
        ColumnDef(key: 'code', label: 'Put-away'),
        ColumnDef(key: 'grnRef', label: 'GRN'),
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'binLocation', label: 'Bin'),
        ColumnDef(key: 'assignedTo', label: 'Assigned To'),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        const FieldDef(key: 'grnRef', label: 'GRN Reference'),
        FieldDef(key: 'warehouse', label: 'Warehouse', type: FieldType.select, optionsFn: _warehouseNames),
        const FieldDef(key: 'binLocation', label: 'Bin Location'),
        const FieldDef(key: 'assignedTo', label: 'Assigned To'),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Pending', 'In Progress', 'Completed']),
      ],
    ),
    'cycleCounting': EntitySchema(
      key: 'cycleCounting', primaryKey: 'code', subKey: 'warehouse', numberKey: 'code',
      columns: const [
        ColumnDef(key: 'code', label: 'Cycle Count'),
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'binLocation', label: 'Bin'),
        ColumnDef(key: 'countedBy', label: 'Counted By'),
        ColumnDef(key: 'variance', label: 'Variance', type: ColumnType.numraw),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        FieldDef(key: 'warehouse', label: 'Warehouse', type: FieldType.select, optionsFn: _warehouseNames),
        const FieldDef(key: 'binLocation', label: 'Bin Location'),
        const FieldDef(key: 'countedBy', label: 'Counted By'),
        const FieldDef(key: 'variance', label: 'Variance', type: FieldType.number),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Scheduled', 'In Progress', 'Completed', 'Variance Review']),
      ],
    ),
    'inventoryMovement': EntitySchema(
      key: 'inventoryMovement', primaryKey: 'code', subKey: 'item', numberKey: 'code',
      columns: const [
        ColumnDef(key: 'code', label: 'Movement'),
        ColumnDef(key: 'item', label: 'Item'),
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'movementType', label: 'Type'),
        ColumnDef(key: 'qty', label: 'Qty', type: ColumnType.numraw),
        ColumnDef(key: 'refDoc', label: 'Ref. Doc'),
        ColumnDef(key: 'date', label: 'Date', type: ColumnType.date),
      ],
      fields: [
        FieldDef(key: 'item', label: 'Item', type: FieldType.select, optionsFn: (db) => _opt(db, 'items', 'name')),
        FieldDef(key: 'warehouse', label: 'Warehouse', type: FieldType.select, optionsFn: _warehouseNames),
        const FieldDef(key: 'movementType', label: 'Movement Type', type: FieldType.select, options: ['Inbound', 'Outbound', 'Transfer', 'Adjustment']),
        const FieldDef(key: 'qty', label: 'Quantity', type: FieldType.number),
        const FieldDef(key: 'refDoc', label: 'Reference Document'),
        const FieldDef(key: 'date', label: 'Date', type: FieldType.date),
      ],
    ),
    'binManagement': EntitySchema(
      key: 'binManagement', primaryKey: 'code', subKey: 'warehouse', numberKey: 'code',
      columns: const [
        ColumnDef(key: 'code', label: 'Bin Code'),
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'zone', label: 'Zone'),
        ColumnDef(key: 'capacityUnits', label: 'Capacity', type: ColumnType.numraw),
        ColumnDef(key: 'occupied', label: 'Occupied %', type: ColumnType.pct),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        FieldDef(key: 'warehouse', label: 'Warehouse', type: FieldType.select, optionsFn: _warehouseNames),
        const FieldDef(key: 'zone', label: 'Zone', type: FieldType.select, options: ['Receiving', 'Bulk Storage', 'Pick Face', 'Staging', 'Returns']),
        const FieldDef(key: 'capacityUnits', label: 'Capacity (units)', type: FieldType.number),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Active', 'Inactive']),
      ],
    ),

    // ---------------- Logistics ----------------
    'shipments': EntitySchema(
      key: 'shipments', primaryKey: 'code', subKey: 'customer', numberKey: 'code',
      workflow: 'inventoryFlow', step: 'Shipment',
      columns: const [
        ColumnDef(key: 'code', label: 'Shipment'),
        ColumnDef(key: 'customer', label: 'Customer'),
        ColumnDef(key: 'carrier', label: 'Carrier'),
        ColumnDef(key: 'trackingNo', label: 'Tracking No.'),
        ColumnDef(key: 'destination', label: 'Destination'),
        ColumnDef(key: 'eta', label: 'ETA', type: ColumnType.date),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        FieldDef(key: 'customer', label: 'Customer', type: FieldType.select, optionsFn: _customerNames),
        const FieldDef(key: 'carrier', label: 'Carrier', type: FieldType.select, options: kCouriers),
        const FieldDef(key: 'destination', label: 'Destination', type: FieldType.select, options: kCities),
        const FieldDef(key: 'shipDate', label: 'Ship Date', type: FieldType.date),
        const FieldDef(key: 'eta', label: 'ETA', type: FieldType.date),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Booked', 'Picked Up', 'In Transit', 'Out for Delivery', 'Delivered', 'Delayed']),
      ],
    ),
    'deliverySchedule': EntitySchema(
      key: 'deliverySchedule', primaryKey: 'code', subKey: 'customer', numberKey: 'code',
      columns: const [
        ColumnDef(key: 'code', label: 'Dispatch'),
        ColumnDef(key: 'deliveryRef', label: 'Delivery Note'),
        ColumnDef(key: 'customer', label: 'Customer'),
        ColumnDef(key: 'scheduledDate', label: 'Scheduled', type: ColumnType.date),
        ColumnDef(key: 'vehicle', label: 'Vehicle'),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        const FieldDef(key: 'deliveryRef', label: 'Delivery Note Ref'),
        FieldDef(key: 'customer', label: 'Customer', type: FieldType.select, optionsFn: _customerNames),
        const FieldDef(key: 'scheduledDate', label: 'Scheduled Date', type: FieldType.date),
        const FieldDef(key: 'vehicle', label: 'Vehicle', type: FieldType.select, options: kVehicles),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Scheduled', 'Loading', 'Dispatched', 'Delivered', 'Delayed']),
      ],
    ),
    'transportManagement': EntitySchema(
      key: 'transportManagement', primaryKey: 'code', subKey: 'carrier', numberKey: 'code',
      columns: const [
        ColumnDef(key: 'code', label: 'Trip'),
        ColumnDef(key: 'route', label: 'Route'),
        ColumnDef(key: 'carrier', label: 'Carrier'),
        ColumnDef(key: 'vehicle', label: 'Vehicle'),
        ColumnDef(key: 'capacityUsedPct', label: 'Capacity Used', type: ColumnType.pct),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: const [
        FieldDef(key: 'route', label: 'Route'),
        FieldDef(key: 'carrier', label: 'Carrier', type: FieldType.select, options: kCouriers),
        FieldDef(key: 'vehicle', label: 'Vehicle', type: FieldType.select, options: kVehicles),
        FieldDef(key: 'capacityUsedPct', label: 'Capacity Used %', type: FieldType.number),
        FieldDef(key: 'plannedDate', label: 'Planned Date', type: FieldType.date),
        FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Planned', 'Dispatched', 'In Transit', 'Completed']),
      ],
    ),
    'dispatchPlanning': EntitySchema(
      key: 'dispatchPlanning', primaryKey: 'code', subKey: 'warehouse', numberKey: 'code',
      columns: const [
        ColumnDef(key: 'code', label: 'Plan'),
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'ordersConsolidated', label: 'Orders', type: ColumnType.numraw),
        ColumnDef(key: 'vehicle', label: 'Vehicle'),
        ColumnDef(key: 'plannedDate', label: 'Planned Date', type: ColumnType.date),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        FieldDef(key: 'warehouse', label: 'Warehouse', type: FieldType.select, optionsFn: _warehouseNames),
        const FieldDef(key: 'ordersConsolidated', label: 'Orders Consolidated', type: FieldType.number),
        const FieldDef(key: 'vehicle', label: 'Vehicle', type: FieldType.select, options: kVehicles),
        const FieldDef(key: 'route', label: 'Route'),
        const FieldDef(key: 'plannedDate', label: 'Planned Date', type: FieldType.date),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Draft', 'Confirmed', 'Dispatched']),
      ],
    ),
    'courierTracking': EntitySchema(
      key: 'courierTracking', primaryKey: 'code', subKey: 'carrier', numberKey: 'code',
      columns: const [
        ColumnDef(key: 'code', label: 'Tracking'),
        ColumnDef(key: 'shipmentRef', label: 'Shipment'),
        ColumnDef(key: 'carrier', label: 'Carrier'),
        ColumnDef(key: 'trackingNo', label: 'Tracking No.'),
        ColumnDef(key: 'lastLocation', label: 'Last Location'),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: const [
        FieldDef(key: 'shipmentRef', label: 'Shipment Ref'),
        FieldDef(key: 'carrier', label: 'Carrier', type: FieldType.select, options: kCouriers),
        FieldDef(key: 'lastLocation', label: 'Last Known Location', type: FieldType.select, options: kCities),
        FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Booked', 'Picked Up', 'In Transit', 'Out for Delivery', 'Delivered', 'Delayed']),
      ],
    ),
    'vehicleAllocation': EntitySchema(
      key: 'vehicleAllocation', primaryKey: 'code', subKey: 'vehicle', numberKey: 'code',
      columns: const [
        ColumnDef(key: 'code', label: 'Allocation'),
        ColumnDef(key: 'vehicle', label: 'Vehicle'),
        ColumnDef(key: 'driver', label: 'Driver'),
        ColumnDef(key: 'warehouse', label: 'Warehouse'),
        ColumnDef(key: 'route', label: 'Route'),
        ColumnDef(key: 'status', label: 'Status', type: ColumnType.status),
      ],
      fields: [
        const FieldDef(key: 'vehicle', label: 'Vehicle', type: FieldType.select, options: kVehicles),
        const FieldDef(key: 'driver', label: 'Driver'),
        FieldDef(key: 'warehouse', label: 'Warehouse', type: FieldType.select, optionsFn: _warehouseNames),
        const FieldDef(key: 'route', label: 'Route'),
        const FieldDef(key: 'status', label: 'Status', type: FieldType.select, options: ['Allocated', 'On Route', 'Returned', 'Under Maintenance']),
      ],
    ),
  };

  static EntitySchema of(String key) => all[key]!;
}
