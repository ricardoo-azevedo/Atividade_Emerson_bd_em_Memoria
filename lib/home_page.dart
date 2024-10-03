import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final List<String> _contatos = [];
  final _formKey = GlobalKey<FormState>();

  Color corFundo = const Color(0xffe9d79d);
  Color corTexto = Colors.black;
  Color? corBotao = const Color(0xff47323b);
  Color formField = const Color(0xff47323b);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _contatos.add('${_controller1.text} - ${_controller2.text}');
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('contatos', _contatos);
      _controller1.clear();
      _controller2.clear();
    }
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? contatosSalvos = prefs.getStringList('contatos');
    if (contatosSalvos != null) {
      setState(() {
        _contatos.addAll(contatosSalvos);
      });
    }
  }

  Future<void> _removeData(int index) async {
    setState(() {
      _contatos.removeAt(index);
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('contatos', _contatos);
  }

  void mudarCor() {
    setState(() {
      if (corFundo == const Color(0xffe9d79d)) {
        corFundo = const Color(0xff47323b);
        corTexto = const Color(0xffe9d79d);
        corBotao = const Color(0xffb0764f);
        formField = corBotao!;
      } else if (corFundo == const Color(0xff47323b)) {
        corFundo = const Color(0xffe9d79d);
        corTexto = Colors.black;
        corBotao = const Color(0xff47323b);
        formField = corBotao!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        actions: [
          FloatingActionButton(
            onPressed: mudarCor,
            backgroundColor: corBotao,
            foregroundColor: const Color(0xffbaac81),
            child: const Icon(Icons.nightlight_rounded),
          ),
        ],
        backgroundColor: const Color(0xff735a55),
        title: const Center(
          child: Text(
            "         Lista de Contatos",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xffe9d79d),
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                style: TextStyle(
                  color: corTexto,
                ),
                decoration: InputDecoration(
                  labelText: "Inserir nome",
                  labelStyle: TextStyle(color: formField),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: formField),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: formField),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                controller: _controller1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite algum nome!";
                  }
                  if (value.length < 2) {
                    return "Adicione um nome maior!";
                  }
                  if (value.length > 25) {
                    return "Adicione um nome menor!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: _controller2,
                style: TextStyle(
                  color: corTexto,
                ),
                decoration: InputDecoration(
                  labelText: "Inserir um número",
                  labelStyle: TextStyle(color: formField),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: formField),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: formField),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite algum número!";
                  }
                  if (value.length < 4) {
                    return "Adicione um número maior!";
                  }
                  if (value.length > 25) {
                    return "Adicione um número menor!";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            // ignore: sized_box_for_whitespace
            Container(
              width: 180,
              height: 40,
              child: FloatingActionButton(
                onPressed: _saveData,
                backgroundColor: const Color(0xff735a55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Salvar",
                  style: TextStyle(color: Color(0xffe9d79d)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _contatos.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xffbaac81),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(_contatos[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Color(0xff5c4657)),
                        onPressed: () {
                          _removeData(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
