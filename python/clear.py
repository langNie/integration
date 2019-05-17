#!/usr/bin/python3

import pymysql
import os, sys


def opdb(dbname):
    # 打开数据库连接
    db = pymysql.connect("192.168.12.125","root","root",dbname )
    return db;

#查找uid 写入白名单
def select_uid(ph):
      db=opdb("数据库名");
      # 使用cursor()方法获取操作游标 
      cursor = db.cursor()
      sql = "select uid,userid,username,phone,email from users where phone='%s'" % (ph);
      try:
            # 执行SQL语句
            cursor.execute(sql)
            # 获取所有记录列表
            results = cursor.fetchall()
            for row in results:
                  uid = row[0]
                  userid = row[1]
                  username = row[2]
                  phone = row[3]
                  email = row[4]
                  # 打印结果
                  print("uid=%s,userid=%s,username=%s,phone=%s",uid,userid,username,phone)
                  return userid;
      except:
            print("Error: unable to fetch data")
            return "";

      # 关闭数据库连接
      db.close()
      return "";

#插入空投值
def findaccountid(userid):

      if userid=="":
             return "";

      db=opdb("数据库名")

      cursor = db.cursor()
      sql = "select * from data where user_id='%s') order by id desc limit 1" % (userid);
      print(sql);
      value="";
      id=0;
      try:
            # 执行SQL语句
            cursor.execute(sql)
            # 获取所有记录列表
            results = cursor.fetchall()
            for row in results:
                  value = row[0]
                  id= row[1]
                  # 打印结果
                  print("【value=%s】" % (value));
      except Exception as e:
            print("Error: unable to fetch data: %s" % e)
            return "";



      sql2 = "select * from data where user_id='%s') order by id desc limit 1" % (userid);
      try:
            print(sql2);
            cursor.execute(sql2);
          # 提交到数据库执行
            db.commit();
      except:
            # 发生错误时回滚
            db.rollback()
      # 关闭数据库连接
      # db.close()

      sql3 = "delete from data where id = %d " % (id);
      try:
            print(sql3);
            cursor.execute(sql3);
          # 提交到数据库执行
            db.commit();
      except:
            # 发生错误时回滚
            db.rollback()


      # 关闭数据库连接
      db.close()


      

#输入手机号 删除最近的一个记录
var_userid=select_uid('18680391276')
findaccountid(var_userid)


