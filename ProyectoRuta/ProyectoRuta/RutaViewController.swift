import UIKit
import CoreData

class RutaViewController: UIViewController {
    
    var paraderos: [Paradero] = []
    var horaDatePickers: [UIDatePicker] = []
    var observacionTextFields: [UITextField] = []
    var enviarButtons: [UIButton] = []
    var resultHoraDatePickers: [UIDatePicker] = []
    var resultObservacionTextViews: [UITextView] = []
    var updateButtons: [UIButton] = []
    var guardarButtons: [UIButton] = [] // Aquí creamos una lista para los botones "Guardar"

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchParaderosActivos() // Cargar paraderos
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restoreValues() // Restaurar valores guardados
    }
    
    // MARK: - Funciones de lógica
    
    func connectBD() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }

    func fetchParaderosActivos() {
        let context = connectBD()
        let fetchRequest: NSFetchRequest<Paradero> = Paradero.fetchRequest()
        
        let predicate = NSPredicate(format: "estado == %@", "Activo")
        fetchRequest.predicate = predicate

        do {
            paraderos = try context.fetch(fetchRequest)
            setupUIForParaderos() // Configuración de la UI después de cargar los paraderos
        } catch {
            print("Error al obtener paraderos activos: \(error.localizedDescription)")
        }
    }

    func setupUIForParaderos() {
        horaDatePickers.removeAll()
        observacionTextFields.removeAll()
        enviarButtons.removeAll()
        resultHoraDatePickers.removeAll()
        resultObservacionTextViews.removeAll()
        updateButtons.removeAll()
        guardarButtons.removeAll() // Limpiar lista de botones "Guardar"
        
        let scrollView = UIScrollView(frame: view.bounds)
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        
        
        // Ajustar la restricción superior del contentView para darle un margen de 40 puntos
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),  // Margen de 10
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40),  // Margen inferior de 40
        ])
        
        var lastView: UIView? = nil
        
        for (index, paradero) in paraderos.enumerated() {
            let horaDatePicker = createDatePicker()
            let observacionTextField = createTextField(placeholder: "Observación para \(paradero.nombreParadero ?? "Paradero")")
            let enviarButton = createButton(title: "Enviar", action: #selector(didTapEnviar(_:)))
            
            let resultHoraDatePicker = createDatePicker()
            let resultObservacionTextView = createTextView()
            let updateButton = createButton(title: "Actualizar", action: #selector(didTapActualizar(_:)))
            
            // Crear botón "Guardar" para cada paradero
            let guardarButton = createButton(title: "Guardar", action: #selector(didTapGuardar(_:)))

            horaDatePickers.append(horaDatePicker)
            observacionTextFields.append(observacionTextField)
            enviarButtons.append(enviarButton)
            resultHoraDatePickers.append(resultHoraDatePicker)
            resultObservacionTextViews.append(resultObservacionTextView)
            updateButtons.append(updateButton)
            guardarButtons.append(guardarButton) // Añadir el botón de guardar a la lista

            let stack = createSectionStack(
                inputs: [horaDatePicker, observacionTextField, enviarButton],
                results: [resultHoraDatePicker, resultObservacionTextView, updateButton, guardarButton]
            )
            contentView.addSubview(stack)
            stack.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                stack.topAnchor.constraint(equalTo: lastView?.bottomAnchor ?? contentView.topAnchor, constant: 16),
            ])
            lastView = stack
        }
        
        if let lastView = lastView {
            lastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        }
    }

    // Funciones de creación de controles
    private func createDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        return datePicker
    }

    private func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        return textField
    }

    private func createTextView() -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.text = "Texto de resultado..."  // Opcional: Agregar un texto predeterminado

        // Restricción de altura mínima para asegurar que se vea
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true

        return textView
    }

    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func createSectionStack(inputs: [UIView], results: [UIView]) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        inputs.forEach { stack.addArrangedSubview($0) }
        results.forEach { stack.addArrangedSubview($0) }
        return stack
    }

    // MARK: - Funciones de acción

    @objc private func didTapEnviar(_ sender: UIButton) {
        guard let index = enviarButtons.firstIndex(of: sender) else { return }
        let hora = horaDatePickers[index].date
        let observacion = observacionTextFields[index].text ?? ""

        resultHoraDatePickers[index].date = hora
        resultObservacionTextViews[index].text = observacion
        
        // Aplicar estilos al enviar
        resultObservacionTextViews[index].backgroundColor = .black
        resultObservacionTextViews[index].textColor = .white
        
        // Cambiar el color de observacionTextField a blanco
        observacionTextFields[index].textColor = .white

        // Deshabilitar elementos de entrada y habilitar botón de actualización
        enviarButtons[index].isEnabled = false
        horaDatePickers[index].isUserInteractionEnabled = false
        observacionTextFields[index].isUserInteractionEnabled = false
        updateButtons[index].isEnabled = true
        
        // Guardar estado en UserDefaults
        UserDefaults.standard.set(true, forKey: "enviado_\(index)")
        UserDefaults.standard.set(true, forKey: "textoEnBlanco_\(index)")
    }

    @objc private func didTapActualizar(_ sender: UIButton) {
        guard let index = updateButtons.firstIndex(of: sender) else { return }
        
        // Permitir la edición del resultObservacionTextView
        resultObservacionTextViews[index].isEditable = true
        resultObservacionTextViews[index].backgroundColor = .white
        resultObservacionTextViews[index].textColor = .black
        
        // Rellenar el texto de la observación con el valor actualizado
        let nuevaObservacion = observacionTextFields[index].text ?? ""
        resultObservacionTextViews[index].text = nuevaObservacion
    }

    @objc private func didTapGuardar(_ sender: UIButton) {
        guard let index = guardarButtons.firstIndex(of: sender) else { return }
        
        let hora = horaDatePickers[index].date
        let observacion = observacionTextFields[index].text ?? ""
        let resultHora = resultHoraDatePickers[index].date
        let resultObservacion = resultObservacionTextViews[index].text ?? ""
        
        // Guardar en UserDefaults
        UserDefaults.standard.set(hora, forKey: "hora_\(index)")
        UserDefaults.standard.set(observacion, forKey: "observacion_\(index)")
        UserDefaults.standard.set(resultHora, forKey: "resultHora_\(index)")
        UserDefaults.standard.set(resultObservacion, forKey: "resultObservacion_\(index)")

        // Verificar que los valores se guardaron
        print("Guardando: hora_\(index): \(hora), observacion_\(index): \(observacion), resultHora_\(index): \(resultHora), resultObservacion_\(index): \(resultObservacion)")
    }

    func restoreValues() {
        for i in 0..<paraderos.count {
            if let storedHora = UserDefaults.standard.object(forKey: "hora_\(i)") as? Date {
                horaDatePickers[i].date = storedHora
            }
            
            if let storedObservacion = UserDefaults.standard.string(forKey: "observacion_\(i)") {
                observacionTextFields[i].text = storedObservacion
            }
            
            if let storedResultHora = UserDefaults.standard.object(forKey: "resultHora_\(i)") as? Date {
                resultHoraDatePickers[i].date = storedResultHora
            }
            
            if let storedResultObservacion = UserDefaults.standard.string(forKey: "resultObservacion_\(i)") {
                resultObservacionTextViews[i].text = storedResultObservacion
            }
            
            // Restaurar si el botón "Enviar" debe estar deshabilitado
            if UserDefaults.standard.bool(forKey: "enviado_\(i)") {
                enviarButtons[i].isEnabled = false
                observacionTextFields[i].textColor = .white  // Asegurarse de que el color de texto sea blanco si se ha enviado
                horaDatePickers[i].isUserInteractionEnabled = false
                observacionTextFields[i].isUserInteractionEnabled = false
            }
        }
    }
}

