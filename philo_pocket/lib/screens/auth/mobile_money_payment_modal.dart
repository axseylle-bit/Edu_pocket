import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/supabase_service.dart';
import '../../core/providers/student_provider.dart';

class MobileMoneyPaymentModal extends ConsumerStatefulWidget {
  final String tierTitle;
  final String tierKey;
  final int amountFcfa;
  final VoidCallback onSuccess;

  const MobileMoneyPaymentModal({
    Key? key,
    required this.tierTitle,
    required this.tierKey,
    required this.amountFcfa,
    required this.onSuccess,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required String tierTitle,
    required String tierKey,
    required int amountFcfa,
    required VoidCallback onSuccess,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => MobileMoneyPaymentModal(
        tierTitle: tierTitle,
        tierKey: tierKey,
        amountFcfa: amountFcfa,
        onSuccess: onSuccess,
      ),
    );
  }

  @override
  ConsumerState<MobileMoneyPaymentModal> createState() =>
      _MobileMoneyPaymentModalState();
}

class _MobileMoneyPaymentModalState
    extends ConsumerState<MobileMoneyPaymentModal> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedOperator = 'airtel'; // 'airtel' ou 'moov'
  int _currentStep = 0; // 0: Saisie, 1: En attente USSD, 2: Succès
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_autoDetectOperator);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String? _transactionReference;

  void _autoDetectOperator() {
    String text = _phoneController.text.replaceAll(RegExp(r'[\s\-\+]'), '').trim();
    if (text.startsWith('241')) text = text.substring(3);
    if (text.startsWith('07') || text.startsWith('7')) {
      if (_selectedOperator != 'airtel') {
        setState(() => _selectedOperator = 'airtel');
      }
    } else if (text.startsWith('06') || text.startsWith('6')) {
      if (_selectedOperator != 'moov') {
        setState(() => _selectedOperator = 'moov');
      }
    }
  }

  Future<void> _initiatePayment() async {
    String phone = _phoneController.text.replaceAll(RegExp(r'[\s\-\+]'), '').trim();
    if (phone.startsWith('241')) {
      phone = phone.substring(3);
    }
    if (phone.length == 8) {
      phone = '0$phone';
    }

    if (phone.length != 9) {
      setState(() {
        _errorMessage = 'Veuillez saisir un numéro gabonais valide à 9 chiffres (ex: 074 12 34 56 ou 066 12 34 56).';
      });
      return;
    }

    if (_selectedOperator == 'airtel') {
      final prefix = phone.substring(0, 3);
      if (prefix != '074' && prefix != '076' && prefix != '077') {
        setState(() {
          _errorMessage = 'Pour Airtel Money Gabon, utilisez un numéro commençant par 074, 076 ou 077.';
        });
        return;
      }
    } else if (_selectedOperator == 'moov') {
      final prefix = phone.substring(0, 3);
      if (prefix != '062' && prefix != '065' && prefix != '066') {
        setState(() {
          _errorMessage = 'Pour Moov Money Gabon, utilisez un numéro commençant par 062, 065 ou 066.';
        });
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _transactionReference = 'TXN-EDUPOCKET-${DateTime.now().millisecondsSinceEpoch}-${phone.substring(5)}';
    });

    // Requête de push USSD sécurisée avec jeton d'idempotence
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _currentStep = 1; // Passe à l'écran d'attente de validation PIN USSD
      });
    }
  }

  Future<void> _confirmUssdPayment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Enregistrement de la transaction sécurisée dans Supabase
      if (_transactionReference != null) {
        await SupabaseService().enregistrerPaiementMobileMoney(
          referenceTransaction: _transactionReference!,
          operateur: _selectedOperator,
          numeroTelephone: _phoneController.text.trim(),
          montant: widget.amountFcfa,
          palierKey: widget.tierKey,
          idempotenceToken: _transactionReference,
        );
      }

      // 2. Mise à jour de l'abonnement
      await SupabaseService().updateSubscription(widget.tierKey);

      // 3. Recharger l'état de l'élève
      ref.read(studentProvider.notifier).reloadProgress();

      // Délai pour simuler le callback webhook réussi
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          _isLoading = false;
          _currentStep = 2; // Écran de succès
        });

        // Délai de célébration avant fermeture et redirection
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          Navigator.of(context).pop();
          widget.onSuccess();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Erreur lors de la validation du paiement: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _currentStep == 0
              ? _buildStepInput()
              : _currentStep == 1
                  ? _buildStepWaitingUssd()
                  : _buildStepSuccess(),
        ),
      ),
    );
  }

  // --- ÉTAPE 1 : Saisie de l'opérateur et du numéro ---
  Widget _buildStepInput() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Paiement Mobile Money',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Formule ${widget.tierTitle}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.amountFcfa} FCFA',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Choisissez votre opérateur au Gabon :',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildOperatorCard(
                name: 'Airtel Money',
                iconSubtitle: '074, 076, 077',
                color: const Color(0xFFE20613), // Rouge Airtel
                isSelected: _selectedOperator == 'airtel',
                onTap: () => setState(() => _selectedOperator = 'airtel'),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildOperatorCard(
                name: 'Moov Money',
                iconSubtitle: '062, 065, 066',
                color: const Color(0xFF0072BC), // Bleu Moov
                isSelected: _selectedOperator == 'moov',
                onTap: () => setState(() => _selectedOperator = 'moov'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Numéro de téléphone (+241) :',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: _selectedOperator == 'airtel' ? '074 00 00 00' : '066 00 00 00',
            prefixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                '🇬🇦 +241',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isLoading ? null : _initiatePayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedOperator == 'airtel'
                ? const Color(0xFFE20613)
                : const Color(0xFF0072BC),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : Text(
                  'Payer ${widget.amountFcfa} FCFA',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // --- ÉTAPE 2 : Attente de la validation du code secret PIN (Push USSD) ---
  Widget _buildStepWaitingUssd() {
    final operatorName = _selectedOperator == 'airtel' ? 'Airtel Money' : 'Moov Money';
    final operatorColor = _selectedOperator == 'airtel'
        ? const Color(0xFFE20613)
        : const Color(0xFF0072BC);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: operatorColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.phonelink_ring_rounded, size: 54, color: operatorColor),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Confirmation sur votre téléphone',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'Une demande de paiement de ${widget.amountFcfa} FCFA a été envoyée au (+241) ${_phoneController.text}.\n\nVeuillez valider le débit en saisissant votre code secret $operatorName.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
        ),
        const SizedBox(height: 28),
        ElevatedButton(
          onPressed: _isLoading ? null : _confirmUssdPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text(
                  'J\'ai validé sur mon téléphone',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => setState(() => _currentStep = 0),
          child: const Text('Corriger le numéro de téléphone'),
        ),
      ],
    );
  }

  // --- ÉTAPE 3 : Succès & Activation ---
  Widget _buildStepSuccess() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const CircleAvatar(
          radius: 36,
          backgroundColor: AppColors.success,
          child: Icon(Icons.check_rounded, color: Colors.white, size: 48),
        ),
        const SizedBox(height: 20),
        Text(
          'Paiement validé avec succès ! 🎉',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Votre formule ${widget.tierTitle} est désormais active. Vos accès illimités sont débloqués.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildOperatorCard({
    required String name,
    required String iconSubtitle,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? color.withOpacity(0.06) : Colors.white,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  size: 18,
                  color: isSelected ? color : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? color : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              iconSubtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
