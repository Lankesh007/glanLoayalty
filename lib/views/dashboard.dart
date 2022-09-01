// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'package:tayal/views/bottomNavigation.dart';
import 'package:tayal/views/campaign_screen.dart';
import 'package:tayal/views/category_screen.dart';
import 'package:tayal/views/dashboard_screen.dart';
import 'package:tayal/views/help_screen.dart';
import 'package:tayal/views/mybiz_screen.dart';
import 'package:tayal/views/tabItem.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  // this is static property so other widget throughout the app
  // can access it simply by AppState.currentTab
  static int currentTab = 0;
  final List<TabItem> tabs = [
    TabItem(
      tabName: " Dashboard",
      icon: TablerIcons.home_2,
      page: DashBoardScreen(),
    ),
    TabItem(
      tabName: "My Biz",
      icon: TablerIcons.grid_dots,
      page: MyBizScreen(),
    ),
    TabItem(
      tabName: "Cart",
      icon: TablerIcons.shopping_cart_plus,
      page: CategoryScreen(),
    ),
    TabItem(
      tabName: "Campaign",
      icon: TablerIcons.trophy,
      page: CampaignScreen(),
    ),
    TabItem(
      tabName: "Help",
      icon: TablerIcons.message,
      page: HelpScreen(),
    ),
  ];

  DashboardState() {
    // indexing is necessary for proper funcationality
    // of determining which tab is active
    tabs.asMap().forEach((index, details) {
      details.setIndex(index);
    });
  }

  // sets current tab index
  // and update state
  void _selectTab(int index) {
    if (index == currentTab) {
      // pop to first route
      // if the user taps on the active tab
      tabs[index].key.currentState?.popUntil((route) => route.isFirst);
    } else {
      // update the state
      // in order to repaint
      setState(() => currentTab = index);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // WillPopScope handle android back btn
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await tabs[currentTab].key.currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (currentTab != 2) {
            // select 'main' tab
            _selectTab(2);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      // this is the base scaffold
      // don't put appbar in here otherwise you might end up
      // with multiple appbars on one screen
      // eventually breaking the app
      child: Scaffold(
          // indexed stack shows only one child
          body: IndexedStack(
            index: currentTab,
            children: tabs.map((e) => e.page).toList(),
          ),
          // Bottom navigation

          bottomNavigationBar: BottomNavigation(
            onSelectTab: _selectTab,
            tabs: tabs,
          )),
    );
  }
}
