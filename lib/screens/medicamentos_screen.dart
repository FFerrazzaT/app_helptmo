import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'novoRegistro_screen.dart';

class MedicamentosScreen extends StatefulWidget {
  const MedicamentosScreen({Key? key}) : super(key: key);

  @override
  _MedicamentosScreenState createState() => _MedicamentosScreenState();
}

class _MedicamentosScreenState extends State<MedicamentosScreen> {
  final formKey = GlobalKey<FormState>();
  var modelo = ModeloMedicamento();
  DateTime date = DateTime.now();

  TextEditingController _datecontroller = new TextEditingController();

  var myFormat = DateFormat('dd/MM/yyyy');
  String hintData = 'Selecione a data de início';

  showAlertDialog1(BuildContext context) {
    AlertDialog alerta = AlertDialog(
      title: Text("Registro realizado com sucesso!"),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2222));
    if (picked != null && picked != date)
      setState(() {
        date = picked;
        hintData = '${myFormat.format(date)}';
        modelo.dataInicio = '${myFormat.format(date)}';
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo registro de medicamento'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              CustomTextField(
                label: 'Nome do medicamento',
                icon: Icons.search,
                hint: 'Escreva o nome do medicamento...',
                validator: (text) => text == null || text.isEmpty
                    ? 'Esse campo deve ser preenchido!'
                    : null,
                onSaved: (text) => modelo = modelo.copyWith(medicamento: text),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () => _selectDate(context),
                child: IgnorePointer(
                  child: TextFormField(
                    validator: (dataInicio) =>
                        modelo.dataInicio != '${myFormat.format(date)}'
                            ? 'Esse campo deve ser preenchido!'
                            : null,
                    onSaved: (dataInicio) {
                      debugPrint(dataInicio.toString());
                    },
                    controller: _datecontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today_rounded),
                      hintText: (hintData),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 500,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Modo de usar',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Container(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLines: 5,
                  validator: (text) => text == null || text.isEmpty
                      ? 'Esse campo deve ser preenchido!'
                      : null,
                  onSaved: (text) => modelo = modelo.copyWith(modoUso: text),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: Icon(
                        Icons.mode,
                      ),
                    ),
                    hintText: 'Oral, tópico...',
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(fixedSize: Size(200, 70)),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NovoRegistroScreen(),
                            ),
                          );
                          showAlertDialog1(context);
                          print(modelo.medicamento);
                          print(modelo.modoUso);
                          print(modelo.dataInicio);
                        }
                      },
                      icon: Icon(Icons.save_alt),
                      label: Text('Registrar'),
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(fixedSize: Size(200, 70)),
                      onPressed: () {
                        setState(() {
                          hintData = 'Selecione a data de início';
                          date = DateTime.now();
                        });
                        formKey.currentState?.reset();
                      },
                      icon: Icon(Icons.delete),
                      label: Text('Limpar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? icon;
  final Widget? suffix;
  final String? Function(String? text)? validator;
  final void Function(String? text)? onSaved;

  const CustomTextField({
    Key? key,
    required this.label,
    this.icon,
    this.hint,
    this.validator,
    this.onSaved,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
        prefixIcon: icon == null ? null : Icon(icon),
        suffixIcon: suffix,
      ),
    );
  }
}

class ModeloMedicamento {
  final String medicamento;
  final String modoUso;
  String dataInicio;

  ModeloMedicamento(
      {this.dataInicio = '', this.medicamento = '', this.modoUso = ''});

  ModeloMedicamento copyWith({
    String? medicamento,
    String? modoUso,
    String? dataInicio,
  }) {
    return ModeloMedicamento(
      medicamento: medicamento ?? this.medicamento,
      modoUso: modoUso ?? this.modoUso,
      dataInicio: dataInicio ?? this.dataInicio,
    );
  }
}
