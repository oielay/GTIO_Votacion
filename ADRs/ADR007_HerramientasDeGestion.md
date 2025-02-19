# Herramientas de gestión

* EstaComdo: aceptada
* Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango, Urki Aristu y Oier Layana.
* Fecha: 15/02/2025

Historia técnica: [Issue #4](https://github.com/oielay/GTIO_Votacion/issues/4)

## Contexto y Planteamiento del Problema
El equipo de desarrollo necesita una herramienta de gestión de tareas que se integre de manera eficiente con nuestro flujo de trabajo en GitHub. Actualmente, consideramos varias opciones, incluyendo GitHub Projects (Kanban), Trello y Jira, evaluando su nivel de integración con nuestro ecosistema, facilidad de uso y funcionalidades clave. La decisión debe favorecer la automatización, visibilidad del trabajo y reducción de herramientas externas.

## Opciones Consideradas

* GitHub Projects (Kanban): Una herramienta de gestión de tareas integrada en GitHub, diseñada para sincronizar issues y pull requests en un flujo de trabajo ágil.
* Trello: Plataforma visual de gestión de proyectos basada en tableros, ideal para equipos que buscan simplicidad y flexibilidad en la organización de tareas.
* Jira: Software avanzado para la gestión de proyectos ágiles, especialmente útil en entornos de desarrollo que requieren flujos de trabajo personalizados y detallados.

## Factores en la Decisión
* Integración con GitHub → Permite conectar issues, pull requests y automatizaciones con GitHub Actions.
* Automatización del flujo de trabajo → Reducción de tareas manuales mediante reglas automáticas.
* Visibilidad y trazabilidad → Seguimiento directo del progreso dentro del ecosistema de GitHub.
* Curva de aprendizaje → Uso intuitivo para equipos familiarizados con GitHub, sin necesidad de herramientas adicionales.
* Reducción de herramientas externas → Evita la fragmentación del flujo de trabajo en múltiples plataformas.
* Simplicidad y eficiencia → Sin configuraciones complejas, facilitando la adopción en el equipo.
* Costo → Incluido en GitHub sin necesidad de licencias adicionales en comparación con Jira.

## Decisión

Tras evaluar diversas opciones, se ha decidido utilizar GitHub Projects (Kanban) como la herramienta principal de gestión de tareas. Esta elección se basa en su integración nativa con GitHub, la automatización del flujo de trabajo y la capacidad de mantener la trazabilidad del desarrollo sin depender de herramientas externas. Esta solución equilibra simplicidad y eficiencia, alineándose con las necesidades del equipo sin añadir complejidad innecesaria.

## Ventajas y Desventajas de las opciones

### GitHub Projects (Kanban)

#### Ventajas

* Integración nativa con GitHub (ideal para equipos de desarrollo).
* Automatización mediante GitHub Actions.
* Markdown y vista de tabla personalizable.
* Permite conectar issues y pull requests directamente.

#### Desventajas

* Funcionalidad más limitada en comparación con otras herramientas.
* No es tan intuitivo para quienes no usan GitHub regularmente.
* Menos opciones de personalización visual.

### Trello

#### Ventajas

* Interfaz sencilla y fácil de usar.
* Gran flexibilidad y personalización con etiquetas, checklists, y power-ups.
* Gratis con funcionalidades básicas suficientes para pequeños equipos.
* Aplicación móvil intuitiva.

#### Desventajas

* Las automatizaciones y power-ups avanzados requieren la versión de pago.
* Puede volverse desordenado con tableros grandes.
* No está tan enfocado en el desarrollo de software como GitHub Projects.

### Jira (de Atlassian)

#### Ventajas

* Potente en la gestión de proyectos ágiles (Scrum/Kanban).
* Integración con Bitbucket, Confluence y otras herramientas de Atlassian.
* Seguimiento de errores y flujos de trabajo avanzados.
* Gran capacidad de personalización.

#### Desventajas

* Interfaz compleja y menos intuitiva.
* Puede ser excesivo para equipos pequeños.
* Versión gratuita limitada a 10 usuarios.


## Conclusiones

Dado que nuestro equipo utiliza GitHub como herramienta principal para el desarrollo y gestión del código, optar por GitHub Projects (Kanban) nos permite mantener un flujo de trabajo integrado sin necesidad de herramientas externas. Su conexión nativa con issues, pull requests y GitHub Actions facilita la automatización y el seguimiento del desarrollo, asegurando una mejor trazabilidad de las tareas y alineación con el ciclo de vida del software.

Si bien otras herramientas como Trello o Jira ofrecen una mayor personalización o funcionalidades avanzadas, GitHub Projects se alinea mejor con nuestras necesidades al proporcionar un entorno unificado, reducción de fricción entre gestión y desarrollo, y una curva de aprendizaje mínima para el equipo.

Por estas razones, se ha decidido adoptar GitHub Projects (Kanban) como la herramienta principal de gestión de tareas dentro de nuestro flujo de trabajo.
