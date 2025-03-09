part of 'backup_bloc.dart';

sealed class BackupEvent {}

class BackupData extends BackupEvent {}

class RestoreData extends BackupEvent {}
