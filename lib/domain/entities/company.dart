/// Ported from `COMPANIES` — the company/branch switcher data.
class Company {
  const Company({required this.id, required this.name, required this.branches});

  final String id;
  final String name;
  final List<String> branches;
}

const kCompanies = [
  Company(
    id: 'c1',
    name: 'IMPACGO Global Trading LLC',
    branches: ['HQ — New York', 'West Coast Office — Los Angeles', 'EU Liaison — Rotterdam'],
  ),
  Company(
    id: 'c2',
    name: 'IMPACGO Manufacturing Pvt Ltd',
    branches: ['Plant 1 — Charlotte, NC', 'Plant 2 — Monterrey, MX'],
  ),
  Company(
    id: 'c3',
    name: 'IMPACGO Distribution FZE',
    branches: ['Distribution Hub — Dallas', 'Distribution Hub — Chicago'],
  ),
];
