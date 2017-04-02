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
ROOT    := $(realpath ../..)
DEPS    :=
TYPE    := dll
SUBDIRS := 
AT2_VERSION := 13
ifeq ($(OS),Windows_NT)
	EXTRA_CFLAGS := -DSTDC_HEADERS -DHAVE_STDLIB_H -DHAVE_STRING_H
	CC_SRCS := arg_dbl.c arg_end.c arg_file.c arg_int.c arg_uint.c arg_lit.c arg_rem.c arg_str.c argtable2.c getopt1.c getopt.c
	LINK_EXTRALIBS_REL := -def:argtable2.def
	LINK_EXTRALIBS_DBG := $(LINK_EXTRALIBS_REL)
	GET_ARGTABLE = PATCH=paatch AT2_VERSION=$(AT2_VERSION) ./paatch.sh
else
	EXTRA_CFLAGS := -DHAVE_CONFIG_H
	CC_SRCS := arg_date.c arg_dbl.c arg_end.c arg_file.c arg_int.c arg_uint.c arg_lit.c arg_rem.c arg_rex.c arg_str.c argtable2.c getopt1.c getopt.c
	GET_ARGTABLE = PATCH=patch AT2_VERSION=$(AT2_VERSION) ./paatch.sh
endif
PRE_BUILD := foo $(CC_SRCS)
EXTRA_CLEAN := *.c *.h *.def argtable2-$(AT2_VERSION)
CONFIGS := 

-include $(ROOT)/common/top.mk

foo: argtable2.tgz
	$(GET_ARGTABLE)
	make dbg rel

argtable2.tgz:
	wget --no-check-certificate -O argtable2.tgz http://downloads.sourceforge.net/project/argtable/argtable/argtable-2.$(AT2_VERSION)/argtable2-$(AT2_VERSION).tar.gz
