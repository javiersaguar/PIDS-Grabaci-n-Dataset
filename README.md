# Grabación del dataset de gestos — PIDS 26/27, Project 1

Kit para grabar tu parte del dataset de reconocimiento de gestos de mano.
Tardarás unos **15 minutos** en total (10 de instalación la primera vez, 12 de grabación).

Adaptado de [`efhes/IE-workspace`](https://github.com/efhes/IE-workspace) para
funcionar en **Windows nativo con la webcam del portátil**, sin Raspberry Pi y sin WSL.

---

## 1. Los 6 gestos

Se graba **una sola mano**. Usa siempre **la misma mano** durante toda tu sesión
y apunta cuál en el mensaje que envíes al final.

| Clase | Gesto | Cómo se hace |
|---|---|---|
| `ok` | 👌 OK | Pulgar e índice formando un círculo cerrado; los otros tres dedos **extendidos y separados** hacia arriba |
| `paper` | ✋ Papel | Mano completamente abierta, cinco dedos extendidos y **separados entre sí**, palma hacia la cámara |
| `rock` | ✊ Piedra | Puño cerrado, palma hacia la cámara, **pulgar recogido por delante** de los dedos |
| `rockandroll` | 🤘 Cuernos | Índice y meñique extendidos; corazón y anular doblados con el pulgar encima |
| `scissors` | ✌️ Tijera | Índice y corazón extendidos en V **bien abierta**; el resto cerrado |
| `thumbsup` | 👍 Pulgar arriba | Puño cerrado con el **pulgar extendido hacia arriba**, bien separado del puño |

> **Ojo con estos dos pares**, son los que el modelo confundirá si los haces con desgana:
> - `rock` vs `thumbsup`: se diferencian **sólo en el pulgar**. En `rock` recógelo del todo; en `thumbsup` sepáralo bien y apúntalo claramente hacia arriba.
> - `scissors` vs `rockandroll`: abre bien la V de `scissors` y asegúrate de que en `rockandroll` el corazón y el anular quedan claramente doblados.

---

## 2. Instalación (sólo la primera vez)

**Necesitas Python 3.12.** No vale el 3.13 (aún no hay versión estable de MediaPipe).
Compruébalo con `py -0p`. Si no lo tienes: <https://www.python.org/downloads/release/python-3129/>
(marca **"Add python.exe to PATH"** al instalar).

Abre PowerShell y ejecuta, una línea cada vez:

```powershell
git clone https://github.com/javiersaguar/PIDS-Grabaci-n-Dataset.git
cd PIDS-Grabaci-n-Dataset
py -3.12 -m venv .venv
.venv\Scripts\python.exe -m pip install --upgrade pip
.venv\Scripts\python.exe -m pip install -r requirements.txt
```

La última tarda unos minutos (descarga ~150 MB). Si no tienes `git`, descarga el
ZIP desde el botón verde **Code → Download ZIP** y descomprímelo.

---

## 3. Pon tu identificador de participante

Abre `HAR_mediapipe\src\record_dataset.py` con el Bloc de notas (o VS Code) y busca,
cerca de la línea 60, el bloque `CONFIGURACION DE LA GRABACION`:

```python
PARTICIPANT = 'p1'      # <-- CAMBIA ESTO
```

Pon **el identificador que te haya asignado Javier** (`p2`, `p3`, `p4`...). Es lo único
que tienes que editar. **Si dos personas graban con el mismo identificador, una
machaca los datos de la otra.**

No toques `CLASSES`, `NUM_IMAGES_PER_CLASS` ni `TRAINING_PERCENTAGE`.

---

## 4. Grabar

Doble clic en **`grabar_dataset.bat`** (o, desde PowerShell en la carpeta del proyecto,
`.\grabar_dataset.bat`).

Se abre una ventana de vídeo y el proceso es, **para cada uno de los 6 gestos**:

1. La ventana muestra en verde **`Class to be recorded: <gesto>`**.
2. Coloca la mano haciendo ese gesto y **comprueba que se dibujan los puntos y líneas de colores sobre tu mano**. Si no aparecen, MediaPipe no te está detectando: acércate, mejora la luz o cambia el fondo (ver *Problemas* abajo). **No pulses nada hasta ver los landmarks.**
3. Pulsa **`s`** con la **ventana de vídeo enfocada** (no el terminal). Verás `Recording in progress...` en rojo y un contador `Stored images: N/100`.
4. Se captura **1 imagen por segundo durante 100 segundos**. Durante ese tiempo, **muévete** (ver reglas abajo).
5. Al llegar a 100 pasa al siguiente gesto y vuelve al punto 1.

Teclas: **`s`** empieza a grabar · **`q`** aborta.

Al final aparece `Recording finished successfully!!!`; pulsa `q` para cerrar.

### Reglas de calidad — esto es lo que hace que el modelo sirva para algo

Durante los 100 segundos de cada gesto, **no te quedes quieto**. Si no te mueves, las
100 imágenes son prácticamente el mismo fotograma repetido: el modelo memoriza tu
postura exacta y luego falla con cualquier otra persona. Varía **despacio y de forma
continua**:

- **Distancia**: acércate hasta ~30 cm de la cámara y aléjate hasta ~1 m, ida y vuelta, varias veces.
- **Ángulo**: gira la muñeca a izquierda y derecha, inclina la mano adelante y atrás.
- **Posición en el encuadre**: mueve la mano por las distintas zonas de la imagen (centro, arriba, abajo, izquierda, derecha). Esto importa más de lo que parece.
- **Mantén el gesto reconocible** todo el rato: mover no es deformar.

Y además:

- **Sólo tu mano en cuadro.** El sistema detecta una única mano; si sale otra persona detrás, puede engancharse a la suya.
- **Luz por delante, no por detrás.** No te pongas con una ventana a la espalda: la mano sale a contraluz y MediaPipe falla.
- **Fondo lo más liso posible** (una pared). Evita fondos con caras, pósters o mucho desorden.
- **Manga corta o remangado**, y sin guantes.

Si te equivocas de gesto o algo sale mal, pulsa `q`, borra la carpeta
`HAR_mediapipe\data\gestos_pids_<tu_id>\` entera y vuelve a empezar. Es preferible
repetir 12 minutos que enviar datos malos.

---

## 5. Dónde queda guardado

Dentro de la carpeta del proyecto, en:

```
HAR_mediapipe\data\gestos_pids_<tu_id>\
├── train\          70 imágenes por gesto
│   ├── ok\               ok_00001.jpg ... ok_00070.jpg
│   ├── paper\            paper_00001.jpg ...
│   ├── rock\
│   ├── rockandroll\
│   ├── scissors\
│   └── thumbsup\
└── test\           30 imágenes por gesto
    ├── ok\               ok_00071.jpg ... ok_00100.jpg
    └── ...
```

Son **600 imágenes JPG de 1280×720**, unos **120 MB** en total. El reparto 70/30
entre `train` y `test` lo hace el propio script; tú no tienes que separar nada.

La ruta completa te la imprime el script al terminar:
`[DATASET GUARDADO EN] C:\...\HAR_mediapipe\data\gestos_pids_p2`

### Comprueba antes de enviar

```powershell
Get-ChildItem -Recurse -File HAR_mediapipe\data\gestos_pids_p2 | Measure-Object | Select-Object Count
```

(cambia `p2` por tu identificador). Tiene que dar **600**. Y abre 3 o 4 imágenes al azar
de carpetas distintas para confirmar que se ve tu mano, que no están negras y que el
gesto es el que dice la carpeta.

---

## 6. Cómo enviar tu grabación

**No subas las imágenes a GitHub** (están en el `.gitignore` a propósito: 120 MB por
persona reventarían el repositorio).

1. Clic derecho sobre la carpeta `gestos_pids_<tu_id>` → **Enviar a → Carpeta comprimida**.
2. Sube el `.zip` (~110 MB) a Google Drive / WeTransfer y pasa el enlace a Javier.
3. En el mensaje indica: **tu identificador**, **qué mano** usaste (izquierda o derecha)
   y cualquier incidencia (p. ej. *"en `scissors` tuve que repetir"*).

---

## 7. Problemas frecuentes

| Síntoma | Causa y solución |
|---|---|
| La ventana se ve **completamente negra** | El **obturador físico** de la webcam está cerrado, o el interruptor de cámara del portátil (suele ser `Fn` + `F9`/`F10`, busca el icono de cámara tachada). Es el fallo más común. |
| `[ERROR] No se pudo abrir la camara` | Otra aplicación la está usando. Cierra **Teams, Zoom, Discord, Chrome** y vuelve a lanzarlo. |
| `[ERROR] No encuentro el entorno virtual .venv` | No hiciste el paso 2, o lo hiciste desde otra carpeta. Repite la instalación **dentro** de la carpeta del proyecto. |
| **No se dibujan los landmarks** sobre la mano | Poca luz, contraluz, mano demasiado lejos o fondo muy cargado. Acércate a ~50 cm, enciende una luz frontal y ponte contra una pared lisa. |
| `'py' no se reconoce` | Python no está en el PATH. Reinstálalo marcando *"Add python.exe to PATH"*, o usa `python -m venv .venv` en vez de `py -3.12 -m venv .venv`. |
| `ModuleNotFoundError: No module named 'mediapipe'` | Estás usando el Python del sistema en vez del del `.venv`. Usa siempre `grabar_dataset.bat`. |
| El vídeo va **a tirones** (~7 fps) | Es normal: MediaPipe tarda ~135 ms por fotograma a 720p en CPU. No afecta a la grabación, que va por reloj (1 imagen/segundo). |

---

## 8. Qué hay en este repositorio

```
.
├── grabar_dataset.bat              lanzador (doble clic)
├── requirements.txt                dependencias del kit de grabación
├── common\
│   ├── cameras.py                  acceso a la webcam
│   ├── gui.py                      textos y teclado
│   └── evaluation.py
└── HAR_mediapipe\
    ├── models\hand_landmarker.task modelo de MediaPipe (7.8 MB)
    └── src\
        ├── record_dataset.py       ← el script de grabación (aquí se edita PARTICIPANT)
        ├── config.py               clases, rutas y detector
        └── landmarksLib.py         extracción y dibujo de los 21 landmarks
```

El código de `common\` y `HAR_mediapipe\src\` viene del repositorio de la asignatura,
con parches para que funcione en Windows (el original usa `tty`/`termios`, que sólo
existen en Linux, e imprime emojis que rompen la consola de Windows). Los cambios
están documentados en comentarios `[PARCHE]` dentro de cada fichero.
