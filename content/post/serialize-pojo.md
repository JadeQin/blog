---
title: "Java 对象序列化"
date: 2015-05-18T15:07:27+08:00
---

# 目的
通过对比apache Avro和jackson json的序列化方式及效率，找寻一个比较合适的动态序列化方式。
项目地址：[serial-benchmark](https://github.com/loveai88/serial-benchmark/tree/master)

# Avro的序列化
Avro本身是从Hadoop项目中独立出来的一个项目，主要用于序列化和rpc，想起以前还有一次面试的时候问，为什么Hadoop要自己做一套序列化和rpc方案，而不用现有的。
Avro相较于Thrift而言，最大的特点应该在于可以运行时改变，而不是必须要有声明类的参与。


# jackson json序列化
jackson json除了基本的pojo和json的转换之后，还通过多种dataformat的形式，提供了json和其他编码格式的转换，比如avro。