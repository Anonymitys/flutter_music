
import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class CurrentPlayAlbumEvent{
  String url;
  CurrentPlayAlbumEvent(this.url);
}