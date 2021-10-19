usuarios = {
    nomes = {"Maria","Douglas","joão","Marcelo"},
    idades = {27, 32, 19 , 24},
    imprimeDados = function  (self,id)      
       print("Usuário:",self.nomes[id]," \nIdade:        ",self.idades[id]);

    end
}

usuarios.imprimeDados(usuarios,1);
print("\n\nAdicionando novo usuário...\nNome = Valentina\n idade = 20\n\n");

table.insert(usuarios.nomes,"Valentina");
table.insert(usuarios.idades, 20);
usuarios:imprimeDados(#usuarios.nomes);