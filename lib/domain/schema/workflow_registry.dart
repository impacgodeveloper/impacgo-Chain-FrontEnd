/// Ported from `WORKFLOWS` — the business-process diagrams shown on the
/// home workspace (`renderHome()`). Step icons come from
/// `NavRegistry.entitiesByKey[key].icon` since every step is a real entity.
class WorkflowStep {
  const WorkflowStep({required this.title, required this.entityKey});

  final String title;
  final String entityKey;
}

class WorkflowDef {
  const WorkflowDef({required this.title, required this.description, required this.steps});

  final String title;
  final String description;
  final List<WorkflowStep> steps;
}

abstract final class WorkflowRegistry {
  static const List<WorkflowDef> all = [
    WorkflowDef(
      title: 'Order to Cash',
      description: 'Lead through to customer payment — click any stage to open its worklist.',
      steps: [
        WorkflowStep(title: 'Lead', entityKey: 'leads'),
        WorkflowStep(title: 'Opportunity', entityKey: 'opportunities'),
        WorkflowStep(title: 'Quotation', entityKey: 'quotations'),
        WorkflowStep(title: 'Sales Order', entityKey: 'salesOrders'),
        WorkflowStep(title: 'Delivery Note', entityKey: 'deliveryNotes'),
        WorkflowStep(title: 'Sales Invoice', entityKey: 'salesInvoices'),
        WorkflowStep(title: 'Customer Payment', entityKey: 'customerPayments'),
      ],
    ),
    WorkflowDef(
      title: 'Procure to Pay',
      description: 'Internal purchase request through to supplier settlement.',
      steps: [
        WorkflowStep(title: 'Purchase Request', entityKey: 'purchaseRequests'),
        WorkflowStep(title: 'RFQ', entityKey: 'rfqs'),
        WorkflowStep(title: 'Supplier Quotation', entityKey: 'supplierQuotations'),
        WorkflowStep(title: 'Purchase Order', entityKey: 'purchaseOrders'),
        WorkflowStep(title: 'Purchase Receipt', entityKey: 'purchaseReceipts'),
        WorkflowStep(title: 'Purchase Invoice', entityKey: 'purchaseInvoices'),
      ],
    ),
    WorkflowDef(
      title: 'Inventory Flow',
      description: 'Movement of stock from receipt through to customer delivery.',
      steps: [
        WorkflowStep(title: 'Purchase Receipt', entityKey: 'purchaseReceipts'),
        WorkflowStep(title: 'Warehouse', entityKey: 'warehouses'),
        WorkflowStep(title: 'Stock Transfer', entityKey: 'stockTransfers'),
        WorkflowStep(title: 'Shipment', entityKey: 'shipments'),
      ],
    ),
  ];
}
