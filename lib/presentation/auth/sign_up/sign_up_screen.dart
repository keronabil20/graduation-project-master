// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:graduation_project/generated/l10n.dart';
import 'package:graduation_project/presentation/auth/sign_up/cubit/auth_cubit.dart';
import 'package:graduation_project/presentation/auth/sign_up/pending_dialog.dart';
import 'package:graduation_project/presentation/auth/widgets/choose_type.dart';
import 'package:graduation_project/routes/routes.dart';
import 'package:graduation_project/utils/widgets/custome_widgets/custome-textform.dart';
import 'package:graduation_project/utils/widgets/custome_widgets/wide_button.dart';

class SignupContent extends StatefulWidget {
  const SignupContent({super.key});

  @override
  State<SignupContent> createState() => _SignupContentState();
}

class _SignupContentState extends State<SignupContent> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final restaurantNameController = TextEditingController();
  final restaurantAddressController = TextEditingController();

  bool isRestaurantOwner = false;
  bool showRestaurantFields = false;
  final bool _isPasswordHidden = true;
  final bool _isConfirmPasswordHidden = true;

  final _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  @override
  void dispose() {
    emailController.dispose();
    passwordController.clear();
    passwordController.dispose();
    confirmPasswordController.clear();
    confirmPasswordController.dispose();
    nameController.dispose();
    restaurantNameController.dispose();
    restaurantAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          passwordController.clear();
          confirmPasswordController.clear();

          if (isRestaurantOwner) {
            showPendingDialog(context);
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.homenav,
              (route) => false,
            );
          }
        } else if (state is AuthFailure) {
          _showErrorDialog(context, state.message);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: signUpFields(context),
          ),
        ),
      ),
    );
  }

  Column signUpFields(BuildContext context) {
    return Column(
      children: [
        // User Type Selection
        Text(
          S.of(context).accountType,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 10.h),
        UserTypeSelector(
          isRestaurantOwner: isRestaurantOwner,
          onTypeChanged: (owner, showFields) {
            setState(() {
              isRestaurantOwner = owner;
              showRestaurantFields = showFields;
            });
          },
        ),
        SizedBox(height: 20.h),

        // Common Fields
        CustomTextFormField(
          labelText: S.of(context).fullname,
          controller: nameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).nameValidation;
            }
            if (value.length > 100) {
              return S.of(context).nameTooLong;
            }
            return null;
          },
        ),
        SizedBox(height: 20.h),
        CustomTextFormField(
          labelText: S.of(context).email,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).emailValidation;
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return S.of(context).invalidEmail;
            }
            if (value.length > 254) {
              return S.of(context).emailTooLong;
            }
            return null;
          },
        ),
        SizedBox(height: 20.h),
        CustomTextFormField(
          labelText: S.of(context).password,
          obscureText: _isPasswordHidden,
          controller: passwordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).passwordValidation;
            }
            if (!_passwordRegex.hasMatch(value)) {
              return S.of(context).passwordRequirements;
            }
            return null;
          },
        ),
        SizedBox(height: 20.h),
        CustomTextFormField(
          labelText: S.of(context).confirmPassword,
          obscureText: _isConfirmPasswordHidden,
          controller: confirmPasswordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).confirmPasswordValidation;
            }
            if (value != passwordController.text) {
              return S.of(context).passwordMismatch;
            }
            return null;
          },
        ),
        SizedBox(height: 20.h),

        // Restaurant Owner Fields
        if (showRestaurantFields) ...[
          Text(
            S.of(context).restaurantInfo,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 10.h),
          CustomTextFormField(
            labelText: S.of(context).restaurantName,
            controller: restaurantNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).restaurantNameValidation;
              }
              if (value.length > 100) {
                return S.of(context).restaurantNameTooLong;
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          CustomTextFormField(
            labelText: S.of(context).restaurantAddress,
            controller: restaurantAddressController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).restaurantAddressValidation;
              }
              if (value.length > 200) {
                return S.of(context).restaurantAddressTooLong;
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          Text(
            S.of(context).verificationNote,
            style: const TextStyle(color: Colors.orange),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
        ],
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return Column(
              children: [
                if (state is AuthLoading)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: const CircularProgressIndicator(),
                  ),
                signUpSubmitButton(context, state),
                SizedBox(height: 20.h),
              ],
            );
          },
        ),
      ],
    );
  }

  WideButton signUpSubmitButton(BuildContext context, AuthState state) {
    return WideButton(
      text: S.of(context).signUp,
      onTap: state is AuthLoading
          ? null
          : () async {
              if (_formKey.currentState!.validate()) {
                if (isRestaurantOwner &&
                    (restaurantNameController.text.isEmpty ||
                        restaurantAddressController.text.isEmpty)) {
                  _showErrorDialog(context, S.of(context).fillRestaurantInfo);
                  return;
                }

                try {
                  await context.read<AuthCubit>().signUp(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        name: nameController.text.trim(),
                        isRestaurantOwner: isRestaurantOwner,
                        restaurantName: restaurantNameController.text.trim(),
                        restaurantAddress:
                            restaurantAddressController.text.trim(),
                      );
                } catch (e) {
                  _showErrorDialog(context, S.of(context).errorOccurred);
                }
              }
            },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      title: S.of(context).signUpFailed,
      desc: message,
      btnOkText: "ok",
      btnOkColor: Colors.red,
    ).show();
  }
}
