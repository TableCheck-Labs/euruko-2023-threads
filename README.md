
# Ruby Threads (and so can you!)

Presenter: Johnny Shields, Founder & CTO, [TableCheck](https://careers.tablecheck.com)

This project demonstrates the use of Ruby threads to perform data processing in parallel.
It was presented as an "Unconference" talk at the
[2023 Euruko Conference](https://2023.euruko.org/) in Vilnius, Lithuania.

### Project structure

- `/docs` Contains the slides used in the presentation.
- `/examples` The example code used in the presentation.
- `/perf` The benchmark code which proves the performance increase.

### Examples

- `producer_consumer.rb` A simple producer/consumer example.
- `multi_stage.rb` A more complex example with multiple producer/consumer stages.
- `abstract.rb` An abstract base-class which you can subclass to add multi-threading 
  to your own task classes.

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

$> ruby perf/bm_abstract.rb
#        user     system      total        real
# single thread
# Task: Using 1 threads
# Task: P:100
# Task: C:100
# Task: P:200
# Task: C:200
# Task: P:300
# Task: C:300
# Task: P:400
# Task: C:400
# Task: P:500
# Task: C:500
# Task: P:600
# Task: C:600
# Task: P:700
# Task: C:700
# Task: P:800
# Task: C:800
# Task: P:900
# Task: C:900
# Task: P:1000
# Task: producer.0 finished gracefully P:1000
# Task: C:1000
# Task: consumer.0 finished gracefully C:1000
# Task: All consumers finished C:1000  0.000000   0.000000   0.000000 ( 15.591158)
# 50 threads
# Task: Using 50 threads
# Task: P:100
# Task: P:200
# Task: C:100
# Task: P:300
# Task: C:200
# Task: P:400
# Task: C:300
# Task: P:500
# Task: C:400
# Task: P:600
# Task: C:500
# Task: P:700
# Task: C:600
# Task: P:800
# Task: C:700
# Task: P:900
# Task: C:800
# Task: P:1000
# Task: producer.0 finished gracefully P:1000
# Task: C:900
# Task: consumer.45 finished gracefully C:1000
# Task: consumer.5 finished gracefully C:1000
# Task: consumer.41 finished gracefully C:1000
# Task: consumer.42 finished gracefully C:1000
# Task: consumer.37 finished gracefully C:1000
# Task: consumer.10 finished gracefully C:1000
# Task: consumer.12 finished gracefully C:1000
# Task: consumer.49 finished gracefully C:1000
# Task: consumer.21 finished gracefully C:1000
# Task: consumer.36 finished gracefully C:1000
# Task: consumer.28 finished gracefully C:1000
# Task: consumer.9 finished gracefully C:1000
# Task: consumer.4 finished gracefully C:1000
# Task: consumer.7 finished gracefully C:1000
# Task: consumer.13 finished gracefully C:1000
# Task: consumer.19 finished gracefully C:1000
# Task: consumer.8 finished gracefully C:1000
# Task: consumer.39 finished gracefully C:1000
# Task: consumer.34 finished gracefully C:1000
# Task: consumer.6 finished gracefully C:1000
# Task: consumer.38 finished gracefully C:1000
# Task: consumer.27 finished gracefully C:1000
# Task: consumer.25 finished gracefully C:1000
# Task: consumer.40 finished gracefully C:1000
# Task: consumer.0 finished gracefully C:1000
# Task: consumer.31 finished gracefully C:1000
# Task: consumer.29 finished gracefully C:1000
# Task: consumer.15 finished gracefully C:1000
# Task: consumer.46 finished gracefully C:1000
# Task: consumer.26 finished gracefully C:1000
# Task: consumer.44 finished gracefully C:1000
# Task: consumer.22 finished gracefully C:1000
# Task: consumer.24 finished gracefully C:1000
# Task: consumer.23 finished gracefully C:1000
# Task: consumer.30 finished gracefully C:1000
# Task: consumer.47 finished gracefully C:1000
# Task: consumer.14 finished gracefully C:1000
# Task: consumer.17 finished gracefully C:1000
# Task: consumer.16 finished gracefully C:1000
# Task: consumer.43 finished gracefully C:1000
# Task: consumer.1 finished gracefully C:1000
# Task: consumer.3 finished gracefully C:1000
# Task: consumer.48 finished gracefully C:1000
# Task: consumer.11 finished gracefully C:1000
# Task: consumer.2 finished gracefully C:1000
# Task: consumer.32 finished gracefully C:1000
# Task: consumer.18 finished gracefully C:1000
# Task: consumer.20 finished gracefully C:1000
# Task: consumer.35 finished gracefully C:1000
# Task: C:1000
# Task: consumer.33 finished gracefully C:1000
# Task: All consumers finished C:1000  0.000000   0.047000   0.047000 (  0.422189)
```
