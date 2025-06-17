ImagenBaseWP
Entorno de desarrollo y despliegue profesional para WordPress con Docker Compose
🚀 Descripción
ImagenBaseWP es una plantilla avanzada para crear, desarrollar y desplegar sitios WordPress de forma profesional usando Docker Compose.
Incluye automatización de instalación, gestión de plugins y temas personalizados, seguridad mejorada, logs, y scripts para facilitar la vida a equipos de desarrollo.

```
.
├── config/
│   └── php/
│       └── conf.d/
│           └── custom.ini
│   └── nginx/
│       └── default.conf
├── docker-compose.yml
├── Dockerfile
├── install.sh
├── logs/
│   ├── nginx/
│   └── php/
├── wordpress/
│   ├── plugins_custom/
│   ├── themes/
│   ├── uploads/
│   ├── wp-config.php.example
│   └── security/
├── .env.example
└── README.md

```

⚙️ Requisitos previos
Docker (recomendado Docker Desktop)

Docker Compose

(Opcional) Git

🚦 Primeros pasos
1. Clona el repositorio
bash
git clone https://github.com/tuusuario/ImagenBaseWP.git
cd ImagenBaseWP
2. Configura tus variables de entorno
Copia el archivo de ejemplo y personaliza los valores:

bash
cp .env.example .env
nano .env  # O edítalo con tu editor favorito
Nunca subas tu archivo .env real al repositorio.

3. Levanta los servicios
bash
docker compose up -d
WordPress estará disponible en la URL definida en WORDPRESS_URL (por defecto, http://localhost:8000).

4. Accede a WordPress
Usuario y contraseña de admin: definidos en tu .env

Base de datos: MySQL 5.7, credenciales en .env

🛠️ Personalización
Plugins personalizados:
Coloca tus plugins en wordpress/plugins_custom/

Temas personalizados:
Coloca tus temas en wordpress/themes/

Uploads:
Los archivos subidos por WordPress van en wordpress/uploads/ (no se versionan los archivos, solo la carpeta)

Configuración PHP personalizada:
Edita config/php/conf.d/custom.ini

Configuración Nginx personalizada:
Edita config/nginx/default.conf

🔄 Comandos útiles
Ver logs:

bash
docker compose logs -f
Acceder al contenedor WordPress:

bash
docker compose exec wordpress bash
Usar WP-CLI:

bash
docker compose run --rm wpcli plugin list
🧩 Scripts y automatización
install.sh:
Automatiza la instalación, configuración, activación de plugins y temas, y refuerza la seguridad.

Variables de entorno:
Controla la instalación y configuración desde el archivo .env.

🔒 Buenas prácticas
No subas archivos confidenciales (.env, backups, uploads, etc.).

Versiona solo tus plugins y temas personalizados.

Utiliza .gitignore para mantener el repositorio limpio.

Haz backup regular de la base de datos y uploads en producción.

📝 Notas adicionales
Puedes añadir más servicios (Redis, Mailhog, etc.) modificando el docker-compose.yml.

Para producción, revisa y ajusta las variables de seguridad y rendimiento.

Si necesitas restaurar la base de datos, monta tus backups en mysql_data.

🤝 Contribuciones
¡Las contribuciones son bienvenidas!
Abre un issue o pull request para mejoras, correcciones o nuevas funcionalidade