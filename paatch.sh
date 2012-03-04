#
# Copyright (C) 2011-2012 Chris McClelland
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#!/bin/bash
rm -rf argtable2-${AT2_VERSION}
tar zxf argtable2.tgz
cd argtable2-${AT2_VERSION}
if [ "$OS" != "Windows_NT" ]; then
	./configure
fi
cd src
mv *.c ../..
mv *.h ../..
mv *.def ../..
cd ../..
pwd

${PATCH} arg_int.c <<EOF
--- argtable2-12/src/arg_int.c	2010-02-06 08:26:46.000000000 +0000
+++ arg_int.c	2011-06-03 19:20:09.003695002 +0100
@@ -26,2 +26,4 @@
 
+#include <ctype.h>
+
 /* #ifdef HAVE_STDLIB_H */
EOF

cp argtable2.h argtable2.h.original

${PATCH} argtable2.h <<EOF
--- argtable2.h.original	2011-07-31 14:56:49.894112000 +0100
+++ argtable2.h	2011-07-31 14:58:39.242112000 +0100
@@ -30,4 +30,8 @@
 #endif
 
+/* argtable2 needs this otherwise cl.exe gives warnings */
+#ifdef WIN32
+#pragma warning (disable:4204)
+#endif
 
 /* bit masks for arg_hdr.flag */
@@ -97,4 +101,11 @@
    };
 
+struct arg_uint
+   {
+   struct arg_hdr hdr;      /* The mandatory argtable header struct */
+   int count;               /* Number of matching command line args */
+   unsigned int *ival;      /* Array of parsed argument values */
+   };
+
 struct arg_dbl
    {
@@ -189,4 +200,19 @@
                          const char *glossary);
 
+struct arg_uint* arg_uint0(const char* shortopts,
+                           const char* longopts,
+                           const char* datatype,
+                           const char* glossary);
+struct arg_uint* arg_uint1(const char* shortopts,
+                           const char* longopts,
+                           const char* datatype,
+                           const char *glossary);
+struct arg_uint* arg_uintn(const char* shortopts,
+                           const char* longopts,
+                           const char *datatype,
+                           int mincount,
+                           int maxcount,
+                           const char *glossary);
+
 struct arg_dbl* arg_dbl0(const char* shortopts,
                          const char* longopts,
EOF

cp arg_int.c arg_uint.c
${PATCH} arg_uint.c <<EOF
--- arg_int.c	2011-06-03 20:58:13.667695002 +0100
+++ arg_uint.c	2011-06-03 20:58:13.671695002 +0100
@@ -32,0 +33 @@
+#include <ctype.h>
@@ -39 +40 @@
-static void resetfn(struct arg_int *parent)
+static void resetfn(struct arg_uint *parent)
@@ -55 +56 @@
-static long int strtol0X(const char* str, const char **endptr, char X, int base)
+static unsigned long int strtol0X(const char* str, const char **endptr, char X, int base)
@@ -57,2 +58 @@
-    long int val;               /* stores result */
-    int s=1;                    /* sign is +1 or -1 */
+    unsigned long int val;               /* stores result */
@@ -66,17 +65,0 @@
-    /* scan optional sign character */
-    switch (*ptr)
-        {
-        case '+':
-            ptr++;
-            s=1;
-            break;
-        case '-':
-            ptr++;
-            s=-1;
-            break;
-        default:
-            s=1;
-            break;    
-        }
-    /* printf("2) %s\\n",ptr); */
-
@@ -100 +83 @@
-    val = strtol(ptr,(char**)endptr,base);
+    val = strtoul(ptr,(char**)endptr,base);
@@ -109 +92 @@
-    return s*val;
+    return val;
@@ -145 +128 @@
-static int scanfn(struct arg_int *parent, const char *argval)
+static int scanfn(struct arg_uint *parent, const char *argval)
@@ -163 +146 @@
-        long int val;
+        unsigned long int val;
@@ -179 +162 @@
-                    val = strtol(argval, (char**)&end, 10);
+                    val = strtoul(argval, (char**)&end, 10);
@@ -189,5 +171,0 @@
-        /* Safety check for integer overflow. WARNING: this check    */
-        /* achieves nothing on machines where size(int)==size(long). */
-        if ( val>INT_MAX || val<INT_MIN )
-            errorcode = EOVERFLOW;
-
@@ -198 +176 @@
-            if ( val>(INT_MAX/1024) || val<(INT_MIN/1024) )
+            if ( val > UINT_MAX/1024 )
@@ -205 +183 @@
-            if ( val>(INT_MAX/1048576) || val<(INT_MIN/1048576) )
+            if ( val > UINT_MAX/1048576 )
@@ -212 +190 @@
-            if ( val>(INT_MAX/1073741824) || val<(INT_MIN/1073741824) )
+            if ( val > UINT_MAX/1073741824 )
@@ -229 +207 @@
-static int checkfn(struct arg_int *parent)
+static int checkfn(struct arg_uint *parent)
@@ -236 +214 @@
-static void errorfn(struct arg_int *parent, FILE *fp, int errorcode, const char *argval, const char *progname)
+static void errorfn(struct arg_uint *parent, FILE *fp, int errorcode, const char *argval, const char *progname)
@@ -272 +250 @@
-struct arg_int* arg_int0(const char* shortopts,
+struct arg_uint* arg_uint0(const char* shortopts,
@@ -277 +255 @@
-    return arg_intn(shortopts,longopts,datatype,0,1,glossary);
+    return arg_uintn(shortopts,longopts,datatype,0,1,glossary);
@@ -280 +258 @@
-struct arg_int* arg_int1(const char* shortopts,
+struct arg_uint* arg_uint1(const char* shortopts,
@@ -285 +263 @@
-    return arg_intn(shortopts,longopts,datatype,1,1,glossary);
+    return arg_uintn(shortopts,longopts,datatype,1,1,glossary);
@@ -289 +267 @@
-struct arg_int* arg_intn(const char* shortopts,
+struct arg_uint* arg_uintn(const char* shortopts,
@@ -297 +275 @@
-    struct arg_int *result;
+    struct arg_uint *result;
@@ -302 +280 @@
-    nbytes = sizeof(struct arg_int)     /* storage for struct arg_int */
+    nbytes = sizeof(struct arg_uint)     /* storage for struct arg_uint */
@@ -305 +283 @@
-    result = (struct arg_int*)malloc(nbytes);
+    result = (struct arg_uint*)malloc(nbytes);
@@ -322,2 +300,2 @@
-        /* store the ival[maxcount] array immediately after the arg_int struct */
-        result->ival  = (int*)(result+1);
+        /* store the ival[maxcount] array immediately after the arg_uint struct */
+        result->ival  = (unsigned int*)(result+1);
@@ -326 +304 @@
-    /*printf("arg_intn() returns %p\\n",result);*/
+    /*printf("arg_uintn() returns %p\\n",result);*/
EOF

${PATCH} argtable2.def <<EOF
--- argtable2.def.original	2011-06-03 15:23:33.071695002 +0100
+++ argtable2.def	2011-06-03 15:23:55.611695002 +0100
@@ -8,2 +8,5 @@
   arg_intn
+  arg_uint0
+  arg_uint1
+  arg_uintn
   arg_dbl0
EOF
