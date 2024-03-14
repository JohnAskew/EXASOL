OPEN SCHEMA EXA_TOOLBOX;

--/
CREATE OR REPLACE PYTHON3 SCALAR SCRIPT MAIL_MAN (summary varchar(200000)) 
emits (message varchar(1000))
AS
import smtplib
import datetime as dt
#######################################
# FUNCTIONS
#######################################
#---------------------------------------
def get_timestamp():
#---------------------------------------
    now = dt.datetime.now()
    now_formatted = now.strftime("%Y-%m-%d %H.%M")
    return now_formatted

#---------------------------------------
def parse_summary(summaries):
#---------------------------------------
    s = ''
    cr = "\n"
    for sum in summaries:
        #ctx.emit(sum)
        s +=sum
        s +=cr
    return s

#######################################
# MAIN LOGIC
#######################################

#---------------------------------------
def run(ctx):
#---------------------------------------
    summaries = ctx.summary.split("'")
    summaries = [sum.strip(",") for sum in summaries if sum != ' ']
    s = parse_summary(summaries)
    print(s)
    
    date_now = get_timestamp()
    mail_user='user@gmail.com'    --update me
    mail_password = 'xxxxxxxx'   -- update me
    sent_from = 'xxxxxx@gmailcom <xxxxxxx>@gmail.com>'  -- update me
    to = ['user@exasol.com']      -- update me
    subject = 'LDAP Sync Report'
    body = "Reporting for {}\n".format(get_timestamp())
    body += s
    email_text = """From: %s\nTo: %s\nSubject: %s\n\n%s""" % (sent_from, ", ".join(to), subject, body)
    
    try:
        server_ssl = smtplib.SMTP_SSL('smtp.gmail.com', 465)
        print(server_ssl.ehlo())
        server_ssl.login(mail_user, mail_password)
        server_ssl.sendmail(sent_from, to, email_text)
        server_ssl.close()
        print("Email Sent")
    except:
        print('Something went wrong in MAIN LOGIC...')

/
