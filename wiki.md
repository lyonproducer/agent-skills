# Wiki Concepts 

---

### 🤖 Core de Agentes e IA

* **Agent (Agente):** Una instancia de IA (como Claude, Gemini o Cursor) configurada con un rol específico, capaz de ejecutar tareas y razonar sobre tu código.
* **Skill (Habilidad):** Un conjunto de instrucciones, documentación y ejemplos (generalmente en Markdown) que "entrenan" al agente en una tecnología específica, como Angular o Ionic.
* **Sub-agent (Sub-agente):** Un agente especializado que es invocado por otro agente principal para resolver una tarea de nicho (ej. un agente experto en migraciones standalone invocado por el agente de arquitectura).
* **System Prompt / Instructions:** El archivo maestro (`AGENTS.md`, `.cursorrules`) que define la personalidad, reglas de estilo y límites del agente en el proyecto.

---

### 📁 Infraestructura y Archivos

* **SH (Shell Script):** Archivo ejecutable (`setup.sh`) que automatiza tareas en la terminal, como instalar dependencias o configurar los entornos de los agentes.
* **Symlink (Enlace Simbólico):** Un "acceso directo" avanzado. Es un archivo que apunta a una carpeta o archivo en otra ubicación, permitiendo que varios agentes compartan las mismas `skills` sin duplicar espacio.
* **Hard Link (Enlace Duro):** Una referencia física al mismo contenido en el disco. A diferencia del symlink, la IA lo ve como un archivo real, lo que evita problemas de permisos en apps como Claude Desktop.
* **Root (Raíz):** La carpeta principal de tu repositorio donde residen los archivos de configuración globales como `angular.json` o tu script `setup.sh`.

---

### 🔧 Comandos y Herramientas

* **CLI (Command Line Interface):** Herramientas que ejecutas en la terminal (ej. `ionic cli`, `gemini cli`) para interactuar con frameworks o modelos de IA.
* **Standalone:** En el contexto de Angular, componentes que no dependen de `NgModules`, simplificando la estructura y mejorando el rendimiento (tree-shaking).
* **Hydration / Indexing:** El proceso mediante el cual Cursor o Claude escanean tus archivos y carpetas para crear un índice vectorial que les permite "recordar" tu código.

---

### 🎯 Términos de tu Setup Específico

* **`setup.sh`:** Tu script automatizado que detecta qué asistentes usas (Claude, Gemini, Copilot) y vincula las habilidades correspondientes.
* **`REPO_ROOT`:** Variable en tu script que identifica la ruta absoluta de tu proyecto para asegurar que los enlaces se creen correctamente.
* **`replace_link`:** Función de tu script que limpia enlaces viejos o carpetas corruptas antes de crear una nueva conexión a las `skills`.

¿Te gustaría que añada algún término más específico de **Ionic/Capacitor** para que el diccionario sea 100% completo para tus desarrolladores?