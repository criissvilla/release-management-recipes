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
      title: 'Calculadora IMC Pro',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
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
  int _indiceActual = 0;

  // Variables para la calculadora
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  String _perfilSeleccionado = 'Persona Común';
  
  // Resultados
  double _imc = 0.0;
  String _resultadoTexto = '';
  String _dietaSugerida = 'Calculá tu IMC para ver tu dieta.';
  String _rutinaSugerida = 'Calculá tu IMC para ver tu rutina.';
  String _mensajeMotivacional = '¡Tu salud es lo primero! Cuidá tu cuerpo cada día.';
  List<String> _riesgos = [];

  // Lista para el historial de avances
  final List<String> _historialAvances = ['Registro inicial: App lista para usar'];

  void _calcularIMC() {
    final double? peso = double.tryParse(_pesoController.text);
    final double? altura = double.tryParse(_alturaController.text);

    if (peso == null || altura == null || altura <= 0 || peso <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresá valores válidos.')),
      );
      return;
    }

    // Calcular IMC (Peso / Altura^2)
    setState(() {
      _imc = peso / (altura * altura);
      _riesgos.clear();

      if (_perfilSeleccionado == 'Embarazada') {
        _resultadoTexto = 'IMC Actual: ${_imc.toStringAsFixed(1)}\nNota: El IMC gestacional varía según la semana de embarazo.';
        _mensajeMotivacional = '¡Felicitaciones por esta hermosa etapa! Recordá que estás creando vida. Tu peso actual es el adecuado para proteger a tu bebé.';
        _dietaSugerida = 'Dieta Nutritiva:\n- Incrementá el consumo de ácido fólico y hierro (espinacas, legumbres).\n- Proteínas magras (pollo, pescado bien cocido, huevos).\n- Lácteos pasteurizados y mucha agua.';
        _rutinaSugerida = 'Rutina de Bajo Impacto:\n- Caminatas suaves de 20 a 30 minutos.\n- Estiramientos ligeros.\n- Ejercicios de respiración y yoga prenatal (evitando rebotes).';
      } 
      else if (_perfilSeleccionado == 'Deportista') {
        if (_imc >= 25) {
          _resultadoTexto = 'IMC: ${_imc.toStringAsFixed(1)} (Musculatura Elevada)';
          _mensajeMotivacional = '¡Excelente estado físico! Tu IMC es alto debido a tu gran masa muscular, no por grasa. ¡Seguí entrenando con todo!';
        } else {
          _resultadoTexto = 'IMC: ${_imc.toStringAsFixed(1)} (Atlético)';
          _mensajeMotivacional = '¡Nivel de deportista óptimo! Mantenés una gran relación entre peso y masa muscular.';
        }
        _dietaSugerida = 'Dieta Hiperproteica e Energética:\n- Carbohidratos complejos (avena, arroz integral) para rendir.\n- Proteínas de alta calidad para reparar músculo.\n- Grasas saludables (palta, frutos secos).';
        _rutinaSugerida = 'Rutina de Alto Rendimiento:\n- 4 a 5 días de entrenamiento de fuerza/hipertrofia.\n- 2 sesiones de cardio HIIT a la semana.\n- Enfoque en sobrecarga progresiva.';
      } 
      else {
        // Persona Común
        if (_imc < 18.5) {
          _resultadoTexto = 'IMC: ${_imc.toStringAsFixed(1)} (Bajo peso)';
          _mensajeMotivacional = 'Es importante asegurar que estés sumando los nutrientes necesarios. ¡Cuidate!';
          _dietaSugerida = 'Dieta para ganar masa limpia:\n- Superávit calórico controlado.\n- Frutos secos, lácteos enteros, carnes y legumbres.';
          _rutinaSugerida = 'Rutina Funcional:\n- Ejercicios con el propio peso corporal (flexiones, sentadillas).\n- Cardio moderado 2 veces por semana.';
        } else if (_imc >= 18.5 && _imc < 25) {
          _resultadoTexto = 'IMC: ${_imc.toStringAsFixed(1)} (Peso Saludable)';
          _mensajeMotivacional = '¡Espectacular! Estás en tu rango ideal. Mantené estos buenos hábitos.';
          _dietaSugerida = 'Dieta de Mantenimiento:\n- Plato equilibrado (50% verduras, 25% proteína, 25% carbohidratos).\n- Frutas frescas y agua.';
          _rutinaSugerida = 'Rutina Saludable:\n- 150 minutos de actividad física moderada a la semana.\n- Caminatas, bicicleta o natación.';
        } else {
          _resultadoTexto = 'IMC: ${_imc.toStringAsFixed(1)} (Sobrepeso/Obesidad)';
          _mensajeMotivacional = '¡Vos podés! Cada pequeño cambio en tus hábitos diarios cuenta para mejorar tu bienestar.';
          _dietaSugerida = 'Dieta de Déficit Calórico Saludable:\n- Reducir azúcares refinados y ultraprocesados.\n- Más porciones de verduras y proteínas saciantes.';
          _rutinaSugerida = 'Rutina de Quema de Grasa y Fuerza:\n- Cardio de bajo impacto para cuidar articulaciones (elíptica, caminata rápida).\n- Circuitos de fuerza livianos.';
          
          // Agregar factores de riesgo médicos si el IMC es alto
          _riesgos = [
            'Cardiovascular: Mayor esfuerzo del corazón y presión arterial elevada.',
            'Metabólico: Riesgo de resistencia a la insulina o diabetes tipo 2.',
            'Articular: Sobrecarga en rodillas, tobillos y columna debido al peso.'
          ];
        }
      }

      // Guardar de forma automática en la pestaña de avances
      _historialAvances.insert(0, 'Fecha actual - Peso: ${peso}kg - Perfil: $_perfilSeleccionado - IMC: ${_imc.toStringAsFixed(1)}');
    });

    // Cambiar automáticamente a la pestaña de planes para ver la rutina
    setState(() {
      _indiceActual = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Definir las 3 pantallas principales
    final List<Widget> pantallas = [
      _construirPantallaCalculadora(),
      _construirPantallaPlanes(),
      _construirPantallaAvances(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora IMC Inteligente', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: pantallas[_indiceActual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceActual,
        onTap: (index) {
          setState(() {
            _indiceActual = index;
          });
        },
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Calculadora'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Mis Planes'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Mis Avances'),
        ],
      ),
    );
  }

  Widget _construirPantallaCalculadora() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Seleccioná tu Perfil',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _perfilSeleccionado,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
            items: ['Persona Común', 'Deportista', 'Embarazada'].map((String valor) {
              return DropdownMenuItem<String>(value: valor, child: Text(valor));
            }).toList(),
            onChanged: (nuevoValor) {
              setState(() {
                _perfilSeleccionado = nuevoValor!;
              });
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _pesoController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Peso en Kilogramos (ej: 75.5)',
              prefixIcon: const Icon(Icons.scale),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _alturaController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Altura en Metros (ej: 1.75)',
              prefixIcon: const Icon(Icons.height),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: _calcularIMC,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('CALCULAR Y GENERAR PLANES', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 25),
          if (_imc > 0) ...[
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(_resultadoTexto, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 10),
                    Text(_mensajeMotivacional, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.teal)),
                  ],
                ),
              ),
            ),
          ],
          if (_riesgos.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text('Factores de Riesgo Médicos Asociados:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.redAccent)),
            const SizedBox(height: 8),
            ..._riesgos.map((riesgo) => Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(riesgo, style: const TextStyle(fontSize: 13, color: Colors.black87))),
                ],
              ),
            )),
          ]
        ],
      ),
    );
  }

  Widget _construirPantallaPlanes() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.restaurant, color: Colors.orange),
                      SizedBox(width: 10),
                      Text('Plan de Alimentación Asignado', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 20),
                  Text(_dietaSugerida, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.fitness_center, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Guía de Ejercicios y Rutina', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 20),
                  Text(_rutinaSugerida, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirPantallaAvances() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Historial de Cambios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
          const SizedBox(height: 5),
          const Text('Cada vez que calculás un nuevo peso, se registra acá automáticamente.', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const Divider(height: 25),
          Expanded(
            child: ListView.builder(
              itemCount: _historialAvances.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.show_chart, color: Colors.teal),
                    title: Text(_historialAvances[index], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
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
