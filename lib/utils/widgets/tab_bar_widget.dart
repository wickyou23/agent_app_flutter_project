import 'package:agent_app/res/res.dart';
import 'package:flutter/material.dart';

class TPTabBar extends StatefulWidget {
  const TPTabBar({Key? key, required this.tabController, required this.items})
      : super(key: key);

  final TabController tabController;
  final List<TabItem> items;

  @override
  State createState() => _TPTabBarState();
}

class _TPTabBarState extends State<TPTabBar> {
  late List<TabItem> mItems;

  @override
  void initState() {
    super.initState();

    mItems = widget.items;
    widget.tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.tabBarBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 6,
          )
        ],
      ),
      child: SafeArea(
        child: TabBar(
          controller: widget.tabController,
          indicator: const BoxDecoration(),
          labelColor: Theme.of(context).primaryColor,
          labelStyle: textTheme(context).caption!.bold,
          unselectedLabelStyle: textTheme(context).caption!.bold,
          indicatorColor: Colors.transparent,
          labelPadding: const EdgeInsets.only(top: 4),
          tabs: widget.items.map(_tabItem).toList(),
        ),
      ),
    );
  }

  Widget _tabItem(TabItem item) {
    final index = widget.items.indexOf(item);
    final color = index == widget.tabController.index
        ? Theme.of(context).primaryColor
        : AppColors.grayTextColor.withPercentAlpha(0.7);
    return IgnorePointer(
      ignoring: !item.isEnable,
      child: Opacity(
        opacity: item.isEnable ? 1.0 : 0.5,
        child: Tab(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ImageIcon(
                AssetImage(item.icon),
                size: 22,
                color: color,
              ),
              const SizedBox(height: 3),
              Text(
                item.title,
                style: textTheme(context).bodySmall2.copyWith(
                      color: color,
                      fontWeight: index == widget.tabController.index
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabItem {
  const TabItem({
    required this.id,
    required this.title,
    required this.icon,
    this.isEnable = true,
  });
  final int id;
  final String title;
  final String icon;
  final bool isEnable;

  TabItem copyWith({int? id, String? title, String? icon, bool? isEnable}) {
    return TabItem(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      isEnable: isEnable ?? this.isEnable,
    );
  }
}
