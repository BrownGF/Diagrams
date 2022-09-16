# Dapr-Perf

## No Dapr

     data_received..................: 15 MB  13 kB/s
     data_sent......................: 7.7 MB 6.4 kB/s
     http_req_blocked...............: avg=6.83µs  min=1.1µs  med=2.29µs  max=15.15ms p(90)=4.59µs   p(95)=5.6µs        http_req_connecting............: avg=2.89µs  min=0s     med=0s      max=15.05ms p(90)=0s       p(95)=0s           http_req_duration..............: avg=90.16ms min=1.6ms  med=11.39ms max=2.21s   p(90)=78.22ms  p(95)=577.84ms
       { expected_response:true }...: avg=90.16ms min=1.6ms  med=11.39ms max=2.21s   p(90)=78.22ms  p(95)=577.84ms
     http_req_failed................: 0.00%  ✓ 0        ✗ 82696
     http_req_receiving.............: avg=74.57µs min=10µs   med=25.5µs  max=1.02s   p(90)=66.9µs   p(95)=97.2µs       http_req_sending...............: avg=74.34µs min=4.59µs med=9.7µs   max=17.22ms p(90)=150.45µs p(95)=467.02µs
     http_req_tls_handshaking.......: avg=0s      min=0s     med=0s      max=0s      p(90)=0s       p(95)=0s           http_req_waiting...............: avg=90.01ms min=1.55ms med=11.27ms max=2.21s   p(90)=78.05ms  p(95)=577.28ms
     http_reqs......................: 82696  68.88574/s
     iteration_duration.............: avg=1.09s   min=1s     med=1.01s   max=3.21s   p(90)=1.07s    p(95)=1.57s        iterations.....................: 82696  68.88574/s
     vus............................: 1      min=1      max=100
     vus_max........................: 100    min=100    max=100
     
## Dapr

     data_received..................: 15 MB  12 kB/s
     data_sent......................: 6.9 MB 5.8 kB/s
     http_req_blocked...............: avg=6.95µs   min=1µs    med=2.4µs   max=16.7ms  p(90)=4.8µs   p(95)=5.8µs        http_req_connecting............: avg=2.98µs   min=0s     med=0s      max=16.62ms p(90)=0s      p(95)=0s           http_req_duration..............: avg=109.32ms min=2.22ms med=14.84ms max=3.5s    p(90)=93.18ms p(95)=805.59ms
       { expected_response:true }...: avg=109.32ms min=2.22ms med=14.84ms max=3.5s    p(90)=93.18ms p(95)=805.59ms
     http_req_failed................: 0.00%  ✓ 0         ✗ 81267
     http_req_receiving.............: avg=109.35µs min=10.5µs med=27.4µs  max=1.68s   p(90)=71.7µs  p(95)=104.8µs 
     http_req_sending...............: avg=53.7µs   min=4.5µs  med=9.79µs  max=12.34ms p(90)=80.9µs  p(95)=284.07µs
     http_req_tls_handshaking.......: avg=0s       min=0s     med=0s      max=0s      p(90)=0s      p(95)=0s           http_req_waiting...............: avg=109.15ms min=2.16ms med=14.72ms max=3.5s    p(90)=93ms    p(95)=805.26ms
     http_reqs......................: 81267  67.692613/s
     iteration_duration.............: avg=1.11s    min=1s     med=1.01s   max=4.5s    p(90)=1.09s   p(95)=1.8s         iterations.....................: 81267  67.692613/s
     vus............................: 1      min=1       max=100
     vus_max........................: 100    min=100     max=100
