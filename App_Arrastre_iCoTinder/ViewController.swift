//
//  ViewController.swift
//  App_Arrastre_iCoTinder
//
//  Created by User on 7/1/16.
//  Copyright © 2016 iCologic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    //MARK: - VARIABLES LOCALES GLOBALES
    //esto lo que quiero es saber cuanto me he desplazado desde que empezo a hacer
    var xFromCenter : CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        //debemos decirle el tamaño y en donde esta ubicada nuestra etiqueta
        //para eso usamos una estructura de datos de tipo CGRect que nos da una posicion y un tamaño partiendo de la la esquina superior izquierda
        //Aqui le damos la posicion inicial y su tamaño
        let myLabel : UILabel = UILabel(frame: CGRectMake(0, 0, 200, 100))
        //aqui le asignamos que el centro de dicho etiqueta sea el centro de la pantalla
        myLabel.center = self.view.center
        //le damos un valor
        myLabel.text = "Arrástrame"
        //le decimos que su propiedad de alineacion se hacia la izquierda o el centro
        myLabel.textAlignment = NSTextAlignment.Center
        //Las etiquetas normalente no interactuan con los gestos
        myLabel.userInteractionEnabled = true
        
        
        
        
        //le tenemos que añadir a la jerarquia de vista de la pantalla
        self.view.addSubview(myLabel)
        
        
        //creamos un gesto de arrastre y le pasamos una funcion
        let gesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "heArrastradoLaEtiqueta:")
        //aqui le especificamos que objeto va a recibir dicho gesto
        myLabel.addGestureRecognizer(gesture)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //esta funcion deberia tener como atributo al gesture recognizer para saber cuanto le he arrastrado, sobre que vista, etc
    func heArrastradoLaEtiqueta (gestureReconizer: UIPanGestureRecognizer){
        
        //aqui le asignamos a una variable traslacion saber cuanto se ha traslado en la vista de la pantalla
        let traslation = gestureReconizer.translationInView(self.view)
        
        //aqui debemos recuperar la etiqueta ya que no me la he creado como una variable global, pero no pasa nada por que el propio gestureRecognizer sabe sobre quien ha detectado el gesto
        let myLabel = gestureReconizer.view as! UILabel
        
        //Puedo modificar el centro de la etiqueta (cuanto me muevo en eje x y en el eje y)
        // defino el centro de la etiqueta en eje x + lo que me he movido en el eje horizontal y mas lo que me movido en vertical
        myLabel.center = CGPoint(x: myLabel.center.x + traslation.x, y: myLabel.center.y + traslation.y)
        
        //le voy a ir sumando la traslacion en el eje horizontal
        xFromCenter = xFromCenter + traslation.x
        
        
        // mientras mas grande cerca el xfromCenter mas pequeño va a ser el escalado
        // mientras mas me lajo del centro de la pantalla mas pequeño se va a ver
        
        let scale = min(100 / abs(xFromCenter), 1)
        
        //Aqui podemos ver la rotacionde la etiqueta si queremos que rote 180 grados le decimos (PI_RADIANES) si quiero quw rote 90 sera PI_2 y si quiero que rote 45 grados sera PI_$
        let rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        //para apliacarle dicha rotacion a la etiqueta debo tocar una tributo que se llama trasformacion usando la MATRIZ DE TRASFORMACION
        //basicamente le vamos aplicar una transformacion en funcion de su tamaño, su rotacion, su desplazamiento etc..

        // le del escalado le paso el tipo de transformacion le paso la de "rotacion"
        //creamos una variable scale
        let stretch = CGAffineTransformScale(rotation, scale, scale)
        
        //Aqui la transformacion no puede ser la rotacion sino la de stretch
        //myLabel.transform = rotation
        myLabel.transform = stretch
        
        
        //Debo reiniciar la posicion del gesture recognizer ya que mientras no levante el dedo va a ir cumulando lo que se va trasladando
        gestureReconizer.setTranslation(CGPointZero, inView: self.view)
        //asi cada vez que llame a este metodo me dara la ultima posicion de la Etiqueta

        
        
        //Vamos a comprobar que si la etiqueta se ha desplazado de manera menor de 100 o mayor de 100 planteamos la condicion
        if myLabel.center.x < 100{
            print("Usuario NO Elegido")
        }else if myLabel.center.x > self.view.bounds.width - 100{
            
            print("Usuario Elegido")
        }else{
            print("ni Fu ni Fa")
        }
        
        
        
        //lo mas logico es que todo los elementos que sufren cambios vuelvan a su estado original
        // si gesture recgnozer  es igual a el estado finalizado por parte del usuario y ha levantado el dedo
        if gestureReconizer.state == UIGestureRecognizerState.Ended{
            myLabel.center = self.view.center
            myLabel.transform = CGAffineTransformIdentity // matriz de identidad
            xFromCenter = 0
            
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

