enum MealType {
  lau('Lẩu'),
  com('Cơm'),
  pho('Phở'),
  bun('Bún'),
  mi('Mì'),
  banhMi('Bánh mì'),
  haiSan('Hải sản'),
  nuong('Nướng'),
  buffet('Buffet'),
  doUong('Đồ uống'),
  anVat('Ăn vặt'),
  khac('Khác');

  final String displayName;
  const MealType(this.displayName);
}