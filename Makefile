PROGRAM = shared.a

SRCDIR = src/
SOURCES = $(wildcard $(SRCDIR)*.s)
OBJDIR = obj/
OBJECTS = $(patsubst $(SRCDIR)%.s, $(OBJDIR)%.o, $(SOURCES))

$(PROGRAM): $(OBJECTS)
	ar rcs $@ $^

$(OBJDIR)%.o: $(SRCDIR)%.s
	as -g -I include -o $@ $^

$(OBJECTS): | $(OBJDIR)
$(OBJDIR):
	mkdir $(OBJDIR)

.PHONY: clean debug
clean:
	-rm -r $(PROGRAM) $(OBJDIR)
