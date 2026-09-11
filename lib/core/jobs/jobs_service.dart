import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';

/// Real job postings + applications — see backend/migrations/0010_jobs.sql.
class JobsService {
  JobsService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetchActiveJobs() async {
    final rows = await _client
        .from('job_postings')
        .select('*, poster:profiles(full_name, is_verified)')
        .eq('is_active', true)
        .order('created_at', ascending: false)
        .limit(30);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> postJob({
    required String title,
    required String category,
    required String employmentType,
    required double? salaryMin,
    required double? salaryMax,
    required bool salaryNegotiable,
    required String requirements,
  }) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');
    await _client.from('job_postings').insert({
      'poster_id': userId,
      'title': title,
      'category': category,
      'employment_type': employmentType,
      'salary_min': salaryMin,
      'salary_max': salaryMax,
      'salary_negotiable': salaryNegotiable,
      'requirements': requirements,
    });
  }

  static Future<void> apply({
    required String jobId,
    required String? introMessage,
  }) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');
    await _client.from('job_applications').insert({
      'job_id': jobId,
      'applicant_id': userId,
      if (introMessage != null && introMessage.trim().isNotEmpty) 'intro_message': introMessage.trim(),
    });
  }
}
