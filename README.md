# Simplytest.me Docker

This is a single image Drupal install that runs Apache and MySQL in the same image. Drupal comes pre-installed and ready to run, and there is a (currently very simplistic) facility to install additional projects as well as build derivative images with projects pre-installed.

* Run Drupal
```
docker run -p 80:80 --rm -it grugnog/simplytest
```

The site will be up your own IP address (or Docker VM IP address) - you can log in with admin/drupal.

* Run Drupal with Panels installed
```
docker run -p 80:80 --rm -it grugnog/simplytest panels
```

* Pre-build a local image with Panels installed
```
docker run --name panels -e BUILDONLY=1 grugnog/simplytest panels && docker commit --change='ENTRYPOINT [/run.sh]' panels panels:latest && docker rm -f panels
```

* Run the pre-built image
```
docker run -p 80:80 -it --rm panels
```

* Build/develop locally
```
git clone https://github.com/grugnog/simplytest.git
cd simplytest
docker build -t simplytest .
```
Then replace `grugnog/simplytest` with just `simplytest` in the above commands.
