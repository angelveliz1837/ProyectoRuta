import UIKit
import AlamofireImage

// Celda de la tabla de socios
class ListaSocioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var listaImagenView: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var apellidoLabel: UILabel!
    @IBOutlet weak var correoLabel: UILabel!
    @IBOutlet weak var generalView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        layer.cornerRadius = 10
        backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Método para configurar la vista de la celda
    func configureView(viewList: Socio) {
        nombreLabel.text = viewList.first_name
        apellidoLabel.text = viewList.last_name
        correoLabel.text = viewList.email
        
        // Establecer la URL de la foto del socio
        let urlFotoSocio = viewList.avatar
        if let url = URL(string: urlFotoSocio) {
            listaImagenView?.af.setImage(withURL: url, placeholderImage: UIImage(named: "icon_usuario"))
        }
        
        // Hacer que la imagen sea redonda (si la imagen es cuadrada)
        listaImagenView?.contentMode = .scaleAspectFill
        listaImagenView?.layer.cornerRadius = listaImagenView.frame.size.width / 2
        listaImagenView?.clipsToBounds = true  // Es importante para asegurar que la imagen se recorte dentro del borde

        // Configuración adicional del view general
        generalView?.layer.shadowOffset = CGSize.zero
        generalView?.layer.shadowRadius = 1
        generalView?.layer.shadowOpacity = 1
        generalView?.layer.cornerRadius = 40
    }
}
