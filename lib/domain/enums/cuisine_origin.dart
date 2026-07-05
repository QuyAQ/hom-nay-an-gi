enum CuisineOrigin {
  viet('Việt'),
  thai('Thái'),
  trung('Trung'),
  han('Hàn'),
  nhat('Nhật'),
  y('Ý'),
  phap('Pháp'),
  an('Ấn'),
  khac('Khác');

  final String displayName;
  const CuisineOrigin(this.displayName);
}