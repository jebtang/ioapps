.PHONY : all clean

DISTFILES=ioreplay
DOCDIR=man
IOPROFILER=ioprofiler
INSTALL=install
TARGET_PATH=/usr/bin
SOURCES=ioreplay.c in_common.c in_strace.c in_binary.c replicate.c simulate.c stats.c fdmap.c namemap.c simfs.c adt/list.c adt/hash_table.c adt/fs_trie.c
CFLAGS=-c -g -pg -Wall -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -I. 
OBJFILES=$(subst .c,.o,$(SOURCES))
DEPFILES=$(subst .c,.d,$(SOURCES))

all: replay profiler

profiler: 
	$(MAKE) -C $(IOPROFILER)

replay: $(DISTFILES)
	$(MAKE) -C $(DOCDIR)

clean:
	$(MAKE) -C $(DOCDIR) clean
	$(MAKE) -C $(IOPROFILER) clean
	rm -f $(DISTFILES) $(OBJFILES) $(DEPFILES)

install: install_replay install_profiler

install_replay: replay
	$(INSTALL) $(DISTFILES) $(TARGET_PATH)
	$(MAKE) -C $(DOCDIR) install

install_profiler: profiler
	$(MAKE) -C $(IOPROFILER) install

$(DISTFILES): $(subst .c,.o,$(SOURCES))
	$(CC) $^ -lprofiler -o $@

%.o: %.c
	$(CC) $(CFLAGS) $< -o $@

include $(subst .c,.d,$(SOURCES))

%.d: %.c
	$(CC) -MM -MT "$*.o" $(CPPFLAGS) $< > $*.d
	
