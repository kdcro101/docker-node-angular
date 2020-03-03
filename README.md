
# Node.js  + Angular 9

```sh
docker run -d --restart unless-stopped -h node -p 44022:22 -p 3000 -p 4200 -p 9222 -p 9876 -v projects:/home/dev/projects --entrypoint /bin/bash node-angular  /script/start
```