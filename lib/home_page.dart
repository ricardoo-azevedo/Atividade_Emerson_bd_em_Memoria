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

  Color corFundo = Colors.white;
  Color corTexto = Colors.black;
  Color? corBotao = Color.fromARGB(255, 58, 4, 67);

  

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
    
  void mudarCor(){
    setState(() {
      if(corFundo == Colors.white){
      corFundo = Color.fromARGB(255, 58, 4, 67);
      corTexto = Colors.white;
      corBotao = Colors.deepPurple[200];
    }else if(corFundo == Color.fromARGB(255, 58, 4, 67)){
      corFundo = Colors.white;
      corTexto = Color.fromARGB(255, 58, 4, 67);
      corBotao = Color.fromARGB(255, 58, 4, 67);
    }
    });
    
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        actions: [
          FloatingActionButton(onPressed: mudarCor,
          backgroundColor: corBotao,
          ),
        ],
        backgroundColor: Colors.deepPurple[300],
        title: const Center(
          child: Text(
            "         Lista de Contatos",
            style: TextStyle(
              fontWeight: FontWeight.w500, 
              color: Colors.white,
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
                style:  TextStyle(
                  color: corTexto,
                ),
                decoration: const InputDecoration(
                  
                    labelText: "Inserir nome",
                    border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white
                    )
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
                style:  TextStyle(
                  color: corTexto,
                ),
                decoration: const InputDecoration(
                  labelText: "Inserir um número",
                  
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite algum número!";
                  }
                  if (value.length < 4) {
                    return "Adicione um número maior!";
                  }
                  if (value.length > 18) {
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
                backgroundColor: Colors.deepPurple[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Salvar",
                  style: TextStyle(color: Colors.white),
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
                      color: Colors.deepPurple[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(_contatos[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.deepPurple),
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
