# 3.1. Preparación del entorno con SDKMAN!

### ¿Que es SDKMAN!?

Es una herramienta de linea de comandos (CLI) que permite **instalar, cambiar y gestionar** múltiples versiones de Kits de Desarrollo de Software (SDKs) en sistemas operativos basados en Unix. Siendo un **gestor de versiones** para herramientas que usan lenguajes como **java, kotlin, scala** y herramientas de build como **Maven o Gradle**.

## ¿Para qué se utiliza en entornos Java/DevOps?

Para **gestionar** múltiples versiones de SDKs y build tools de forma mas practica, rapida y no invasiva. Garantizando la **compatibilidad y consistencia** del entorno de desarrollo a lo largo del ciclo de vida del software.


## Instalar SDKMAN!
Para instalar SDKMAN! se requiere la utilidad **zip y unzip** primeramente, por lo cual la puedes instalar con el siguiente comando:

```bash
sudo apt install unzip zip
```

Luego ejecuta para instalarlo:

```bash
curl -s "https://get.sdkman.io" | bash
```

Ejecutar el siguiente comando para no tener que abrir una nueva terminal:

```bash
source "~/.sdkman/bin/sdkman-init.sh"
```

Para listar las opciones de java disponibles:

```bash
sdk list java
```

Instalacion de una version LTS:

```bash
sdk install java 17.0.17-tem
```

Poner la versión como defecto:

```bash
sdk default java 17.0.17-tem
```

Verificar que el sistema utilize la version configurada con SDKMAN con el siguiente comando:

```bash
java --version && javac --version
```

# 3.2. Maven

Instalar maven con el gestor de paquetes de ubuntu:

```bash
sudo apt install maven
```

Una vez instalado, verificar la version de maven instalada con el siguiente comando:

```bash
mvn --version
```

En la misma salida de maven, verificar que este utilizando la version de maven previamente instalada:

![Evidencia de version de java utilizada](/img/java-version.png)

# 3.3. Obtención y exploración del proyecto joko-utils

Instalar primeramente git si no esta instalado:

```bash
sudo apt install git
```

Clonar el repositorio correspondiente:

```bash
git clone https://github.com/jokoframework/joko-utils.git
```

### Ubicación del archivo pom.xml

El arhivo se encuentra en la raiz del proyecto: `/joko-utils/pom.xml`

### Estructura de los directorios principales

- /src/main/java
- /src/test/java
- pom.xml
- /target/

### Referencia a CI

El archivo maven.yml, ubicado en el directorio: `/joko-utils/.github/workflows` hace referencia a procesos y configuraciones de CI.

# 3.4. Fases de maven

### 1 - clean (Limpiar el proyecto)

Elimina todos los archivos generados por la build anterior (ejemplo el directorio /target). Asegurando que la construccion sea limpia.

```bash
mvn clean
```
**Resultado**: Build Success

![Clean Success](/img/clean-output.png)

### 2 - validate (Validar el codigo): 

Verifica si el proyecto esta correcto y verifica si toda la informacion esta disponible.

```bash
mvn validate
```

**Resultado**: Build Success

![Validate Success](/img/validate-output.png)

### 3 - compile (Compilar el codigo): 

Traduce el codigo fuente a bytecode (El comando ejecuta primeramente **validate**, verificando que este correcto)

```bash
mvn compile
```

**Resultado**: Build Success

![Compile Succes](/img/compile-output.png)

### 4 - test (Ejecutar los test):

Realiza pruebas del codigo compilado. Depende de la fase de compile (y lo ejecuta si no se ha hecho antes). El resultado incluye un resumen de cuantos test se ejecutaron y si alguno fallo.

```bash
mvn test
```

**Resultado**: Build Success

**Test realizados**: 7

![Test Success](/img/test-output.png)

### 5 - package (Generar el artefacto empaquetado):

Toma los archivos compilados y los empaqueta en el formato de distribucion final (generalmente un .jar o .war). Depende de las fases de **validate, compile y test**, y las ejecuta en orden.

```bash
mvn package
```

**Resultado**: Build Success

**Ubicacion del artefacto**: /home/devops/joko-utils/target/joko-utils-0.6.9.jar

**Nombre del artefacto**: joko-utils-0.6.9.jar

![Package Success](/img/package-output.png)

![Artifact Name](/img/artifact.png)

## Consejo practico

Para ejecutar todas las fases hasta package se puede utilizar el siguiente comando (intentar probar a futuro):

```bash
mvn clean package
```

El cual ejecuta el **clean** y luego **validate, compile, test** y finalmente **package**.

## 3.5: Script

El resultado de la ejecucion del script fue exitosa:

![Script Succes](/img/script-output.png)

## 3.6: Cambio mínimo en el codigo 

El archivo modificado fue: `~/joko-utils/src/main/java/io/github/jokoframework/utils/date/DateTimeUtils.java`, especificamente la funcion: `dateFromHourMinSec`

Mensaje original:

```bash
throw new IllegalArgumentException(hhmmss + " is not a valid time, expecting HH:MM:SS format");
```

Mensaje modificado:

```bash
throw new IllegalArgumentException("joko-utils v2.0: Invalid time format [" + hhmmss + "]. Expected format is HH:MM:SS.");
```

Se realizo nuevamente la ejecucion del script, el cual termino con un resultado exitoso.

![Script Succes 2](/img/script-output2.png)

No hubo impacto en la ejecucion de los tests.

## 3.7. Reflexión DevOps

### ¿Por qué es útil gestionar múltiples versiones de Java con una herramienta como SDKMAN! en un contexto DevOps?

Es util porque ademas de simplificar la gestion de versiones, permite poder cambiar de forma segura y rapida versiones de java (e incluso de distintos proveedores), lo cual beneficia al momento a tener distintos proyectos, los cuales utilizan diferentes versiones de java entre si.

### ¿Qué ventajas y desventajas ves en utilizar Maven desde el repositorio de Ubuntu frente a otras formas de instalación?

Entre las ventajas del mismo:

- Es mas facil y rapido instalar, ya que solo se requiere un comando: `apt install maven`

- El sistema se encarga de la **configuracion del path y dependencias**.

- **Las actualizaciones y parches de seguridad** se manejan con el resto del sistema.

Pero tambien cuenta con ciertas desventajas:

- Es mucho mas complicado tener multiples versiones de **maven** instaladas simultaneamente para distintos proyectos.

- Los repositorios de Ubuntu priorizan la estabilidad, por lo cual las versiones de maven disponible a traves de `apt` suele ser **varias veces menor** a la última version estable oficial.

## ¿Qué pasos de este ejercicio se asemejan a un pipeline de CI real en Jenkins o GitHub Actions?

La parte de realizar el script.sh se asemeja a un pipeline de CI real de Jenkins, debido a que hay que automatizar el build lifecycle de maven.

## ¿En qué etapa del proceso se detectarían fallos de compilación o tests que impedirían desplegar a un entorno productivo?

Estos fallos se detectarian al hacer los comandos de `mvn compile` o `mvn test`, ya que verifican que se haya construido correctamente y que hayan pasado los test unitarios correspondientes



Fuentes: 
- https://sdkman.io/ (Ques es SDKMAN, para que sirve y comando de instalacion)
- https://www.markdownguide.org/basic-syntax/ (Sintaxis del markdown)
- https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html (Ciclo de vida de maven)
- https://bertvv.github.io/cheat-sheets/Bash.html (Tips para bash)
- https://www.youtube.com/watch?v=bBqxC43ASsM (Maven)
- https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo (Como realizar un fork)
