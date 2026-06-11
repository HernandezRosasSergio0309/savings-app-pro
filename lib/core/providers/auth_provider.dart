import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ==========================================
// 1. MODELO DE USUARIO
// ==========================================
class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl; // --- NUEVO: Soporte para foto de perfil ---

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });
}

// ==========================================
// 2. ESTADO DE AUTENTICACIÓN
// ==========================================
class AuthState {
  final bool isLoading;
  final User? user;
  final String? errorMessage;

  AuthState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// ==========================================
// 3. NOTIFIER (ViewModel)
// ==========================================
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    _check_current_session();
  }

  final _supabase = Supabase.instance.client;

  // --- ACTUALIZAR ESTADO LOCAL AL INSTANTE ---
  void updateUsernameInState(String newName) {
    if (state.user != null) {
      state = state.copyWith(
        user: User(
          id: state.user!.id,
          name: newName,
          email: state.user!.email,
          avatarUrl: state.user!.avatarUrl,
        ),
      );
    }
  }

  // --- NUEVO: ACTUALIZAR FOTO AL INSTANTE ---
  void updateAvatarInState(String? newAvatarUrl) {
    if (state.user != null) {
      state = state.copyWith(
        user: User(
          id: state.user!.id,
          name: state.user!.name,
          email: state.user!.email,
          avatarUrl: newAvatarUrl,
        ),
      );
    }
  }

  // --- VERIFICAR SESIÓN (Sincronizado con DB) ---
  Future<void> _check_current_session() async {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      final userData = session.user;

      // Buscamos el nombre y la foto real en la tabla profiles
      String finalName = 'Usuario';
      String? finalAvatarUrl;

      try {
        final profile = await _supabase
            .from('profiles')
            .select(
                'username, avatar_url') // --- NUEVO: Pedimos el avatar_url ---
            .eq('id', userData.id)
            .single();

        finalName = profile['username'] ?? 'Usuario';
        finalAvatarUrl = profile['avatar_url'];
      } catch (e) {
        // Si no hay perfil aún, usamos el metadata
        finalName = userData.userMetadata?['username'] ?? 'Usuario';
        finalAvatarUrl = userData.userMetadata?['avatar_url'];
      }

      state = state.copyWith(
        user: User(
          id: userData.id,
          name: finalName,
          email: userData.email ?? '',
          avatarUrl: finalAvatarUrl,
        ),
      );
    }
  }

  // --- INICIAR SESIÓN ---
  Future<bool> login(String email, String password, String errorMsg) async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Traemos el nombre y la foto de la DB inmediatamente
        final profile = await _supabase
            .from('profiles')
            .select(
                'username, avatar_url') // --- NUEVO: Pedimos el avatar_url ---
            .eq('id', response.user!.id)
            .single();

        final loggedUser = User(
          id: response.user!.id,
          name: profile['username'] ?? 'Usuario',
          email: response.user!.email ?? email,
          avatarUrl: profile['avatar_url'],
        );

        state = state.copyWith(
            isLoading: false, user: loggedUser, errorMessage: '');
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: errorMsg);
      return false;
    }
  }

  // --- REGISTRARSE ---
  Future<bool> register(
      String username, String email, String password, String errorMsg) async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final response = await _supabase.auth.signUp(
          email: email, password: password, data: {'username': username});

      if (response.user != null) {
        final newUser = User(
          id: response.user!.id,
          name: username,
          email: email,
          avatarUrl: null, // Por defecto al registrarse no hay foto
        );
        state =
            state.copyWith(isLoading: false, user: newUser, errorMessage: '');
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: errorMsg);
      return false;
    }
  }

  // --- INICIAR SESIÓN CON GOOGLE ---
  Future<bool> login_with_google(String errorMsg) async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      const redirectUrl = kIsWeb
          ? 'http://localhost:3000/callback'
          : 'com.example.galaxysavings://callback';

      final success = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: redirectUrl,
      );

      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMsg,
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    state = AuthState();
  }

  Future<bool> deleteAccount(String errorMsg) async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      await _supabase.rpc('delete_user');
      await _supabase.auth.signOut();
      state = AuthState();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
