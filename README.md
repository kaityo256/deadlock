
# Deadlock Sample of MPI

[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

[Jananese](README_ja.md)/ English

## Summary

As you may know, the following MPI call may cause deadlock.

```cpp
  MPI_Status st;
  if (rank == 0) {
    MPI_Send(sendbuf.data(), size, MPI_INT, 1, 0, MPI_COMM_WORLD);
    MPI_Recv(recvbuf.data(), size, MPI_INT, 1, 0, MPI_COMM_WORLD, &st);
  } else {
    MPI_Send(sendbuf.data(), size, MPI_INT, 0, 0, MPI_COMM_WORLD);
    MPI_Recv(recvbuf.data(), size, MPI_INT, 0, 0, MPI_COMM_WORLD, &st);
  }
```

However, it may work when the size of data is small.
This is due to the Eager protocol which does not require matching of reciever.
However, the Rendezvous protocol will be adapted when the size of data becomes larger.
With the Rendezvous protocol the above snipet will cause deadlock.

The data size at which Rendezvous and Eager protocols switch is system dependent.
This repository demonstrates where two protocols switch.

## Usage

Write your own setups on `makefile.opt`. For example,

```makefile
CC=icpc
CPPFLAGS=-lmpi -lmpi_cxx
```

Then make it.

```sh
$ make
mpic++ test.cpp -o a.out
mpic++ test2.cpp -o b.out
```

`a.out` may cause deadlock, while `b.out` does not.

To figure out the size at which Rendezvous and Eager protocols switch, run `search.rb`.
For example, the following is the results of OpenMPI on MacOS X.

```sh
$ ruby search.rb
500050 NG
250075 NG
125087 NG
62593 NG
31346 NG
15723 NG
7911 NG
4005 NG
2052 NG
1076 NG
588 OK
832 OK
954 OK
1015 NG
984 OK
999 OK
1007 OK
1011 NG
1009 OK
1010 OK
```

You can see the threshold size of data is 1010. Since we send integer, the threashold size of data is 4040 Bytes.
