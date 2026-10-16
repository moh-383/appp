bool isMineDetectedStatus(String? status, {bool? mineDetectedFlag}) {
  if (mineDetectedFlag == true) return true;
  final s = (status ?? '').trim().toLowerCase();
  return s == 'mine détectée' || s == 'mine detected';
}
