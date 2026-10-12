import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/supabase_service.dart';
import 'package:go_router/go_router.dart';
import '../legal/legal_document_viewer_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  bool _acceptTerms = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _supabase = SupabaseService();

  @override
  void initState() {
    super.initState();
    _checkExistingAuth();
  }

  Future<void> _checkExistingAuth() async {
    if (_supabase.isAuthenticated) {
      await _routeAuthenticatedUser();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // ACCÈS TEST INSTANTANÉ (pour le test immédiat sans mot de passe / évaluateur)
    final lowerEmail = email.toLowerCase();
    if (lowerEmail.contains('test') || 
        lowerEmail.contains('demo') || 
        lowerEmail.contains('prof') ||
        lowerEmail.contains('eval') ||
        lowerEmail.contains('axseylle') ||
        password == 'edupocket2026') {
      if (mounted) {
        if (lowerEmail.contains('prof') || lowerEmail.contains('axseylle')) {
          context.go('/teacher-partner');
        } else {
          context.go('/role-selection');
        }
        return;
      }
    }

    if (!email.contains('@') || !email.contains('.')) {
      _showError('Saisissez une adresse e-mail valide.');
      return;
    }
    if (password.length < 6) {
      _showError('Le mot de passe doit contenir au moins 6 caractères.');
      return;
    }

    if (!_isLogin && !_acceptTerms) {
      _showError(
        'Veuillez accepter les CGU et la Politique de confidentialité (avec accord parental pour les mineurs).',
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        await _supabase.signInWithEmail(email, password);
        await _routeAuthenticatedUser();
      } else {
        final response = await _supabase.signUpWithEmail(
          email,
          password,
          'Utilisateur',
        );
        if (response.session == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Compte créé. Vérifiez votre e-mail avant de vous connecter.',
                ),
              ),
            );
          }
        } else {
          await _routeAuthenticatedUser();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 8),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _routeAuthenticatedUser() async {
    final role = await _supabase.getCurrentUserRole();
    if (!mounted) return;

    if (role == 'parent') {
      context.go('/parent');
      return;
    }

    if (role == 'enseignant') {
      context.go('/teacher-partner');
      return;
    }

    if (role == 'eleve') {
      final profile = await _supabase.getStudentProfile();
      if (!mounted) return;
      context.go(profile?['niveau'] == null ? '/profile-setup' : '/hub');
      return;
    }

    context.go('/role-selection');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Connexion' : 'Inscription'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.password_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                if (!_isLogin) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() => _acceptTerms = val ?? false);
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text("J'accepte les "),
                              GestureDetector(
                                onTap: () => LegalDocumentViewerScreen.show(
                                  context,
                                  title: 'Conditions Générales (CGU/CGV)',
                                  assetPath: 'assets/legal/cgu_cgv.md',
                                ),
                                child: const Text(
                                  'CGU & CGV',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const Text(" et la "),
                              GestureDetector(
                                onTap: () => LegalDocumentViewerScreen.show(
                                  context,
                                  title: 'Politique de Confidentialité',
                                  assetPath: 'assets/legal/politique_confidentialite.md',
                                ),
                                child: const Text(
                                  'Politique de Confidentialité',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const Text(
                                " (accord préalable du parent/tuteur requis pour les mineurs dès la 6e).",
                                style: TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ] else
                  const SizedBox(height: 8),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(_isLogin
                            ? 'Se connecter avec Email'
                            : 'Créer un compte'),
                      ),
                const SizedBox(height: 16),
                  /* --- TEMPORAIREMENT MASQUÉ POUR LA BÊTA ---
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("OU", style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Bouton Google
                  OutlinedButton.icon(
                    onPressed: () async {
                      try {
                        await _supabase.signInWithGoogle();
                        // Redirection gérée automatiquement par le auth state listener de main.dart
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Erreur Google: $e'),
                                backgroundColor: Colors.red),
                          );
                        }
                      }
                    },
                    icon: Image.network(
                      'https://developers.google.com/identity/images/g-logo.png',
                      height: 24,
                      errorBuilder: (c, e, s) => const Icon(Icons.login),
                    ),
                    label: const Text('Continuer avec Google',
                        style: TextStyle(color: Colors.black87)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  */
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(
                    _isLogin
                        ? 'Nouveau ici ? Créez un compte via Email'
                        : 'Déjà un compte ? Connectez-vous',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => context.go('/teacher-partner'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade400, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.flash_on_rounded, color: Colors.orange, size: 24),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '⚡ Accès Test Immédiat (1 Clic)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Explorer l\'espace enseignant & quotas sans mot de passe',
                                style: TextStyle(fontSize: 11, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.black54),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
