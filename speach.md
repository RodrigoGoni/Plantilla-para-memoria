# Speech — Presentación Final

## "Optimización biomecánica del ciclismo asistida por inteligencia artificial"

**Duración total: 30 minutos**
**Carrera de Especialización en Inteligencia Artificial — FIUBA — 2026**

---

> **Convenciones de formato:**
>
> - _[Acción]_ → indicación de gestos o transiciones visuales
> - **Tiempo acumulado** se indica al inicio de cada sección
> - El texto en cursiva son notas de apoyo, no se lee en voz alta

---

---

## Diapositiva 1 — Portada

### ⏱ Tiempo: 0:00 – 1:00 (1 minuto)

Buenos días a todos.

Se agradece al jurado — al Doctor Ingeniero David Marcelo De Yong, al Especialista Ingeniero Fernando Monzón y al Ingeniero Octavio Deshays — por el tiempo y la dedicación dedicados a la evaluación de este trabajo. Se agradece especialmente al director, el Magíster Fernando Corteggiano, por la guía permanente brindada a lo largo de todo el proceso.

El trabajo que se presenta hoy se titula **"Optimización biomecánica del ciclismo asistida por inteligencia artificial"**, y constituye el Trabajo Final de la Carrera de Especialización en Inteligencia Artificial de FIUBA.

_[Pausa breve. Mirar al jurado.]_

En los próximos treinta minutos se recorrerá el problema que motivó este trabajo, las decisiones de diseño, la implementación y los resultados obtenidos.

---

---

## Diapositiva 2 — Contexto y problemática

### ⏱ Tiempo: 1:00 – 2:30 (1 minuto 30 segundos)

_[Señalar la imagen con las tres posturas del ciclista.]_

Para comprender el problema, se plantea una pregunta simple: ¿qué tan importante es la posición del cuerpo sobre la bicicleta?

La respuesta que la bibliografía especializada nos da es contundente: **un ajuste incorrecto puede reducir la potencia de salida hasta un veinte por ciento**, y al mismo tiempo incrementar significativamente el riesgo de lesiones por sobreuso, especialmente en rodillas, zona lumbar y cuello.

_[Señalar las imágenes de izquierda a derecha.]_

La imagen ilustra tres situaciones típicas. A la izquierda, un balance correcto. En el centro, una posición demasiado larga y baja que fuerza la extensión lumbar. A la derecha, una posición demasiado corta y alta que carga las articulaciones de la rodilla.

Ahora bien, acceder a un análisis biomecánico profesional no es trivial. Las soluciones disponibles hoy son **costosas, escasas y presenciales**, lo que excluye a la gran mayoría de los ciclistas que se entrenan de manera recreativa o amateur.

Este es el punto de partida del trabajo.

---

---

## Diapositiva 3 — Estado del arte

### ⏱ Tiempo: 2:30 – 4:00 (1 minuto 30 segundos)

_[Señalar la imagen del túnel de viento.]_

El estado del arte en bike fitting puede organizarse en tres grandes categorías.

En primer lugar, los **laboratorios 3D y 4D**, que utilizan sistemas de cámaras infrarrojas como Retül o Vicon para rastrear marcadores reflectivos ubicados en puntos anatómicos clave. Estos sistemas ofrecen el análisis más preciso disponible, con captura dinámica en los tres planos del espacio. Sin embargo, su costo y disponibilidad los hacen inaccesibles para la mayoría.

En segundo lugar, la **aerodinámica asistida por inteligencia artificial**, donde se combina CFD —dinámica computacional de fluidos— con modelos de aprendizaje automático para estimar el coeficiente de arrastre sin necesidad de un túnel de viento real. La imagen de la derecha muestra un ciclista en un túnel de viento de laboratorio.

Y en tercer lugar, las **aplicaciones móviles 2D**, que han democratizado el acceso al análisis de video, pero que presentan limitaciones serias en cuanto a precisión, dado que no corrigen el error de perspectiva inherente a una cámara 2D.

**La brecha que identifica este trabajo está exactamente entre el segundo y el tercer nivel**: la posibilidad de ofrecer resultados de calidad comparable al laboratorio, pero con el bajo costo y accesibilidad de una aplicación móvil.

---

---

## Diapositiva 4 — Motivación y objetivos

### ⏱ Tiempo: 4:00 – 5:30 (1 minuto 30 segundos)

Sobre esa brecha se construye la motivación central del trabajo, que puede resumirse en una idea: **el ajuste biomecánico debe ser dinámico y continuo**, adaptándose a la evolución física del ciclista a lo largo del tiempo, y no un evento puntual y costoso.

El objetivo principal fue desarrollar un **prototipo inteligente** capaz de analizar la postura del ciclista a partir de video convencional, modelar su comportamiento biomecánico y proponer configuraciones optimizadas de la bicicleta mediante un algoritmo de optimización multi-objetivo.

El diseño del sistema estuvo gobernado por un **compromiso de tres objetivos** que son inherentemente contradictorios entre sí:

- **Maximizar la potencia mecánica** de pedaleo, lo que implica buscar la configuración más eficiente para la transmisión de fuerza.
- **Minimizar el riesgo de lesiones**, garantizando que los ángulos articulares se mantengan dentro de rangos seguros en todo momento.
- **Equilibrar la aerodinámica**, reduciendo el área frontal proyectada del ciclista para disminuir la resistencia al avance.

Ninguno de estos tres objetivos puede maximizarse individualmente sin perjudicar a los otros dos. Por eso la solución requiere, necesariamente, un enfoque multi-objetivo.

---

---

## Diapositiva 5 — Estimación de pose: MediaPipe BlazePose

### ⏱ Tiempo: 5:30 – 7:00 (1 minuto 30 segundos)

_[Señalar la imagen con el esqueleto superpuesto sobre el ciclista.]_

El primer pilar tecnológico del sistema es la **estimación de pose humana**. Esta es la capa de percepción: la que convierte el video crudo en información biomecánica procesable.

Se evaluaron varios modelos disponibles. La selección final fue **MediaPipe BlazePose**, una red neuronal convolucional desarrollada por Google que detecta **33 puntos anatómicos** del cuerpo humano, incluyendo pies y talones, que son críticos para el análisis del pedaleo. Se lo puede ver en la imagen: los puntos amarillos representan las articulaciones, y las líneas de colores representan los segmentos óseos.

Los criterios de selección frente a alternativas como HRNet o OpenPose fueron dos: la **cobertura anatómica completa** de las extremidades inferiores, y la **velocidad de inferencia**, que permite procesar video a tiempo real sin hardware especializado.

Sin embargo, BlazePose introduce ruido en las coordenadas de los puntos clave —lo que en la literatura se conoce como _jitter_—. Para resolver este problema, se incorporó un **Filtro Prior Cinemático**, que corrige las coordenadas en cada fotograma imponiendo la invarianza de la longitud de los segmentos óseos. Esta restricción biomecánica reduce los saltos espurios sin afectar la dinámica real del movimiento.

---

---

## Diapositiva 6 — Optimización multi-objetivo: NSGA-II

### ⏱ Tiempo: 7:00 – 9:00 (2 minutos)

_[Señalar el gráfico del frente de Pareto evolutivo.]_

El segundo pilar tecnológico es el algoritmo de optimización. El sistema de optimización elegido fue el **NSGA-II** — _Non-dominated Sorting Genetic Algorithm II_ —, un algoritmo genético multi-objetivo de codificación real.

El problema de optimización se define en un espacio de cuatro variables de decisión, que representan los cuatro parámetros ajustables de la bicicleta: la **altura y el retroceso del sillín**, y la **altura y el alcance del manillar**.

El algoritmo fue seleccionado por tres propiedades que lo hacen especialmente adecuado para este problema:

En primer lugar, su **robustez ante la no convexidad** del espacio de soluciones. La relación entre la configuración de la bicicleta y los objetivos biomecánicos no es lineal ni convexa.

En segundo lugar, su **tolerancia al ruido**, que es una propiedad fundamental cuando el modelo de evaluación de cada individuo incorpora señales de video filtradas.

Y en tercer lugar, su capacidad para **manejar discontinuidades** en las funciones de restricción, que aparecen cuando los ángulos articulares alcanzan los límites de los rangos seguros.

_[Señalar la evolución del frente de Pareto en el gráfico.]_

En el gráfico se puede observar la evolución del frente de Pareto a lo largo de cien generaciones. Las líneas punteadas grises representan los frentes de las generaciones intermedias, y los círculos de colores representan el frente final. La estrella amarilla marca la **solución de compromiso**, que es el punto del frente con la mínima distancia euclidiana normalizada al origen en el espacio de objetivos.

---

---

## Diapositiva 7 — Metodología CRISP-DM adaptada

### ⏱ Tiempo: 9:00 – 10:00 (1 minuto)

_[Señalar el diagrama circular.]_

Para estructurar el proceso de desarrollo, se adoptó la metodología **CRISP-DM** — _Cross-Industry Standard Process for Data Mining_ — adaptada al dominio biomecánico.

Las fases clásicas de comprensión del negocio, comprensión de los datos, preparación, modelado, evaluación y despliegue se mantienen, pero se traducen en términos del dominio específico: comprensión del problema biomecánico, adquisición de video y telemetría, preprocesamiento y filtrado, modelado físico e inversión dinámica, evaluación del frente de Pareto, y despliegue del reporte de recomendaciones.

Esta metodología permitió estructurar el trabajo en ciclos iterativos, lo que resultó fundamental cuando, durante la fase de adquisición, el primer dispositivo de captura demostró ser inadecuado y fue necesario replantear la estrategia de hardware.

---

---

## Diapositiva 8 — Arquitectura del pipeline

### ⏱ Tiempo: 10:00 – 12:00 (2 minutos)

_[Señalar el diagrama de bloques de arriba hacia abajo.]_

El sistema se implementó como un **pipeline de procesamiento modular** con retroalimentación de control cerrado. En el diagrama pueden ver el flujo completo de datos desde la adquisición hasta el reporte final.

El flujo se organiza en seis etapas principales:

**Etapa 0 — Filtrado de inicio:** Antes de cualquier procesamiento, se descartan automáticamente los fotogramas previos al pedaleo efectivo. El sistema analiza la telemetría del rodillo y detecta el instante en que se superan simultáneamente umbrales mínimos de potencia y cadencia durante al menos tres muestras consecutivas. Todo el video anterior a ese instante se descarta, garantizando que el modelo trabaja únicamente sobre ciclos de pedaleo reales.

**Etapa 1 — Adquisición:** Se captura de forma asíncrona el video del ciclista y la telemetría del rodillo inteligente. Estas dos fuentes tienen frecuencias de muestreo muy distintas: el video a 60 fotogramas por segundo, y la telemetría a 1 hertz.

**Etapa 2 — Sincronización y alineación temporal:** Se alinean ambas fuentes de datos en el tiempo utilizando la **metadata temporal** embebida en cada registro: las marcas de tiempo del video y las del archivo JSON exportado por GoldenCheetah se usan como referencia común para determinar el offset entre ambas fuentes.

**Etapa 3 — Percepción y procesamiento:** Se ejecuta BlazePose sobre cada fotograma, se aplican los filtros cinemáticos y de Kalman, y se calculan los ángulos articulares del ciclo de pedaleo.

**Etapa 4 — Modelado físico y optimización:** Los datos cinemáticos alimentan el gemelo digital del ciclista, que computa la dinámica inversa y estima el CdA. Luego, el NSGA-II explora el espacio de configuraciones y genera el frente de Pareto.

**Etapa 5 — Salida y retroalimentación:** El frente de Pareto produce la solución de compromiso, que se traduce en recomendaciones concretas de ajuste expresadas en milímetros, y se genera el reporte visual aumentado.

La **modularidad** de esta arquitectura fue una decisión de diseño deliberada, que permitió actualizar los modelos de red neuronal y los parámetros del algoritmo genético de forma independiente.

---

---

## Diapositiva 9 — Adquisición de datos y sincronización

### ⏱ Tiempo: 12:00 – 14:00 (2 minutos)

_[Señalar la imagen del ciclista en escala de grises.]_

Vale la pena detenerse en la adquisición de datos, porque fue donde se manifestaron los primeros desafíos técnicos del trabajo, y porque el sistema maneja dos fuentes de datos completamente distintas que deben integrarse de forma coherente.

**Video — captura cinemática:**

La primera cámara evaluada fue una **Microsoft LifeCam HD-3000**, una cámara USB estándar. Las pruebas iniciales mostraron que el desenfoque de movimiento (_motion blur_) producido durante el pedaleo a 90 RPM era inaceptable. Los fotogramas borrosos eran rechazados por el modelo de estimación de pose, haciendo imposible el análisis. La solución fue adoptar el **Google Pixel 8 Pro** como dispositivo de captura, conectado vía USB a la computadora mediante la aplicación **DroidCam**. Este dispositivo permite configurar tiempos de exposición de hasta 1/500 de segundo y capturar a 60 FPS, lo que elimina prácticamente el desenfoque en las extremidades del ciclista.

**Rodillo inteligente — captura de telemetría:**

La segunda fuente de datos es el **rodillo inteligente**, que registra potencia, cadencia, frecuencia cardíaca y velocidad mediante el protocolo inalámbrico **ANT+**. Para la recepción y almacenamiento de estos datos se utilizó **GoldenCheetah**, un software de código abierto para el análisis del entrenamiento deportivo, que actúa como interfaz entre el rodillo y el sistema. Los datos se exportan en formato **JSON** a una frecuencia de **1 Hz** —una muestra por segundo—, lo que contrasta significativamente con los 60 fotogramas por segundo del video. Esta disparidad de frecuencias es uno de los desafíos técnicos centrales que se resolvieron durante el desarrollo.

_[Señalar aspectos de la imagen.]_

Para la **sincronización entre ambas fuentes**, se utilizó la **metadata temporal** de cada registro: las marcas de tiempo del video y las del archivo JSON exportado por GoldenCheetah se compararon directamente para determinar el offset entre ambas fuentes y alinearlas con precisión de fotograma.

La **calibración métrica** es el paso que permite que el sistema opere en unidades reales en lugar de píxeles. Se utilizó la rueda de la bicicleta de formato 700c, cuyo diámetro nominal de llanta es de 622 mm. En cada sesión, el sistema identifica la rueda en la imagen y mide su diámetro en píxeles, estableciendo así un factor de escala píxeles-milímetros específico para esa grabación. Sin esta calibración, las longitudes de segmento óseo calculadas y las fuerzas estimadas carecen de dimensión física y el modelo biomecánico no puede operar correctamente.

Por último, una vez aplicada la calibración y el filtrado de inicio, se ejecuta el **filtro de inicio de captura** sobre el video ya sincronizado: se recortan todos los fotogramas anteriores al instante de inicio del pedaleo detectado en la telemetría, dejando solo los ciclos de pedaleo efectivo para el análisis.

---

---

## Diapositiva 10 — Modelado cinemático: filtro de Kalman

### ⏱ Tiempo: 14:00 – 15:30 (1 minuto 30 segundos)

_[Señalar el gráfico izquierdo con la señal RAW en rojo, y luego el derecho con Kalman en azul.]_

Incluso después de resolver el problema de desenfoque, las coordenadas de los puntos clave detectados por BlazePose presentaban ruido de alta frecuencia. En el gráfico de la izquierda pueden observar la señal cruda de la coordenada x de la rodilla izquierda: la desviación estándar es de 0,018 unidades normalizadas, y se aprecian saltos espurios superpuestos al movimiento periódico del pedaleo.

Para abordar este problema, se implementó un **filtro de Kalman univariado** independiente para cada coordenada de cada punto anatómico.

El resultado se observa en el gráfico de la derecha. La señal filtrada tiene una desviación estándar de 0,014 unidades normalizadas, una reducción de aproximadamente el 19%, y el movimiento periódico del pedaleo se preserva completamente.

Este resultado es especialmente relevante en este problema: dado que el análisis biomecánico trabaja sobre **desplazamientos de puntos anatómicos**, el ruido de alta frecuencia se amplifica en el cálculo de ángulos y velocidades angulares, produciendo errores que pueden ser del mismo orden de magnitud que la señal de interés. Suprimir ese ruido es, por lo tanto, una condición necesaria para que los momentos articulares calculados sean físicamente plausibles.

---

---

## Diapositiva 11 — Dinámica inversa y gemelo digital

### ⏱ Tiempo: 15:30 – 17:30 (2 minutos)

_[Señalar la imagen del esqueleto 2D superpuesto sobre la foto.]_

Con las series temporales de puntos clave filtradas, el siguiente paso fue construir el **gemelo digital del ciclista**: un modelo biomecánico plano 2D que representa la cadena cinemática pedal-tobillo-rodilla-cadera.

El modelo resuelve el problema de **dinámica inversa** mediante el algoritmo de Newton-Euler recursivo. P`artiendo de las fuerzas en el pedal, se propaga el cálculo articulación por articulación hacia la cadera. Esto permite estimar los momentos de reacción articular en cada instante del ciclo.

La **potencia articular** se calcula mediante la ecuación:

> P = M_joint · (θ̇_prox − θ̇_dist)

Donde M_joint es el momento articular y las derivadas del ángulo son la velocidad angular proximal y distal del segmento.

_[Señalar la imagen del esqueleto.]_

El gemelo digital también incorpora la **estimación aerodinámica**. Se implementó el modelo de Heil más Bassett, que estima el coeficiente de arrastre CdA a partir del ángulo de inclinación del torso, la altura y el peso del ciclista, sin necesidad de un túnel de viento. Esto permite incluir el objetivo aerodinámico en el optimizador utilizando únicamente las medidas obtenidas del video.

La parametrización del modelo con la morfología real del ciclista —longitudes segmentarias, masas, centros de masa— fue fundamental para garantizar la personalización de las recomendaciones.

---

---

## Diapositiva 12 — Funciones objetivo del optimizador

### ⏱ Tiempo: 17:30 – 19:00 (1 minuto 30 segundos)

El NSGA-II minimiza simultáneamente tres funciones objetivo, cada una representando una dimensión del compromiso biomecánico.

**J_comfort — Seguridad articular:** Es una **función de penalización cuadrática** —es decir, un costo que el optimizador busca reducir a cero—. Crece cuando los ángulos articulares de rodilla, tobillo, cadera u hombro se devía de los rangos seguros definidos por la literatura clínica. Para la rodilla, por ejemplo, el rango seguro durante el pedaleo es de 70 a 147 grados. Un valor de J_comfort cercano a cero significa que las articulaciones están dentro del rango en todo el ciclo; un valor alto significa que la configuración propuesta fuerza alguna articulación fuera de ese rango, lo que se traduce en riesgo de lesión. El nombre puede resultar contraintuitivo: **más J_comfort significa más incomodidad articular**, no menos, porque es un costo.

**J_power — Eficiencia mecánica:** Minimiza la suma de los cuadrados de los momentos articulares a lo largo del ciclo. Una menor carga cuadrática está asociada con un reclutamiento preferencial de fibras musculares de tipo I, que son las fibras de resistencia, lo que se traduce en mayor eficiencia metabólica para esfuerzos sostenidos.

**J_aero — Aerodinámica:** Minimiza el área frontal proyectada del ciclista, que es función del ángulo de inclinación del torso. A mayor inclinación hacia adelante, menor resistencia al avance, pero mayor carga en las muñecas y el cuello.

La tensión entre estas tres funciones es la que da lugar al frente de Pareto: no existe una única solución óptima, sino un **conjunto de soluciones no dominadas** que representa el mejor compromiso alcanzable entre los tres objetivos.

---

---

## Diapositiva 13 — Protocolo de prueba y equipamiento

### ⏱ Tiempo: 19:00 – 20:30 (1 minuto 30 segundos)

_[Señalar el gráfico de potencia en escalera.]_

A continuación se describe el protocolo experimental que generó los datos de entrada del sistema.

El protocolo de prueba fue un **ensayo de rampa incremental** que comenzó en 130 vatios y escaló hasta 250 vatios, manteniendo una cadencia constante de 90 RPM. En el gráfico puede observarse la traza de potencia registrada durante el ensayo a través de **GoldenCheetah**: los escalones son claramente visibles, y la potencia media durante todo el protocolo fue de 193,3 vatios. Cada escalón se mantuvo durante aproximadamente dos minutos, permitiendo que el organismo alcanzara un estado cuasi-estacionario antes de incrementar la carga.

_[Señalar los escalones en la gráfica.]_

La elección de un protocolo de rampa —en lugar de una carga constante— fue deliberada: permite capturar la variabilidad biomecánica del ciclista bajo distintos niveles de esfuerzo, enriqueciendo el modelo de entrada del optimizador con condiciones representativas de un entrenamiento real. El rodillo registró simultáneamente potencia, cadencia, frecuencia cardíaca y velocidad, todos con marca temporal precisa para su posterior alineación con el video.

---

---

## Diapositiva 14 — Interpolación de telemetría

### ⏱ Tiempo: 20:30 – 21:30 (1 minuto)

_[Señalar el gráfico de frecuencia cardíaca.]_

Como se mencionó en la etapa de adquisición, existe una **disparidad crítica de frecuencias de muestreo** entre las dos fuentes de datos: el video opera a 60 fotogramas por segundo, mientras que GoldenCheetah registra la telemetría del rodillo a 1 hertz mediante ANT+. Esto implica que por cada muestra de potencia o cadencia disponible, existen 60 fotogramas de video sin dato asociado.

Para resolver esta discrepancia, se implementó una **interpolación mediante spline cúbico** que eleva la telemetría de 1 Hz a la frecuencia del video. En el gráfico pueden ver un ejemplo con la frecuencia cardíaca: los puntos rojos son las muestras originales a 1 Hz, y la línea continua es la señal interpolada.

---

---

## Diapositiva 15 — Resultado: frontera de Pareto

### ⏱ Tiempo: 21:30 – 23:30 (2 minutos)

_[Señalar el gráfico de Pareto 2D con la estrella amarilla.]_

El resultado central del sistema es el **frente de Pareto** obtenido tras cien generaciones del NSGA-II. En el eje horizontal se muestra J_comfort y en el eje vertical J_power. Antes de leer el gráfico es importante recordar que **ambos ejes son costos**: valores bajos son mejores en los dos. J_comfort bajo significa articulaciones dentro del rango seguro; J_comfort alto significa que la configuración fuerza alguna articulación fuera de ese rango. J_power bajo significa carga mecánica eficiente; J_power alto significa mayor estrés muscular.

La razón por la que estos dos objetivos se contraponen en el frente tiene una explicación biomecánica directa: las configuraciones que reducen la carga mecánica —sillín más alto, manillar más cercano— tienden a llevar la rodilla hacia ángulos de extensión máxima que superan los 147 grados, disparando la penalización de J_comfort. A la inversa, las configuraciones que mantienen los ángulos articulares dentro del rango seguro a veces implican una posición menos eficiente mecánicamente.

El color de cada punto representa el valor de J_aero: tonos cálidos indican mayor resistencia aerodínamica, tonos fríos indican mejor aerodínamica.

Lo que se observa en el gráfico es exactamente el **compromiso esperado**: en el extremo superior izquierdo están las soluciones con bajo riesgo articular pero alta carga mecánica. En el extremo inferior derecho están las soluciones eficientes mecánicamente, pero que comprometen la seguridad articular. Ninguna soluciona los tres objetivos al mismo tiempo: ese es precisamente el frente de Pareto.

La **estrella amarilla** marca la solución de compromiso seleccionada automáticamente: el punto del frente con la mínima distancia euclidiana normalizada al origen en el espacio de objetivos normalizados. Esta elección equilibra los tres criterios de forma objetiva, sin requerir la definición a priori de pesos subjetivos.

_[Pausa breve.]_

Este resultado fue el primero en la literatura —hasta donde llega la revisión bibliográfica de este trabajo— que combina la estimación de CdA sin túnel de viento con un algoritmo NSGA-II para la optimización conjunta de confort, potencia y aerodinámica a partir únicamente de video monoscópico 2D.

---

---

## Diapositiva 16 — Validación cinemática: antes y después

### ⏱ Tiempo: 23:30 – 25:00 (1 minuto 30 segundos)

_[Señalar imagen izquierda — configuración actual — y luego imagen derecha — optimizada.]_

Para validar el resultado, se comparó la configuración actual del ciclista con la configuración propuesta por el optimizador.

En la imagen de la izquierda pueden ver la **configuración actual**: ángulo de rodilla de 130,6 grados, tobillo de 123,3 grados, cadera de 89,1 grados, hombro de 86,1 grados, y torso a 38,2 grados respecto de la vertical. Todos los ángulos están dentro de los rangos seguros, pero la configuración no es óptima en cuanto a aerodinámica y potencia.

En la imagen de la derecha está la **configuración optimizada**: el torso se inclina más hacia adelante —32,2 grados—, mejorando la aerodinámica. El ángulo de rodilla baja a 126,2 grados, lo que queda perfectamente dentro del rango seguro de 70 a 147 grados. La cadera pasa a 79,7 grados y el hombro a 92,2 grados.

El mensaje principal es que el sistema logra **una mejora aerodinámica y mecánica simultánea, sin comprometer la seguridad articular**. La rodilla, que es la articulación más vulnerable en el ciclismo, queda dentro del rango seguro en todo momento.

---

---

## Diapositiva 17 — Validación cinemática: ángulo de rodilla

### ⏱ Tiempo: 25:00 – 26:30 (1 minuto 30 segundos)

_[Señalar el gráfico del ciclo de pedaleo.]_

Este gráfico muestra el ángulo de la rodilla a lo largo de un ciclo completo de pedaleo, desde el punto muerto superior —TDC en el eje horizontal— hasta el regreso al TDC.

Los puntos rojos representan los ángulos medidos en los fotogramas del video en la **configuración actual**. Los diamantes verdes representan los ángulos simulados por el gemelo digital en la **configuración optimizada**.

Cabe destacar lo siguiente: en la configuración actual, los puntos rojos presentan **dispersión** considerable —se distribuyen en una nube— lo que refleja la variabilidad ciclo a ciclo debida al ruido residual. En contraste, la curva verde es suave y continua, porque es producida por el modelo analítico.

Más importante aún: la configuración optimizada **mantiene el ángulo de rodilla dentro del rango seguro de 70 a 147 grados durante toda la fase activa del pedaleo**, lo que confirma que el modelo de restricción biomecánica está actuando correctamente.

El punto blanco en el gráfico es el fotograma actual en el instante 177 grados de fase, con un ángulo de 130,6 grados, que coincide con lo mostrado en la diapositiva anterior.

---

---

## Diapositiva 18 — Diagnóstico visual aumentado

### ⏱ Tiempo: 26:30 – 27:30 (1 minuto)

_[Señalar la imagen con los overlays de ángulos.]_

Para cerrar el lazo de control humano, el sistema genera un **reporte visual aumentado**: cada fotograma del video tiene superpuestos los marcadores articulares, las líneas del esqueleto y las etiquetas con los ángulos calculados en tiempo real.

Este reporte cumple dos funciones. Por un lado, permite al ingeniero biomecánico o al entrenador **verificar visualmente** que el modelo está interpretando correctamente la postura del ciclista antes de confiar en las recomendaciones. Por otro lado, sirve como herramienta de **comunicación con el ciclista**, que puede ver directamente cuál es su postura actual y cómo cambia con el ajuste.

En la imagen pueden ver la posición optimizada proyectada con los ángulos superpuestos: torso a 28,4 grados, hombro a 93 grados, cadera a 61,3 grados, rodilla a 116,2 grados y tobillo a 126,2 grados. Todos en la zona verde del rango seguro.

---

---

## Diapositiva 19 — Recomendaciones de ajuste físico

### ⏱ Tiempo: 27:30 – 29:00 (1 minuto 30 segundos)

_[Señalar la tabla.]_

El último paso del pipeline es la **traducción de la solución óptima en recomendaciones concretas**, expresadas en los parámetros físicos ajustables de la bicicleta real.

La tabla que ven en pantalla resume las cuatro recomendaciones generadas por el sistema para este ciclista:

- El **sillín** debe moverse **13,5 milímetros hacia atrás** para ajustar el fore/aft, y subirse **11,4 milímetros** en altura.
- El **manillar** debe acortarse **23 milímetros en alcance** (_reach_), y bajarse **26,4 milímetros en altura** (_stack_).

Dos notas técnicas sobre estas recomendaciones: la reducción del reach de 23 mm es consistente con la compensación de una potencia de 120 mm instalada, que es mayor a lo recomendado para el perfil de este ciclista. Y la reducción del stack de 26,4 mm equivale físicamente a retirar aproximadamente dos espaciadores de la pipa de dirección, que es un ajuste completamente reversible y gratuito.

Este nivel de especificidad y accionabilidad es lo que distingue a este sistema de una simple herramienta de análisis de postura.

---

---

## Diapositiva 20 — Conclusiones generales

### ⏱ Tiempo: 29:00 – 30:30 (1 minuto 30 segundos)

_[Hacer contacto visual con el jurado.]_

A modo de cierre, se resumen los aportes principales de este trabajo.

Se desarrolló un **pipeline completo y robusto** que integra visión artificial, modelado biomecánico y algoritmos evolutivos para producir recomendaciones de ajuste personalizadas a partir de video convencional.

Los problemas prácticos que emergieron durante el desarrollo —el desenfoque de movimiento, la falta de sincronización, el ruido en los puntos clave— se resolvieron con soluciones de ingeniería concretas y reproducibles: la sustitución de la cámara, la correlación cruzada, y los filtros cinemático y de Kalman.

El resultado más significativo es que el sistema **logra resultados comparables a los de un laboratorio profesional**, sin marcadores físicos ni instrumentos invasivos, utilizando únicamente un teléfono móvil y hardware estándar de entrenamiento.

El grado de cumplimiento de los requerimientos definidos en la etapa de planificación fue del **89%**, con 26 de 29 criterios de aceptación cumplidos.

_[Pausa.]_

El aporte principal de este trabajo, en términos de impacto, es la **democratización del bike fitting de precisión**: hacer accesible un análisis biomecánico dinámico y personalizado para cualquier ciclista, con independencia de su presupuesto o ubicación geográfica.

---

---

## Diapositiva 21 — Trabajo futuro

### ⏱ Tiempo: 30:00 – 31:00 (1 minuto)

_[Nota: si el tiempo lo permite al llegar aquí, esta diapositiva se presenta; si no, se menciona en las conclusiones y se pasa a preguntas.]_

Las líneas de trabajo futuro identificadas son cuatro:

Primero, la integración de **sensores de potencia bilaterales** —como los pedales Garmin Rally RK 200— para validar experimentalmente el modelo de dinámica inversa contra mediciones reales de fuerza.

Segundo, la **extensión del modelo biomecánico** al tren superior: brazos, hombros y cuello, que son relevantes para la postura en manillar de triatlón o posición aerodinámica.

Tercero, la **generalización del modelo** mediante una muestra ampliada de ciclistas de distintos niveles, morfologías y disciplinas.

Y cuarto, el **despliegue en producción** como aplicación web con soporte multi-usuario, historial longitudinal del ciclista y retroalimentación automática tras cada sesión de entrenamiento.

---

---

## Diapositiva 22 — Demostración en video

### ⏱ Tiempo: 31:00 – 31:30 (30 segundos)

_[Si el tiempo permite mostrar el video, reproducirlo. Si no, describir brevemente.]_

En el enlace disponible en esta diapositiva pueden acceder a un video de demostración del sistema en funcionamiento, que muestra el pipeline completo desde la captura de video hasta la generación del reporte, incluyendo la interfaz web del visualizador del pipeline con el DAG de pasos y el estado en tiempo real de cada etapa.

---

---

## Diapositiva 23 — ¿Preguntas?

### ⏱ Tiempo: 31:30 – 32:00 (30 segundos)

Esto concluye la presentación.

Se queda a disposición del jurado y del director para responder las preguntas y observaciones que se consideren pertinentes.

Muchas gracias.

---

---

## Anexo: Posibles preguntas del jurado y respuestas sugeridas

### ¿Por qué NSGA-II y no NSGA-III u otro algoritmo multi-objetivo?

NSGA-III está diseñado para problemas con cuatro o más objetivos, donde la preservación de la diversidad en espacios de alta dimensión es crítica. Con tres objetivos, NSGA-II ofrece un balance adecuado entre exploración del frente de Pareto y velocidad de convergencia, y su implementación está bien documentada en la literatura biomecánica. La elección fue también pragmática: la disponibilidad de implementaciones robustas en Python (pymoo) con codificación real facilitó la integración con el pipeline existente.

### ¿Cómo se validó el modelo de dinámica inversa?

La validación en esta instancia es indirecta: se compara la distribución de ángulos articulares producida por el modelo con los rangos reportados en la literatura clínica para ciclistas de rendimiento similar. La validación directa —contra mediciones de fuerza reales con pedales instrumentados— es uno de los trabajos futuros identificados, que requiere los sensores Garmin Rally RK 200.

### ¿Por qué se usó solo un ciclista? ¿Los resultados son generalizables?

El trabajo es un prototipo de validación de concepto. El objetivo no era la generalización estadística sino demostrar la viabilidad técnica del pipeline completo. La arquitectura del sistema es completamente paramétrica respecto al perfil morfológico del ciclista, lo que significa que puede aplicarse a cualquier sujeto con solo actualizar los parámetros antropométricos. La generalización con una muestra ampliada es un trabajo futuro explícitamente identificado.

### ¿Cuál es la precisión del sistema comparada con un sistema 3D profesional?

No existe una validación cruzada directa con un sistema Retül o Vicon en este trabajo. Sin embargo, los ángulos articulares medidos en la configuración actual están dentro del rango de variación reportado en la literatura para ciclistas con características similares, lo que sugiere que el sistema es plausible. La precisión absoluta en comparación con captura 3D requeriría un estudio de campo con ambos sistemas en paralelo.

### ¿El sistema funciona en tiempo real?

La inferencia de BlazePose puede ejecutarse a tiempo real en hardware estándar. Sin embargo, el pipeline completo —incluyendo el NSGA-II con cien generaciones y una población de cincuenta individuos— tiene una latencia de varios minutos en CPU convencional. El sistema no está diseñado para operar en tiempo real durante el pedaleo, sino como herramienta de análisis post-sesión. El despliegue en tiempo real es posible con aceleración GPU y reduciendo el número de generaciones.

### ¿Qué ocurre si el ciclista no pedalea en el plano sagital perfectamente alineado con la cámara?

El sistema incluye una corrección de perspectiva básica basada en la calibración métrica con la rueda. Sin embargo, si el ciclista presenta desviación lateral significativa respecto al plano focal, los ángulos articulares calculados incorporarán el error de proyección de perspectiva propio del análisis 2D. Este es el mismo problema que afecta a todas las aplicaciones móviles 2D, y es la razón fundamental por la cual los sistemas 3D con múltiples cámaras ofrecen mayor precisión para análisis fuera del plano sagital.

---

## Preguntas probables — perfil Ingeniería Mecatrónica

*Focalizadas en modelado físico, dinámica, sensores y control.*

---

### ¿Por qué se eligió un modelo plano 2D y no un modelo 3D con dinámica multicuerpo?

El análisis se restringe al plano sagital porque es donde ocurre el 90% del trabajo mecánico del pedaleo y donde la proyección de una cámara lateral introduce el menor error. Un modelo 3D requeriría al menos dos cámaras calibradas entre sí, marcadores físicos o un sistema de captura multi-vista, lo que contradice el objetivo de democratización del sistema. El error introducido por la proyección 2D en el plano sagital está acotado y es del mismo orden de magnitud que la incertidumbre de BlazePose, por lo que no constituye la limitación dominante del sistema.

### ¿Cómo se maneja la indeterminación estática de la dinámica inversa sin medir las fuerzas directamente?

La dinámica inversa de Newton-Euler requiere como entrada las fuerzas en el extremo distal de la cadena, es decir, en el pedal. Dado que no se dispone de un sensor de fuerza en el pedal durante el ensayo principal, esa fuerza se estima a partir de la potencia registrada por el rodillo, la cadencia y el modelo cuadrático de distribución de fuerza en la fase de potencia. Es una estimación: la fuerza tangencial en el pedal se calcula como P/(ω·r), donde ω es la velocidad angular de la biela y r es la longitud del brazo de manivela. El modelo cuadrático ajusta esa fuerza en función del ángulo de fase del pedal según los datos del Garmin Rally, no se asume fuerza constante.

### ¿El filtro de Kalman implementado es un filtro de posición pura o incluye modelo dinámico?

Es un filtro de Kalman univariado de orden uno: el estado es la posición del punto clave en cada eje y el modelo de transición asume velocidad constante (modelo cinemático de movimiento uniforme). No se modela aceleración. Esto es suficiente para las frecuencias de movimiento del pedaleo —entre 1 y 2 Hz a 60-90 RPM— dado que el video a 60 FPS muestrea con factor 30 respecto a la dinámica de interés.

### ¿Cuáles son las hipótesis del modelo de Heil-Bassett para estimar CdA y cuándo dejan de ser válidas?

El modelo de Heil-Bassett es un modelo empírico que correlaciona el ángulo de inclinación del torso, la altura y el peso del ciclista con el CdA medido en túnel de viento para una muestra de ciclistas de ruta. Sus hipótesis son: geometría corporal estándar, posición de ruta en manillar bajo, equipamiento aerodinámica neutro y ausencia de viento lateral. El modelo deja de ser válido para posiciones de triatlón (aerobarras), ciclistas de morfología muy atípica, o cuando el equipo (casco, maillot, bici) difiere significativamente del equipamiento de referencia de la muestra original.

### ¿Cómo se determinaron los rangos articulares seguros de 70°-147° para la rodilla?

Los rangos se extrajeron de la revisión de literatura biomecánica especializada en ciclismo. El límite superior de 147° para la rodilla corresponde al ángulo máximo de extensión en el punto muerto inferior del pedaleo, según las recomendaciones de Pruitt y Matheny (2006) y la revisión de Bini et al. (2011). El límite inferior de 70° corresponde al ángulo de flexión máxima en el punto muerto superior. Valores fuera de estos rangos están asociados estadísticamente con síndrome patelofemoral y tendinitis rotuliana en ciclistas.

### ¿Cómo se calcula el centro de rotación virtual del pedal si BlazePose no detecta el pedal directamente?

BlazePose detecta el talón y la punta del pie. El centro de rotación del pedal se estima geométricamente proyectando un punto sobre el segmento pie-tobillo a una distancia fija desde el tobillo, proporcional a la longitud del pie medida en la imagen. Esa longitud se calibra con el factor de escala píxeles-milímetros de la rueda 700c. Es una aproximación: el pedal real puede desplazarse algunos milímetros respecto a ese punto según la posición del pie sobre el pedal, pero el error resultante en el ángulo de fase es menor a 3-5 grados, que está dentro del ruido del propio modelo.

---

## Preguntas probables — perfil Telecomunicaciones / Procesamiento de señales

*Focalizadas en adquisición, filtrado, sincronización, compresión y sistemas de tiempo real.*

---

### ¿Por qué se eligió spline cúbico para la interpolación de telemetría y no interpolación lineal o un filtro de reconstrucción tipo sinc?

La interpolación lineal produce discontinuidades en la primera derivada (velocidad de cambio) en cada muestra original, lo que genera artefactos visibles como "esquinas" en las transiciones entre escalones de potencia. El filtro sinc ideal (reconstrucción de Nyquist) sería teóricamente óptimo pero requiere que la señal sea de banda limitada, lo que no se cumple estrictamente para señales fisiológicas con transitorios. El spline cúbico ofrece continuidad hasta la segunda derivada, es computacionalmente liviano y produce interpolaciones suaves que son visualmente coherentes con la fisiología del ciclista. Para señales a 1 Hz interpoladas a 60 Hz, el criterio dominante es la suavidad, no la fidelidad de alta frecuencia.

### ¿Cómo se garantiza que la sincronización por metadata temporal es precisa si el reloj del teléfono y el del rodillo pueden estar desincronizados?

Es una limitación real del sistema. La sincronización por metadata asume que el reloj del dispositivo de video (Pixel 8 Pro) y el reloj interno del sistema que timestampea el JSON de GoldenCheetah están sincronizados con NTP o son suficientemente estables. En la práctica, la deriva de reloj entre ambos dispositivos en una sesión de 15-20 minutos es del orden de decenas de milisegundos, lo que equivale a menos de 2 fotogramas a 60 FPS. Para el análisis biomecánico ese error es despreciable, pero es una fuente de incertidumbre que en un sistema de producción debería resolverse con un protocolo de sincronización explícito —como un pulso visual o sonoro registrado simultáneamente en ambas fuentes.

### ¿Cuál es el ancho de banda de la señal biomecánica útil y cómo se relaciona con la frecuencia de muestreo de 60 FPS?

Las articulaciones del ciclista durante el pedaleo generan movimiento a la frecuencia de pedaleo (1-2 Hz para 60-90 RPM) y sus armónicos, que para análisis biomecánico relevante llegan hasta aproximadamente 10-15 Hz. A 60 FPS el teorema de Nyquist garantiza fidelidad hasta 30 Hz, lo que ofrece un margen cómodo. El filtro de Kalman actúa como filtro pasa-bajos adaptativo que suprime las componentes de alta frecuencia (ruido de detección de BlazePose, que puede llegar a 10-15 Hz) sin afectar el contenido biomecánico útil por debajo de 5 Hz.

### ¿Por qué no se usó un filtro Butterworth pasa-bajos en lugar del filtro de Kalman?

Un filtro Butterworth de fase cero (aplicado con filtfilt) sería equivalente en términos de respuesta en frecuencia, pero introduce distorsión en los extremos de la señal (efecto borde) y requiere definir a priori la frecuencia de corte. El filtro de Kalman se adapta automáticamente a la varianza de la señal y no requiere parametrización manual de la frecuencia de corte. Además, el filtro de Kalman es causal, lo que permite una eventual implementación en tiempo real sin procesamiento hacia atrás.

### ¿Cuántos fotogramas se procesaron en total y cuál fue el tiempo de procesamiento del pipeline completo?

Se procesaron más de 26.000 fotogramas en la sesión de análisis principal. El tiempo de procesamiento del pipeline completo —incluyendo inferencia de BlazePose, filtrado, cálculo de ángulos y optimización NSGA-II— fue del orden de varios minutos en CPU estándar. La etapa más costosa computacionalmente es la inferencia de BlazePose (alrededor de 50-100 ms por fotograma en CPU), seguida por el NSGA-II. Con aceleración GPU la inferencia puede reducirse a 5-10 ms por fotograma, llevando el tiempo total a menos de un minuto.

### ¿Cómo se detecta el inicio del pedaleo en el video y qué tan robusto es ese detector ante falsos positivos?

El detector de inicio usa la telemetría del rodillo: busca el primer instante en que potencia ≥ 80 W y cadencia ≥ 60 RPM se mantienen durante al menos 3 muestras consecutivas (3 segundos a 1 Hz). Los umbrales fueron elegidos para evitar que movimientos preparatorios —giro lento del pedal antes de arrancar— se interpreten como pedaleo efectivo. La robustez es razonable para sesiones estructuradas en rodillo, pero podría necesitar ajuste para captura en exteriores donde la potencia varía más abruptamente.

---

_Fin del speech._
