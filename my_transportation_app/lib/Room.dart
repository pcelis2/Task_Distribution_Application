class Room {
  int _floor;
  String _unit;
  int _roomNumber;
  Room(int flr, String unt, int rmNum) {
    _floor = flr;
    _unit = unt;
    _roomNumber = rmNum;
  }
  @override
  String toString() {
    return _floor.toString() + _unit + _roomNumber.toString();
  }
}
