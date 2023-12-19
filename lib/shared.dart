
import 'package:synthetic_tests_one_file_vs_many/shared_dependency.dart';

class SharedClass {

  static String sharedValue = "Shared Value";

  int sharedMethod() {
    if(sharedGlobal){
      return 6 * 7;
    } else {
      return SharedDependency().sharedMethod();
    }

  }


}