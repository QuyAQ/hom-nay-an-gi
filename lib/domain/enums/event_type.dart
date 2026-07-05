enum EventType {
  sinhNhat('Sinh nhật'),
  lienHoan('Liên hoan'),
  nhau('Nhậu'),
  henHo('Hẹn hò'),
  congViec('Công việc'),
  giaDinh('Gia đình'),
  motMinh('Một mình'),
  khac('Khác');

  final String displayName;
  const EventType(this.displayName);
}