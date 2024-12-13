extension StringExtension on String{
  bool get isInt => int.tryParse(this) != null;
}