import 'api_service.dart';
import '../models/appointment_model.dart';

class AppointmentService {
  static Future<List<Appointment>> getAppointments(int babyId) async {
    final response = await ApiService.get('babies/$babyId/appointments');
    final List<dynamic> data =
    response is List ? List<dynamic>.from(response as Iterable<dynamic>) : <dynamic>[];
    return data.map((json) => Appointment.fromJson(json)).toList();
  }

  static Future<Appointment> createAppointment(
      int babyId,
      Map<String, dynamic> data,
      ) async {
    final response = await ApiService.post('babies/$babyId/appointments', data);
    return Appointment.fromJson(response['appointment']);
  }

  static Future<void> updateAppointment(
      int id,
      Map<String, dynamic> data,
      ) async {
    await ApiService.put('appointments/$id', data);
  }

  static Future<void> deleteAppointment(int id) async {
    await ApiService.delete('appointments/$id');
  }
}