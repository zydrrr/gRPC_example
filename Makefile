subdir = ./

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

SOURCES = $(wildcard $(subdir)*.cc)
SRCOBJS = $(patsubst %.cc,%.o,$(SOURCES))
CC = g++

%.o:%.cc
	$(CC) -std=c++11 -I/usr/local/include -pthread -c $< -o $@

all: client server clean

client:	helloworld.grpc.pb.o helloworld.pb.o greeter_client.o
	$(CC) $^ -L/usr/local/lib `pkg-config --libs grpc++ grpc` -Wl,--no-as-needed -lgrpc++_reflection -Wl,--as-needed -lprotobuf -lpthread -ldl -lssl -o $@

server: helloworld.grpc.pb.o helloworld.pb.o greeter_server.o
	$(CC) $^ -L/usr/local/lib `pkg-config --libs grpc++ grpc` -Wl,--no-as-needed -lgrpc++_reflection -Wl,--as-needed -lprotobuf -lpthread -ldl -lssl -o $@
#chmod 777 $@

clean:
	rm *.o

