

### Benchmark for running 1000 dart tests in 1000 files vs generating a single file that starts all 1000 tests 

to start the benchmark, execute 

```bash
./benchmark_tests.sh
```

Sample output:

```
+ dart test
00:25 +1000: All tests passed!

real	0m26.842s
user	1m18.616s
sys	0m13.281s
+ dart test test/test_wrapper.g.dart
00:01 +1000: All tests passed!

real	0m1.841s
user	0m1.603s
sys	0m0.305s
```

