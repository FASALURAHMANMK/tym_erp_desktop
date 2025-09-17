import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../domain/models/kot_station.dart';

/// Style configuration for KOT printing
class KOTStyle {
  final String fontFamily;
  final double headerFontSize;
  final double normalFontSize;
  final double itemFontSize;
  final double footerFontSize;
  final Color textColor;

  const KOTStyle({
    this.fontFamily = 'Verdana',
    this.headerFontSize = 32,
    this.normalFontSize = 24,
    this.itemFontSize = 28,
    this.footerFontSize = 24,
    this.textColor = Colors.black,
  });
}

/// Mock order item for KOT printing
class KOTOrderItem {
  final String productName;
  final String? variationName;
  final String categoryName;
  final double quantity;
  final String? specialInstructions;

  KOTOrderItem({
    required this.productName,
    this.variationName,
    required this.categoryName,
    required this.quantity,
    this.specialInstructions,
  });
}

/// Mock order for KOT printing
class KOTOrder {
  final String orderNumber;
  final String? tableNumber;
  final String? customerName;
  final DateTime orderTime;
  final List<KOTOrderItem> items;
  final String businessName;
  final String? employeeName;
  final String orderType;

  KOTOrder({
    required this.orderNumber,
    this.tableNumber,
    this.customerName,
    required this.orderTime,
    required this.items,
    required this.businessName,
    this.employeeName,
    this.orderType = 'Dine In',
  });
}

/// Widget for rendering KOT that will be converted to image for printing
class KOTPrintWidget extends StatelessWidget {
  final KOTOrder order;
  final KotStation station;
  final List<KOTOrderItem> items;
  final bool isRunning;
  final KOTStyle style;

  const KOTPrintWidget({
    super.key,
    required this.order,
    required this.station,
    required this.items,
    this.isRunning = false,
    this.style = const KOTStyle(),
  });

  TextStyle _getTextStyle(
    double fontSize, {
    FontWeight weight = FontWeight.normal,
    Color? color,
    bool italic = false,
  }) {
    return TextStyle(
      fontFamily: style.fontFamily,
      fontSize: fontSize,
      fontWeight: weight,
      color: color ?? style.textColor,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      height: 1.2,
    );
  }

  IconData _getOrderTypeIcon() {
    switch (order.orderType.toLowerCase()) {
      case 'dine in':
      case 'table':
        return Icons.table_restaurant;
      case 'takeaway':
      case 'parcel':
        return Icons.shopping_bag_outlined;
      case 'delivery':
        return Icons.delivery_dining_outlined;
      default:
        return Icons.receipt;
    }
  }

  IconData _getOrderStatusIcon() {
    return isRunning ? Icons.update : Icons.fiber_new_outlined;
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Business name and station
        Text(
          order.businessName.toUpperCase(),
          style: _getTextStyle(style.headerFontSize, weight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          station.name.toUpperCase(),
          style: _getTextStyle(style.normalFontSize + 4, weight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        
        // Order info with icons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              _getOrderStatusIcon(),
              color: Colors.black,
              size: style.itemFontSize * 2,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Order: ${order.orderNumber}',
                    style: _getTextStyle(style.headerFontSize - 4, weight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd/MM/yy HH:mm').format(order.orderTime),
                    style: _getTextStyle(style.normalFontSize),
                  ),
                ],
              ),
            ),
            Icon(
              _getOrderTypeIcon(),
              color: Colors.black,
              size: style.itemFontSize * 2,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Table/Order Type
        if (order.tableNumber != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.table_restaurant, size: style.normalFontSize * 1.2),
              const SizedBox(width: 8),
              Text(
                'Table: ${order.tableNumber}',
                style: _getTextStyle(style.itemFontSize, weight: FontWeight.bold),
              ),
            ],
          ),
        ] else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_getOrderTypeIcon(), size: style.normalFontSize * 1.2),
              const SizedBox(width: 8),
              Text(
                order.orderType.toUpperCase(),
                style: _getTextStyle(style.itemFontSize, weight: FontWeight.bold),
              ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        
        // Customer info if available
        if (order.customerName != null && order.customerName!.isNotEmpty) ...[
          Row(
            children: [
              Icon(Icons.person_outline, size: style.normalFontSize),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Customer: ${order.customerName}',
                  style: _getTextStyle(style.normalFontSize),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        
        // Employee/Waiter info
        if (order.employeeName != null && order.employeeName!.isNotEmpty) ...[
          Row(
            children: [
              Icon(Icons.badge_outlined, size: style.normalFontSize),
              const SizedBox(width: 4),
              Text(
                'Waiter: ${order.employeeName}',
                style: _getTextStyle(style.normalFontSize),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildItemsList() {
    return Column(
      children: [
        // Items header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 2),
              bottom: BorderSide(width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'QTY',
                  style: _getTextStyle(style.itemFontSize, weight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 10,
                child: Text(
                  'ITEM',
                  style: _getTextStyle(style.itemFontSize, weight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        
        // Items list
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: index.isEven ? Colors.grey.shade100 : Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      alignment: Alignment.center,
                      child: Text(
                        item.quantity.toStringAsFixed(
                          item.quantity == item.quantity.roundToDouble() ? 0 : 1
                        ),
                        style: _getTextStyle(
                          style.itemFontSize + 2,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName.toUpperCase(),
                            style: _getTextStyle(
                              style.itemFontSize,
                              weight: FontWeight.bold,
                            ),
                          ),
                          if (item.variationName != null && 
                              item.variationName!.isNotEmpty &&
                              item.variationName!.toLowerCase() != 'default') ...[
                            Text(
                              '  ${item.variationName}',
                              style: _getTextStyle(
                                style.normalFontSize,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                // Special instructions
                if (item.specialInstructions != null && 
                    item.specialInstructions!.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 68, top: 4),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.note, size: style.normalFontSize - 4),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.specialInstructions!,
                              style: _getTextStyle(
                                style.normalFontSize - 2,
                                italic: true,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFooter() {
    // Generate a token number from order number
    final token = order.orderNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final tokenNumber = token.length > 4 
        ? token.substring(token.length - 4) 
        : token.padLeft(4, '0');
    
    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Token: $tokenNumber',
                style: _getTextStyle(style.footerFontSize + 4, weight: FontWeight.bold),
              ),
              if (isRunning)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'RUNNING',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: style.footerFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 576, // Fixed width for 80mm thermal printer
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildOrderInfo(),
          const SizedBox(height: 12),
          _buildItemsList(),
          _buildFooter(),
        ],
      ),
    );
  }
}
