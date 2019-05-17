import pymysql
import os, sys


def opdb(dbname):
    return pymysql.connect("172.18.138.44", "root", "NDc2Yzk2M2Mw", dbname)


def queryArticle():
    db = opdb("aaa")
    cursor = db.cursor()
    try:
        sql = "select * from data where user_id='%s') order by id desc limit 1" % (userid);
        cursor.execute(sql)
        results = cursor.fetchall()
        print(len(results))

        for row in results:
            articleId = row[0]
            articleHash = row[1]
            print("articleHash = %s,articleId = %s", articleHash, articleId)
            hash = selectByArticleHash(articleHash)
            print("hash = %s", hash)
            if hash is None:
                print(111)
            else:
                updata(articleId, hash)
    except:
        print("Error: unable to fetch data1")

    db.close()


def selectByArticleHash(articleHash):
    db = opdb("aaa")
    cursor = db.cursor()
    try:
        sql = "select * from data where user_id='%s') order by id desc limit 1" % (articleHash);
        cursor.execute(sql)
        row = cursor.fetchone()
        if row is None:
            return None
        else:
            return row[0]
    except:
        print("Error: unable to fetch data2")
    db.close()


def updata(articleId, hash):
    db = opdb("aaa")
    cursor = db.cursor()
    try:
        sql = "select * from data where user_id='%s') order by id desc limit 1" % (articleId, hash);
        cursor.execute(sql)
        db.commit();
    except:
        db.rollback()
    db.close()


queryArticle()
