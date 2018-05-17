---
title: "Accumulo Compact"
date: 2015-06-04T15:07:46+08:00
---

Accumulo中，Tablet Server用于处理数据业务，table有可能分成多个tablet，每个tablet在HDFS中对应着一个目录，目录里面放着具体的数据文件。

为了避免tablet中的小文件数过多导致的查询性能降低，Accumulo会定期的合并文件，里面涉及到相关参数。

*table.compaction.major.ratio*
ratio会影响合并后的文件数，增加该值会降低合并操作，其工作原理如下：
如果某一批文件的文件大小总和大于ratio*最大的文件大小，那么就合并这一批文件，否则去掉最大的文件，对剩下的文件做相同操作。
所以radio越大，则文件数越多。

*tserver.compaction.major.concurrent.max*
*tserver.compaction.minor.concurrent.max*
进行合并操作的线程数大小。

*table.file.max*
如果当前文件数已经达到最大值，则每次将MemTable中的数据写入HDFS的时候，都会触发一次合并操作（merging minor compaction），将数据写入最小的文件中，从而导致吞吐量的下降。

除了通过配置值自动完成，还可以通过手动执行的方式来完成。在shell中执行
flush，将MemTable中的数据写入HDFS
compact，合并文件
