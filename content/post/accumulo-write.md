---
title: "Accumulo Write"
date: 2015-05-29T15:07:37+08:00
---

# 写入
TabletServer接收到写入数据后，先写入WAL（Write-Ahead Log），然后将数据写入内存中的一个排序结构（MemTable）。当MemTable的数据量达到一个阈值的时候，将数据写入HDFS，并创建一个新的MemTable。

写往HDFS中的数据存储格式是RFile（Relative Key File），是Accumulo自己的一种文件格式，是一种ISAM文件（Indexed Sequential Access Method）。

# 读取
当读取数据时，TabletServer在MemTable和RFile的内存索引中做二分查找，然后对查找结果做合并排序。

# Minor Compaction
当MemTable中的数据达到阈值时，数据会以文件形式写入HDFS，这个过程就是Minor Compaction。

# Major Compaction
Tablet Server会周期性的合并RFile，将多个文件合并成一个文件，并在Garbage Collector的时候，删除原文件。

# Garbage Collector
Accumulo会对存储在HDFS中的文件做周期性扫描，删除不再使用的文件。多个GC服务器会选举leader，仅有leader做GC。
