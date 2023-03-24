# Características avanzadas

## Artefactos (`artifacts`)

Los artefactos te permiten hacer datos persistentes después de que se complete un job y comparten estos datos con otro job en el mismo flujo de trabajo.

```yaml
jobs:  
	build:
    runs-on: ubuntu-20.04
    steps:
      - name: Copy build directory
        uses: actions/upload-artifact@v2
        with:
          name: build
          path: build
 
  publish:
    needs: [build]
    runs-on: ubuntu-20.04
    steps:
      - name: Copy build directory
        uses: actions/download-artifact@v2
        with:
          name: dist
          path: dist
```

## Secretos

En general no es una buena practica utilizar datos sensibles en nuestro código por lo que podemos configurar secretos que estén disponibles en nuestro repositorio, sin exponerlos.

```yaml
jobs:
  example-job:
    runs-on: ubuntu-latest
    steps:
      - name: Retrieve secret
        env:
          super_secret: ${{ secrets.SUPERSECRET }}
        run: |
          example-command "$super_secret"
```

## Dependencia de Jobs

Todos los jobs por default se ejecutan en paralelo pero podemos crear dependencias que permitan arrancar un job después de que finalice la ejecución de otro job.

```yaml
jobs:
  setup:
    runs-on: ubuntu-latest
    steps:
      - run: ./setup_server.sh
  build:
    needs: setup
    runs-on: ubuntu-latest
    steps:
      - run: ./build_server.sh
  test:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - run: ./test_server.sh
```

## Matrices

Las matrices nos permiten crear y ejecutar multiples jobs a partir de las combinaciones deseadas.

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node: [12, 14, 16]
    steps:
      - uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node }}
```

## Almacenar dependencias en caché

Podemos optimizar nuestros procesos utilizando una caché que estará disponible para todos los flujos de trabajo en el mismo repositorio.

```yaml
jobs:
  example-job:
    steps:
      - name: Cache node modules
        uses: actions/cache@v3
        env:
          cache-name: cache-node-modules
        with:
          path: ~/.npm
          key: ${{ runner.os }}-build-${{ env.cache-name }}-${{ hashFiles('**/package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-build-${{ env.cache-name }}-
```

## Contenedores de servicio

Podemos crear contenedores temporales para almacenar servicios, estos contenedores estarán disponibles para todos los pasos de ese job y se eliminara cuando el job termine.

```yaml
jobs:
  container-job:
    runs-on: ubuntu-latest
    container: node:10.18-jessie
    services:
      postgres:
        image: postgres
    steps:
      - name: Check out repository code
        uses: actions/checkout@v3
      - name: Install dependencies
        run: npm ci
      - name: Connect to PostgreSQL
        run: node client.js
        env:
          POSTGRES_HOST: postgres
          POSTGRES_PORT: 5432
```

## ****Utilizar etiquetas para enrutar los flujos de trabajo****

Podemos forzar la ejecución de los flujos de trabajo a partir de las etiquetas seleccionadas.

```yaml
jobs:
  example-job:
    runs-on: [self-hosted, linux, x64]
```

## Cron Jobs

Podemos configurar que nuestros flujos de trabajo se ejecuten en periodos específicos de tiempo.

```yaml
name: CronJob
on:
	schedule: 
		- cron: '0 0 * * *'
```

[Crontab.guru - The cron schedule expression editor](https://crontab.guru/)

## ****Reutilizar flujos de trabajo****

[Reutilizar flujos de trabajo - GitHub Docs](https://docs.github.com/es/actions/learn-github-actions/reusing-workflows)

## ****Utilizar ambientes****

[Utilizar ambientes para el despliegue - GitHub Docs](https://docs.github.com/es/actions/deployment/using-environments-for-deployment)