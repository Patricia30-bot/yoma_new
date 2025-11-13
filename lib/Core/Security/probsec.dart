// lib/core/security/probsec.dart
//
// ProbSec — Módulo Base de Proteção e Segurança do YOMA
// Desenvolvido por Patricia Giorgetto ©2025
//
// Funções principais:
// - Monitoramento contínuo de risco
// - Acionamento de alerta automático
// - Compatível com Android e iOS
// - Envio de alertas via Firebase
// - Sistema seguro e discreto (sem logs locais)

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

/// Classe principal do ProbSec — núcleo de segurança do YOMA
class ProbSec {
  static final ProbSec _instance = ProbSec._internal();
  factory ProbSec() => _instance;
  ProbSec._internal();

  /// Controle interno de status
  bool _isMonitoring = false;
  StreamSubscription<Position>? _locationSubscription;

  /// Firebase e UID do usuário
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// Inicializa o sistema de segurança
  Future<void> startMonitoring() async {
    if (_isMonitoring) return;
    _isMonitoring = true;

    debugPrint('🛡️ ProbSec iniciado — monitoramento ativo.');

    try {
      // Permissões de localização
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        debugPrint('⚠️ Localização não permitida. ProbSec continuará sem rastreamento.');
      } else {
        _locationSubscription =
            Geolocator.getPositionStream(
  locationSettings: const LocationSettings(
    distanceFilter: 10,
  ),
).listen((pos) {

          _updateLocation(pos);
        });
      }
    } catch (e) {
      debugPrint('Erro ao iniciar localização: $e');
    }
  }

  /// Encerra o monitoramento
  void stopMonitoring() {
    _isMonitoring = false;
    _locationSubscription?.cancel();
    debugPrint('🛑 ProbSec desativado.');
  }

  /// Atualiza a localização no Firestore em tempo real
  Future<void> _updateLocation(Position position) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('yoma_alerts').doc(user.uid).set({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'safe',
      }, SetOptions(merge: true));

      debugPrint('📍 Localização atualizada com sucesso.');
    } catch (e) {
      debugPrint('Erro ao atualizar localização: $e');
    }
  }

  /// Envia um alerta manual de emergência
  Future<void> sendEmergencyAlert({String? customMessage}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final pos = await Geolocator.getCurrentPosition();

      await _firestore.collection('yoma_alerts').add({
        'user_id': user.uid,
        'latitude': pos.latitude,
        'longitude': pos.longitude,
        'timestamp': FieldValue.serverTimestamp(),
        'message': customMessage ?? '⚠️ Alerta manual enviado pelo ProbSec.',
        'status': 'danger',
      });

      debugPrint('🚨 Alerta enviado com sucesso.');
    } catch (e) {
      debugPrint('Erro ao enviar alerta: $e');
    }
  }

  /// Retorna o status atual do sistema
  bool get isMonitoring => _isMonitoring;
}
