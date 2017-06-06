//
//  CardapioViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 215//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import Dispatch

struct TipoCardapio {
    static let normal: [Refeicao] = [.almoco, .jantar]
    static let vegetariano: [Refeicao] = [.almocoVegetariano, .jantarVegetariano]
    static let todos: [Refeicao] = [.almoco, .almocoVegetariano, .jantar, .jantarVegetariano]
}

class CardapioViewController: UIViewController, UIScrollViewDelegate {
	

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var pageControl: UIPageControl!
	
	// TODO: metodo que pega os cardapios somente da semana atual.
	// TODO: metodo que retorna cardapio só dos normais ou só dos vegetarianos.
	// TODO: talvez seja melhor fazer pedido de cardapio normal ou vegetariano separado??

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
		
        scrollView.isPagingEnabled = true
        scrollView.isDirectionalLockEnabled = true
        
        // FIXME: acho que o pageControl nao aparece porque nos colocamos subviews em cima dele... Entao acho que ele fica escondido no eixo z.
        // OBS: coloquei o pageControl todo vermelho para facilitar a solucao disso (fica mais facil de ver ele)... depois eu mudo a cor.
        
        // TODO: chamar metodo que recebera vetor de CardapioDia para todas as datas. Exibir as que o usuario quiser.
        
        
        CardapioServices.getCardapiosBulk(for: CardapioServices.getDates(next: 3)) {
            (cardapios) in
            
            let SCROLL_VIEW_HEIGHT = self.scrollView.frame.height
            
            var pages = [UIView]()
            
            // Inicializa o page control
            self.pageControl.currentPage = 0

            
            for cardapioDia in cardapios {
                
                for r in TipoCardapio.todos {
                    let pageFrameSize = CGSize(width: self.scrollView.frame.width, height: SCROLL_VIEW_HEIGHT)
                    let pageFrame = CGRect(origin: self.scrollView.frame.origin, size: pageFrameSize)
                    let refeicaoView = RefeicaoView(frame: pageFrame, data: cardapioDia.data, refeicao: r, cardapioDia: cardapioDia)
                    pages.append(refeicaoView)
                }
                
                
            }
            
            
            for page in pages{
                
                // Calcula um novo frame para a página deslocando em X o tamanho de uma página
                // para colocar as views lado a lado
                page.frame = (page.frame.offsetBy(dx: self.scrollView.contentSize.width, dy: 0))
                
                page.frame = CGRect(x:page.frame.origin.x, y:0, width:self.scrollView.frame.width,height: SCROLL_VIEW_HEIGHT)
                
                // FIXME: bug relacionado a altura de cada view que mostra uma faixa preta em cima.

                
                // adiciona a página na scrollview
                self.scrollView.addSubview(page)
                
                // calcula o tamanho do conteúdo da scrollview
                self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width + self.view.frame.width, height: SCROLL_VIEW_HEIGHT)
                
                
                
            }
            
            self.pageControl.numberOfPages = pages.count
           
            
            print("terminou getCardapios")
            
        }
        
        

    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         self.view.bringSubview(toFront: self.pageControl)
    }
    
    
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		// calcula o numero da página baseado no quanto o scrollview está deslocado em X
		let page = floor(scrollView.contentOffset.x / self.view.frame.width)
		
		// Para atualizar o current page é necessário converter o float para Int
		pageControl.currentPage = Int(page)
	}


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
}
