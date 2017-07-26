////
////  CardapioViewController.swift
////  BandecoUnicamp
////
////  Created by Gustavo Avena on 215//17.
////  Copyright © 2017 Gustavo Avena. All rights reserved.
////
//
//import UIKit
//import Dispatch
//
//struct TipoCardapio {
//    static let normal: [TipoRefeicao] = [.almoco, .jantar]
//    static let vegetariano: [TipoRefeicao] = [.almocoVegetariano, .jantarVegetariano]
//    static let todos: [TipoRefeicao] = [.almoco, .almocoVegetariano, .jantar, .jantarVegetariano]
//}
//
//class CardapioViewController: UIViewController, UIScrollViewDelegate {
//	
//
//	@IBOutlet weak var scrollView: UIScrollView!
//	@IBOutlet weak var pageControl: UIPageControl!
//    @IBOutlet weak var errorLabel: UILabel!
//    /* 
//     typeSegmentedControl:
//     0 -> Tradicional
//     1 -> Vegetariano 
//     */
//    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
//	
//    var pagesNormal = [UIView]()
//    var pagesVegetariano = [UIView]()
//    let errorString = "Desculpa, estamos com problemas técnicos!"
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // carrega a view com o segmentedControl correto para sua dieta. Pela primeira vez, isso comeca como false.
//        typeSegmentedControl.selectedSegmentIndex = UserDefaults(suiteName: "group.bandex.shared")!.bool(forKey: "vegetariano") ? 1 : 0
//        
//        scrollView.delegate = self
//        scrollView.isPagingEnabled = true
//        scrollView.isDirectionalLockEnabled = true
//
//        
//        CardapioServices.getAllCardapios() {
//            (cardapios) in
//            
//            // Inicializa o page control
//            self.pageControl.currentPage = 0
//            
//            
//            for cardapioDia in cardapios {
//                let cardapioViewNormal = CardapioView(frame: CGRect.zero, data: cardapioDia.data, almoco: cardapioDia.almoco, jantar: cardapioDia.jantar)
//                self.pagesNormal.append(cardapioViewNormal)
//            
//                // Inicializa todas as CardapioViews com frames iguais a CGRect.zero, porque os frames delas serao atribuidos corretamente no metodo loadScrollView.
//            
//                let cardapioViewVegetariano = CardapioView(frame: CGRect.zero, data: cardapioDia.data, almoco: cardapioDia.almocoVegetariano, jantar: cardapioDia.jantarVegetariano)
//                self.pagesVegetariano.append(cardapioViewVegetariano)
//            }
//            
//            self.loadScrollView()
//            
//            //Tanto faz se será do tamanho de pagesNormal ou pagesVegetariano
//            self.pageControl.numberOfPages = self.pagesNormal.count
//            
//            if(cardapios.count == 0) {
//                self.errorLabel.isHidden = false
//                self.errorLabel.text = self.errorString
//                self.errorLabel.adjustsFontSizeToFitWidth = true
//            } else {
//                self.errorLabel.isHidden = true
//            }
//            
//        }
//    }
//    
//    
//    
//    override func viewDidAppear(_ animated: Bool) {
//        for subview in self.view.subviews {
//            if let cardapio = subview as? CardapioView {
//                print(cardapio.almoco.refeicao.font)
//            }
//        }
//    }
//    
//    /// Atualize o segmented control e chama o reloadScrollView para atualizar qual cardapio sera exibido (normal ou vegetariano).
//    @IBAction func changeSegmentedControl(_ sender: Any) {
//        
//        // guardamos o pageNumber e offsetX para exibirmos o cardapio da outra dieta na mesma data, sem jogar o usuario para o inicio da scroll view.
//        let pageNumber = self.pageControl.currentPage
//        let offsetX = scrollView.contentOffset.x
//        
//        reloadScrollView()
//        
//        self.pageControl.currentPage = pageNumber
//        scrollView.contentOffset.x = offsetX
//    }
//    
//    
//    
//    /// Carrega a view pela primeira vez.
//    /// 
//    /// Esse metodo so e executado uma vez.
//    /// Carrega todas as CardapioViews e posiciona elas corretamente. Seta o atributo isHidden para das views, para exibir soh um dos cardapios por vez (normal ou vegetariano).
//    private func loadScrollView(){
//        let SCROLL_VIEW_HEIGHT = scrollView.frame.height
//
//        for view in scrollView.subviews{
//            if let refView = view as? RefeicaoView {
//                refView.removeFromSuperview()
//            }
//        }
//
//        self.scrollView.contentSize = CGSize(width:0,height:0)
//        
//        let dietaNormal = (self.typeSegmentedControl.selectedSegmentIndex == 0) // Guarda um bool relacionado a dieta do usuario, para decidir qual pagina exibir.
//        
//        for (pNormal, pVeg) in zip(self.pagesNormal, self.pagesVegetariano) {
//            
//            // Posiciona o cardapio normal e vegetariano de um dia no mesmo lugar. Mas soh exibe um deles.
//            pNormal.frame = CGRect(x:self.scrollView.contentSize.width, y:0, width:self.view.frame.width, height: SCROLL_VIEW_HEIGHT)
//            pVeg.frame = CGRect(x:self.scrollView.contentSize.width, y:0, width:self.view.frame.width, height: SCROLL_VIEW_HEIGHT)
//            
//            
//            // Decide qual dos cardapios mostrar.
//            pNormal.isHidden = !dietaNormal
//            pVeg.isHidden = dietaNormal
//            
//            // adiciona as duas CardapioViews na scrollview.
//            self.scrollView.addSubview(pNormal)
//            self.scrollView.addSubview(pVeg)
//            
//            
//            // atualiza o tamanho do conteúdo da scrollview
//            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width + self.view.frame.width, height: SCROLL_VIEW_HEIGHT)
//        }
//    }
//    
//    /// Chamado quando o usuario toca no segmented control.
//    ///
//    /// Inverte os atributos isHidden das CardapioViews.
//    private func reloadScrollView() {
//        let dietaNormal = (self.typeSegmentedControl.selectedSegmentIndex == 0)
//        
//        for (pNormal, pVeg) in zip(self.pagesNormal, self.pagesVegetariano) {
//            pNormal.isHidden = !dietaNormal
//            pVeg.isHidden = dietaNormal
//        }
//    }
//
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//         self.view.bringSubview(toFront: self.pageControl)
//    }
//    
//	func scrollViewDidScroll(_ scrollView: UIScrollView) {
//		// calcula o numero da página baseado no quanto o scrollview está deslocado em X
//		let page = floor(scrollView.contentOffset.x / self.view.frame.width)
//		
//		// Para atualizar o current page é necessário converter o float para Int
//		pageControl.currentPage = Int(page)
//	}
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//}
//
//
//extension CardapioViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 6
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        return UITableViewCell()
//    }
//    
//    
//}
