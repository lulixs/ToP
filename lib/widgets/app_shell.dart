import 'package:flutter/material.dart';

import '../app_state.dart';
import '../data/mock_data.dart';
import '../screens/accounts_section.dart';
import '../screens/alerts_section.dart';
import '../screens/audit_log_section.dart';
import '../screens/boxes_section.dart';
import '../screens/buildings_section.dart';
import '../screens/categories_section.dart';
import '../screens/dashboard_section.dart';
import '../screens/deleted_items_section.dart';
import '../screens/devices_section.dart';
import '../screens/employee_signin_screen.dart';
import '../screens/master_signin_screen.dart';
import '../screens/scanner_screen.dart';
import '../theme.dart';
import 'common.dart';

enum Section { dashboard, boxes, categories, alerts, accounts, buildings, devices, deleted, audit }

const _main = [
  (Section.dashboard, 'Dashboard', Icons.grid_view_outlined),
  (Section.boxes, 'Boxes', Icons.inventory_2_outlined),
  (Section.categories, 'Categories', Icons.sell_outlined),
];
const _master = [
  (Section.accounts, 'Accounts', Icons.people_outline),
  (Section.buildings, 'Buildings', Icons.apartment_outlined),
  (Section.devices, 'Devices', Icons.tablet_android_outlined),
  (Section.deleted, 'Deleted Items', Icons.delete_outline),
  (Section.audit, 'Audit Log', Icons.description_outlined),
];

bool isMasterOnly(Section s) => _master.any((m) => m.$1 == s);

/// Main app frame: sidebar on the left, page in the middle, Scan / Search /
/// Alerts bar at the bottom. On narrow screens the sidebar becomes a drawer.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  Section section = Section.dashboard;
  String boxesCategory = 'Coats';
  bool focusSearch = false;
  int boxesKey = 0; // forces Boxes to rebuild with a new starting filter
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void go(Section s) => setState(() {
        section = s;
        focusSearch = false;
      });

  void openCategory(String cat) => setState(() {
        section = Section.boxes;
        boxesCategory = cat;
        focusSearch = false;
        boxesKey++;
      });

  void openSearch() => setState(() {
        section = Section.boxes;
        boxesCategory = 'All categories';
        focusSearch = true;
        boxesKey++;
      });

  /// Turn on: confirm -> Master sign-in. Turn off: confirm.
  Future<bool> toggleMaster() async {
    if (AppState.masterOn.value) {
      final r = await showPopup(context,
          title: 'Turn off Master mode?',
          message: 'Master-only pages lock again on this tablet.',
          actions: ['Cancel', 'Turn off']);
      if (r == 'Turn off') {
        AppState.masterOn.value = false;
        if (isMasterOnly(section)) go(Section.dashboard);
        setState(() {});
      }
      return false;
    }
    final r = await showPopup(context,
        title: 'Turn on Master mode?',
        message:
            'Master mode unlocks Accounts, Buildings, Devices, Deleted Items, and the Audit Log on this tablet. You will sign in with the Master account next.',
        actions: ['Cancel', 'Turn on']);
    if (r != 'Turn on' || !mounted) return false;
    final ok = await Navigator.push<bool>(
        context, MaterialPageRoute(builder: (_) => MasterSignInScreen()));
    if (ok == true) {
      AppState.masterOn.value = true;
      setState(() {});
      return true;
    }
    return false;
  }

  Future<void> tapNav(Section s) async {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) _scaffoldKey.currentState!.closeDrawer();
    if (isMasterOnly(s) && !AppState.masterOn.value) {
      if (await toggleMaster()) go(s);
      return;
    }
    go(s);
  }

  Widget _page() {
    return switch (section) {
      Section.dashboard => DashboardSection(onOpenCategory: openCategory),
      Section.boxes => BoxesSection(
          key: ValueKey(boxesKey), initialCategory: boxesCategory, autofocusSearch: focusSearch),
      Section.categories => CategoriesSection(onMasterRequired: toggleMaster),
      Section.alerts => AlertsSection(),
      Section.accounts => AccountsSection(),
      Section.buildings => BuildingsSection(),
      Section.devices => DevicesSection(),
      Section.deleted => DeletedItemsSection(),
      Section.audit => AuditLogSection(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 640;
    final sidebar = _Sidebar(
      active: section,
      onTap: tapNav,
      onMaster: toggleMaster,
      // Switch user signs the employee out and turns Master mode off.
      onSwitchUser: () {
        AppState.masterOn.value = false;
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (_) => EmployeeSignInScreen()), (_) => false);
      },
    );
    final main = Column(children: [
      Expanded(child: _page()),
      _BottomBar(
        alertsActive: section == Section.alerts,
        onScan: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ScannerScreen())),
        onSearch: openSearch,
        onAlerts: () => go(Section.alerts),
      ),
    ]);

    if (narrow) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: C.panel,
          title: Text('IMP', style: TextStyle(fontWeight: FontWeight.w700)),
        ),
        drawer: Drawer(backgroundColor: C.panel, width: 220, child: sidebar),
        body: main,
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Row(children: [
          SizedBox(width: 190, child: sidebar),
          Container(width: 2, color: g(0xFF9A9A9A)),
          Expanded(child: main),
        ]),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final Section active;
  final ValueChanged<Section> onTap;
  final VoidCallback onMaster;
  final VoidCallback onSwitchUser;
  const _Sidebar({required this.active, required this.onTap, required this.onMaster, required this.onSwitchUser});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.masterOn,
      builder: (context, masterOn, _) => Container(
        color: C.panel,
        padding: EdgeInsets.fromLTRB(10, 18, 10, 10),
        child: Column(children: [
          Expanded(
            child: ListView(children: [
              Center(child: Logo()),
              SizedBox(height: 18),
              for (final n in _main) _NavItem(n.$2, n.$3, active == n.$1, false, () => onTap(n.$1)),
              Padding(
                padding: EdgeInsets.fromLTRB(4, 16, 4, 7),
                child: Text('MASTER ONLY',
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: C.ink2)),
              ),
              for (final n in _master) _NavItem(n.$2, n.$3, active == n.$1, !masterOn, () => onTap(n.$1)),
            ]),
          ),
          SizedBox(height: 4),
          DarkModeSwitch(),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(8, 12, 8, 10),
            decoration: BoxDecoration(
                color: C.card, border: Border.all(color: C.line), borderRadius: BorderRadius.circular(10)),
            child: Column(children: [
              Material(
                color: masterOn ? C.ink : C.card,
                shape: StadiumBorder(side: BorderSide(color: C.ink, width: 1.5)),
                child: InkWell(
                  customBorder: StadiumBorder(),
                  onTap: onMaster,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(11, 5, 9, 5),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(masterOn ? 'Master on' : 'Master off',
                          style: TextStyle(
                              fontSize: 11.5, fontWeight: FontWeight.w700, color: masterOn ? C.white : C.ink)),
                      SizedBox(width: 6),
                      Icon(Icons.sync, size: 14, color: masterOn ? C.white : C.ink),
                    ]),
                  ),
                ),
              ),
              SizedBox(height: 7),
              Avatar(AppState.currentUser),
              SizedBox(height: 7),
              Text(AppState.currentUser, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              SizedBox(height: 7),
              PillButton('Switch user', small: true, height: 28, onTap: onSwitchUser),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final bool locked;
  final VoidCallback onTap;
  const _NavItem(this.label, this.icon, this.active, this.locked, this.onTap);

  @override
  Widget build(BuildContext context) {
    final fg = active ? C.white : (locked ? C.ink3 : C.ink);
    return Padding(
      padding: EdgeInsets.only(bottom: 7),
      child: Material(
        color: active ? C.ink : (locked ? Colors.transparent : C.card),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: active ? C.ink : (locked ? g(0xFFB3B3B3) : C.line)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: SizedBox(
            height: 42,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 9),
              child: Row(children: [
                Icon(icon, size: 18, color: fg),
                SizedBox(width: 8),
                Expanded(
                  child: Text(label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14, color: fg, fontWeight: active ? FontWeight.w700 : FontWeight.w400)),
                ),
                if (locked) Icon(Icons.lock_outline, size: 13, color: fg),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final bool alertsActive;
  final VoidCallback onScan, onSearch, onAlerts;
  const _BottomBar({required this.alertsActive, required this.onScan, required this.onSearch, required this.onAlerts});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      decoration: BoxDecoration(color: C.soft, border: Border(top: BorderSide(color: g(0xFFB5B5B5)))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _bbItem(Icons.qr_code_scanner, 'Scan', onScan),
        _bbItem(Icons.search, 'Search', onSearch),
        _bbItem(Icons.notifications_none, 'Alerts', onAlerts, badge: alertBoxes.length, active: alertsActive),
      ]),
    );
  }

  Widget _bbItem(IconData icon, String label, VoidCallback onTap, {int? badge, bool active = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Stack(clipBehavior: Clip.none, children: [
            Icon(icon, size: 38, color: C.ink),
            if (badge != null)
              Positioned(
                top: -6,
                right: -10,
                child: Container(
                  constraints: BoxConstraints(minWidth: 22),
                  height: 22,
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: C.ink, borderRadius: BorderRadius.circular(11), border: Border.all(color: C.soft, width: 2)),
                  child: Text('$badge',
                      style: TextStyle(color: C.white, fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ),
          ]),
          SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: active ? FontWeight.w700 : FontWeight.w400)),
          if (active)
            Container(margin: EdgeInsets.only(top: 4), width: 40, height: 4,
                decoration: BoxDecoration(color: C.ink, borderRadius: BorderRadius.circular(2))),
        ]),
      ),
    );
  }
}

/// Header + scrolling content used by every section in the shell.
class SectionPage extends StatelessWidget {
  final String title;
  final String sub;
  final VoidCallback? onAdd;
  final Widget child;
  final bool scroll;
  SectionPage(
      {super.key, required this.title, required this.sub, this.onAdd, required this.child, this.scroll = true});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        padding: EdgeInsets.fromLTRB(24, 30, 24, 18),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: g(0xFFB5B5B5)))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
              SizedBox(height: 8),
              Text(sub, style: TextStyle(fontSize: 13.5, fontStyle: FontStyle.italic, color: C.ink2)),
            ]),
          ),
          if (onAdd != null)
            Material(
              color: C.card,
              shape: CircleBorder(side: BorderSide(color: C.ink, width: 2)),
              child: InkWell(
                customBorder: CircleBorder(),
                onTap: onAdd,
                child: SizedBox(width: 46, height: 46, child: Icon(Icons.add, size: 26, color: C.ink)),
              ),
            ),
        ]),
      ),
      Expanded(
        child: scroll
            ? SingleChildScrollView(padding: EdgeInsets.fromLTRB(22, 16, 22, 16), child: child)
            : Padding(padding: EdgeInsets.fromLTRB(22, 16, 22, 0), child: child),
      ),
    ]);
  }
}
