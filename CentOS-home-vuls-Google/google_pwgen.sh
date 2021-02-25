#!/bin/bash
# Usage: ./google_pwgen.sh
# 引数なし
# Google-account, Security は、~/.mailrc に登録されたメールアドレスのエイリアス

export LC_CTYPE=ja_JP.UTF-8

YEAR="`date +%Y`年"		# 2020年
MONTH="`date +%b`"		# 10月
DAY="`date +%-d`日"		# 1日
TODAY="`date +%Y-%m`"	# 2020-10
PWFILE="google_pwgen_${TODAY}.txt"
BASEFILE="base.txt"
MAILFILE="mail.txt"
SUBJECT="[Remind]GoogleAccount"
CC="Google-account"
TO="Security"
ZCSV="/mnt/z/path/to/Google/google-xxxxxxxx-gmail.com.csv"

echo -e "Today is the first day of ${YEAR}${MONTH}. \nGoogle password is: " > $BASEFILE

PW=`pwgen -c -n -s -B 12 1`
echo $PW > $PWFILE
cat $BASEFILE $PWFILE > $MAILFILE
cat $MAILFILE > log/google_pwgen_${TODAY}.log 2>&1

# 2020年10月,2020年10月01日,2020年10月31日,4qe34uQggdsq 追記
ENDOFMONTH=`date +"%Y年%m月%d日" -d "1 days ago \`date +%Y%m01 -d "+1 month"\`"`
ADDLINE="${YEAR}${MONTH},${YEAR}${MONTH}${DAY},${ENDOFMONTH},${PW}"

echo -e $ADDLINE >> $ZCSV

# メール送信
# mail -v　送信ログが、From あてに届く
cat ${MAILFILE} | \
mail \
-s ${SUBJECT} \
-r vuls@abcd.com \   # From
-c ${CC} \
${TO}
