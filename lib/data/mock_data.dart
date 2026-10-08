// Fake sample data copied from the wireframe source (build.py).
// Replace this file with real backend calls later.

final DateTime today = DateTime(2026, 10, 7);
const int alertDays = 180; // placeholder threshold

class Box {
  final int id;
  final String category;
  final String building;
  final String shelf;
  final int level;
  final String fullness; // Full, Half, Empty
  final DateTime created;
  final bool racked;
  final bool deleted;

  const Box(this.id, this.category, this.building, this.shelf, this.level,
      this.fullness, this.created, this.racked, this.deleted);

  int get daysStored => today.difference(created).inDays;
  bool get tooLong => racked && !deleted && daysStored > alertDays;
}

const List<String> categories = [
  'Coats', 'Winter Hats', 'Gloves', 'Halloween Costumes',
  'Christmas Lights', 'Scarves', 'Pool Noodles', 'Easter Baskets',
];

const Map<String, String> categorySymbol = {
  'Coats': '🧥', 'Winter Hats': '❄️', 'Gloves': '🧤', 'Halloween Costumes': '🎃',
  'Christmas Lights': '🎄', 'Scarves': '🧣', 'Pool Noodles': '🏊',
};

String withSymbol(String cat) =>
    categorySymbol.containsKey(cat) ? '${categorySymbol[cat]}  $cat' : cat;

const String pc = 'Processing Center';
const String ms = 'Main Store';
const String oa = 'Old Annex';
const List<String> buildings = [pc, ms, oa, 'Back Garage'];
const Map<String, String> buildingAdded = {
  pc: '08/31/26', ms: '08/31/26', oa: '09/14/26', 'Back Garage': '10/06/26',
};

DateTime _d(String s) => DateTime.parse(s);

final List<Box> boxes = [
  Box(6789, 'Coats', pc, 'A', 2, 'Full', _d('2026-01-14'), true, false),
  Box(6712, 'Coats', pc, 'B', 1, 'Half', _d('2026-02-21'), true, false),
  Box(6735, 'Coats', pc, 'A', 3, 'Full', _d('2026-03-29'), true, false),
  Box(6744, 'Coats', pc, 'D', 2, 'Half', _d('2026-04-19'), false, false),
  Box(6750, 'Coats', pc, 'C', 1, 'Empty', _d('2026-05-10'), true, false),
  Box(6768, 'Coats', pc, 'B', 2, 'Full', _d('2026-07-25'), true, false),
  Box(6801, 'Coats', pc, 'C', 3, 'Half', _d('2026-10-04'), true, false),
  Box(6602, 'Coats', pc, 'B', 3, 'Half', _d('2026-06-02'), true, true),
  Box(6540, 'Halloween Costumes', pc, 'E', 1, 'Full', _d('2025-12-10'), true, false),
  Box(6588, 'Halloween Costumes', ms, 'B', 3, 'Half', _d('2026-02-05'), true, false),
  Box(6620, 'Halloween Costumes', pc, 'E', 2, 'Full', _d('2026-05-02'), true, false),
  Box(6655, 'Halloween Costumes', pc, 'E', 3, 'Full', _d('2026-06-11'), true, false),
  Box(6690, 'Halloween Costumes', ms, 'B', 1, 'Half', _d('2026-07-30'), true, false),
  Box(6720, 'Halloween Costumes', pc, 'F', 3, 'Empty', _d('2026-09-01'), true, false),
  Box(6702, 'Pool Noodles', pc, 'F', 1, 'Full', _d('2026-03-10'), true, false),
  Box(6630, 'Pool Noodles', pc, 'F', 2, 'Full', _d('2026-04-20'), true, false),
  Box(6641, 'Pool Noodles', ms, 'C', 1, 'Full', _d('2026-05-14'), true, false),
  Box(6660, 'Pool Noodles', pc, 'G', 1, 'Full', _d('2026-05-28'), true, false),
  Box(6675, 'Pool Noodles', pc, 'G', 2, 'Full', _d('2026-06-19'), true, false),
  Box(6710, 'Pool Noodles', pc, 'G', 3, 'Half', _d('2026-07-08'), true, false),
  Box(6758, 'Pool Noodles', ms, 'C', 2, 'Half', _d('2026-08-12'), true, false),
  Box(6790, 'Pool Noodles', pc, 'H', 1, 'Empty', _d('2026-09-15'), true, false),
  Box(6695, 'Scarves', ms, 'A', 1, 'Full', _d('2026-03-24'), true, false),
  Box(6730, 'Scarves', ms, 'A', 2, 'Half', _d('2026-06-24'), true, false),
  Box(6776, 'Scarves', ms, 'A', 3, 'Full', _d('2026-08-03'), true, false),
  Box(6795, 'Scarves', pc, 'D', 1, 'Empty', _d('2026-09-22'), true, false),
  Box(6377, 'Scarves', ms, 'C', 2, 'Full', _d('2026-04-02'), true, true),
  Box(6725, 'Winter Hats', pc, 'D', 3, 'Half', _d('2026-06-30'), true, false),
  Box(6748, 'Winter Hats', pc, 'H', 2, 'Half', _d('2026-07-21'), true, false),
  Box(6783, 'Winter Hats', ms, 'D', 1, 'Half', _d('2026-09-09'), true, false),
  Box(6762, 'Gloves', pc, 'H', 3, 'Full', _d('2026-08-18'), true, false),
  Box(6411, 'Gloves', oa, 'A', 2, 'Half', _d('2026-04-28'), true, false),
  Box(6398, 'Gloves', oa, 'A', 1, 'Empty', _d('2026-04-14'), true, true),
  Box(6733, 'Christmas Lights', ms, 'E', 1, 'Half', _d('2026-07-02'), true, false),
  Box(6766, 'Christmas Lights', ms, 'E', 2, 'Half', _d('2026-08-06'), true, false),
  Box(6799, 'Christmas Lights', pc, 'B', 3, 'Half', _d('2026-09-29'), true, false),
];

List<Box> get activeBoxes => boxes.where((b) => !b.deleted).toList();
List<Box> get rackedBoxes => activeBoxes.where((b) => b.racked).toList();
List<Box> get deletedBoxes => boxes.where((b) => b.deleted).toList();
List<Box> get alertBoxes =>
    boxes.where((b) => b.tooLong).toList()..sort((a, b) => a.created.compareTo(b.created));

Box boxById(int id) => boxes.firstWhere((b) => b.id == id);

String fmtDate(DateTime d) =>
    '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${(d.year % 100).toString().padLeft(2, '0')}';

class Employee {
  final String name;
  bool active;
  final String lastSignIn;
  Employee(this.name, this.active, this.lastSignIn);
}

final List<Employee> employees = [
  Employee('Mabel', true, '10/07/26'),
  Employee('Dipper', true, '10/07/26'),
  Employee('Stan', true, '10/06/26'),
  Employee('Soos', false, '09/25/26'),
  Employee('Wendy', true, '10/04/26'),
];

const Map<int, List<String>> deletedInfo = {
  6602: ['09/26/26', 'Dipper'],
  6398: ['09/20/26', 'Wendy'],
  6377: ['09/18/26', 'Mabel'],
};

const List<String> deletedCategories = ['Tools'];

// created, created by, last edited, edited by
const Map<int, List<String>> boxRecord = {
  6789: ['01/14/26', 'Mabel', '10/02/26', 'Dipper'],
  6744: ['04/19/26', 'Stan', '10/07/26', 'Mabel'],
};

class AuditEntry {
  final String date, time, employee, master, device, action, target;
  final String? diff;
  const AuditEntry(this.date, this.time, this.employee, this.master, this.device,
      this.action, this.target, [this.diff]);
}

const List<AuditEntry> audit = [
  AuditEntry('10/07/26', '2:41 PM', 'Dipper', 'Yes', 'Processing tablet', 'Restore', 'Box #6655'),
  AuditEntry('10/07/26', '11:20 AM', 'Mabel', 'No', 'Front desk tablet', 'Unrack', 'Box #6744',
      'Rack status: Racked → Unracked'),
  AuditEntry('10/06/26', '3:05 PM', 'Stan', 'No', 'Stockroom tablet', 'Soft delete', 'Box #6655'),
  AuditEntry('10/06/26', '9:10 AM', 'Dipper', 'Yes', 'Processing tablet', 'Building add', 'Building Back Garage'),
  AuditEntry('10/04/26', '3:15 PM', 'Wendy', 'No', 'Stockroom tablet', 'Create', 'Box #6801'),
  AuditEntry('10/02/26', '9:12 AM', 'Dipper', 'No', 'Processing tablet', 'Edit', 'Box #6789',
      'Fullness: Half → Full\nNotes: (empty) → "Mostly adult sizes. Check zippers before putting out."'),
  AuditEntry('09/30/26', '1:08 PM', 'Mabel', 'No', 'Front desk tablet', 'Category soft delete', 'Category Tools'),
  AuditEntry('09/27/26', '8:41 PM', 'Mabel', 'Yes', 'Front desk tablet', 'Deactivate account', 'Employee Soos'),
  AuditEntry('09/26/26', '4:30 PM', 'Dipper', 'No', 'Processing tablet', 'Soft delete', 'Box #6602'),
];

class Device {
  final String name;
  final bool thisTablet;
  final String? employee;
  final bool masterOn;
  final String signedIn, lastActivity;
  const Device(this.name, this.thisTablet, this.employee, this.masterOn, this.signedIn, this.lastActivity);
}

const List<Device> devices = [
  Device('Processing tablet', true, 'Dipper', true, '10/07/26 8:02 AM', '10/07/26 2:44 PM'),
  Device('Front desk tablet', false, 'Mabel', false, '10/07/26 8:15 AM', '10/07/26 2:41 PM'),
  Device('Stockroom tablet', false, null, false, '10/07/26 9:30 AM', '10/07/26 11:02 AM'),
];
