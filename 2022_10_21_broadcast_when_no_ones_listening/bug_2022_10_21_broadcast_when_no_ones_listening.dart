import 'dart:async';

/*
Streams are single subscription by default.
They hold on to their values till someone starts listening.

Can make them asBroadcastStream()
Now they can have multiple listeners (or no listeners)
But if no one is listening, data gets tossed out
    This is not true for initial data though. Is this a bug???
*/

void main(List<String> args) {
  // broadcast stream counts numbers every 500ms, from [start, stop)
  Stream<int> ns = StreamCounter(start: 2, stop: 30, milliseconds: 500)
      .stream
      .asBroadcastStream();
  // first subscription happens after 2 seconds, lasts for 6 seconds
  // data piled up to this moment is flushed into this subscription
  subscribe<int>(ns, 'subs1', startDelay: 2, life: 6);
  // second subscription also happens after 2 seconds, lasts for 3 seconds
  // note that this happens just after subs1 but only subs1 gets buffered up data
  subscribe<int>(ns, 'subs2', startDelay: 2, life: 3);
  // third subscription is to see how onDone behaves & what happens to data when no one is listening
  // note that subs1 & subs2 also have onDone, but they unsubscribe before stream closure
  // so their onDone doesn't fire
  bool noSubscriptionOnStreamClosure = false;
  if (!noSubscriptionOnStreamClosure) {
    subscribe<int>(ns, 'subs3', startDelay: 11);
  }
  print('main:: main is done');
}

// startDelay is delay in seconds that will be introduced before subscription happens
// Subscription will get cancelled after 'life' seconds post subscription
// To not unsubscribe, let 'life' be negative
void subscribe<T>(Stream<T> stream, String id,
    {int startDelay = 0, int life = -1}) {
  Future.delayed(Duration(seconds: startDelay), () {
    print('$id subscribes');
    StreamSubscription<T> subscription = stream.listen(
      (data) => print('    $id got data: $data'),
      onError: (err) {
        print('$id handles error: $err');
      },
      onDone: () {
        print('$id notices stream closure');
      },
    );
    if (life >= 0) {
      Future.delayed(Duration(seconds: life), () {
        subscription.cancel();
        print('$id cancels its subscription');
      });
    }
  });
}

class StreamCounter {
  // data/state members
  int _counter = 1;
  final _controller = StreamController<int>();

  // constructor
  StreamCounter({
    int start = 1,
    int stop = 10,
    int milliseconds = 200,
    bool throwErrors = false,
    int errorOnMultiplesOf = 5,
  }) {
    if (start > stop) {
      int temp = stop;
      stop = start;
      start = temp;
    }
    _counter = start;
    Timer.periodic(Duration(milliseconds: milliseconds), (timer) {
      if (throwErrors && _counter % errorOnMultiplesOf == 0) {
        _controller.sink.addError(
            Exception('$_counter is a multiple of $errorOnMultiplesOf'));
      } else {
        _controller.sink.add(_counter);
      }

      _counter++;
      if (_counter == stop) {
        timer.cancel();
        _controller.close();
        print('stream controller closed');
      }
    });
  }

  // getter for controllers stream
  Stream<int> get stream => _controller.stream;
}
