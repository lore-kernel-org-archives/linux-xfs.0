Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 Mar 2007 10:49:21 -0700 (PDT)
Received: from smtp2.mundo-r.com (smtp5.mundo-r.com [212.51.32.152])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2PHnE6p031806
	for <xfs@oss.sgi.com>; Sun, 25 Mar 2007 10:49:16 -0700
Message-ID: <4606B617.4020807@mundo-r.com>
Date: Sun, 25 Mar 2007 19:49:11 +0200
From: Antonio Trueba <atrueba@mundo-r.com>
MIME-Version: 1.0
Subject: New ACL translations
Content-Type: multipart/mixed;
 boundary="------------070900010502020704060304"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------070900010502020704060304
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello all,

Here I send new ACL translations to Spanish (es) and Galician (gl), both
against current CVS tree.

Regards,
--

--------------070900010502020704060304
Content-Type: text/x-gettext-translation;
 name="es.po"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="es.po"

# SOME DESCRIPTIVE TITLE.
# Copyright (C) YEAR THE PACKAGE'S COPYRIGHT HOLDER
# This file is distributed under the same license as the PACKAGE package.
# FIRST AUTHOR <EMAIL@ADDRESS>, YEAR.
#
msgid ""
msgstr ""
"Project-Id-Version: acl-2.2.43.1\n"
"Report-Msgid-Bugs-To: \n"
"POT-Creation-Date: 2007-03-16 19:00+0100\n"
"PO-Revision-Date: 2007-03-16 23:25+0100\n"
"Last-Translator: Antonio Trueba <atrueba@users.sourceforge.net>\n"
"Language-Team: Spanish\n"
"MIME-Version: 1.0\n"
"Content-Type: text/plain; charset=utf-8\n"
"Content-Transfer-Encoding: 8bit\n"
"X-Poedit-Language: Spanish\n"

#: ../chacl/chacl.c:45
#, c-format
msgid "Usage:\n"
msgstr "Uso:\n"

#: ../chacl/chacl.c:46
#, c-format
msgid "\t%s acl pathname...\n"
msgstr "\t%s nombre de ruta de ACL...\n"

#: ../chacl/chacl.c:47
#, c-format
msgid "\t%s -b acl dacl pathname...\n"
msgstr "\t%s -b nombre de ruta ACL DACL...\n"

#: ../chacl/chacl.c:48
#, c-format
msgid "\t%s -d dacl pathname...\n"
msgstr "\t%s -d nombre de ruta de ACL...\n"

#: ../chacl/chacl.c:49
#, c-format
msgid "\t%s -R pathname...\n"
msgstr "\t%s -R ruta...\n"

#: ../chacl/chacl.c:50
#, c-format
msgid "\t%s -D pathname...\n"
msgstr "\t%s -D ruta...\n"

#: ../chacl/chacl.c:51
#, c-format
msgid "\t%s -B pathname...\n"
msgstr "\t%s -B ruta...\n"

#: ../chacl/chacl.c:52
#, c-format
msgid "\t%s -l pathname...\t[not IRIX compatible]\n"
msgstr "\t%s -l ruta...\t[no compatible con IRIX]\n"

#: ../chacl/chacl.c:54
#, c-format
msgid "\t%s -r pathname...\t[not IRIX compatible]\n"
msgstr "\t%s -r ruta...\t[no compatible con IRIX]\n"

#: ../chacl/chacl.c:145
#, c-format
msgid "%s: error removing access acl on \"%s\": %s\n"
msgstr "%s: error borrando ACL de acceso en \"%s\": %s\n"

#: ../chacl/chacl.c:152
#, c-format
msgid "%s: error removing default acl on \"%s\": %s\n"
msgstr "%s: error borrando ACL predeterminado en \"%s\": %s\n"

#: ../chacl/chacl.c:171
#: ../chacl/chacl.c:190
#, c-format
msgid "%s: access ACL '%s': %s at entry %d\n"
msgstr "%s: ACL de acceso '%s': %s en posición %d\n"

#: ../chacl/chacl.c:258
#, c-format
msgid "%s: cannot get access ACL on '%s': %s\n"
msgstr "%s: no se pudo obtener ACL de acceso en '%s': %s\n"

#: ../chacl/chacl.c:264
#, c-format
msgid "%s: cannot get default ACL on '%s': %s\n"
msgstr "%s: no se pudo obtener ACL predeterminado en '%s': %s\n"

#: ../chacl/chacl.c:270
#, c-format
msgid "%s: cannot get access ACL text on '%s': %s\n"
msgstr "%s: no se pudo obtener texto ACL de acceso en '%s': %s\n"

#: ../chacl/chacl.c:277
#, c-format
msgid "%s: cannot get default ACL text on '%s': %s\n"
msgstr "%s: no se pudo obtener texto de ACL predeterminado en '%s': %s\n"

#: ../chacl/chacl.c:303
#, c-format
msgid "%s: cannot set access acl on \"%s\": %s\n"
msgstr "%s: no se pudo establecer ACL de acceso en \"%s\": %s\n"

#: ../chacl/chacl.c:309
#, c-format
msgid "%s: cannot set default acl on \"%s\": %s\n"
msgstr "%s: no se pudo establecer ACL predeterminado a \"%s\": %s\n"

#: ../chacl/chacl.c:327
#, c-format
msgid "%s: opendir failed: %s\n"
msgstr "%s: falló la apertura: %s\n"

#: ../chacl/chacl.c:341
#, c-format
msgid "%s: malloc failed: %s\n"
msgstr "%s: falló la asignación de memoria: %s\n"

#: ../setfacl/do_set.c:391
#, c-format
msgid "%s: %s: Malformed access ACL `%s': %s at entry %d\n"
msgstr "%s: %s: ACL incorrecto `%s': %s en posición %d\n"

#: ../setfacl/do_set.c:418
#, c-format
msgid "%s: %s: Malformed default ACL `%s': %s at entry %d\n"
msgstr "%s: %s: ACL predeterminado incorrecto `%s': %s en posición %d\n"

#: ../setfacl/do_set.c:480
#, c-format
msgid "%s: %s: Only directories can have default ACLs\n"
msgstr "%s: %s: Sólo los directorios pueden tener ACLs predeterminados\n"

#: ../setfacl/setfacl.c:151
#, c-format
msgid "%s: %s: No filename found in line %d, aborting\n"
msgstr "%s: %s: No se encontró nombre de archivo en línea %d, abortando\n"

#: ../setfacl/setfacl.c:156
#, c-format
msgid "%s: No filename found in line %d of standard input, aborting\n"
msgstr "%s: %s: No se encontró nombre de archivo en línea %d de entrada estándar, abortando\n"

#: ../setfacl/setfacl.c:176
#, c-format
msgid "%s: %s: %s in line %d\n"
msgstr "%s: %s: %s en línea %d\n"

#: ../setfacl/setfacl.c:200
#, c-format
msgid "%s: %s: Cannot change owner/group: %s\n"
msgstr "%s: %s: No se pudo cambiar el propietario/grupo: %s\n"

#: ../setfacl/setfacl.c:240
#, c-format
msgid "%s %s -- set file access control lists\n"
msgstr "%s %s -- establecer listas de control de acceso a archivo\n"

#: ../setfacl/setfacl.c:242
#: ../setfacl/setfacl.c:692
#, c-format
msgid "Usage: %s %s\n"
msgstr "Uso: %s %s\n"

#: ../setfacl/setfacl.c:245
#, c-format
msgid ""
"  -m, --modify=acl        modify the current ACL(s) of file(s)\n"
"  -M, --modify-file=file  read ACL entries to modify from file\n"
"  -x, --remove=acl        remove entries from the ACL(s) of file(s)\n"
"  -X, --remove-file=file  read ACL entries to remove from file\n"
"  -b, --remove-all        remove all extended ACL entries\n"
"  -k, --remove-default    remove the default ACL\n"
msgstr ""
"  -m, --modify=acl         modificar ACL actual(es) de archivo(s)\n"
"  -M, --modify-file=arch   leer entradas ACL desde \"arch\"\n"
"  -x, --remove=acl         eliminar entradas desde ACL(s) de archivo(s)\n"
"  -X, --remove-file=arch   leer entradas de ACL a borrar desde \"arch\"\n"
"  -b, --remove-all         eliminar todas las entradas ACL extendidas\n"
"  -k, --remove-default     eliminar el ACL predeterminado\n"

#: ../setfacl/setfacl.c:254
#, c-format
msgid ""
"      --set=acl           set the ACL of file(s), replacing the current ACL\n"
"      --set-file=file     read ACL entries to set from file\n"
"      --mask              do recalculate the effective rights mask\n"
msgstr ""
"      --set=acl        establecer ACL(s) de archivo(s), reemplazando el actual\n"
"      --set-file=arch  leer entradas ACL a establecer desde \"arch\"\n"
"      --mask           recalcular la máscara de permisos efectivos\n"

#: ../setfacl/setfacl.c:260
#, c-format
msgid ""
"  -n, --no-mask           don't recalculate the effective rights mask\n"
"  -d, --default           operations apply to the default ACL\n"
msgstr ""
"  -n, --no-mask           no recalcular la máscara de derechos efectivos\n"
"  -d, --default           las operaciones afectal al ACL predeterminado\n"

#: ../setfacl/setfacl.c:265
#, c-format
msgid ""
"  -R, --recursive         recurse into subdirectories\n"
"  -L, --logical           logical walk, follow symbolic links\n"
"  -P, --physical          physical walk, do not follow symbolic links\n"
"      --restore=file      restore ACLs (inverse of `getfacl -R')\n"
"      --test              test mode (ACLs are not modified)\n"
msgstr ""
"  -R, --recursive         recorrer subdirectorios recursivamente\n"
"  -L, --logical           recorrido lógico, siguiendo enlaces simbólicos\n"
"  -P, --physical          recorrido físico, sin seguir enlaces simbólicos\n"
"      --restore=file      restaurar ACLs (inverso de `getfacl -R')\n"
"      --test              modo de prueba (los ACLs no se modifican)\n"

#: ../setfacl/setfacl.c:273
#: ../getfacl/getfacl.c:559
#, c-format
msgid ""
"      --version           print version and exit\n"
"      --help              this help text\n"
msgstr ""
"      --version           escribir versión y salir\n"
"      --help              este texto de ayuda\n"

#: ../setfacl/setfacl.c:358
#: ../getfacl/getfacl.c:768
#, c-format
msgid "%s: Standard input: %s\n"
msgstr "%s: Entrada estándar: %s\n"

#: ../setfacl/setfacl.c:494
#, c-format
msgid "%s: Option -%c incomplete\n"
msgstr "%s: Opción -%c incompleta\n"

#: ../setfacl/setfacl.c:499
#, c-format
msgid "%s: Option -%c: %s near character %d\n"
msgstr "%s: Opción -%c: %s cerca del carácter %d\n"

#: ../setfacl/setfacl.c:575
#, c-format
msgid "%s: %s in line %d of file %s\n"
msgstr "%s: %s en línea %d de archivo %s\n"

#: ../setfacl/setfacl.c:583
#, c-format
msgid "%s: %s in line %d of standard input\n"
msgstr "%s: %s en línea %d de entrada estándar\n"

#: ../setfacl/setfacl.c:694
#: ../getfacl/getfacl.c:782
#, c-format
msgid "Try `%s --help' for more information.\n"
msgstr "Escriba `%s --help' para más información.\n"

#: ../getfacl/getfacl.c:463
#, c-format
msgid "%s: Removing leading '/' from absolute path names\n"
msgstr "%s: Eliminando '/' inicial en nombres de ruta absolutos\n"

#: ../getfacl/getfacl.c:532
#, c-format
msgid "%s %s -- get file access control lists\n"
msgstr "%s %s -- obtener listas de control de acceso a archivo\n"

#: ../getfacl/getfacl.c:534
#: ../getfacl/getfacl.c:780
#, c-format
msgid "Usage: %s [-%s] file ...\n"
msgstr "Uso: %s [-%s] archivo ...\n"

#: ../getfacl/getfacl.c:540
#, c-format
msgid "  -d, --default           display the default access control list\n"
msgstr "  -d, --default           mostrar la lista de control de acceso predeterminada\n"

#: ../getfacl/getfacl.c:544
#, c-format
msgid ""
"      --access            display the file access control list only\n"
"  -d, --default           display the default access control list only\n"
"      --omit-header       do not display the comment header\n"
"      --all-effective     print all effective rights\n"
"      --no-effective      print no effective rights\n"
"      --skip-base         skip files that only have the base entries\n"
"  -R, --recursive         recurse into subdirectories\n"
"  -L, --logical           logical walk, follow symbolic links\n"
"  -P  --physical          physical walk, do not follow symbolic links\n"
"      --tabular           use tabular output format\n"
"      --numeric           print numeric user/group identifiers\n"
"      --absolute-names    don't strip leading '/' in pathnames\n"
msgstr ""
"      --access            sólo mostrar la lista de control de acceso a fichero\n"
"  -d, --default           sólo mostrar la lista de acceso predeterminada\n"
"      --omit-header       no mostrar el encabezado de comentarios\n"
"      --all-effective     mostrar todos los permisos efectivos\n"
"      --no-effective      mostrar los permisos no efectivos\n"
"      --skip-base         ignorar archivos que sólo tienen las entradas básicas\n"
"  -R, --recursive         descender recursivamente en los subdirectorios\n"
"  -L, --logical           recorrido lógico, siguiendo enlaces simbólicos\n"
"  -P  --physical          recorrido físico, sin seguir enlaces simbólicos\n"
"      --tabular           usar formato de salida tabular\n"
"      --numeric           mostrar identificadores numéricos de usuario/grupo\n"
"      --absolute-names    no eliminar '/' inicial en nombres de ruta\n"

#: ../libacl/acl_error.c:34
msgid "Multiple entries of same type"
msgstr "Múltiples entradas del mismo tipo"

#: ../libacl/acl_error.c:36
msgid "Duplicate entries"
msgstr "Entradas duplicadas"

#: ../libacl/acl_error.c:38
msgid "Missing or wrong entry"
msgstr "Falta una posición o es errónea"

#: ../libacl/acl_error.c:40
msgid "Invalid entry type"
msgstr "Tipo de posición inválido"

#: ../libacl/perm_copy_fd.c:124
#: ../libacl/perm_copy_fd.c:136
#: ../libacl/perm_copy_fd.c:198
#: ../libacl/perm_copy_file.c:124
#: ../libacl/perm_copy_file.c:139
#: ../libacl/perm_copy_file.c:150
#: ../libacl/perm_copy_file.c:235
#, c-format
msgid "setting permissions for %s"
msgstr "estableciendo permisos a %s"

#: ../libacl/perm_copy_fd.c:186
#: ../libacl/perm_copy_file.c:199
#: ../libacl/perm_copy_file.c:224
#, c-format
msgid "preserving permissions for %s"
msgstr "manteniendo permisos a %s"


--------------070900010502020704060304
Content-Type: text/x-gettext-translation;
 name="gl.po"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="gl.po"

# SOME DESCRIPTIVE TITLE.
# Copyright (C) YEAR THE PACKAGE'S COPYRIGHT HOLDER
# This file is distributed under the same license as the PACKAGE package.
# FIRST AUTHOR <EMAIL@ADDRESS>, YEAR.
#
msgid ""
msgstr ""
"Project-Id-Version: acl-2.2.43.1\n"
"Report-Msgid-Bugs-To: \n"
"POT-Creation-Date: 2007-03-06 12:08+0100\n"
"PO-Revision-Date: 2007-03-16 18:52+0100\n"
"Last-Translator: Antonio Trueba <atrueba@users.sourceforge.net>\n"
"Language-Team: Galician\n"
"MIME-Version: 1.0\n"
"Content-Type: text/plain; charset=utf-8\n"
"Content-Transfer-Encoding: 8bit\n"
"X-Poedit-Language: Galician\n"

#: ../chacl/chacl.c:45
#, c-format
msgid "Usage:\n"
msgstr "Uso:\n"

#: ../chacl/chacl.c:46
#, c-format
msgid "\t%s acl pathname...\n"
msgstr "\t%s nome de rota do ACL...\n"

#: ../chacl/chacl.c:47
#, c-format
msgid "\t%s -b acl dacl pathname...\n"
msgstr "\t%s -b nome de ruta ACL DACL..\n"

#: ../chacl/chacl.c:48
#, c-format
msgid "\t%s -d dacl pathname...\n"
msgstr "\t%s -d rota ó ACL...\n"

#: ../chacl/chacl.c:49
#, c-format
msgid "\t%s -R pathname...\n"
msgstr "\t%s -R rota...\n"

#: ../chacl/chacl.c:50
#, c-format
msgid "\t%s -D pathname...\n"
msgstr "\t%s -D rota...\n"

#: ../chacl/chacl.c:51
#, c-format
msgid "\t%s -B pathname...\n"
msgstr "\t%s -B rota...\n"

#: ../chacl/chacl.c:52
#, c-format
msgid "\t%s -l pathname...\t[not IRIX compatible]\n"
msgstr "\t%s -l rota...\t[non compatible con IRIX]\n"

#: ../chacl/chacl.c:54
#, c-format
msgid "\t%s -r pathname...\t[not IRIX compatible]\n"
msgstr "\t%s -r rota...\t[non compatible con IRIX]\n"

#: ../chacl/chacl.c:145
#, c-format
msgid "%s: error removing access acl on \"%s\": %s\n"
msgstr "%s: erro borrando ACL de acceso en \"%s\": %s\n"

#: ../chacl/chacl.c:152
#, c-format
msgid "%s: error removing default acl on \"%s\": %s\n"
msgstr "%s: erro borrando ACL predeterminado en \"%s\": %s\n"

#: ../chacl/chacl.c:171
#: ../chacl/chacl.c:190
#, c-format
msgid "%s: access ACL '%s': %s at entry %d\n"
msgstr "%s: ACL de acceso '%s': %s en posición %d\n"

#: ../chacl/chacl.c:258
#, c-format
msgid "%s: cannot get access ACL on '%s': %s\n"
msgstr "%s: non se puido obter ACL de acceso en '%s': %s\n"

#: ../chacl/chacl.c:264
#, c-format
msgid "%s: cannot get default ACL on '%s': %s\n"
msgstr "%s: non se puido obter ACL predeterminado en '%s': %s\n"

#: ../chacl/chacl.c:270
#, c-format
msgid "%s: cannot get access ACL text on '%s': %s\n"
msgstr "%s: non se puido obter texto ACL de acceso en '%s': %s\n"

#: ../chacl/chacl.c:277
#, c-format
msgid "%s: cannot get default ACL text on '%s': %s\n"
msgstr "%s: non se puido obter texto de ACL predeterminado en '%s': %s\n"

#: ../chacl/chacl.c:303
#, c-format
msgid "%s: cannot set access acl on \"%s\": %s\n"
msgstr "%s: non se puido establecé-lo ACL de acceso en \"%s\": %s\n"

#: ../chacl/chacl.c:309
#, c-format
msgid "%s: cannot set default acl on \"%s\": %s\n"
msgstr "%s: non se puido establecé-lo ACL predeterminado en \"%s\": %s\n"

#: ../chacl/chacl.c:327
#, c-format
msgid "%s: opendir failed: %s\n"
msgstr "%s: a chamada a opendir fallou: %s\n"

#: ../chacl/chacl.c:341
#, c-format
msgid "%s: malloc failed: %s\n"
msgstr "%s: a chamada a malloc fallou: %s\n"

#: ../setfacl/do_set.c:391
#, c-format
msgid "%s: %s: Malformed access ACL `%s': %s at entry %d\n"
msgstr "%s: %s: ACL incorrecto `%s': %s na posición %d\n"

#: ../setfacl/do_set.c:418
#, c-format
msgid "%s: %s: Malformed default ACL `%s': %s at entry %d\n"
msgstr "%s: %s: ACL predeterminado incorrecto `%s': %s na posición %d\n"

#: ../setfacl/do_set.c:480
#, c-format
msgid "%s: %s: Only directories can have default ACLs\n"
msgstr "%s: %s: Só os directorios poden ter ACLs predeterminados\n"

#: ../setfacl/setfacl.c:151
#, c-format
msgid "%s: %s: No filename found in line %d, aborting\n"
msgstr "%s: %s: Non se atopou nome de ficheiro na liña %d, abortando\n"

#: ../setfacl/setfacl.c:156
#, c-format
msgid "%s: No filename found in line %d of standard input, aborting\n"
msgstr "%s: Non se atopou nome de ficheiro na liña %d da entrada estándar, abortando\n"

#: ../setfacl/setfacl.c:176
#, c-format
msgid "%s: %s: %s in line %d\n"
msgstr "%s: %s: %s na liña %d\n"

#: ../setfacl/setfacl.c:200
#, c-format
msgid "%s: %s: Cannot change owner/group: %s\n"
msgstr "%s: %s: Non se pode cambiá-lo propietario/grupo: %s\n"

#: ../setfacl/setfacl.c:240
#, c-format
msgid "%s %s -- set file access control lists\n"
msgstr "%s %s -- establecer listas de control de acceso a ficheiro\n"

#: ../setfacl/setfacl.c:242
#: ../setfacl/setfacl.c:692
#, c-format
msgid "Usage: %s %s\n"
msgstr "Uso: %s %s\n"

#: ../setfacl/setfacl.c:245
#, c-format
msgid ""
"  -m, --modify=acl        modify the current ACL(s) of file(s)\n"
"  -M, --modify-file=file  read ACL entries to modify from file\n"
"  -x, --remove=acl        remove entries from the ACL(s) of file(s)\n"
"  -X, --remove-file=file  read ACL entries to remove from file\n"
"  -b, --remove-all        remove all extended ACL entries\n"
"  -k, --remove-default    remove the default ACL\n"
msgstr ""
"  -m, --modify=ACL        modificá-lo ACL actual de ficheiro(s)\n"
"  -M, --modify-file=fich  ler entradas ACL a modificar dende ficheiro\n"
"  -x, --remove=ACL        borrar entradas do ACL de ficheiro(s)\n"
"  -X, --remove-file=fich  ler entradas dACL a borrar dende ficheiro\n"
"  -b, --remove-all        borrar tódalas entradas de ACL extendidas\n"
"  -k, --remove-default    borrar ó ACL predeterminado\n"

#: ../setfacl/setfacl.c:254
#, c-format
msgid ""
"      --set=acl           set the ACL of file(s), replacing the current ACL\n"
"      --set-file=file     read ACL entries to set from file\n"
"      --mask              do recalculate the effective rights mask\n"
msgstr ""
"      --set=ACL           estableceé-lo ACL de ficheiro(s), substituindo ó ACL actual\n"
"      --set-file=fich     ler entradas ACL a establecer dende ficheiro\n"
"      --mask              recalculá-la máscara de dereitos efectiva\n"

#: ../setfacl/setfacl.c:260
#, c-format
msgid ""
"  -n, --no-mask           don't recalculate the effective rights mask\n"
"  -d, --default           operations apply to the default ACL\n"
msgstr ""
"  -n, --no-mask           non recalculá-la máscara de dereitos efectiva\n"
"  -d, --default           as operacións afectan ó ACL predeterminado\n"

#: ../setfacl/setfacl.c:265
#, c-format
msgid ""
"  -R, --recursive         recurse into subdirectories\n"
"  -L, --logical           logical walk, follow symbolic links\n"
"  -P, --physical          physical walk, do not follow symbolic links\n"
"      --restore=file      restore ACLs (inverse of `getfacl -R')\n"
"      --test              test mode (ACLs are not modified)\n"
msgstr ""
"  -R, --recursive         recorrer subdirectorios recursivamente\n"
"  -L, --logical           percorrido lóxico, seguindo enlaces simbólicos\n"
"  -P, --physical          percorrido físico, non seguir enlaces simbólicos\n"
"      --restore=fich      restaurar ACLs (inverso de 'getfacl -R')\n"
"      --test              modo de proba (os ACLs non son modificados)\n"

#: ../setfacl/setfacl.c:273
#: ../getfacl/getfacl.c:559
#, c-format
msgid ""
"      --version           print version and exit\n"
"      --help              this help text\n"
msgstr ""
"      --version           amosar versión e sair\n"
"      --help              este texto de axuda\n"

#: ../setfacl/setfacl.c:358
#: ../getfacl/getfacl.c:768
#, c-format
msgid "%s: Standard input: %s\n"
msgstr "%s: Entrada estándar: %s\n"

#: ../setfacl/setfacl.c:494
#, c-format
msgid "%s: Option -%c incomplete\n"
msgstr "%s: Opción -%c incompleta\n"

#: ../setfacl/setfacl.c:499
#, c-format
msgid "%s: Option -%c: %s near character %d\n"
msgstr "%s: Opción -%c: %s preto do carácter %d\n"

#: ../setfacl/setfacl.c:575
#, c-format
msgid "%s: %s in line %d of file %s\n"
msgstr "%s: %s na liña %d do ficheiro %s\n"

#: ../setfacl/setfacl.c:583
#, c-format
msgid "%s: %s in line %d of standard input\n"
msgstr "%s: %s na liña %d da entrada estándar\n"

#: ../setfacl/setfacl.c:694
#: ../getfacl/getfacl.c:782
#, c-format
msgid "Try `%s --help' for more information.\n"
msgstr "Escriba \"%s --help\" para máis información.\n"

#: ../getfacl/getfacl.c:463
#, c-format
msgid "%s: Removing leading '/' from absolute path names\n"
msgstr "%s: Eliminando '/' iniciais en nomes de ruta absolutos\n"

#: ../getfacl/getfacl.c:532
#, c-format
msgid "%s %s -- get file access control lists\n"
msgstr "%s %s -- obter listas de control de acceso a ficheiro\n"

#: ../getfacl/getfacl.c:534
#: ../getfacl/getfacl.c:780
#, c-format
msgid "Usage: %s [-%s] file ...\n"
msgstr "Uso: %s [-%s] ficheiro ...\n"

#: ../getfacl/getfacl.c:540
#, c-format
msgid "  -d, --default           display the default access control list\n"
msgstr "  -d, --default           amosá-la lista de control de acceso predeterminada\n"

#: ../getfacl/getfacl.c:544
#, c-format
msgid ""
"      --access            display the file access control list only\n"
"  -d, --default           display the default access control list only\n"
"      --omit-header       do not display the comment header\n"
"      --all-effective     print all effective rights\n"
"      --no-effective      print no effective rights\n"
"      --skip-base         skip files that only have the base entries\n"
"  -R, --recursive         recurse into subdirectories\n"
"  -L, --logical           logical walk, follow symbolic links\n"
"  -P  --physical          physical walk, do not follow symbolic links\n"
"      --tabular           use tabular output format\n"
"      --numeric           print numeric user/group identifiers\n"
"      --absolute-names    don't strip leading '/' in pathnames\n"
msgstr ""
"      --access            só amosá-la lista de control de acceso ó ficheiro\n"
"  -d, --default           só mostrá-la lista de control de acceso predeterminada\n"
"      --omit-header       non amosá-lo comentario de encabezamento\n"
"      --all-effective     amosar tódolos dereitos efectivos\n"
"      --no-effective      non amosar ningún dereito efectivo\n"
"      --skip-base         saltar ficheiros que só teñan as entradas básicas\n"
"  -R, --recursive         descender recursivamente nos subdirectorios\n"
"  -L, --logical           percorrido lóxico, seguindo enlaces simbólicos\n"
"  -P  --physical          percorrido físico, non seguir enlaces simbólicos\n"
"      --tabular           usar formato de saída tabular\n"
"      --numeric           amosar identificadores numéricos de propietario/grupo\n"
"      --absolute-names    non eliminá-la '/' en nomes de ruta\n"

#: ../libacl/acl_error.c:34
msgid "Multiple entries of same type"
msgstr "Varias entradas do mesmo tipo"

#: ../libacl/acl_error.c:36
msgid "Duplicate entries"
msgstr "Entradas duplicadas"

#: ../libacl/acl_error.c:38
msgid "Missing or wrong entry"
msgstr "Falta un atributo, ou está mal formado"

#: ../libacl/acl_error.c:40
msgid "Invalid entry type"
msgstr "Tipo de entrada non válido"

#: ../libacl/perm_copy_fd.c:124
#: ../libacl/perm_copy_fd.c:136
#: ../libacl/perm_copy_fd.c:198
#: ../libacl/perm_copy_file.c:124
#: ../libacl/perm_copy_file.c:139
#: ../libacl/perm_copy_file.c:150
#: ../libacl/perm_copy_file.c:235
#, c-format
msgid "setting permissions for %s"
msgstr "establecendo permisos para %s"

#: ../libacl/perm_copy_fd.c:186
#: ../libacl/perm_copy_file.c:199
#: ../libacl/perm_copy_file.c:224
#, c-format
msgid "preserving permissions for %s"
msgstr "mantendo permisos de %s"


--------------070900010502020704060304--
