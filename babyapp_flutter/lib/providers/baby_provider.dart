import 'package:flutter/material.dart';
import '../models/baby_model.dart';
import '../services/baby_service.dart';

class BabyProvider with ChangeNotifier {
  List<Baby> _babies = [];
  Baby? _selectedBaby;
  bool _isLoading = false;
  String? _error;

  List<Baby> get babies => _babies;
  Baby? get selectedBaby => _selectedBaby;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadBabies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _babies = await BabyService.getBabies();
      if (_babies.isNotEmpty && _selectedBaby == null) {
        _selectedBaby = _babies.first;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectBaby(Baby baby) {
    _selectedBaby = baby;
    notifyListeners();
  }

  Future<bool> addBaby(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final baby = await BabyService.createBaby(data);
      _babies.add(baby);
      _selectedBaby = baby;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBaby(int id, Map<String, dynamic> data) async {
    try {
      final updatedBaby = await BabyService.updateBaby(id, data);
      final index = _babies.indexWhere((b) => b.id == id);
      if (index != -1) {
        _babies[index] = updatedBaby;
        if (_selectedBaby?.id == id) {
          _selectedBaby = updatedBaby;
        }
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  Future<bool> deleteBaby(int id) async {
    try {
      await BabyService.deleteBaby(id);
      _babies.removeWhere((b) => b.id == id);
      if (_selectedBaby?.id == id) {
        _selectedBaby = _babies.isNotEmpty ? _babies.first : null;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }
}