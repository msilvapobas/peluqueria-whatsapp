# 🎯 GUÍA PASO A PASO - DEPLOYMENT AL VPS

## 1️⃣ CONECTAR AL VPS DESDE WINDOWS

En tu PowerShell de Windows, ejecuta:

```powershell
ssh -p5661 root@149.50.144.227
```

**¿Qué va a pasar?**
- Te pedirá la contraseña del servidor
- Una vez conectado, verás algo como: `root@tu-servidor:~#`
- ¡Ya estás DENTRO del servidor Linux!

---

## 2️⃣ UNA VEZ CONECTADO AL VPS (Terminal Linux)

**IMPORTANTE:** Ahora ya NO estás en Windows. Estás en un servidor Linux Ubuntu.

### Paso 2.1: Verificar dónde estás
```bash
pwd
# Debería mostrar: /root
```

### Paso 2.2: Instalar Node.js
```bash
# Actualizar el sistema
apt update

# Instalar curl (herramienta para descargar)
apt install -y curl

# Instalar Node.js versión 18
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Verificar que se instaló
node --version
npm --version
```

### Paso 2.3: Instalar Git
```bash
# Instalar Git
apt install -y git

# Verificar
git --version
```

### Paso 2.4: Instalar PM2 (Gestor de procesos)
```bash
# Instalar PM2 globalmente
npm install -g pm2

# Verificar
pm2 --version
```

### Paso 2.5: Descargar tu código
```bash
# Ir al directorio home
cd /root

# Clonar tu repositorio de GitHub
git clone https://github.com/msilvapobas/peluqueria-whatsapp.git

# Entrar al directorio del proyecto
cd peluqueria-whatsapp

# Verificar que tienes los archivos
ls -la
```

### Paso 2.6: Instalar dependencias del proyecto
```bash
# Instalar las librerías que necesita tu bot
npm install
```

### Paso 2.7: Configurar variables de entorno
```bash
# Copiar el archivo de configuración de producción
cp .env.production .env

# Editar el archivo con tus datos secretos
nano .env
```

**En el editor nano:**
- Verás el contenido del archivo
- Cambia `AUTH_TOKEN=production-token-change-me` por tu token real
- Por ejemplo: `AUTH_TOKEN=mi-token-super-secreto-123456`
- Para salir: Ctrl+X, luego Y, luego Enter

### Paso 2.8: Iniciar la aplicación
```bash
# Iniciar con PM2
pm2 start ecosystem.config.json --env production

# Configurar PM2 para que inicie automáticamente al reiniciar el servidor
pm2 startup systemd -u root --hp /root
pm2 save

# Ver el estado de tu aplicación
pm2 status
```

---

## 3️⃣ VERIFICAR QUE TODO FUNCIONA

### Ver si tu bot está corriendo:
```bash
pm2 status
```

### Ver los logs (mensajes de tu aplicación):
```bash
pm2 logs app-sebaarevalo-wapp
```

### Probar que responde en el puerto:
```bash
curl http://localhost:3001/webhook
```

---

## 4️⃣ COMANDOS ÚTILES PARA EL FUTURO

### Ver estado de la aplicación:
```bash
pm2 status
```

### Reiniciar la aplicación:
```bash
pm2 restart app-sebaarevalo-wapp
```

### Ver logs en tiempo real:
```bash
pm2 logs app-sebaarevalo-wapp --lines 50
```

### Parar la aplicación:
```bash
pm2 stop app-sebaarevalo-wapp
```

### Actualizar código desde GitHub:
```bash
cd /root/peluqueria-whatsapp
git pull origin main
npm install
pm2 restart app-sebaarevalo-wapp
```

---

## 5️⃣ SALIR DEL VPS

Para salir del servidor y volver a tu Windows:
```bash
exit
```

---

## ❓ RESUMEN SIMPLE

1. **Conectarte**: `ssh -p5661 root@149.50.144.227`
2. **Instalar herramientas**: Node.js, Git, PM2
3. **Bajar tu código**: `git clone ...`
4. **Configurar**: Editar `.env`
5. **Iniciar**: `pm2 start ...`
6. **Verificar**: `pm2 status`

¡Tu bot estará corriendo 24/7 en el servidor!
