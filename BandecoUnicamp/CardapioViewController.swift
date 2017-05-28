//
//  CardapioViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 215//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class CardapioViewController: UIViewController, UIScrollViewDelegate {
	

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var pageControl: UIPageControl!
	
	// TODO: metodo que pega os cardapios somente da semana atual.
	// TODO: metodo que retorna cardapio só dos normais ou só dos vegetarianos.
	// TODO: talvez seja melhor fazer pedido de cardapio normal ou vegetariano separado??

    override func viewDidLoad() {
        super.viewDidLoad()
		
        
        // FIXME: make me async?
        loadNextDays()
        

		
		

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func loadNextDays() {
        print("carregou CardapioViewController!")
        let pages: [UIView?] = [UIView?]()
        
        
        // Inicializa o page control
        self.pageControl.currentPage = 0
        self.pageControl.numberOfPages = pages.count
        
        // Adicionar as páginas no scrollview
        
        
        // Inicialmente, vou pegar somente um dia (22/05/2017).
        let dates = CardapioRequest.getDates()
        
//        print("dates: \(dates)")
        
        for d in dates {
            CardapioRequest.getCardapio(date: d) {
                (cardapioData) in
                
                guard let cardapio = cardapioData, cardapio.keys.count > 0 else {
                    print("CardapioRequest nao retornou dados pro dia \(d)!")
                    return
                }
                
                
                // FIXME: lidar com situacao em que o cardapio e um dicionario vazio.
                
                
                let almoco = RefeicaoView(frame: CGRect(origin: self.view.frame.origin, size: self.view.frame.size), cardapio: cardapio["Almoço"]! as! [String: Any]) as UIView
                
                let jantar = RefeicaoView(frame: CGRect(origin: self.view.frame.origin, size: self.view.frame.size), cardapio: cardapio["Jantar"]! as! [String: Any]) as UIView

                (jantar as! RefeicaoView).refeicao.text = "Jantar"
                let pages = [almoco, jantar]
                
                for page in pages{
                    
                    // Calcula um novo frame para a página deslocando em X o tamanho de uma página
                    // para colocar as views lado a lado
                    page.frame = (page.frame.offsetBy(dx: self.scrollView.contentSize.width, dy: 0))
                    
                    page.frame = CGRect(x:page.frame.origin.x, y:0, width:self.scrollView.frame.width,height: self.scrollView.frame.height)
                    
                    // FIXME: bug relacionado a altura de cada view que mostra uma faixa preta em cima.
                    
                    // adiciona a página na scrollview
                    self.scrollView.addSubview(page)
                    
                    // calcula o tamanho do conteúdo da scrollview
                    self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width + self.view.frame.width, height: (page.frame.height))
                }
                
            }
        }

    }

}
