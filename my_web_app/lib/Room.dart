class Room {
  String roomID;
  bool isAvailable = false;
  Room({this.roomID, this.isAvailable});
  @override
  String toString() {
    return roomID;
  }
}
