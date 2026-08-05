# Instrucciones Técnicas de Cumplimiento: Uptodown (v1.0.94)

Para que Uptodown valide el archivo APK, el departamento de ingeniería debe asegurar que el binario cumpla con los siguientes estándares técnicos estrictos:

## 1. Esquema de Firma (Mandatorio)
El archivo **debe** estar firmado utilizando el esquema de firma v2 o superior. Las firmas v1 (Jar Signature) por sí solas disparan el error de "Formato no soportado".
*   **Acción**: Ejecutar `apksigner verify --verbose` sobre el archivo.
*   **Resultado esperado**: `Verified using v1 scheme (true)`, `Verified using v2 scheme (true)`.

## 2. Nivel de API (Target SDK)
Uptodown ha alineado sus requisitos con las políticas de seguridad de 2024.
*   **Requisito**: `targetSdkVersion` debe ser **33 (Android 13)** o superior.
*   **Acción**: Verificar en el `AndroidManifest.xml` o en el archivo `build.gradle`.

## 3. Optimización de Estructura (Zipalign)
El archivo debe estar alineado para optimizar el uso de RAM. Si no está alineado, el validador lo marca como corrupto.
*   **Acción**: Ejecutar la herramienta `zipalign -c -v 4`.

## 4. Método de Carga Recomendado
Debido a los firewalls de red de la plataforma, el método de "URL de descarga" suele fallar por tiempos de espera (handshake). 
*   **Estrategia**: Descargar el archivo localmente y utilizar la opción **"Subir archivo" (Upload file)** directamente en la consola de Uptodown.

---
**Generado por el Núcleo de Bio-Resonancia - Ecovia Global Systems**