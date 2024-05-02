import 'dart:collection';
import 'dart:math' as math;

List<int> getUniqueRandomNumbers(int n, int length){
  List<int> result = [];
  Queue pool = Queue.from(List.generate(length, (index) => index));
  for (int i = 0; i < n && length - i > 0; i++){
    int r = math.Random().nextInt(length - i);
    int e = pool.elementAt(r);
    result.add(e);
    pool.remove(e);
  }
  return result;
}


