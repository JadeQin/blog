---
title: "Maven Filters 使用"
date: 2015-06-19T18:07:41+08:00
---

# 场景
在项目开发过程中，经常会遇到部署到不同的环境中，比如本地、测试、正式等，如果每次都人为修改相关内容，很容易误操作，也不方便记录。
Maven本身提供了一种解决方案，能够在编译过程中，对相关内容进行修改。

# 方案
* 在build中对resource开启filter

```
<resources>
  <resource>
    <directory>${basedir}/src/main/resources</directory>
    <filtering>true</filtering>
  </resource>
</resources>
```

* 定义profile，指定默认的profile

```
<profiles>
  <profile>
    <id>test</id>
    <activation>
      <activeByDefault>true</activeByDefault>
    </activation>
    <properties>
      <profile.env>test</profile.env>
    </properties>
  </profile>

  <profile>
    <id>produce</id>
    <properties>
      <profile.env>produce</profile.env>
    </properties>
  </profile>
</profiles>
```

* 在build中定义filter

```
<filters>
  <filter>${basedir}/profiles/${profile.env}.properties</filter>
</filters>
```

* 定义需要修改的内容，比如数据库连接地址

```
db.server=***
```
然后在项目的属性文件中，将原来定义的地址替换为`${db.server}`

这样，maven在编译时，会根据`-P`指定的profile或者默认的profile中定义的属性值，替换成实际内容，避免了人为修改的情况。