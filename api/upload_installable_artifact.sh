import 'package:flutter/material.dart';

void main() {
  runApp(const MiAppIMC());
}

class MiAppIMC extends StatelessWidget {
  const MiAppIMC({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora IMC Inteligente',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterialDesign: true,
      ),
      home: const PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _currentIndex = 0;
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  
  double? _imc;
  String _resultadoTexto = '';
  String _genero = 'Masculino';
  final List<String> _historial = [];

  void _calcularIMC() {
    final double? peso = double.tryParse(_pesoController.text);
    final double? altura = double.tryParse(_alturaController.text);

    if (peso == null || altura == null || altura <= 0 || peso <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa valores válidos y mayores a cero')),
      );
      return;
    }

    // Corrección lógica: Si la altura se ingresa en centímetros (ej. 175), la pasa a metros (1.75)
    double alturaMetros = altura;
    if (altura > 3.0) {
      alturaMetros = altura / 100.0;
    }

    // Validación lógica: Evitar estaturas imposibles en metros
    if (alturaMetros > 2.5 || alturaMetros < 0.5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, revisa la altura ingresada')),
      );
      return;
    }

    setState(() {
      _imc = peso / (alturaMetros * alturaMetros);
      
      // Clasificación corregida rigurosamente según la OMS
      if (_imc! < 18.5) {
        _resultadoTexto = 'Bajo peso (Requiere superávit calórico)';
      } else if (_imc! >= 18.5 && _imc! < 25.0) {
        _resultadoTexto = 'Peso normal (Saludable)';
      } else if (_imc! >= 25.0 && _imc! < 30.0) {
        _resultadoTexto = 'Sobrepeso (Monitorear alimentación)';
      } else {
        _resultadoTexto = 'Obesidad (Se recomienda consulta médica)';
      }

      _historial.add(
        '${DateTime.now().day}/${DateTime.now().month} - IMC: ${_imc!.toStringAsFixed(1)} ($_resultadoTexto)'
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pantallas = [
      _buildCalculadora(),
      _buildPlanes(),
      _buildHistorial(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('IMC Inteligente', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: pantallas[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.teal,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Calculadora'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Planes'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
        ],
      ),
    );
  }

  Widget _buildCalculadora() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Análisis de Composición Corporal',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
            textAlign: Center,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _genero,
            decoration: const InputDecoration(labelText: 'Género', border: OutlineInputBorder()),
            items: ['Masculino', 'Femenino'].map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _genero = newValue!;
              });
            },
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _pesoController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Peso (kg)', placeholder: 'Ej: 75.5', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _alturaController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Altura (cm o m)', placeholder: 'Ej: 175 o 1.75', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _calcularIMC,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, padding: const EdgeInsets.all(15)),
            child: const Text('CALCULAR IMC', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          if (_imc != null) ...[
            const SizedBox(height: 30),
            Card(
              color: Colors.teal.shade50,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text('Tu IMC es: ${_imc!.toStringAsFixed(1)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(
                      _resultadoTexto, 
                      style: TextStyle(fontSize: 18, color: _imc! < 18.5 || _imc! >= 25.0 ? Colors.red.shade900 : Colors.teal.shade900, fontWeight: FontWeight.bold),
                      textAlign: Center,
                    ),
                  ],
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildPlanes() {
    return ListView(
      padding: const EdgeInsets.all(15.0),
      children: [
        const Text('Guías y Orientación Nutricional', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal), textAlign: Center),
        const SizedBox(height: 15),
        
        // Sección corregida: Consejos específicos según el resultado actual para evitar contradicciones
        if (_imc != null && _imc! < 18.5)
          _buildCardPlan(
            'Plan Crítico: Recuperación de Peso Bajo', 
            'Enfoque: Superávit calórico controlado.\n\n• Nutrición: Incrementa el consumo de grasas saludables (palta, frutos secos, aceite de oliva) y proteínas de alta calidad (huevo, pollo, legumbres). Realiza de 5 a 6 comidas al día sin saltearte ninguna.\n• Entrenamiento: Prioriza ejercicios de fuerza con peso para estimular el desarrollo de masa muscular magra, reduciendo las sesiones largas de cardio intenso.'
          ),
          
        _buildCardPlan(
          'Estrategia de Alimentación General', 
          '• Desayuno energético: Avena integral, frutas de estación y fuente proteica.\n• Almuerzo balanceado: Proteína magra a la plancha, carbohidratos complejos (arroz integral o boniato) y abundantes vegetales verdes.\n• Merienda: Yogur natural o griego sin azúcar con un puñado de almendras.\n• Cena ligera: Pescado o pechuga con verduras al vapor o al horno.'
        ),
        _buildCardPlan(
          'Distribución de Entrenamiento Funcional', 
          '• Lunes: Estabilidad, fuerza básica y ejercicios multiarticulares (sentadillas, flexiones).\n• Miércoles: Resistencia neuromuscular y trabajo de zona media (core).\n• Viernes: Sesión de desarrollo de fuerza general o funcional de intensidad media.\n• Sábado/Domingo: Descanso activo o caminata regenerativa para permitir la reparación de los tejidos.'
        ),
      ],
    );
  }

  Widget _buildCardPlan(String titulo, String detalle) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ExpansionTile(
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
        children: [Padding(padding: const EdgeInsets.all(15.0), child: Text(detalle, style: const TextStyle(fontSize: 15, height: 1.4)))],
      ),
    );
  }

  Widget _buildHistorial() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          const Text('Historial de Mediciones', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
          const SizedBox(height: 15),
          _historial.isEmpty
              ? const Expanded(child: Center(child: Text('No hay registros guardados en esta sesión.', style: TextStyle(color: Colors.grey))))
              : Expanded(
                  child: ListView.builder(
                    itemCount: _historial.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.trending_up, color: Colors.teal),
                          title: Text(_historial[index]),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}