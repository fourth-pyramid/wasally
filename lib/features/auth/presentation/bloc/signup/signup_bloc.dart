import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/domain/usecases/signup_usecase.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUseCase _signupUseCase;

  SignupBloc({
    required SignupUseCase signupUseCase,
  })  : _signupUseCase = signupUseCase,
        super(const SignupState()) {
    on<NameChanged>(_onNameChanged);
    on<PhoneChanged>(_onPhoneChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<PasswordVisibilityChanged>(_onPasswordVisibilityChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<ConfirmPasswordVisibilityChanged>(_onConfirmPasswordVisibilityChanged);
    on<TermsAcceptedChanged>(_onTermsAcceptedChanged);
    on<AvatarChanged>(_onAvatarChanged);
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  void _onNameChanged(NameChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(name: event.name, clearError: true));
  }

  void _onPhoneChanged(PhoneChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(phone: event.phone, clearError: true));
  }

  void _onEmailChanged(EmailChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(email: event.email, clearError: true));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(password: event.password, clearError: true));
  }

  void _onPasswordVisibilityChanged(
    PasswordVisibilityChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: event.isVisible));
  }

  void _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(
        confirmPassword: event.confirmPassword, clearError: true));
  }

  void _onConfirmPasswordVisibilityChanged(
    ConfirmPasswordVisibilityChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(isConfirmPasswordVisible: event.isVisible));
  }

  void _onTermsAcceptedChanged(
    TermsAcceptedChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(isTermsAccepted: event.isAccepted, clearError: true));
  }

  void _onAvatarChanged(
    AvatarChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(
      avatarFile: event.avatarFile,
      clearError: true,
      clearAvatar: event.avatarFile == null,
    ));
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    if (!state.isTermsAccepted) {
      emit(state.copyWith(
        errorMessage: 'auth_terms_required',
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _signupUseCase(
      SignupParams(
        name: state.name,
        phone: state.phone,
        email: state.email,
        password: state.password,
        confirmPassword: state.confirmPassword,
        avatarFile: state.avatarFile,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        isLoading: false,
        isRegistered: true,
      )),
    );
  }
}
