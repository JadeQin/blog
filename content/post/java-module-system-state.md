---
title: "Java Module System State"
date: 2015-11-11T15:08:15+08:00
---

## 摘要：
Oracle Java平台组的首席架构师Mark Reinhold，公开了一份关于模块系统的状况的报告，同时强调了其目标，并解释了如何满足当前的需要。由于和已经存在的框架存在明显的重复，特别是OSGi，报告引起发了人们的讨论。InfoQ回顾了这份经历及其当前的状况。

## 正文：
Oracle Java平台组首席架构师Mark Reinhold发表了一份关于模块化系统的情况的报告，强调了模块化的目标是什么。由于和已经存在的框架存在明显的重复，特别是OSGi，报告引起发了人们的讨论。

正如报告中所解释的，以及在JSR-376和模块化系统项目主页中完整的详细说明，模块化系统是为了解决当前Java访问模型中的两个疏漏：

 - 可靠的配置：当前一个组件通过类路径访问另一个组件的类时相当容易出错，特别是尝试使用不在类路径里面或者存在多个版本的类的时候。
 - 强封装：没有办法去限制特定组件暴露给其他组件的类，外部能访问所有的公共类。

完整的细节能够在报告和InfoQ之前的文章中找到，总的来说，每一个组件通常（但不一定）作为一个jar文件，其中包含了如下结构的模块描述文件module-info.java：

```java
module com.foo.bar {

   requires com.foo.baz;

   exports com.foo.bar.alpha;

   exports com.foo.bar.beta;

}
```
文件结构中包含一行或多行exports用于指出能够被其他组件访问的包，零行或多行requires用于指出自身需要访问的其他模块。该系统提供了方法用于在编译时评估访问类型是否具有正确的可见性（例如声明为公共类并被所需组件导出），并在运行时评估必需的模块是否可用，而不需要去检查完整的类路径。类似于OSGi中的清单文件。

#### OSGi的背景
OSGi是一个基于Java的模块化系统和服务化平台，实现了一个完整的动态的组件模型。从1998年在JSR-8第一次提出，在随后的审核中被延迟发布（最近一次是2014年），OSGi定义了bundle（类似模块），采用包含如下的MANIFEST.MF文件的JAR文件的形式：

```java
Bundle-Name: Hello World

Bundle-SymbolicName: org.wikipedia.helloworld

Bundle-Description: A Hello World bundle

Bundle-ManifestVersion: 2

Bundle-Version: 1.0.0

Bundle-Activator: org.wikipedia.Activator

Export-Package: org.wikipedia.helloworld;version="1.0.0"

Import-Package: org.osgi.framework;version="1.3.0"
```
（例子来源于Wikipedia）

显而易见的，尽管格式不一样，但是目的表现的和Java模块系统很相似。的确，Java平台模块系统和OSGi之间的相似性，在2005年提出的JSR-277，“Java模块系统”中，初次尝试模块化Java时就已经被注意到了。最初瞄准的Java 7，JSR-277专注简化分发和执行Java程序包。尽管有和JSR-376几乎一样的名字，但两者最初的目标有着细微差别；虽然它的任务是修复“可靠的配置”问题，但是它并不试图解决“强封装”的问题。相对于JSR-376，它也尝试增加一个版本模型到Java程序包中。这些目标和OSGi提供的功能之间的相似性是完全足够让作者在最初考虑把OSGi作为一个解决方案，放弃的原因考虑为OSGi的版本控制太弱了。

不久之后创建的JSR-294的目标是实现“改进Java程序语言的模块性支持”。同时针对Java 7，JSR-294新增了模块概念（所谓的“超级包”）来修复强封装的问题；这个概念匹配了当前的Java平台模块系统项目。当Java 7的目标被放弃时，JSR-277和JSR-294从2012年开始被冻结，由JSR-376代替。

OSGi和模块化Java的另一个关联能在JSR-291中找到，“Java SE的动态组件支持”（本质上是OSGi服务平台发布的第四版）。JSR-291参考了JSR-277，作为最早的Java模块系统，来主动区分两者之间的不同作用：JSR-277关注Java中使用的静态模块定义，而JSR-291关注运行时动态组件的加载和卸载。

最后，JSR-376也参考了OSGi，放弃它作为有效解决方案的主要原因是因为它的范围远远大于Java框架模块系统规范。

综上所述，多数人难以区分新的模块系统和OSGi是正常的。但是，模块系统和OSGi相互补充，用以服务于不同的目标，OSGi作为一个构建于Java之上的框架，在一个持续运行的应用中，创建了一个用以动态管理bundle的环境，而模块系统作为Java本身的新能力能够更紧密更简单的控制静态模块。


### Java平台模块系统和OSGi的区别

为了更好的理解这一点，InfoQ请教了Holly Cummins，《Enterprise OSGi in Action》的作者之一。不过以下内容并不会彻底说清楚Java平台模块系统和OSGi之间的差异，只是为读者提供一个基本的理解关于两者目标的区别。

一方面，Java新的模块系统将会提供更简单的方式在编译时检查包和类的可见性，但是当我们询问OSGi的bundle是否能用相同的方式使用时，Holly表示“答案是相当的复杂”。

> OSGi通过bundle的清单文件来描述依赖，有两种基本方式来创建清单文件:“代码优先”和“清单文件优先”。代码优先方式（使用bnd工具，和maven bundle插件），并不会在编译时检查依赖列表，实际上它是在编译时生成的。在通常方式的编译过程中，工具会根据编译时的依赖统计出运行时的依赖。另一种方式是清单文件优先，通过Eclipse PDE工具来使用。在这种方式中，依赖被声明在清单文件中，Eclipse IDE会使用这份清单文件统计出你的代码能访问的类，并高亮缺失的依赖。PDE命令行构建和一个叫做Tycho的Maven插件，都会在编译时检查依赖关系。但是，请注意OSGi自己并不会检查可见性，而是通过PDE自带的工具；因为不是所有使用PDE的团队都会使用其中的工具，有时候可能会在编译时造成缺少依赖。

新的模块系统的另一个重要方面是能够限定指定包对模块的导出，这是很有用的当一批相互关联的模块需要互相访问，但却不能访问其他内容时。正如Mark Reinhold在报告中指出的，这能够用以下语法来实现：

```java
 module java.base {
   ...
   exports sun.reflect to
       java.corba,
       java.logging,
       java.sql,
       java.sql.rowset,
       jdk.scripting.nashorn;
}
```

OSGi最初并没有这个能力，但增加之后能够让它比模块系统的目标走的更远。Holly解释道，“所有的bundle都能够注册成一个解析拦截器，用以过滤匹配，因此包只会暴露给指定的bundle。当导出声明了确定的元数据的包给bundle时，你能够使用相同的机制来预测，或者只是在每周二疯狂的导出包”。


[查看英文原文](http://www.infoq.com/news/2015/10/java-state-module-system)
[InfoQ译文地址](http://www.infoq.com/cn/news/2015/11/java-state-module-system)


  [1]: http://www.infoq.com/news/2015/10/java-state-module-system
