extensions [pathdir gis palette ]

;----------------------------------------------------------------------------------------------------------------

globals [

  directorio_de_modelo ;; variable para guardar el directorio raiz en el que esta guardado el archivo .nlogo del modelo

  area_estudio_SHP_dataset ;; shapefile con los municipios del area de estudio
  area_estudio_dataset ;; municipios en formato raster

  precio_viviendas_dataset ;; raster con los 3 tipos de viviendas
  tipo_viviendas_dataset ;; NUEVA CLASIFICACION DE LAS VIVIENDAS

  zonificacion_dataset ;; zonificacion legal de la zona (tipo 2 = zonas en las que se puede construir)

  dist_urbano_dataset ;; raster con las distancias a las zonas urbanas consolidadas
  dist_carreteras_dataset ;; raster con las distancias a las carreteras
  dist_estaciones_dataset ;; raster con la distancia a paradas de tren
  dist_zonas_trabajo_dataset ;; raster con las distancias a zonas de trabajo
  dist_zonas_verdes_dataset ;; raster con las distancias a zonas verdes

  demanda_total

  demanda_multifamiliar_alto demanda_multifamiliar_medio demanda_multifamiliar_bajo ;; demanda de multi
  demanda_suplida_multifamiliar_alto demanda_suplida_multifamiliar_medio demanda_suplida_multifamiliar_bajo ;; demandas suplidas por iteracion

  demanda_unifamiliar_alto demanda_unifamiliar_medio demanda_unifamiliar_bajo ;; demanda uni
  demanda_suplida_unifamiliar_alto demanda_suplida_unifamiliar_medio demanda_suplida_unifamiliar_bajo ;; demandas suplidas por iteracion

  ;; VARIABLES PARA ESTABLECER LAS DISTINTAS PONDERACIONES PARA CADA TIPO DE EDIFICACION
  preferencia_urb_conso_alto_multi_p1
  preferencia_carretera_alto_multi_p1
  preferencia_trans_pub_alto_multi_p1
  preferencia_zonas_tr_alto_multi_p1
  preferencia_zonas_ver_alto_multi_p1

  preferencia_urb_conso_bajo_multi_p1
  preferencia_carretera_bajo_multi_p1
  preferencia_trans_pub_bajo_multi_p1
  preferencia_zonas_tr_bajo_multi_p1
  preferencia_zonas_ver_bajo_multi_p1

  preferencia_urb_conso_medio_multi_p1
  preferencia_carretera_medio_multi_p1
  preferencia_trans_pub_medio_multi_p1
  preferencia_zonas_tr_medio_multi_p1
  preferencia_zonas_ver_medio_multi_p1

  preferencia_urb_conso_alto_uni_p1
  preferencia_carretera_alto_uni_p1
  preferencia_trans_pub_alto_uni_p1
  preferencia_zonas_tr_alto_uni_p1
  preferencia_zonas_ver_alto_uni_p1

  preferencia_urb_conso_medio_uni_p1
  preferencia_carretera_medio_uni_p1
  preferencia_trans_pub_medio_uni_p1
  preferencia_zonas_tr_medio_uni_p1
  preferencia_zonas_ver_medio_uni_p1

  preferencia_urb_conso_alto_multi_p2
  preferencia_carretera_alto_multi_p2
  preferencia_trans_pub_alto_multi_p2
  preferencia_zonas_tr_alto_multi_p2
  preferencia_zonas_ver_alto_multi_p2

  preferencia_urb_conso_bajo_multi_p2
  preferencia_carretera_bajo_multi_p2
  preferencia_trans_pub_bajo_multi_p2
  preferencia_zonas_tr_bajo_multi_p2
  preferencia_zonas_ver_bajo_multi_p2

  preferencia_urb_conso_medio_multi_p2
  preferencia_carretera_medio_multi_p2
  preferencia_trans_pub_medio_multi_p2
  preferencia_zonas_tr_medio_multi_p2
  preferencia_zonas_ver_medio_multi_p2

  preferencia_urb_conso_alto_uni_p2
  preferencia_carretera_alto_uni_p2
  preferencia_trans_pub_alto_uni_p2
  preferencia_zonas_tr_alto_uni_p2
  preferencia_zonas_ver_alto_uni_p2

  preferencia_urb_conso_medio_uni_p2
  preferencia_carretera_medio_uni_p2
  preferencia_trans_pub_medio_uni_p2
  preferencia_zonas_tr_medio_uni_p2
  preferencia_zonas_ver_medio_uni_p2

  ;; variables para evaluar la cantidad de construcciones de cada tipo de promotora
  num_constru_uni_p1
  num_constru_multi_p1
  num_constru_alto_p1
  num_constru_medio_p1
  num_constru_bajo_p1

  num_constru_uni_p2
  num_constru_multi_p2
  num_constru_alto_p2
  num_constru_medio_p2
  num_constru_bajo_p2

  ;; variables para evaluar las ganancias de cada tipo de promotora
  ganancias_p1
  ganancias_p2
]

;----------------------------------------------------------------------------------------------------------------

breed [ nombres_municipios nombre_municipio ]
breed [ promotoras1 promotora1 ]
breed [ promotoras2 promotora2 ]

;----------------------------------------------------------------------------------------------------------------

patches-own [

  area_estudio ;; variable de area de estudio
  zonificacion ;; variable para acceder a la zonificacion

  dist_urbano ;; variable para guardar las distancias a las zonas urbanas consolidadas
  dist_carreteras ;; variable para guardar las distancias a las carreteras
  dist_estaciones ;; variable para guardar las distancias a las estaciones de tren
  dist_zonas_trabajo ;; variable para guardar las distancias a las zonas de trabajo
  dist_zonas_verdes ;; variable para guardar las distancias a las zonas verdes

  precio_viviendas ;; clasificacion del pixel segun tipologia de precios
  tipo_viviendas ;; clasificacion del pixel en funcion de si es uni, multi o vacante

  disponible ;; variable que define si es posible construir en el pixel o no
  modificado ;; variable que define si el pixel ha sido modificado o no
  estandar ;; variable que define el estandar de la edificacion

  ;; valores de aptitud de cada tipo de edificacion para las promotoras tipo 1
  aptitud_multi_alto_p1
  aptitud_multi_medio_p1
  aptitud_multi_bajo_p1
  aptitud_uni_alto_p1
  aptitud_uni_medio_p1

  ;; valores de aptitud de cada tipo de edificacion para las promotoras tipo 2
  aptitud_multi_alto_p2
  aptitud_multi_medio_p2
  aptitud_multi_bajo_p2
  aptitud_uni_alto_p2
  aptitud_uni_medio_p2
]

promotoras1-own [

  area_influencia
  radio_busqueda
  mejor_aptitud
  tipologia_a_construir
  intentos
  adaptacion
  reinicios
  satisfaccion
  ganancias
]

promotoras2-own [

  area_influencia
  radio_busqueda
  mejor_aptitud
  tipologia_a_construir
  intentos
  adaptacion
  reinicios
  satisfaccion
  ganancias
]

;------------------------------------------------------------------------------------------------------------------

;##################################################################################################################
;####################################  FUNCION DE INICIALIZACIÓIN  ################################################
;##################################################################################################################

;; inicializa el ABM, cargando todos los datos y mostrando el area de estudio

to inicio

  __clear-all-and-reset-ticks

  set directorio_de_modelo pathdir:get-model-path  ;; guardar el directorio en el que esta guardado el modelo
  set-current-directory (word directorio_de_modelo "\\datos_entrada") ;; poner como directorio principal la carpeta
                                                                      ;; que contiene los archivos ASCII de los
                                                                      ;; datos de entrada

  set area_estudio_SHP_dataset         gis:load-dataset "Area_estudio.shp"
  set area_estudio_dataset             gis:load-dataset "ae_asc_25_c.asc"
  set precio_viviendas_dataset         gis:load-dataset "pviv_25_c.asc"
  set zonificacion_dataset             gis:load-dataset "zon_leg_25_c.asc"
  set dist_urbano_dataset              gis:load-dataset "d_au_25_c_i_n.asc"
  set dist_carreteras_dataset          gis:load-dataset "d_ca_25_c_i_n.asc"
  set dist_estaciones_dataset          gis:load-dataset "d_est_25_c_r.asc"
  set dist_zonas_trabajo_dataset       gis:load-dataset "d_zt_25_c_i_n.asc"
  set dist_zonas_verdes_dataset        gis:load-dataset "d_zv_25_c_i_n.asc"
  set tipo_viviendas_dataset           gis:load-dataset "resi_class_c.asc"

  gis:set-world-envelope (gis:envelope-of area_estudio_dataset)

  gis:apply-raster area_estudio_dataset             area_estudio
  gis:apply-raster precio_viviendas_dataset         precio_viviendas
  gis:apply-raster zonificacion_dataset             zonificacion
  gis:apply-raster dist_urbano_dataset              dist_urbano
  gis:apply-raster dist_carreteras_dataset          dist_carreteras
  gis:apply-raster dist_estaciones_dataset          dist_estaciones
  gis:apply-raster dist_zonas_trabajo_dataset       dist_zonas_trabajo
  gis:apply-raster dist_zonas_verdes_dataset        dist_zonas_verdes
  gis:apply-raster tipo_viviendas_dataset           tipo_viviendas

  ;; establece aquellos pixeles que son susceptibles a ser edificados, utilizando los datos de entrada
  ask patches with [(area_estudio > 0) and (zonificacion = 2) and (tipo_viviendas = 1)] [set disponible 1]

  mostrar_area_estudio

end

;-----------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------

;#################################################################################################################
;#########################  FUNCIONES DE VISUALIZACIOON DE DATOS DE ENTRADA  #####################################
;#################################################################################################################

;-----------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------


;######################################  MOSTRAR AREA DE ESTUDIO  ################################################
;; muestra el área de estudio, junto con los nombres

to mostrar_area_estudio

  ask nombres_municipios [ die ]
  ask patches with [area_estudio > 0] [set pcolor 49]
  ask patches with [area_estudio <= 0] [set pcolor white]

  gis:draw area_estudio_SHP_dataset 1
  foreach gis:feature-list-of area_estudio_SHP_dataset [ ?1 -> gis:set-drawing-color black
  let centroid gis:location-of gis:centroid-of ?1
       if not empty? centroid
       [ create-nombres_municipios 1
         [ set xcor item 0 centroid
           set ycor item 1 centroid
           set size 1
           set label-color black
           set label gis:property-value ?1 "nombres"
         ]
       ]
  ]
end

;------------------------------------------------------------------------------------------------------------------

;###############################################  ZONIFICACION  ###################################################
;; muestra la zonificacion legal del area de estudio

to mostrar_zonificacion

  ask patches [set pcolor 8] ;; colorear todo el area de gris, se quedará de este color todo lo que no entrene en el resto de categorías

  show (word "Zonas clasificados como ´urbano` (tipo 1): "  count patches with [zonificacion = 1])
  show (word "Zonas clasificados como ´urbanizable` (tipo 2): "  count patches with [zonificacion = 2])
  show (word "Zonas clasificados como ´sistemas generales` (tipo 4): "  count patches with [zonificacion = 4])

  ask patches with [(zonificacion = 1) and (area_estudio > 0)] [set pcolor blue] ;urbano (azul)
  ask patches with [(zonificacion = 2) and (area_estudio > 0)] [set pcolor green] ;urbanizable (verde)
  ask patches with [(zonificacion = 4) and (area_estudio > 0)] [set pcolor orange] ;sistemas generales (naranja)

 end

;------------------------------------------------------------------------------------------------------------------

;################################################  URBANIZABLES  ##################################################
;; muestra aquellas zonas que pueden ser edificadas

to mostrar_zonas_urbanizables

  ask patches [set pcolor 8]
  ask patches with [(area_estudio > 0) and (zonificacion = 2) and (tipo_viviendas = 1)] [set pcolor green]

end

;------------------------------------------------------------------------------------------------------------------

;########################################  ZONAS DE ESTANDAR  #####################################################
;; muestra la clasificacion de cada pixel en funcion de la categoria de precio de vivienda que tiene

to mostrar_estandar_zona

  ask patches [set pcolor 8]
  show (word "Zonas con viviendas baratas (1):"  count patches with [precio_viviendas = 1])
  show (word "Zonas con viviendas medias  (2):"  count patches with [precio_viviendas = 2])
  show (word "Zonas con viviendas caras   (3):"  count patches with [precio_viviendas = 3])

  ask patches with [precio_viviendas = 1] [set pcolor green]
  ask patches with [precio_viviendas = 2] [set pcolor yellow]
  ask patches with [precio_viviendas = 3] [set pcolor orange]

end

;-------------------------------------------------------------------------------------------------------------------

;################################  NÚMERO DE EDIFICACIONES CARGA INICIAL  ##########################################
;; muestra en rojo aquellas zonas que presentan algun tipo de edificacion residencial

to mostrar_zonas_edificadas
  ask patches [set pcolor 8]
  ask patches with [tipo_viviendas > 1] [
    set pcolor red]
  show (word "Número de pixeles edificados: "count patches with [tipo_viviendas > 0])
end

;-------------------------------------------------------------------------------------------------------------------

;################################  DISTANCIA A ÁREAS URBANAS CONSOLIDADAS  #########################################
;; muestra el raster de distancias a areas urbanas consolidadas

to mostrar_distancia_zonas_urbanas_consolidadas

  ask patches [set pcolor 8]
  ask patches with [area_estudio > 0] [set pcolor scale-color sky dist_urbano 7000 10000]
  show (word "Distancia a zona urbanas entre "  min [dist_urbano] of patches " y "  max [dist_urbano] of patches)

end

;-------------------------------------------------------------------------------------------------------------------

;#########################################  DISTANCIA A CARRETERAS  ################################################
;; muestra el raster de distancias a carreteras

to mostrar_distancia_carreteras

  ask patches [set pcolor 8]
  ask patches with [area_estudio > 0] [set pcolor scale-color orange dist_carreteras 7000 10000]
  show (word "distancia a carretera entre "  min [dist_carreteras] of patches " y "  max [dist_carreteras] of patches)

end

;-------------------------------------------------------------------------------------------------------------------

;#######################################  DISTANCIA A PARADAS DE TREN  #############################################
;; muestra el raster de distancias a estaciones de tren

to mostrar_distancia_transporte_publico

  ask patches [set pcolor 8]
  ask patches with [(area_estudio > 0) and (dist_estaciones = 5000)] [set pcolor 117]
  ask patches with [(area_estudio > 0) and (dist_estaciones = 10000)] [set pcolor 115]

end

;-------------------------------------------------------------------------------------------------------------------

;#######################################  DISTANCIA A ZONAS DE TRABAJO   ###########################################
;; muestra el raster de distancias a zonas de trabajo

to mostrar_distancia_zonas_trabajo

  ask patches [set pcolor 8]
  ask patches with [area_estudio > 0] [set pcolor scale-color brown dist_zonas_trabajo 7000 10000]
  show (word "distancia a zonas de trbajo "  min [dist_zonas_trabajo] of patches " y "  max [dist_zonas_trabajo] of patches)

end

;-------------------------------------------------------------------------------------------------------------------

;#######################################  DISTANCIA A ZONAS VERDES  ################################################
;; muestra el raster de distancias a zonas verdes

to mostrar_distancia_zonas_verdes

  ask patches [set pcolor 8]
  ask patches with [area_estudio > 0]  [set pcolor scale-color green dist_zonas_verdes 7000 10000]
  show (word "distancia a zonas de trbajo "  min [dist_zonas_verdes] of patches " y "  max [dist_zonas_verdes] of patches)

end

;-------------------------------------------------------------------------------------------------------------------

;#####################################  ZONIFICACION RESIDENCIAL  #################################################
;; muestra la clasificacion de cada pixel en funcion del tipo de edificacion residencial que tiene, si lo tiene

to mostrar_tipo_viviendas

  ask patches [set pcolor 8]

  ask patches with [tipo_viviendas = 0] [set pcolor white] ;; fuera de la zona de estudio
  ask patches with [tipo_viviendas = 1] [set pcolor green] ;; vacante
  ask patches with [tipo_viviendas = 2] [set pcolor blue] ;; multifamiliar
  ask patches with [tipo_viviendas = 3] [set pcolor orange] ;;unifamiliar

end

;-------------------------------------------------------------------------------------------------------------------

;########################################  PRECIO DE LAS VIVIENDAS  ################################################
;; muestra el precio que tienen las edificaciones

to mostrar_viviendas_por_precios

  ask patches with [(precio_viviendas = 1) and (tipo_viviendas > 1)] [set pcolor green]
  show (word "Edificaciones baratas " count patches with [(precio_viviendas = 1) and (tipo_viviendas > 1)])

  ask patches with [(precio_viviendas = 2) and (tipo_viviendas > 1)] [set pcolor yellow]
  show (word "Edificaciones medias " count patches with [(precio_viviendas = 2) and (tipo_viviendas > 1)])

  ask patches with [(precio_viviendas = 3) and (tipo_viviendas > 1)] [set pcolor orange]
  show (word "Edificaciones caras " count patches with [(precio_viviendas = 3) and (tipo_viviendas > 1)])

end

;-------------------------------------------------------------------------------------------------------------------

;###################################  NÚMERO DE EDIFICACIONES SIMULADAS  ###########################################
;; muestra, en funcion del formato elegido, las edificaciones simuladas

to mostrar_zonas_simuladas [tipo_visualizacion]

  ask patches [set pcolor 8]

  let edificacion patches with [modificado = 1]
  show (word "Total construido: "count edificacion) ;; mostrar total construido

  if tipo_visualizacion = "TIPOLOGIA" [
    ask edificacion with [tipo_viviendas = 2] [set pcolor blue] ;; nuevas multifamiliares
    ask edificacion with [tipo_viviendas = 3] [set pcolor orange] ;; nuevas unifamiliares

    show (word "multifamiliar: "count edificacion with [tipo_viviendas = 2])
    show (word "unifamiliar: " count edificacion with [tipo_viviendas = 3])
  ]

  if tipo_visualizacion = "ESTANDAR" [
    ask edificacion with [estandar = 1] [set pcolor red] ;; estandar alto
    ask edificacion with [estandar = 2] [set pcolor green] ;; estandar medio
    ask edificacion with [estandar = 3] [set pcolor blue] ;; estandar bajo

    show (word "estandar alto: "count edificacion with [estandar = 1])
    show (word "estandar medio: " count edificacion with [estandar = 2])
    show (word "estandar alto: " count edificacion with [estandar = 3])
  ]

  if tipo_visualizacion = "TIPOLOGIA_Y_ESTANDAR" [
    ask edificacion with [(tipo_viviendas = 2) and (estandar = 1)] [set pcolor 115] ;; nuevas multifamiliares de estandar alto
    ask edificacion with [(tipo_viviendas = 2) and (estandar = 2)] [set pcolor 126] ;; nuevas multifamiliares de estandar medio
    ask edificacion with [(tipo_viviendas = 2) and (estandar = 3)] [set pcolor 135] ;; nuevas multifamiliares de estandar bajo

    ask edificacion with [(tipo_viviendas = 3) and (estandar = 1) ] [set pcolor 25] ;; nuevas unifamiliares de estandar alto
    ask edificacion with [(tipo_viviendas = 3) and (estandar = 2) ] [set pcolor 35] ;; nuevas unifamiliares de estandar medio

    show (word "multifamiliar de estandar alto: "count edificacion with [(tipo_viviendas = 2) and (estandar = 1)])
    show (word "multifamiliar de estandar medio: " count edificacion with [(tipo_viviendas = 2) and (estandar = 2)])
    show (word "multifamiliar de estandar bajo: " count edificacion with [(tipo_viviendas = 2) and (estandar = 3)])

    show (word "unifamiliar de estandar alto: "count edificacion with [(tipo_viviendas = 3) and (estandar = 1)])
    show (word "unifamiliar de estandar medio: " count edificacion with [(tipo_viviendas = 3) and (estandar = 2)])
  ]

end


;-------------------------------------------------------------------------------------------------------------------
;###############################  GENERACIÓN DE GRÁFICOS DE SEGUIMIENTO  ###########################################
;-------------------------------------------------------------------------------------------------------------------

to do-plot1
  ;; plot de histograma con cantidad de edificado en cada municipio

  set-current-plot "Edificaciones por municipio"
  histogram [area_estudio] of patches with [(modificado = 1)]

end

;-------------------------------------------------------------------------------------------------------------------

to do-plot2
  ;; plot de la cantidad que se va edificando de cada tipo de estandar

  set-current-plot "Nuevas edificaciones"
  set-current-plot-pen "Alto"
  plot count patches with [(modificado = 1) and (estandar = 1)]
  set-current-plot-pen "Medio"
  plot count patches with [(modificado = 1) and (estandar = 2)]
  set-current-plot-pen "Bajo"
  plot count patches with [(modificado = 1) and (estandar = 3)]

end

;-------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------

;###################################################################################################################
;###########################  FUNCIONES RELATIVAS A LAS REGLAS DE DECISION  ########################################
;###################################################################################################################

;-------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------


;#######################  CALCULAR LAS DEMANDAS DE CADA TIPO DE VIVIENDA A CONSTRUIR  ##############################
;; calcula las demandas de cada tipo que hay que construir en cada iteracion

to calcular_demandas

  set demanda_total (demanda_multifamiliar + demanda_unifamiliar)
  show (word "Demanda total de viviendas: " demanda_total)

  set demanda_multifamiliar_alto   (demanda_multifamiliar * (Proporcion_multifamiliar_alto  / 100))
  set demanda_multifamiliar_medio  (demanda_multifamiliar * (Proporcion_multifamiliar_medio / 100))
  set demanda_multifamiliar_bajo   (demanda_multifamiliar * (Proporcion_multifamiliar_bajo  / 100))

  show (word "Demanda de viviendas multifamiliares de estandar alto: " demanda_multifamiliar_alto)
  show (word "Demanda de viviendas multifamiliares de estandar medio: " demanda_multifamiliar_medio)
  show (word "Demanda de viviendas multifamiliares de estandar bajo: " demanda_multifamiliar_bajo)

  set demanda_unifamiliar_alto   (demanda_unifamiliar * (Proporcion_unifamiliar_alto  / 100))
  set demanda_unifamiliar_medio  (demanda_unifamiliar * (Proporcion_unifamiliar_medio / 100))

  show (word "Demanda de viviendas unifamiliares de estandar alto: " demanda_unifamiliar_alto)
  show (word "Demanda de viviendas unifamiliares de estandar medio: " demanda_unifamiliar_medio)

end

;-------------------------------------------------------------------------------------------------------------------

;#######################################  ACTUALIZACION DE LA DEMANA  ##############################################
;; actualiza el valor de demanta total para la iteracion actual

to actualizar_demandas

  set demanda_total (demanda_multifamiliar_alto + demanda_multifamiliar_medio + demanda_multifamiliar_bajo +
                     demanda_unifamiliar_alto + demanda_unifamiliar_medio)
end

;-------------------------------------------------------------------------------------------------------------------

;##############################  PONDERACIONES DE CADA TIPO DE EDIFICACION  ########################################
;; establece los coeficientes de ponderacion que cada tipo de promotora aplica sobre la zona, utilizando los datos
;; introducidos por el usuario

to establecer_ponderaciones

  let total_importancias (Distancia_a_urbano_consolidado + Distancia_a_carreteras + Distancia_a_transporte_público +
                          Distancia_a_zonas_de_trabajo + Distancia_a_zonas_verdes)

  let importancia_u_c (Distancia_a_urbano_consolidado / total_importancias)
  let importancia_ca  (Distancia_a_carreteras / total_importancias)
  let importancia_tp  (Distancia_a_transporte_público / total_importancias)
  let importancia_zt  (Distancia_a_zonas_de_trabajo / total_importancias)
  let importancia_zv  (Distancia_a_zonas_verdes / total_importancias)

  let ajuste_p1 (1.1 - Diferenciación)
  let ajuste_p2 (1.1 + Diferenciación)

  ;·················································································································

  let tot1 ((2 ^ ajuste_p1) + (2.5 ^ ajuste_p1) + (0.5 ^ ajuste_p1) + (2 ^ ajuste_p1) + (3 ^ ajuste_p1))
  set preferencia_urb_conso_alto_multi_p1  (importancia_u_c * ((2 ^ ajuste_p1) / tot1))
  set preferencia_carretera_alto_multi_p1  (importancia_ca  * ((2.5 ^ ajuste_p1) / tot1))
  set preferencia_trans_pub_alto_multi_p1  (importancia_tp  * ((0.5 ^ ajuste_p1) / tot1))
  set preferencia_zonas_tr_alto_multi_p1   (importancia_zt  * ((2 ^ ajuste_p1) / tot1))
  set preferencia_zonas_ver_alto_multi_p1  (importancia_zv  * ((3 ^ ajuste_p1) / tot1))

  let tot2 ((2 ^ ajuste_p1) + (3 ^ ajuste_p1) + (1 ^ ajuste_p1) + (2.5 ^ ajuste_p1) + (1.5 ^ ajuste_p1))
  set preferencia_urb_conso_medio_multi_p1 (importancia_u_c * ((2 ^ ajuste_p1) / tot2))
  set preferencia_carretera_medio_multi_p1 (importancia_ca  * ((3 ^ ajuste_p1) / tot2))
  set preferencia_trans_pub_medio_multi_p1 (importancia_tp  * ((1 ^ ajuste_p1) / tot2))
  set preferencia_zonas_tr_medio_multi_p1  (importancia_zt  * ((2.5 ^ ajuste_p1) / tot2))
  set preferencia_zonas_ver_medio_multi_p1 (importancia_zv  * ((1.5 ^ ajuste_p1) / tot2))

  let tot3 ((3.5 ^ ajuste_p1) + (0.5 ^ ajuste_p1) + (3.5 ^ ajuste_p1) + (2 ^ ajuste_p1) + (0.5 ^ ajuste_p1))
  set preferencia_urb_conso_bajo_multi_p1  (importancia_u_c * ((3.5 ^ ajuste_p1) / tot3))
  set preferencia_carretera_bajo_multi_p1  (importancia_ca  * ((0.5 ^ ajuste_p1) / tot3))
  set preferencia_trans_pub_bajo_multi_p1  (importancia_tp  * ((3.5 ^ ajuste_p1) / tot3))
  set preferencia_zonas_tr_bajo_multi_p1   (importancia_zt  * ((2 ^ ajuste_p1) / tot3))
  set preferencia_zonas_ver_bajo_multi_p1  (importancia_zv  * ((0.5 ^ ajuste_p1) / tot3))

  let tot4 ((1 ^ ajuste_p1) + (3.5 ^ ajuste_p1) + (0 ^ ajuste_p1) + (2 ^ ajuste_p1) + (3.5 ^ ajuste_p1))
  set preferencia_urb_conso_alto_uni_p1    (importancia_u_c * ((1 ^ ajuste_p1) / tot4))
  set preferencia_carretera_alto_uni_p1    (importancia_ca  * ((3.5 ^ ajuste_p1) / tot4))
  set preferencia_trans_pub_alto_uni_p1    (importancia_tp  * ((0 ^ ajuste_p1) / tot4))
  set preferencia_zonas_tr_alto_uni_p1     (importancia_zt  * ((2 ^ ajuste_p1) / tot4))
  set preferencia_zonas_ver_alto_uni_p1    (importancia_zv  * ((3.5 ^ ajuste_p1) / tot4))

  let tot5 ((2.5 ^ ajuste_p1) + (2.5 ^ ajuste_p1) + (1 ^ ajuste_p1) + (2.5 ^ ajuste_p1) + (1.5 ^ ajuste_p1))
  set preferencia_urb_conso_medio_uni_p1   (importancia_u_c * ((2.5 ^ ajuste_p1) / tot5))
  set preferencia_carretera_medio_uni_p1   (importancia_ca  * ((2.5 ^ ajuste_p1) / tot5))
  set preferencia_trans_pub_medio_uni_p1   (importancia_tp  * ((1 ^ ajuste_p1) / tot5))
  set preferencia_zonas_tr_medio_uni_p1    (importancia_zt  * ((2.5 ^ ajuste_p1) / tot5))
  set preferencia_zonas_ver_medio_uni_p1   (importancia_zv  * ((1.5 ^ ajuste_p1) / tot5))

  ;·················································································································

  let tot6 ((2 ^ ajuste_p2) + (2.5 ^ ajuste_p2) + (0.5 ^ ajuste_p2) + (2 ^ ajuste_p2) + (3 ^ ajuste_p2))
  set preferencia_urb_conso_alto_multi_p2  (importancia_u_c * ((1 ^ ajuste_p2) / tot6))
  set preferencia_carretera_alto_multi_p2  (importancia_ca  * ((2.5 ^ ajuste_p2) / tot6))
  set preferencia_trans_pub_alto_multi_p2  (importancia_tp  * ((0.5 ^ ajuste_p2) / tot6))
  set preferencia_zonas_tr_alto_multi_p2   (importancia_zt  * ((2 ^ ajuste_p2) / tot6))
  set preferencia_zonas_ver_alto_multi_p2  (importancia_zv  * ((3 ^ ajuste_p2) / tot6))

  let tot7 ((2 ^ ajuste_p2) + (3 ^ ajuste_p2) + (1 ^ ajuste_p2) + (2.5 ^ ajuste_p2) + (1.5 ^ ajuste_p2))
  set preferencia_urb_conso_medio_multi_p2 (importancia_u_c * ((2 ^ ajuste_p2) / tot7))
  set preferencia_carretera_medio_multi_p2 (importancia_ca  * ((3 ^ ajuste_p2) / tot7))
  set preferencia_trans_pub_medio_multi_p2 (importancia_tp  * ((1 ^ ajuste_p2) / tot7))
  set preferencia_zonas_tr_medio_multi_p2  (importancia_zt  * ((2.5 ^ ajuste_p2) / tot7))
  set preferencia_zonas_ver_medio_multi_p2 (importancia_zv  * ((1.5 ^ ajuste_p2) / tot7))

  let tot8 ((3.5 ^ ajuste_p2) + (0.5 ^ ajuste_p2) + (3.5 ^ ajuste_p2) + (2 ^ ajuste_p2) + (0.5 ^ ajuste_p2))
  set preferencia_urb_conso_bajo_multi_p2  (importancia_u_c * ((3.5 ^ ajuste_p2) / tot8))
  set preferencia_carretera_bajo_multi_p2  (importancia_ca  * ((0.5 ^ ajuste_p2) / tot8))
  set preferencia_trans_pub_bajo_multi_p2  (importancia_tp  * ((3.5 ^ ajuste_p2) / tot8))
  set preferencia_zonas_tr_bajo_multi_p2   (importancia_zt  * ((2 ^ ajuste_p2) / tot8))
  set preferencia_zonas_ver_bajo_multi_p2  (importancia_zv  * ((0.5 ^ ajuste_p2) / tot8))

  let tot9 ((1 ^ ajuste_p2) + (3.5 ^ ajuste_p2) + (0 ^ ajuste_p2) + (2 ^ ajuste_p2) + (3.5 ^ ajuste_p2))
  set preferencia_urb_conso_alto_uni_p2    (importancia_u_c * ((1 ^ ajuste_p2) / tot9))
  set preferencia_carretera_alto_uni_p2    (importancia_ca  * ((3.5 ^ ajuste_p2) / tot9))
  set preferencia_trans_pub_alto_uni_p2    (importancia_tp  * ((0 ^ ajuste_p2) / tot9))
  set preferencia_zonas_tr_alto_uni_p2     (importancia_zt  * ((2 ^ ajuste_p2) / tot9))
  set preferencia_zonas_ver_alto_uni_p2    (importancia_zv  * ((3.5 ^ ajuste_p2) / tot9))

  let tot10 ((2.5 ^ ajuste_p2) + (2.5 ^ ajuste_p2) + (1 ^ ajuste_p2) + (2.5 ^ ajuste_p2) + (1.5 ^ ajuste_p2))
  set preferencia_urb_conso_medio_uni_p2   (importancia_u_c * ((2.5 ^ ajuste_p2) / tot10))
  set preferencia_carretera_medio_uni_p2   (importancia_ca  * ((2.5 ^ ajuste_p2) / tot10))
  set preferencia_trans_pub_medio_uni_p2   (importancia_tp  * ((1 ^ ajuste_p2) / tot10))
  set preferencia_zonas_tr_medio_uni_p2    (importancia_zt  * ((2.5 ^ ajuste_p2) / tot10))
  set preferencia_zonas_ver_medio_uni_p2   (importancia_zv  * ((1.5 ^ ajuste_p2) / tot10))

end


;-------------------------------------------------------------------------------------------------------------------

;###################################  ESTABLECIMINETO DE LAS APTITUDES  ############################################
;; realiza el calculo de la aptitud final para cada tipo de edificacion segun el tipo de promotora

to establecer_aptitudes

  establecer_ponderaciones

  ask patches with [disponible = 1] [

    set aptitud_multi_alto_p1   ((preferencia_urb_conso_alto_multi_p1 * dist_urbano) + (preferencia_carretera_alto_multi_p1 * dist_carreteras) +
                                (preferencia_trans_pub_alto_multi_p1 * dist_estaciones) + (preferencia_zonas_tr_alto_multi_p1 * dist_zonas_trabajo) +
                                (preferencia_zonas_ver_alto_multi_p1 * dist_zonas_verdes))

    set aptitud_multi_medio_p1  ((preferencia_urb_conso_medio_multi_p1 * dist_urbano) + (preferencia_carretera_medio_multi_p1 * dist_carreteras) +
                                (preferencia_trans_pub_medio_multi_p1 * dist_estaciones) + (preferencia_zonas_tr_medio_multi_p1 * dist_zonas_trabajo) +
                                (preferencia_zonas_ver_medio_multi_p1 * dist_zonas_verdes))

    set aptitud_multi_bajo_p1   ((preferencia_urb_conso_bajo_multi_p1 * dist_urbano) + (preferencia_carretera_bajo_multi_p1 * dist_carreteras) +
                                (preferencia_trans_pub_bajo_multi_p1 * dist_estaciones) + (preferencia_zonas_tr_bajo_multi_p1 * dist_zonas_trabajo) +
                                (preferencia_zonas_ver_bajo_multi_p1 * dist_zonas_verdes))

    set aptitud_uni_alto_p1     ((preferencia_urb_conso_alto_uni_p1 * dist_urbano) + (preferencia_carretera_alto_uni_p1 * dist_carreteras) +
                                (preferencia_trans_pub_alto_uni_p1 * dist_estaciones) + (preferencia_zonas_tr_alto_uni_p1 * dist_zonas_trabajo) +
                                (preferencia_zonas_ver_alto_uni_p1 * dist_zonas_verdes))

    set aptitud_uni_medio_p1    ((preferencia_urb_conso_medio_uni_p1 * dist_urbano) + (preferencia_carretera_medio_uni_p1 * dist_carreteras) +
                                (preferencia_trans_pub_medio_uni_p1 * dist_estaciones) + (preferencia_zonas_tr_medio_uni_p1 *  dist_zonas_trabajo) +
                                (preferencia_zonas_ver_medio_uni_p1 * dist_zonas_verdes))
    ;·····················································································································································

    set aptitud_multi_alto_p2   ((preferencia_urb_conso_alto_multi_p2 * dist_urbano) + (preferencia_carretera_alto_multi_p2 * dist_carreteras) +
                                (preferencia_trans_pub_alto_multi_p2 * dist_estaciones) +  (preferencia_zonas_tr_alto_multi_p2 * dist_zonas_trabajo) +
                                (preferencia_zonas_ver_alto_multi_p2 * dist_zonas_verdes))

    set aptitud_multi_medio_p2  ((preferencia_urb_conso_medio_multi_p2 * dist_urbano) + (preferencia_carretera_medio_multi_p2 * dist_carreteras) +
                                (preferencia_trans_pub_medio_multi_p2 * dist_estaciones) + (preferencia_zonas_tr_medio_multi_p2 * dist_zonas_trabajo) +
                                (preferencia_zonas_ver_medio_multi_p2 * dist_zonas_verdes))

    set aptitud_multi_bajo_p2   ((preferencia_urb_conso_bajo_multi_p2 * dist_urbano) + (preferencia_carretera_bajo_multi_p2 * dist_carreteras) +
                                (preferencia_trans_pub_bajo_multi_p2 * dist_estaciones) + (preferencia_zonas_tr_bajo_multi_p2 * dist_zonas_trabajo) +
                                (preferencia_zonas_ver_bajo_multi_p2 * dist_zonas_verdes))

    set aptitud_uni_alto_p2     ((preferencia_urb_conso_alto_uni_p2 * dist_urbano) + (preferencia_carretera_alto_uni_p2 * dist_carreteras) +
                                (preferencia_trans_pub_alto_uni_p2 * dist_estaciones) + (preferencia_zonas_tr_alto_uni_p2 * dist_zonas_trabajo) +
                                (preferencia_zonas_ver_alto_uni_p2 * dist_zonas_verdes))

    set aptitud_uni_medio_p2    ((preferencia_urb_conso_medio_uni_p2 * dist_urbano) + (preferencia_carretera_medio_uni_p2 * dist_carreteras) +
                                (preferencia_trans_pub_medio_uni_p2 * dist_estaciones) + (preferencia_zonas_tr_medio_uni_p2 * dist_zonas_trabajo) +
                                (preferencia_zonas_ver_medio_uni_p2 * dist_zonas_verdes))

  ]

end

;-------------------------------------------------------------------------------------------------------------------

;######################################  CREACION DE LOS PROMOTORES  ###############################################
;; crea los dos tipos de agentes de promotoras

to crear_promotoras

  ask promotoras1 [die]
  create-promotoras1 Número_promotoras_tipo_1

  ask promotoras1 [

    set radio_busqueda (10 + (Diferenciación * 30))
    set shape "circle"
    set color violet
    set size radio_busqueda
    set intentos 0
    set adaptacion precision ((10 + (10 * Diferenciación)) / 5) 0
    set reinicios 0
  ]

  ask promotoras2 [die]
  create-promotoras2 Número_promotoras_tipo_2

  ask promotoras2 [

    set radio_busqueda (10 + (precision (Diferenciación * 10) 0))
    set shape "circle"
    set color red
    set size radio_busqueda
    set intentos 0
    set adaptacion precision ((10 + (20 * Diferenciación)) / 5) 0
    set reinicios 0
  ]

end

;-------------------------------------------------------------------------------------------------------------------

;#############################  MOVER A LAS PROMOTORAS POR EL AREA DE ESTUDIO  #####################################
;; mueve las promotoras por el area que puede ser edificada

to movilizar_promotoras

  ask promotoras1 [
    move-to one-of patches with [disponible = 1]
    set area_influencia area_influecia_de_cada_promotora self radio_busqueda
  ]

  ask promotoras2 [
    move-to one-of patches with [disponible = 1]
    set area_influencia area_influecia_de_cada_promotora self radio_busqueda
  ]


end
;-------------------------------------------------------------------------------------------------------------------

;###############################  AREA DE INFLUENCIA QUE TIENE CADA PROMOTORA  #####################################
;; devuelve los pixeles a los que cada promotora tiene acceso

to-report area_influecia_de_cada_promotora [promotora distancia]

  let disponibilidad patches with [disponible = 1]
  let aqui promotora
  let area disponibilidad with [distance aqui < distancia]

  report area

end

;-------------------------------------------------------------------------------------------------------------------

;####################################  SELECCION DE LA ZONA MAS IDÓNEA  ############################################
;; de entre todos los pixeles a los que tiene acceso cada promotora, selecciona aquel que tiene mayor aptitud para
;; ser construido, y lo posiciona sobre ese pixel

to seleccion_mejor_pixel

  ask promotoras1 [

    let mejor_aptitud_mu_a (max [aptitud_multi_alto_p1] of area_influencia)
    let mejor_aptitud_mu_m (max [aptitud_multi_medio_p1] of area_influencia)
    let mejor_aptitud_mu_b (max [aptitud_multi_bajo_p1] of area_influencia)
    let mejor_aptitud_un_a (max [aptitud_uni_alto_p1] of area_influencia)
    let mejor_aptitud_un_m (max [aptitud_uni_medio_p1] of area_influencia)

    let orden_mejores sort (list mejor_aptitud_mu_a mejor_aptitud_mu_m mejor_aptitud_mu_b mejor_aptitud_un_a mejor_aptitud_un_m)

    if intentos <= adaptacion [
      set mejor_aptitud item 4 orden_mejores
      set satisfaccion 5
    ]

    if intentos > adaptacion and intentos <= (adaptacion * 2) [
      set mejor_aptitud item 3 orden_mejores
      set satisfaccion 4
    ]

    if intentos > (adaptacion * 2) and intentos <= (adaptacion * 3) [
      set mejor_aptitud item 2 orden_mejores
      set satisfaccion 3
    ]

    if intentos > (adaptacion * 3) and intentos <= (adaptacion * 4) [
      set mejor_aptitud item 1 orden_mejores
      set satisfaccion 2
    ]

    if intentos > (adaptacion * 4) and intentos <= (adaptacion * 5) [
      set mejor_aptitud item 0 orden_mejores
      set satisfaccion 1
    ]

    if mejor_aptitud = mejor_aptitud_un_a [

      let list_coor posicion_pixel 1 mejor_aptitud area_influencia
      move-to patch (item 0 list_coor) (item 1 list_coor)
      set tipologia_a_construir "unifamiliar_estandar_alto"
    ]

    if mejor_aptitud = mejor_aptitud_un_m [

      let list_coor posicion_pixel 2 mejor_aptitud area_influencia
      move-to patch (item 0 list_coor) (item 1 list_coor)
      set tipologia_a_construir "unifamiliar_estandar_medio"
    ]

    if mejor_aptitud = mejor_aptitud_mu_a [

      let list_coor posicion_pixel 3 mejor_aptitud area_influencia
      move-to patch (item 0 list_coor) (item 1 list_coor)
      set tipologia_a_construir "multifamiliar_estandar_alto"
    ]

    if mejor_aptitud = mejor_aptitud_mu_m [

      let list_coor posicion_pixel 4 mejor_aptitud area_influencia
      move-to patch (item 0 list_coor) (item 1 list_coor)
      set tipologia_a_construir "multifamiliar_estandar_medio"
    ]

    if mejor_aptitud = mejor_aptitud_mu_b [

      let list_coor posicion_pixel 5 mejor_aptitud area_influencia
      move-to patch (item 0 list_coor) (item 1 list_coor)
      set tipologia_a_construir "multifamiliar_estandar_bajo"
    ]
  ]

  ask promotoras2 [

    let mejor_aptitud_mu_a (max [aptitud_multi_alto_p2] of area_influencia)
    let mejor_aptitud_mu_m (max [aptitud_multi_medio_p2] of area_influencia)
    let mejor_aptitud_mu_b (max [aptitud_multi_bajo_p2] of area_influencia)
    let mejor_aptitud_un_a (max [aptitud_uni_alto_p2] of area_influencia)
    let mejor_aptitud_un_m (max [aptitud_uni_medio_p2] of area_influencia)

    let orden_mejores sort (list mejor_aptitud_mu_a mejor_aptitud_mu_m mejor_aptitud_mu_b mejor_aptitud_un_a mejor_aptitud_un_m)

    if intentos <= adaptacion [
      set mejor_aptitud item 4 orden_mejores
      set satisfaccion 5
    ]

    if intentos > adaptacion and intentos <= (adaptacion * 2) [
      set mejor_aptitud item 3 orden_mejores
      set satisfaccion 4
    ]

    if intentos > (adaptacion * 2) and intentos <= (adaptacion * 3) [
      set mejor_aptitud item 2 orden_mejores
      set satisfaccion 3
    ]

    if intentos > (adaptacion * 3) and intentos <= (adaptacion * 4) [
      set mejor_aptitud item 1 orden_mejores
      set satisfaccion 2
    ]

    if intentos > (adaptacion * 4) and intentos <= (adaptacion * 5) [
      set mejor_aptitud item 0 orden_mejores
      set satisfaccion 1
    ]

    if mejor_aptitud = mejor_aptitud_un_a [

      let list_coor posicion_pixel 6 mejor_aptitud area_influencia
      move-to patch (item 0 list_coor) (item 1 list_coor)
      set tipologia_a_construir "unifamiliar_estandar_alto"
    ]

    if mejor_aptitud = mejor_aptitud_un_m [

      let list_coor posicion_pixel 7 mejor_aptitud area_influencia
      move-to patch (item 0 list_coor) (item 1 list_coor)
      set tipologia_a_construir "unifamiliar_estandar_medio"
    ]

    if mejor_aptitud = mejor_aptitud_mu_a [

      let list_coor posicion_pixel 8 mejor_aptitud area_influencia
      move-to patch (item 0 list_coor) (item 1 list_coor)
      set tipologia_a_construir "multifamiliar_estandar_alto"
    ]

    if mejor_aptitud = mejor_aptitud_mu_m [

      let list_coor posicion_pixel 9 mejor_aptitud area_influencia
      move-to patch (item 0 list_coor) (item 1 list_coor)
      set tipologia_a_construir "multifamiliar_estandar_medio"
    ]

    if mejor_aptitud = mejor_aptitud_mu_b [

      let list_coor posicion_pixel 10 mejor_aptitud area_influencia
      move-to patch (item 0 list_coor) (item 1 list_coor)
      set tipologia_a_construir "multifamiliar_estandar_bajo"
    ]
  ]


end
;-------------------------------------------------------------------------------------------------------------------

;#########################################  LOCALIZACION DEL PIXEL  ################################################
;; devuelve la localizacion del pixel con mayor aptitud

to-report posicion_pixel [tipo_mejor_aptitud valor area]

  if tipo_mejor_aptitud = 1 [

    let pixel area with [aptitud_uni_alto_p1 = valor]
    let x_coor [pxcor] of pixel
    let y_coor [pycor] of pixel

    report list item 0 x_coor item 0 y_coor
  ]

  if tipo_mejor_aptitud = 2 [

    let pixel area with [aptitud_uni_medio_p1 = valor]
    let x_coor [pxcor] of pixel
    let y_coor [pycor] of pixel

    report list item 0 x_coor item 0 y_coor
  ]

  if tipo_mejor_aptitud = 3 [

    let pixel area with [aptitud_multi_alto_p1 = valor]
    let x_coor [pxcor] of pixel
    let y_coor [pycor] of pixel

    report list item 0 x_coor item 0 y_coor
  ]

  if tipo_mejor_aptitud = 4 [

    let pixel area with [aptitud_multi_medio_p1 = valor]
    let x_coor [pxcor] of pixel
    let y_coor [pycor] of pixel

    report list item 0 x_coor item 0 y_coor
  ]

  if tipo_mejor_aptitud = 5 [

    let pixel area with [aptitud_multi_bajo_p1 = valor]
    let x_coor [pxcor] of pixel
    let y_coor [pycor] of pixel

    report list item 0 x_coor item 0 y_coor
  ]

  if tipo_mejor_aptitud = 6 [

    let pixel area with [aptitud_uni_alto_p2 = valor]
    let x_coor [pxcor] of pixel
    let y_coor [pycor] of pixel

    report list item 0 x_coor item 0 y_coor
  ]

  if tipo_mejor_aptitud = 7 [

    let pixel area with [aptitud_uni_medio_p2 = valor]
    let x_coor [pxcor] of pixel
    let y_coor [pycor] of pixel

    report list item 0 x_coor item 0 y_coor
  ]

  if tipo_mejor_aptitud = 8 [

    let pixel area with [aptitud_multi_alto_p2 = valor]
    let x_coor [pxcor] of pixel
    let y_coor [pycor] of pixel

    report list item 0 x_coor item 0 y_coor
  ]

  if tipo_mejor_aptitud = 9 [

    let pixel area with [aptitud_multi_medio_p2 = valor]
    let x_coor [pxcor] of pixel
    let y_coor [pycor] of pixel

    report list item 0 x_coor item 0 y_coor
  ]

  if tipo_mejor_aptitud = 10 [

    let pixel area with [aptitud_multi_bajo_p2 = valor]
    let x_coor [pxcor] of pixel
    let y_coor [pycor] of pixel

    report list item 0 x_coor item 0 y_coor
  ]

end

;-------------------------------------------------------------------------------------------------------------------

;##############################################  CONSTRUCCION  #####################################################
;; ejecuta el proceso de construccion que debe seguir cada promotora

to construir

  ask promotoras1 [

    ifelse intentos < (adaptacion * 6) [set intentos (intentos + 1)] [set intentos 0 set reinicios (reinicios + 1)]

    let pixel_ya_construido? [modificado] of patch-here
    let precio_pixel [precio_viviendas] of patch-here

    if pixel_ya_construido? = 0 [

      if tipologia_a_construir = "unifamiliar_estandar_alto" and demanda_unifamiliar_alto > 0 [

        ask patch-here [set modificado 1]
        ask patch-here [set disponible 0]
        ask patch-here [set tipo_viviendas 3]
        ask patch-here [set estandar 1]

        set demanda_unifamiliar_alto (demanda_unifamiliar_alto - 1)
        set intentos (intentos - 1)
        set num_constru_uni_p1 (num_constru_uni_p1 + 1)
        set num_constru_alto_p1 (num_constru_alto_p1 + 1)
        set ganancias (ganancias + (satisfaccion - precio_pixel + 2))
        set ganancias_p1 (ganancias_p1 + ganancias)
      ]

     if tipologia_a_construir = "unifamiliar_estandar_medio" and demanda_unifamiliar_medio > 0 [

        ask patch-here [set modificado 1]
        ask patch-here [set disponible 0]
        ask patch-here [set tipo_viviendas 3]
        ask patch-here [set estandar 2]

        set demanda_unifamiliar_medio (demanda_unifamiliar_medio - 1)
        set intentos (intentos - 1)
        set num_constru_uni_p1 (num_constru_uni_p1 + 1)
        set num_constru_medio_p1 (num_constru_medio_p1 + 1)
        set ganancias (ganancias + (satisfaccion - precio_pixel + 2))
        set ganancias_p1 (ganancias_p1 + ganancias)
      ]

     if tipologia_a_construir = "multifamiliar_estandar_alto" and demanda_multifamiliar_alto > 0 [

        ask patch-here [set modificado 1]
        ask patch-here [set disponible 0]
        ask patch-here [set tipo_viviendas 2]
        ask patch-here [set estandar 1]

        set demanda_multifamiliar_alto (demanda_multifamiliar_alto - 1)
        set intentos (intentos - 1)
        set num_constru_multi_p1 (num_constru_multi_p1 + 1)
        set num_constru_alto_p1 (num_constru_alto_p1 + 1)
        set ganancias (ganancias + (satisfaccion - precio_pixel + 2))
        set ganancias_p1 (ganancias_p1 + ganancias)
      ]

     if tipologia_a_construir = "multifamiliar_estandar_medio" and demanda_multifamiliar_medio > 0 [

        ask patch-here [set modificado 1]
        ask patch-here [set disponible 0]
        ask patch-here [set tipo_viviendas 2]
        ask patch-here [set estandar 2]

        set demanda_multifamiliar_medio (demanda_multifamiliar_medio - 1)
        set intentos (intentos - 1)
        set num_constru_multi_p1 (num_constru_multi_p1 + 1)
        set num_constru_medio_p1 (num_constru_medio_p1 + 1)
        set ganancias (ganancias + (satisfaccion - precio_pixel + 2))
        set ganancias_p1 (ganancias_p1 + ganancias)
      ]

     if tipologia_a_construir = "multifamiliar_estandar_bajo" and demanda_multifamiliar_bajo > 0 [

        ask patch-here [set modificado 1]
        ask patch-here [set disponible 0]
        ask patch-here [set tipo_viviendas 2]
        ask patch-here [set estandar 3]

        set demanda_multifamiliar_bajo (demanda_multifamiliar_bajo - 1)
        set intentos (intentos - 1)
        set num_constru_multi_p1 (num_constru_multi_p1 + 1)
        set num_constru_bajo_p1 (num_constru_bajo_p1 + 1)
        set ganancias (ganancias + (satisfaccion - precio_pixel + 2))
        set ganancias_p1 (ganancias_p1 + ganancias)
      ]
    ]
  ]

  ask promotoras2 [

    ifelse intentos < (adaptacion * 6) [set intentos (intentos + 1)] [set intentos 0 set reinicios (reinicios + 1)]

    let pixel_ya_construido? [modificado] of patch-here
    let precio_pixel [precio_viviendas] of patch-here

    if pixel_ya_construido? = 0 [

      if tipologia_a_construir = "unifamiliar_estandar_alto" and demanda_unifamiliar_alto > 0 [

        ask patch-here [set modificado 1]
        ask patch-here [set disponible 0]
        ask patch-here [set tipo_viviendas 3]
        ask patch-here [set estandar 1]

        set demanda_unifamiliar_alto (demanda_unifamiliar_alto - 1)
        set intentos (intentos - 1)
        set num_constru_uni_p2 (num_constru_uni_p2 + 1)
        set num_constru_alto_p2 (num_constru_alto_p2 + 1)
        set ganancias (ganancias + (satisfaccion - precio_pixel + 2))
        set ganancias_p2 (ganancias_p2 + ganancias)
      ]

     if tipologia_a_construir = "unifamiliar_estandar_medio" and demanda_unifamiliar_medio > 0 [

        ask patch-here [set modificado 1]
        ask patch-here [set disponible 0]
        ask patch-here [set tipo_viviendas 3]
        ask patch-here [set estandar 2]

        set demanda_unifamiliar_medio (demanda_unifamiliar_medio - 1)
        set intentos (intentos - 1)
        set num_constru_uni_p2 (num_constru_uni_p2 + 1)
        set num_constru_medio_p2 (num_constru_medio_p2 + 1)
        set ganancias (ganancias + (satisfaccion - precio_pixel + 2))
        set ganancias_p2 (ganancias_p2 + ganancias)
      ]

     if tipologia_a_construir = "multifamiliar_estandar_alto" and demanda_multifamiliar_alto > 0 [

        ask patch-here [set modificado 1]
        ask patch-here [set disponible 0]
        ask patch-here [set tipo_viviendas 2]
        ask patch-here [set estandar 1]

        set demanda_multifamiliar_alto (demanda_multifamiliar_alto - 1)
        set intentos (intentos - 1)
        set num_constru_multi_p2 (num_constru_multi_p2 + 1)
        set num_constru_alto_p2 (num_constru_alto_p2 + 1)
        set ganancias (ganancias + (satisfaccion - precio_pixel + 2))
        set ganancias_p2 (ganancias_p2 + ganancias)
      ]

     if tipologia_a_construir = "multifamiliar_estandar_medio" and demanda_multifamiliar_medio > 0 [

        ask patch-here [set modificado 1]
        ask patch-here [set disponible 0]
        ask patch-here [set tipo_viviendas 2]
        ask patch-here [set estandar 2]

        set demanda_multifamiliar_medio (demanda_multifamiliar_medio - 1)
        set intentos (intentos - 1)
        set num_constru_multi_p2 (num_constru_multi_p2 + 1)
        set num_constru_medio_p2 (num_constru_medio_p2 + 1)
        set ganancias (ganancias + (satisfaccion - precio_pixel + 2))
        set ganancias_p2 (ganancias_p2 + ganancias)
      ]

     if tipologia_a_construir = "multifamiliar_estandar_bajo" and demanda_multifamiliar_bajo > 0 [

        ask patch-here [set modificado 1]
        ask patch-here [set disponible 0]
        ask patch-here [set tipo_viviendas 2]
        ask patch-here [set estandar 3]

        set demanda_multifamiliar_bajo (demanda_multifamiliar_bajo - 1)
        set intentos (intentos - 1)
        set num_constru_multi_p2 (num_constru_multi_p2 + 1)
        set num_constru_bajo_p2 (num_constru_bajo_p2 + 1)
        set ganancias (ganancias + (satisfaccion - precio_pixel + 2))
        set ganancias_p2 (ganancias_p2 + ganancias)
      ]
    ]
  ]

end


;-------------------------------------------------------------------------------------------------------------------

;##############################################  REINICIAR INTENTOS  ###############################################
;; reinicia el numero de intentos para que en la nueva iteracion vuelvan a seguir el proceso de seleccion desde 0

to actualizar_estado_promotoras

  ask promotoras1 [
    set intentos 0
  ]

  ask promotoras2 [
    set intentos 0
  ]

end

;-------------------------------------------------------------------------------------------------------------------

;##############################################  GUARDAR RESULTADOS  ###############################################
;; guardar los resultados de la simulacion en una carpeta a parte

to guardar_simulacion

  set-current-directory (word directorio_de_modelo "\\resultados") ;; directorio para guardar los resultados

  gis:store-dataset (gis:patch-dataset modificado) (word "edificaciones_simuladas.asc")
  gis:store-dataset (gis:patch-dataset estandar)  (word "estandar_simulado.asc")
  gis:store-dataset (gis:patch-dataset tipo_viviendas)  (word "tipologia_resultado.asc")
  resumen_municipios

end


;-------------------------------------------------------------------------------------------------------------------

;########################################  ESTADÍSTICAS POR MUNICIPIOS  ############################################
;; guardar resultados divididos para cada municipio

to resumen_municipios

file-open (word "simulacion_cada_municipio.csv")
file-print (word "COD_MUN;NOM_MUN;TOTAL_PIX;SELECTED_PIX;PERCENTAGE_SELECTED;NUM_MULTI;NUM_UNI;NUM_EST_ALTO;NUM_EST_MEDIO;NUM_EST_BAJO" )

let mun 1

while [mun < 19 ][

  let patches_municipio count patches with [area_estudio = mun]
  let patches_selecc    count patches with [(area_estudio = mun) and (modificado = 1)]
  let nombre_mun ""

  ifelse   (mun = 1) [set nombre_mun "28002;Ajalvir" ]
    [ ifelse   (mun = 2) [set nombre_mun "28005;Alcala  de Henares" ]
      [ ifelse   (mun = 3) [set nombre_mun "28012;Anchuelo" ]
        [ ifelse   (mun = 4) [set nombre_mun "28032;Camarma de Esteruelas" ]
          [ ifelse   (mun = 5) [set nombre_mun "28049;Coslada" ]
            [ ifelse   (mun = 6) [set nombre_mun "28053;Daganzo de Arriba" ]
              [ ifelse   (mun = 7) [set nombre_mun "28057;Fresno de Torote" ]
                [ ifelse   (mun = 8) [set nombre_mun "28075;Loeches" ]
                  [ ifelse   (mun = 9) [set nombre_mun "28083;Meco" ]
                    [ ifelse   (mun = 10) [set nombre_mun "28084;Mejorada del Campo" ]
                      [ ifelse   (mun = 11) [set nombre_mun "28104;Paracuellos de Jarama" ]
                        [ ifelse   (mun = 12) [set nombre_mun "28130;San Fernando de Henares" ]
                          [ ifelse   (mun = 13) [set nombre_mun "28136;Santorcaz" ]
                            [ ifelse   (mun = 14) [set nombre_mun "28137;Santos de la Humosa, Los" ]
                              [ ifelse   (mun = 15) [set nombre_mun "28148;Torrejon de Ardoz" ]
                                [ ifelse   (mun = 16) [set nombre_mun "28154;Torres de la Alameda" ]
                                  [ ifelse   (mun = 17) [set nombre_mun "28156;Valdeavero" ]
                                    [ if   (mun = 18) [set nombre_mun "28172;Villalbilla" ]
    ]]]]]]]]]]]]]]]]]

file-print (word  nombre_mun ";" patches_municipio ";" patches_selecc ";" precision (patches_selecc * 100 / patches_municipio ) 2 ";"
            count patches with [(area_estudio = mun) and (modificado = 1) and (tipo_viviendas = 2)] ";"
            count patches with [(area_estudio = mun) and (modificado = 1) and (tipo_viviendas = 3)] ";"
            count patches with [(area_estudio = mun) and (modificado = 1) and (estandar = 1)] ";"
            count patches with [(area_estudio = mun) and (modificado = 1) and (estandar = 2)] ";"
            count patches with [(area_estudio = mun) and (modificado = 1) and (estandar = 3)] ";")

 set mun mun + 1
]

file-close

end

;-------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------

;###################################################################################################################
;#######################                                                                    ########################
;#######################  FUNCION PRINCIPAL QUE EJECUTA EL CONJUNTO DE PROCESOS DEL MODELO  ########################
;#######################                                                                    ########################
;###################################################################################################################

;-------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------


to ejecutar_modelo

  establecer_aptitudes ;; primero se establecen las aptitudes a los pixeles que son susceptibles a ser edificados
  crear_promotoras ;; se crean las promotoras

  while [ticks <= (Número_de_iteraciones - 1)] [ ;; restar 1 ya que el tick inicial es el 0

    calcular_demandas ;; se calculan las demandas en cada tick
    actualizar_estado_promotoras ;; se actualiza el estado de las promotoras, reinicializando los intentos

    while [demanda_total > 0] [ ;; mientras que la demanda total de la iteracion actual no este suplida

      movilizar_promotoras    ;; se movilizan las promotoras por el area de estudio (pixeles edificables)
      seleccion_mejor_pixel   ;; cada una selecciona donde quiere construir
      construir               ;; intenta constuir
      actualizar_demandas     ;; se actualizan las demandas
      do-plot1                ;; actualizar los datos del grafico 1
      do-plot2                ;; actualizar los datos del grafico 1

    ]

    tick ;; aumentar los ticks en 1
  ]

  guardar_simulacion ;; al finalizar se guardan los datos simulados

  user-message (word "¡Finalizado!")
  stop

end
@#$#@#$#@
GRAPHICS-WINDOW
10
10
1323
1403
-1
-1
1.0
1
10
1
1
1
0
0
0
1
0
1304
0
1383
0
0
1
ticks
30.0

BUTTON
1334
11
1504
125
INICIO
inicio\n\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1334
150
1504
183
Mostrar el área de estudio
mostrar_area_estudio
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1337
506
1507
539
Mostrar la zonificación legal
mostrar_zonificacion
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1337
614
1507
660
Mostrar zonificación por precios
mostrar_estandar_zona
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1336
696
1506
732
Mostrar edificación inicial
mostrar_zonas_edificadas
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1335
980
1505
1013
Urbano consolidado
mostrar_distancia_zonas_urbanas_consolidadas
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1335
1013
1505
1046
Carreteras
mostrar_distancia_carreteras
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1335
1046
1505
1079
Transporte público
mostrar_distancia_transporte_publico
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
1708
284
1843
350
Demanda_unifamiliar
600.0
1
0
Number

TEXTBOX
1340
947
1505
979
MOSTRAR DISTANCIAS A:
13
0.0
1

BUTTON
1335
1079
1505
1112
Zonas de trabajo
mostrar_distancia_zonas_trabajo
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1335
1112
1505
1145
Zonas verdes
mostrar_distancia_zonas_verdes
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1337
539
1507
572
Mostrar zonas urbanizables
mostrar_zonas_urbanizables
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1335
799
1688
843
Mostrar edificación simulada
mostrar_zonas_simuladas Tipo_visualización_zonas_simuladas
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
1339
193
1489
473
MUNICIPIOS:\n\n01) Ajalvir\n02) Alcala  de Henares\n03) Anchuelo\n04) Camarma de Esteruelas\n05) Coslada\n06) Daganzo de Arriba\n07) Fresno de Torote\n08) Loeches\n09) Meco\n10) Mejorada del Campo\n11) Paracuellos de Jarama\n12) San Fernando de Henares\n13) Santorcaz\n14) Los Santos de la Humosa\n15) Torrejon de Ardoz\n16) Torres de la Alameda\n17) Valdeavero\n18) Villalbilla
11
0.0
1

TEXTBOX
1512
507
1699
587
URBANO (azul)\nURBANIZABLE (verde)\nNO URBANIZABLE (gris oscuro)\nSIST.GENERALES (naranja)
13
0.0
1

TEXTBOX
1513
612
1615
665
CARA (naranja)\nMEDIA (amarillo)\nBARATA (verde)
13
0.0
1

SLIDER
1856
403
2053
436
Proporcion_multifamiliar_alto
Proporcion_multifamiliar_alto
0
100 - Proporcion_multifamiliar_medio - Proporcion_multifamiliar_bajo
10.0
1
1
NIL
HORIZONTAL

SLIDER
1856
435
2053
468
Proporcion_multifamiliar_medio
Proporcion_multifamiliar_medio
0
100
60.0
1
1
NIL
HORIZONTAL

SLIDER
1856
468
2053
501
Proporcion_multifamiliar_bajo
Proporcion_multifamiliar_bajo
0
100 - Proporcion_multifamiliar_medio - Proporcion_multifamiliar_alto
30.0
1
1
NIL
HORIZONTAL

BUTTON
1504
150
1685
183
Ocultar nombre municipios
ask nombres_municipios [ die ]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1506
696
1687
732
Mostrar estandar edificación
mostrar_viviendas_por_precios
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1707
13
2056
127
EJECUTAR MODELO
ejecutar_modelo\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
2199
45
2324
98
Terreno disponible
count patches with [disponible = 1]
17
1
13

MONITOR
2084
45
2195
98
Iteración actual
ticks + 1
17
1
13

INPUTBOX
1710
178
1845
238
Número_de_iteraciones
5.0
1
0
Number

BUTTON
1335
869
1505
915
Clasificación de las viviendas
mostrar_tipo_viviendas
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
1511
18
1632
118
INICIALIZACIÓN DEL MODELO\n\n(¡REQUERIDO ANTES DE EJECUTAR EL MODELO!)
13
0.0
1

TEXTBOX
1512
868
1662
916
VACANTE (verde)\nMULTIFAMILIAR (azul)\nUNIFAMILIAR (naranja)
13
0.0
1

TEXTBOX
1331
126
2073
154
__________________________________________________________________________________________________________________________
11
0.0
1

TEXTBOX
1697
10
1712
1172
|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n
11
0.0
1

TEXTBOX
2063
10
2078
1172
|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|
11
0.0
1

TEXTBOX
1713
150
1976
182
PARÁMETROS A SELECCIONAR:
13
0.0
1

TEXTBOX
1332
477
1700
515
-------------------------------------------------------------------------
15
0.0
1

TEXTBOX
2082
13
2232
31
MONOTORIZACIÓN:
13
0.0
1

TEXTBOX
1334
581
1706
599
-------------------------------------------------------------------------
15
0.0
1

TEXTBOX
1334
669
1717
707
-------------------------------------------------------------------------
15
0.0
1

TEXTBOX
1333
845
1703
863
-------------------------------------------------------------------------
15
0.0
1

TEXTBOX
1334
920
1703
938
-------------------------------------------------------------------------
15
0.0
1

TEXTBOX
1333
1158
2513
1186
___________________________________________________________________________________________________________________________________________________________________________________________________
11
0.0
1

TEXTBOX
2502
12
2517
1171
|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|
11
0.0
1

TEXTBOX
1720
910
2049
966
IMPORTANCIA DE LOS FACTORES (pesos que los distintos tipos de promotores deben tener en cuenta para la selección de zonas en las que quieren construir)
13
0.0
1

TEXTBOX
1855
174
2053
244
Cada iteración representa un ciclo de construcción, determinado por la demanda que introduzca (recomendable 1 o 2 años)\n
13
0.0
1

SLIDER
1715
981
2049
1014
Distancia_a_urbano_consolidado
Distancia_a_urbano_consolidado
0
1
0.4
0.01
1
NIL
HORIZONTAL

SLIDER
1715
1013
2049
1046
Distancia_a_carreteras
Distancia_a_carreteras
0
1
0.3
0.01
1
NIL
HORIZONTAL

SLIDER
1715
1046
2049
1079
Distancia_a_transporte_público
Distancia_a_transporte_público
0
1
0.3
0.01
1
NIL
HORIZONTAL

SLIDER
1715
1079
2049
1112
Distancia_a_zonas_de_trabajo
Distancia_a_zonas_de_trabajo
0
1
0.25
0.01
1
NIL
HORIZONTAL

SLIDER
1715
1112
2049
1145
Distancia_a_zonas_verdes
Distancia_a_zonas_verdes
0
1
0.1
0.01
1
NIL
HORIZONTAL

INPUTBOX
1709
404
1844
502
Demanda_multifamiliar
400.0
1
0
Number

TEXTBOX
1710
260
2018
292
Demanda de edificacaiones de tipo unifamiliar:
13
0.0
1

TEXTBOX
1711
380
2032
412
Demanda de edificaciones de tipo multifamiliar:\n
13
0.0
1

SLIDER
1855
284
2052
317
Proporcion_unifamiliar_medio
Proporcion_unifamiliar_medio
0
100
70.0
1
1
NIL
HORIZONTAL

SLIDER
1855
317
2052
350
Proporcion_unifamiliar_alto
Proporcion_unifamiliar_alto
0
100 - Proporcion_unifamiliar_medio
30.0
1
1
NIL
HORIZONTAL

TEXTBOX
1699
241
2066
259
-------------------------------------------------------------------------
15
0.0
1

TEXTBOX
1698
358
2070
376
·········································································
15
0.0
1

TEXTBOX
1698
506
2081
524
-------------------------------------------------------------------------
15
0.0
1

TEXTBOX
1717
535
1867
553
NÚMERO DE PROMOTORAS:
11
0.0
1

INPUTBOX
1714
568
1865
628
Número_promotoras_tipo_1
10.0
1
0
Number

INPUTBOX
1713
673
1864
733
Número_promotoras_tipo_2
20.0
1
0
Number

TEXTBOX
1881
569
2059
617
Promotoras tipo 1: generalistas, proyectos de todo tipo
13
0.0
1

TEXTBOX
1879
678
2046
732
Promotoras tipo 2: especializadas, enfocadas en proyectos concretos
13
0.0
1

TEXTBOX
1699
640
2068
658
·········································································
15
0.0
1

TEXTBOX
1717
768
2040
804
Grado de diferenciación entre cada tipo de promotora: 0 = ninguno, 1 = máximo
13
0.0
1

SLIDER
1714
824
2048
857
Diferenciación
Diferenciación
0
1
0.5
0.1
1
NIL
HORIZONTAL

TEXTBOX
1698
745
2070
763
-------------------------------------------------------------------------
15
0.0
1

TEXTBOX
1699
871
2065
889
-------------------------------------------------------------------------
15
0.0
1

BUTTON
1336
1205
1503
1238
NIL
establecer_aptitudes
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1336
1238
1503
1271
NIL
crear_promotoras
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1336
1370
1503
1403
NIL
construir
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
1336
742
1687
787
Tipo_visualización_zonas_simuladas
Tipo_visualización_zonas_simuladas
"TIPOLOGIA" "ESTANDAR" "TIPOLOGIA_Y_ESTANDAR"
1

BUTTON
1336
1271
1503
1304
NIL
movilizar_promotoras\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1336
1337
1503
1370
NIL
seleccion_mejor_pixel\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1336
1304
1503
1337
NIL
calcular_demandas\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
1516
981
1683
1157
El formato de los datos está reflejado en forma de aptitudes, es decir, los valores de distancia están invertidos y además normalizados a escala 0 - 10000.\n\nMás claro = mayor aptitud\nMás oscuro = menor aptitud
13
0.0
1

MONITOR
2328
45
2484
98
Edificaciones construidas
count patches with [modificado = 1]
17
1
13

MONITOR
2083
154
2267
203
Unifamiliares_promotoras_2
num_constru_uni_p2
17
1
12

MONITOR
2083
203
2267
252
Multifamiliares_promotoras_2
num_constru_multi_p2
17
1
12

MONITOR
2083
275
2268
324
Estándar_alto_promotoras_2
num_constru_alto_p2
17
1
12

MONITOR
2083
324
2268
373
Estándar_medio_promotoras_2
num_constru_medio_p2
17
1
12

MONITOR
2083
373
2268
422
Estándar_bajo_promotoras_2
num_constru_bajo_p2
17
1
12

MONITOR
2290
154
2484
203
Unifamiliares_promotoras_1
num_constru_uni_p1
17
1
12

MONITOR
2290
203
2484
252
Multifamiliares_promotoras_1
num_constru_multi_p1
17
1
12

MONITOR
2290
275
2484
324
Estándar_alto_promotoras_1
num_constru_alto_p1
17
1
12

MONITOR
2290
324
2484
373
Estándar_medio_promotoras_1
num_constru_medio_p1
17
1
12

MONITOR
2290
373
2484
422
Estándar_bajo_promotoras_1
num_constru_bajo_p1
17
1
12

TEXTBOX
2065
106
2511
124
----------------------------------------------------------------------------------------
15
0.0
1

TEXTBOX
2065
638
2506
656
----------------------------------------------------------------------------------------
15
0.0
1

TEXTBOX
2277
143
2292
649
:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:\n:
15
0.0
1

TEXTBOX
2068
257
2520
275
·······················································································
15
0.0
1

TEXTBOX
2085
127
2391
147
Edificaciones realizadas por cada tipo de promotora:
13
0.0
1

MONITOR
2291
454
2485
523
Total promotoras 1
num_constru_uni_p1 + num_constru_multi_p1
17
1
17

MONITOR
2083
455
2268
524
Total promotoras 2
num_constru_uni_p2 + num_constru_multi_p2
17
1
17

TEXTBOX
2065
430
2507
448
····························································································
15
0.0
1

TEXTBOX
1337
1179
1526
1197
Ejecución por puntos de control
13
0.0
1

MONITOR
2083
562
2268
631
Ganancias promotora 2
ganancias_p2 / Número_promotoras_tipo_2
17
1
17

MONITOR
2291
560
2485
629
Ganancias promotora 1
ganancias_p1 / Número_promotoras_tipo_1
17
1
17

TEXTBOX
2064
534
2509
552
····························································································
15
0.0
1

PLOT
2082
667
2484
899
Nuevas edificaciones
Tiempo
Estandar
0.0
5.0
0.0
200.0
true
true
"" ""
PENS
"Alto" 1.0 0 -13791810 true "" ""
"Medio" 1.0 0 -817084 true "" ""
"Bajo" 1.0 0 -6459832 true "" ""

PLOT
2082
922
2485
1145
Edificaciones por municipio
Municipio
Cantidad edificada
1.0
18.0
0.0
50.0
true
false
"" ""
PENS
"Edificaciones" 1.0 1 -16777216 true "" ""

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
