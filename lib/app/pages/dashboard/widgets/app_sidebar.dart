import 'package:flutter/material.dart';

class SidebarItemData {
  final IconData icon;
  final String title;
  final int count;
  final String category;

  const SidebarItemData({
    required this.icon,
    required this.title,
    required this.count,
    required this.category,
  });
}

class AppSidebar extends StatelessWidget {
  final bool isOpen;
  final int totalCount;
  final int activeCount;
  final int completedCount;
  final int personalCount;
  final int shoppingCount;
  final int wishlistCount;
  final int workCount;
  final String selectedKey;
  final ValueChanged<String> onSelect;
  final VoidCallback onClose;
  final VoidCallback onLogout;

  const AppSidebar({
    super.key,
    required this.isOpen,
    required this.totalCount,
    required this.activeCount,
    required this.completedCount,
    required this.personalCount,
    required this.shoppingCount,
    required this.wishlistCount,
    required this.workCount,
    required this.selectedKey,
    required this.onSelect,
    required this.onClose,
    required this.onLogout,
  });

  static const _items = <String, SidebarItemData>{
    'all': SidebarItemData(
      icon: Icons.list_alt, 
      title: 'All Lists', 
      count: -1,
      category: 'all',
    ),
    'personal': SidebarItemData(
      icon: Icons.person, 
      title: 'Personal', 
      count: -1,
      category: 'personal',
    ),
    'shopping': SidebarItemData(
      icon: Icons.shopping_bag, 
      title: 'Shopping', 
      count: -1,
      category: 'shopping',
    ),
    'wishlist': SidebarItemData(
      icon: Icons.favorite_border, 
      title: 'Wishlist', 
      count: -1,
      category: 'wishlist',
    ),
    'work': SidebarItemData(
      icon: Icons.work, 
      title: 'Work', 
      count: -1,
      category: 'work',
    ),
  };

  int _countFor(String key) {
    switch (key) {
      case 'all':
        return totalCount;
      case 'personal':
        return personalCount;
      case 'shopping':
        return shoppingCount;
      case 'wishlist':
        return wishlistCount;
      case 'work':
        return workCount;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sidebarWidth = screenWidth * 0.72 > 300 ? 300.0 : screenWidth * 0.72;

    return IgnorePointer(
      ignoring: !isOpen,
      child: AnimatedOpacity(
        opacity: isOpen ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: onClose,
                  child: Container(color: Colors.black.withValues(alpha: 0.35)),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: isOpen ? 0 : -sidebarWidth,
                top: 0,
                bottom: 0,
                width: sidebarWidth,
                child: SafeArea(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 30,
                          offset: const Offset(5, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 8),
                        _buildSectionLabel('TASKLISTS'),
                        const SizedBox(height: 4),
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            children: [
                              _buildItem('all'),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(
                                  color: Colors.grey.shade200,
                                  thickness: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _buildItem('personal'),
                              _buildItem('shopping'),
                              _buildItem('wishlist'),
                              _buildItem('work'),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(
                                  color: Colors.grey.shade200,
                                  thickness: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _buildLogoutItem(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 8, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ToDoList',
                  style: TextStyle(
                    color: Color(0xFF4A90D9),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.grey.shade600, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String key) {
    final data = _items[key]!;
    final isSelected = selectedKey == key;
    final count = data.count == -1 ? _countFor(key) : data.count;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onSelect(key),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF4A90D9).withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  data.icon,
                  color: isSelected ? const Color(0xFF4A90D9) : Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    data.title,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF4A90D9) : Colors.grey.shade700,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF4A90D9).withValues(alpha: 0.2)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF4A90D9) : Colors.grey.shade600,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onLogout,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.logout,
                  color: Colors.red.shade400,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.red.shade400,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}