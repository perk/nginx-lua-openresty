# openresty
nginx + openresty + WAF

[https://hub.docker.com/r/mkjasinski/openresty/][1]

# installation

```
docker run -p 8090:80 --name openresty mkjasinski/openresty:latest
```

# usage

- [http://localhost:8090][2] - no errors, response with status code 200
- [http://localhost:8090/with-xss][3] - XSS, response with status code 403

[1]: https://hub.docker.com/r/mkjasinski/openresty
[2]: http://localhost:8090
[3]: http://localhost:8090/?tag=<h1>ello</h1>