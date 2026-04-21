import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';
import 'package:wassaly/features/auth/domain/usecases/signup_usecase.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUseCase _signupUseCase;

  SignupBloc({required SignupUseCase signupUseCase})
      : _signupUseCase = signupUseCase,
        super(const SignupState()) {
    on<NameChanged>(_onNameChanged);
    on<PhoneChanged>(_onPhoneChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<PasswordVisibilityChanged>(_onPasswordVisibilityChanged);
    on<TermsAcceptedChanged>(_onTermsAcceptedChanged);
    on<SignupSubmitted>(_onSignupSubmitted);
    on<SignupWithGoogle>(_onSignupWithGoogle);
    on<SignupWithFacebook>(_onSignupWithFacebook);
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

  void _onTermsAcceptedChanged(
    TermsAcceptedChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(isTermsAccepted: event.isAccepted, clearError: true));
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    if (!state.isTermsAccepted) {
      emit(state.copyWith(
        errorMessage: 'auth.terms_required'.tr(),
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
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        isLoading: false,
        user: user,
      )),
    );
  }

  Future<void> _onSignupWithGoogle(
    SignupWithGoogle event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    await Future<void>.delayed(const Duration(seconds: 1));
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _onSignupWithFacebook(
    SignupWithFacebook event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    await Future<void>.delayed(const Duration(seconds: 1));
    emit(state.copyWith(isLoading: false));
  }
}
