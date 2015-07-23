.PHONY: all clean

define macro

$(1).o : $(addprefix $(1), .c .h)
	gcc -c -o $$@ -Wall $$<
$(1).c :  
	echo "int fun_$(1)() { return -1;}" > $$@
$(1).h :  
	echo "int fun_$(1)();" > $$@

endef

my.list = a b c d e f g h i j k l m n o

all: tmp1.out

tmp1.out : $(addsuffix .o, ${my.list})
	echo "int main() { return 0;}" > tmp1.c
	gcc -o $@ -Wall tmp1.c $^
	rm tmp1.c

$(eval $(foreach F,${my.list},$(call macro,${F})))

clean:
	rm  -f *.c *.h *.o
