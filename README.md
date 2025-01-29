# Experiment DSL Language Server
The language server provides grammar validation of DSL in preferred editor, for example Visual Studio Code or IntelliJ IDEA. The language server has fundamentally two sides, server side and clients side. 

## Clone the language server
To run the IDE with XXP language (the DSL) enabled, there are two repos that need to be cloned and both services are required to run together.

1. **experiment-dsl-lang-server**: current repo
2. **extremexp-dsl-framework**: https://colab-repo.intracom-telecom.com/colab-projects/extremexp/experiment-modelling/extremexp-dsl-framework

## Docker composition
Save the below in a `docker-compose.yml` file, then add other services that you would like to have on the same network, and run it. Before running, change  `{...}` to locations of repos and directories of your own.

Directories to be created and used:
- *workspace* where `.xxp` files exist
- *logs*, some directory to store logs

```yml
services:
   ...

  lang-server:
    build:
      context: {path-to-extremexp-dsl-framework}/
      dockerfile: {path-to-extremexp-dsl-framework}/Dockerfile
    volumes:
      - {path-to-some-dir-for-logs}:/opt/logs/:wr
      - {path-to-the-workspace}:/home/user/workspace/:wr
    ports:
      - "127.0.0.1:5007:5007"
      
  code-server:
    build:
      context: {path-to-experiment-dsl-lang-server}/
      dockerfile: {path-to-experiment-dsl-lang-server}/Dockerfile
    environment:
      - PASSWORD=xxp-cuni
      - CODE_SERVER_HOST=0
      - CODE_SERVER_PORT=8080
      - CODE_SERVER_ORIGIN="http://127.0.0.1"
      - CODE_SERVER_WELCOME_TEXT="WELCOME TO XXP IDE"
      - LANG_SERVER_HOST=lang-server
      - LANG_SERVER_PORT=5007
    volumes:
      - {path-to-the-workspace}/:/home/user/workspace/:wr
      - {path-to-some-dir-for-logs}/:/etc/xxp-lang-server/logs/:wr
    ports:
      - "127.0.0.1:8080:8080/tcp"
    depends_on:
      - lang-server
```
