#!/bin/bash

# Verifica se o programa 7z está instalado
#if ! command -v 7z &> /dev/null; then
#    echo "7z não está instalado. Instale-o primeiro."
#    exit 1
#fi

# Para cada arquivo com a extensão .7z no diretório atual
for file in *.7z; do
    # Verifica se existem arquivos com a extensão .7z no diretório
    if [ ! -f "$file" ]; then
        echo "Nenhum arquivo .7z encontrado no diretório atual."
        exit 1
    fi

    echo "Extraindo $file..."
    7z x "$file"
done

echo "Todos os arquivos foram extraídos com sucesso!"
