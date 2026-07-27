#!/bin/bash

# 1. Arqument yoxlanışı
if [ -z "$1" ]; then
    echo "Error: Please provide a file name."
    exit 1
fi

file_name="$1"

# 2. Faylın mövcudluğunun yoxlanışı
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' does not exist."
    exit 1
fi

# 3. Faylın ELF olub-olmadığının yoxlanışı
if ! readelf -h "$file_name" > /dev/null 2>&1; then
    echo "Error: '$file_name' is not a valid ELF file."
    exit 1
fi

# 4. Məlumatların çıxarılması
magic_number=$(readelf -h "$file_name" | grep "Magic:" | sed 's/.*Magic:[ \t]*//')
class=$(readelf -h "$file_name" | grep "Class:" | sed 's/.*Class:[ \t]*//')

# DÜZƏLİŞ EDİLMİŞ SƏTİR: Vergüldən sonrakı hissəni (little endian / big endian) götürür
byte_order=$(readelf -h "$file_name" | grep "Data:" | sed 's/.*, //')

entry_point_address=$(readelf -h "$file_name" | grep "Entry point address:" | sed 's/.*Entry point address:[ \t]*//')

# 5. Mesaj formatının tətbiqi
source ./messages.sh
display_elf_header_info
