import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/exports.dart';
import '../../../../presentation/actions/domain/models/faqs_list_model.dart';
import '../../../../presentation/actions/domain/models/settings_model.dart';
import '../../domain/service/actions_service.dart';

part 'actions_state.dart';

class ActionsCubit extends Cubit<ActionsState> {
  ActionsCubit() : super(ActionsInitial());

  final ActionsService _actionsService = sl();

  SettingsModel settingsModel = SettingsModel.empty();
  String selectedLanguage = "";
  String selectedTheme = "";
  late List<bool> faqsIsExpanded;

  void prepareSettings() {
    emit(Loading());
    var result = _actionsService.loadSettings();
    result.fold(
      (l) => emit(ShowError(message: l.message)),
      (r) {
        settingsModel = r;
        selectedLanguage = r.local;
        selectedTheme = r.theme;
        emit(DisplaySettings(info: r));
      },
    );
  }

  void prepareFaqs() {
    emit(Loading());
    var result = _actionsService.loadFaqs();
    result.fold(
      (l) => emit(ShowError(message: l.message)),
      (r) {
        faqsIsExpanded = List.generate(r.questions.length, (index) => false);
        emit(DisplayFaqs(info: r));
      },
    );
  }

  void changeTheme(String theme) {
    var result = _actionsService.changeTheme(theme: theme);
    result.fold(
      (l) => emit(ShowError(message: l.message)),
      (r) => emit(DisplaySettings(info: settingsModel)),
    );
  }

  void changeLanguage(String language) {
    var result = _actionsService.changeLanguage(language: language);
    result.fold(
      (l) => emit(ShowError(message: l.message)),
      (r) => emit(DisplaySettings(info: settingsModel)),
    );
  }
}
