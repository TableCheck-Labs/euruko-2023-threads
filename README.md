
# Ruby Threads (and so can you!)

Presenter: Johnny Shields, Founder & CTO, [TableCheck](https://careers.tablecheck.com)

This project demonstrates the use of Ruby threads to perform data processing in parallel.
It was presented as an "Unconference" talk at the
[2023 Euruko Conference](https://2023.euruko.org/) in Vilnius, Lithuania.

### Project structure

- `/docs` Contains the slides used in the presentation.
- `/examples` The example code used in the presentation.
- `/perf` The benchmark code which proves the performance increase.

### Running the benchmarks

```bash
$> ruby perf/bm_producer_consumer.rb
# user     system      total        real
# single thread  0.000000   0.000000   0.000000 ( 15.593959)
# 50 threads     0.000000   0.000000   0.000000 (  0.342387)

$> ruby perf/bm_multi_stage.rb
# user     system      total        real
# single thread  0.000000   0.000000   0.000000 ( 31.176699)
# 50 threads     0.000000   0.015000   0.015000 (  0.484707)
```
