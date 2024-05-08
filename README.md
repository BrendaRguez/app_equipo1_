# app_equipo1_
Entrega de aplicación en equipo
# Descripción de la app
El código inicia estableciendo una conexión wifi, una comunicación TCP, esta comunicación es guiada por sockets.
El código presentado consiste en que a partir de iniciar el proceso correr el código con un botón, éste tiene un atributo on press, que manda una función llamada “start socket communication” esta función  manda un flash por el socket de un puerto específico, el cual en el microcontrolador al estar escuchando este socket cuando recibe información de la bandera empieza a hacer el impulso.  Al mismo tiempo que hace el impulso empieza a grabar los datos  hasta llegar a medio segundo. En este tiempo se acaba el impulso pero el microcontrolador sigue grabando los datos tanto del ADC como los datos del tiempo, teniendo 2 vectores.  El vector con los datos del ADC (desplazamiento)  se hace string y se manda por otro socket ( 81) y el otro vector, el de tiempo se manda por el socket 80 80.
Cuando se reciben estos dos datos se guardan en 2 variables y procede a graficar. El microcontrolador que estamos utilizando es el Raspberry Pi Pico W
