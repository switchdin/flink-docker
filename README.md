# flink-docker / dev-master

## Building a custom docker image

1. Compress Flink in `flink-dist/target/flink-1.15-SNAPSHOT-bin`: `tar czf flink-1.15.tgz flink-1.15-SNAPSHOT`
2. Copy created flink tar file (flink-1.11.tgz), pyflink and apache library files to a directory. 
3. `cd` to the directory
4. Start web server ``docker run -it -p 9999:9999 -v `pwd`:/data python:3.7.7-slim-buster python -m http.server 9999``
5. Generate `Dockerfile` `./add-custom.sh -s http://<docker_ip>:9999/data/ -b flink-1.15.tgz -p apache_flink-1.15.dev0-cp38-cp38-linux_x86_64.whl -l apache_flink_libraries-1.15.dev0-py2.py3-none-any.whl -n flink-1.15 -j 11`
    where <docker_ip> is the IP address of the docker container run at step 3 (e.g. 172.17.0.3)
	(If you are on a Mac or Windows(or WSL), use `host.docker.internal` instead of `172.17.0.3`)
	* If you want to build the docker image inside Minikube, then you have to specify the resolved `host.minikube.internal` which you can look up via `minikube ssh "cat /etc/hosts"`.
6. Generate docker image (in `flink-docker/dev/flink-1.15-debian`): `docker build -t flink:1.15-SN .`
7. Run custom Flink docker image: `docker run -it flink:1.15-SN jobmanager`

