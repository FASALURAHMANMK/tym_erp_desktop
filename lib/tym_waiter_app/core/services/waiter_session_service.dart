import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service to manage waiter session persistence
class WaiterSessionService {
  static const String _waiterSessionKey = 'waiter_session';
  static const String _waiterEmployeeKey = 'waiter_employee';
  static const String _isWaiterAuthenticatedKey = 'is_waiter_authenticated';

  /// Save waiter session data
  static Future<void> saveWaiterSession({
    required String employeeId,
    required String businessId,
    required String locationId,
    required DateTime shiftStartTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    final sessionData = {
      'employeeId': employeeId,
      'businessId': businessId,
      'locationId': locationId,
      'shiftStartTime': shiftStartTime.toIso8601String(),
    };
    
    await prefs.setString(_waiterSessionKey, json.encode(sessionData));
    await prefs.setBool(_isWaiterAuthenticatedKey, true);
  }

  /// Get saved waiter session data
  static Future<Map<String, dynamic>?> getWaiterSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionJson = prefs.getString(_waiterSessionKey);
    
    if (sessionJson != null) {
      return json.decode(sessionJson);
    }
    
    return null;
  }

  /// Save employee data
  static Future<void> saveEmployeeData(Map<String, dynamic> employeeData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_waiterEmployeeKey, json.encode(employeeData));
  }

  /// Get saved employee data
  static Future<Map<String, dynamic>?> getEmployeeData() async {
    final prefs = await SharedPreferences.getInstance();
    final employeeJson = prefs.getString(_waiterEmployeeKey);
    
    if (employeeJson != null) {
      return json.decode(employeeJson);
    }
    
    return null;
  }

  /// Check if waiter is authenticated
  static Future<bool> isWaiterAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isWaiterAuthenticatedKey) ?? false;
  }

  /// Clear waiter session (logout)
  static Future<void> clearWaiterSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_waiterSessionKey);
    await prefs.remove(_waiterEmployeeKey);
    await prefs.setBool(_isWaiterAuthenticatedKey, false);
  }

  /// End current shift (but keep authenticated)
  static Future<void> endShift() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionJson = prefs.getString(_waiterSessionKey);
    
    if (sessionJson != null) {
      final sessionData = json.decode(sessionJson);
      sessionData['shiftEndTime'] = DateTime.now().toIso8601String();
      await prefs.setString(_waiterSessionKey, json.encode(sessionData));
    }
  }

  /// Check if there's an active shift
  static Future<bool> hasActiveShift() async {
    final session = await getWaiterSession();
    if (session != null) {
      return session['shiftEndTime'] == null;
    }
    return false;
  }

  /// Get shift duration
  static Future<Duration?> getShiftDuration() async {
    final session = await getWaiterSession();
    if (session != null) {
      final startTime = DateTime.parse(session['shiftStartTime']);
      final endTime = session['shiftEndTime'] != null 
          ? DateTime.parse(session['shiftEndTime'])
          : DateTime.now();
      return endTime.difference(startTime);
    }
    return null;
  }
}