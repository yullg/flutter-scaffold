abstract interface class Message {}

enum PlainMessageType { normal, success, warn, error }

class PlainMessage implements Message {
  final PlainMessageType type;
  final String text;

  const PlainMessage(this.text, {this.type = PlainMessageType.normal});

  const PlainMessage.normal(this.text) : type = PlainMessageType.normal;

  const PlainMessage.success(this.text) : type = PlainMessageType.success;

  const PlainMessage.warn(this.text) : type = PlainMessageType.warn;

  const PlainMessage.error(this.text) : type = PlainMessageType.error;
}
