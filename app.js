import pkg from "@bot-whatsapp/bot";
const { createBot, createFlow, createProvider } = pkg;

import BaileysProvider from "@bot-whatsapp/provider/baileys";
import MemoryDB from "@bot-whatsapp/database/mock";
import dotenv from "dotenv";
import express from "express";
import fs from "fs";
import https from "https";
import { join } from "path";
import { createReadStream } from "fs";

const main = async () => {
  try {
    // Cargar variables de entorno
    dotenv.config()

    const app = express()
    const port = process.env.PORT || 3000
    const AUTH_TOKEN = process.env.AUTH_TOKEN || "default-token"
    const NODE_ENV = process.env.NODE_ENV || "development"

    // Manejo global de errores no capturados
    process.on('uncaughtException', (error) => {
      console.error('❌ Error no capturado:', error)
      console.error('Stack:', error.stack)
      // No salir inmediatamente, intentar continuar
    })

    process.on('unhandledRejection', (reason, promise) => {
      console.error('❌ Promesa rechazada sin manejar:', reason)
      console.error('En promesa:', promise)
      // No salir inmediatamente, intentar continuar
    })

  // Middleware para parsear cuerpos JSON
  app.use(express.json())

   // Middleware de autenticación
   const authenticate = (req, res, next) => {
    const token = req.headers['x-auth-token'];
    if (token === AUTH_TOKEN) {
      next();
    } else {
      res.status(403).json({ status: 'error', message: 'Forbidden' });
    }
  };


  // Crear un proveedor de baileys que manejara la conexion con WhatsApp
  let provider, database;
  try {
    provider = createProvider(BaileysProvider, {})
    database = new MemoryDB()

    await createBot({
      flow: createFlow([]),
      provider: provider,
      database: database,
    })
    console.log("✅ Bot de WhatsApp inicializado correctamente")
  } catch (error) {
    console.error("❌ Error inicializando el bot de WhatsApp:", error.message)
    throw error; // Re-lanzar para que se maneje en el catch principal
  }

  // Configurar servidor según el entorno
  let server;
  
  if (NODE_ENV === "production") {
    // En producción: intentar cargar certificados SSL
    try {
      const privateKey = fs.readFileSync(
        "/etc/letsencrypt/live/cloudserver.nerdyactor.com.ar/privkey.pem",
        "utf8"
      )
      const certificate = fs.readFileSync(
        "/etc/letsencrypt/live/cloudserver.nerdyactor.com.ar/cert.pem",
        "utf8"
      )
      const ca = fs.readFileSync(
        "/etc/letsencrypt/live/cloudserver.nerdyactor.com.ar/chain.pem",
        "utf8"
      )

      const credentials = {
        key: privateKey,
        cert: certificate,
        ca: ca,
      }

      // Crear un servidor HTTPS
      server = https.createServer(credentials, app)
      console.log("🔒 Modo PRODUCCIÓN: Servidor HTTPS con certificados SSL iniciado")
    } catch (error) {
      console.error("❌ Error cargando certificados SSL en producción:", error.message)
      console.log("⚠️  Fallback: Usando servidor HTTP en producción")
      server = app
    }
  } else {
    // En desarrollo: usar HTTP directamente
    server = app
    console.log("🔧 Modo DESARROLLO: Servidor HTTP iniciado (sin SSL)")
  }

  app.get("/status", (req, res) => {
    res.setHeader("Content-Type", "application/json")
    res.end(
      JSON.stringify({
        status: "success",
        message: "Escuchando atentamente",
      })
    )
  })

  app.get("/get-qr", authenticate, async (_, res) => {
    try {
      const YOUR_PATH_QR = join(process.cwd(), `bot.qr.png`)
      
      // Verificar si el archivo QR existe
      if (!fs.existsSync(YOUR_PATH_QR)) {
        return res.status(404).json({
          status: "error",
          message: "Código QR no disponible"
        })
      }
      
      const fileStream = createReadStream(YOUR_PATH_QR)
      res.writeHead(200, { "Content-Type": "image/png" })
      fileStream.pipe(res)
    } catch (error) {
      console.error("❌ Error obteniendo QR:", error.message)
      res.status(500).json({
        status: "error",
        message: "Error interno del servidor al obtener QR"
      })
    }
  })

  app.post("/send-message", authenticate, async (req, res) => {
    try {
      const { phone, message } = req.body
      
      if (!phone || !message) {
        return res.status(400).json({
          status: "error",
          message: "Phone y message son requeridos"
        })
      }
      
      await provider.sendMessage(phone, message, {})
      res.json({
        status: "success",
        message: "Mensaje enviado correctamente",
      })
    } catch (error) {
      console.error("❌ Error enviando mensaje:", error.message)
      res.status(500).json({
        status: "error",
        message: "Error interno del servidor al enviar mensaje"
      })
    }
  })

  server.listen(port, () => {
    const protocol = NODE_ENV === "production" ? "HTTPS/HTTP" : "HTTP"
    console.log(`🚀 Servidor (${protocol}) ejecutándose en puerto ${port}`)
    console.log(`📝 Entorno: ${NODE_ENV}`)
    console.log(`🔑 Token de autenticación configurado: ${AUTH_TOKEN ? "✅" : "❌"}`)
  })

  } catch (error) {
    console.error("❌ Error fatal iniciando la aplicación:", error.message)
    console.error("Stack completo:", error.stack)
    
    // En desarrollo, salir para debugging
    if (process.env.NODE_ENV === "development") {
      process.exit(1)
    }
    
    // En producción, intentar reiniciar después de un delay
    console.log("⏰ Intentando reiniciar en 5 segundos...")
    setTimeout(() => {
      main().catch((retryError) => {
        console.error("❌ Error en reintento:", retryError.message)
        process.exit(1)
      })
    }, 5000)
  }
}

main().catch((error) => {
  console.error("❌ Error fatal en main():", error.message)
  console.error("Stack:", error.stack)
  
  // Solo salir en desarrollo, en producción PM2 o systemd se encargará
  if (process.env.NODE_ENV === "development") {
    process.exit(1)
  }
})