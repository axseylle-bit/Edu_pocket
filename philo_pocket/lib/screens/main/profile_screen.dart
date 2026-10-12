import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/providers/student_provider.dart';
import '../../core/services/supabase_service.dart';
import '../legal/legal_document_viewer_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final service = SupabaseService();
  String? invitationCode;
  bool isLoadingCode = true;

  @override
  void initState() {
    super.initState();
    _loadCode();
  }

  Future<void> _loadCode() async {
    final code = await service.getOrCreateStudentInvitationCode();
    if (mounted) {
      setState(() {
        invitationCode = code;
        isLoadingCode = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = service.currentUser?.userMetadata?['nom'] ?? 'Élève';
    final email = service.currentUser?.email ?? 'Compte non connecté';
    final studentState = ref.watch(studentProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: AppColors.primary,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'E',
              style: const TextStyle(color: Colors.white, fontSize: 32),
            ),
          ),
          const SizedBox(height: 16),
          Text(name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(email,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 28),
          
          // Section Code Invitation Parent
          Card(
            color: AppColors.primary.withOpacity(0.1),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Code de liaison Parent',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Donnez ce code à vos parents pour qu\'ils puissent suivre votre progression.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  if (isLoadingCode)
                    const CircularProgressIndicator()
                  else if (invitationCode != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          invitationCode!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20, color: AppColors.primary),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: invitationCode!));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Code copié !')),
                            );
                          },
                        )
                      ],
                    )
                  else
                    const Text('Erreur lors du chargement du code', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),

          // Carte Académie EVA (Excelle Virtual Academy)
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.workspace_premium_rounded,
                                color: Colors.amber, size: 24),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Académie EVA',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                'Excelle Virtual Academy',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${studentState.creditsEva} Crédits',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Grade : ${studentState.statutEva}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Série active : ${studentState.streak} j 🔥',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 12),
                  const Text(
                    'Badges & Distinctions de Mérite :',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildEvaBadgeChip('🌱 Initié Certifié', Colors.green),
                      _buildEvaBadgeChip('📖 Assiduité IPN', Colors.blue),
                      _buildEvaBadgeChip('🎯 Résolution QCM', Colors.purple),
                      if (studentState.creditsEva >= 200)
                        _buildEvaBadgeChip('⭐ Disciple d\'Honneur', Colors.amber),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.family_restroom_rounded,
                  color: AppColors.primary),
              title: const Text('Espace parent'),
              subtitle: const Text('Suivre la progression d’un enfant lié'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
              onTap: () => context.push('/parent'),
            ),
          ),
          const SizedBox(height: 24),

          // Section Informations Légales & Conformité APDPVP
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Text(
              'Informations Légales & Éthique',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textDark,
              ),
            ),
          ),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.auto_awesome_rounded, color: Colors.amber),
                  title: const Text('Manifeste & Vision EduPocket'),
                  subtitle: const Text('Démocratiser le savoir & valoriser l\'enseignant'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () => LegalDocumentViewerScreen.show(
                    context,
                    title: 'Manifeste & Vision Fondatrice',
                    assetPath: 'assets/legal/manifeste_vision.md',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.gavel_rounded, color: AppColors.primary),
                  title: const Text('Mentions Légales & Charte Éthique'),
                  subtitle: const Text('Éditeur, hébergement et charte IA ALECKSE'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () => LegalDocumentViewerScreen.show(
                    context,
                    title: 'Mentions Légales & Charte Éthique',
                    assetPath: 'assets/legal/mentions_legales.md',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
                  title: const Text('Politique de Confidentialité'),
                  subtitle: const Text('Protection des mineurs & conformité APDPVP'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () => LegalDocumentViewerScreen.show(
                    context,
                    title: 'Politique de Confidentialité',
                    assetPath: 'assets/legal/politique_confidentialite.md',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined, color: AppColors.primary),
                  title: const Text('Conditions Générales (CGU / CGV)'),
                  subtitle: const Text('Modalités d\'accès et règles de la plateforme'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () => LegalDocumentViewerScreen.show(
                    context,
                    title: 'Conditions Générales (CGU / CGV)',
                    assetPath: 'assets/legal/cgu_cgv.md',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),
          OutlinedButton.icon(
            onPressed: () async {
              await service.signOut();
              if (context.mounted) context.go('/welcome');
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Se déconnecter'),
          ),

          const SizedBox(height: 12),
          // Bouton de suppression de compte (Exigence obligatoire Google Play & APDPVP)
          TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogCtx) => AlertDialog(
                  title: const Text(
                    'Supprimer mon compte ?',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  content: const Text(
                    'Cette opération est irréversible. Vos données personnelles, vos progressions et vos liaisons seront définitivement effacées conformément à la réglementation APDPVP et aux règles de Google Play.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogCtx).pop(),
                      child: const Text('Annuler'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        Navigator.of(dialogCtx).pop();
                        final success = await service.deleteAccount();
                        if (context.mounted) {
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Compte et données supprimés.')),
                            );
                            context.go('/welcome');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Erreur lors de la suppression du compte.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Supprimer définitivement'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete_forever_rounded, color: Colors.red, size: 20),
            label: const Text(
              'Supprimer mon compte et mes données',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEvaBadgeChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

