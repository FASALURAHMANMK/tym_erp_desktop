import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/business_model.dart';

class BusinessService {
  static final _supabase = Supabase.instance.client;

  /// Custom exception for business-related errors
  static BusinessException _handleError(dynamic error) {
    if (error is PostgrestException) {
      // Handle specific PostgreSQL errors
      if (error.code == '23505') {
        if (error.message.contains('businesses_name_owner_unique')) {
          return BusinessException('A business with this name already exists.');
        }
      }
      return BusinessException('Database error: ${error.message}');
    } else if (error is Exception) {
      return BusinessException(error.toString());
    } else {
      return BusinessException('An unexpected error occurred: $error');
    }
  }

  /// Get all businesses associated with the current user
  static Future<List<BusinessModel>> getUserBusinesses(String userId) async {
    try {
      final response = await _supabase
          .from('businesses')
          .select()
          .eq('owner_id', userId)
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((business) => BusinessModel.fromJson(business))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Create a new business
  static Future<BusinessModel> createBusiness({
    required String name,
    required BusinessType businessType,
    required String ownerId,
    String? description,
    String? address,
    String? phone,
    String? email,
    String? website,
    String? taxNumber,
    String? registrationNumber,
  }) async {
    try {
      final now = DateTime.now();
      final businessData = {
        'name': name,
        'business_type': businessType.name,
        'owner_id': ownerId,
        'description': description,
        'address': address,
        'phone': phone,
        'email': email,
        'website': website,
        'tax_number': taxNumber,
        'registration_number': registrationNumber,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
        'is_active': true,
      };

      final response = await _supabase
          .from('businesses')
          .insert(businessData)
          .select()
          .single();

      return BusinessModel.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Update an existing business
  static Future<BusinessModel> updateBusiness(BusinessModel business) async {
    try {
      final updatedData = business.copyWith(
        updatedAt: DateTime.now(),
      ).toJson();

      final response = await _supabase
          .from('businesses')
          .update(updatedData)
          .eq('id', business.id)
          .select()
          .single();

      return BusinessModel.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a specific business by ID
  static Future<BusinessModel?> getBusinessById(String businessId) async {
    try {
      final response = await _supabase
          .from('businesses')
          .select()
          .eq('id', businessId)
          .eq('is_active', true)
          .maybeSingle();

      if (response == null) return null;
      return BusinessModel.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Soft delete a business (set is_active to false)
  static Future<void> deleteBusiness(String businessId) async {
    try {
      await _supabase
          .from('businesses')
          .update({
            'is_active': false,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', businessId);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Check if a business name is already taken by the user
  static Future<bool> isBusinessNameTaken(String name, String userId) async {
    try {
      final response = await _supabase
          .from('businesses')
          .select('id')
          .eq('name', name)
          .eq('owner_id', userId)
          .eq('is_active', true)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw _handleError(e);
    }
  }
}

/// Custom exception class for business operations
class BusinessException implements Exception {
  final String message;
  const BusinessException(this.message);

  @override
  String toString() => message;
}