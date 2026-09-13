import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';
import '../promote/ad_token_service.dart';

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
    return AdTokenService.sortFeaturedFirst(List<Map<String, dynamic>>.from(rows as List));
  }

  static Future<String> postJob({
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
    final row = await _client.from('job_postings').insert({
      'poster_id': userId,
      'title': title,
      'category': category,
      'employment_type': employmentType,
      'salary_min': salaryMin,
      'salary_max': salaryMax,
      'salary_negotiable': salaryNegotiable,
      'requirements': requirements,
    }).select('id').single();
    return row['id'] as String;
  }

  static Future<void> apply({
    required String jobId,
    required String? introMessage,
  }) async {
    if (AuthService.currentUser == null) throw Exception('يجب تسجيل الدخول أولاً');
    await _client.rpc('apply_to_job', params: {'p_job_id': jobId, 'p_intro_message': introMessage});
  }

  /// Jobs the current user has posted, newest first — the entry point
  /// into reviewing real applicants.
  static Future<List<Map<String, dynamic>>> fetchMyPostedJobs() async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return [];
    final rows = await _client.from('job_postings').select().eq('poster_id', userId).order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// Real applicants to [jobId] — only returns rows if the caller is
  /// that job's poster (see "job_applications: poster views applicants
  /// to own jobs" RLS policy).
  static Future<List<Map<String, dynamic>>> fetchApplicants(String jobId) async {
    final rows = await _client
        .from('job_applications')
        .select('*, applicant:profiles(full_name, phone, is_verified)')
        .eq('job_id', jobId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// Moves an application through the real status pipeline
  /// (shortlisted/interview/offered/rejected/hired) — only succeeds
  /// server-side if the caller posted that job, and notifies the
  /// applicant for real.
  static Future<void> reviewApplication({required String applicationId, required String status}) async {
    await _client.rpc('review_job_application', params: {'p_application_id': applicationId, 'p_status': status});
  }
}
