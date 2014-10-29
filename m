Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 81AC87F37
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 23:27:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6F5358F8033
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 21:27:07 -0700 (PDT)
Received: from mail-ob0-f176.google.com (mail-ob0-f176.google.com
	[209.85.214.176]) by cuda.sgi.com with ESMTP id
	8Wyb9dFd7MOGNLqW (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Oct 2014 21:27:06 -0700 (PDT)
Received: by mail-ob0-f176.google.com with SMTP id va2so1753865obc.35
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 21:27:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5450686F.9070307@sandeen.net>
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
	<5450686F.9070307@sandeen.net>
Date: Wed, 29 Oct 2014 12:27:05 +0800
Message-ID: <CAGdb-8d5-GuB40ZgP6uM5aQMi+qqaeFd=xqzuxWhM+1AaoLSVw@mail.gmail.com>
Subject: Re: xfsrestore report SUCCESS but not restore all files in kernel 3.17
From: Tommy Wu <wu.tommy@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5310254878404563271=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs <xfs@oss.sgi.com>

--===============5310254878404563271==
Content-Type: multipart/alternative; boundary=001a1134fcba1ceef00506882d09

--001a1134fcba1ceef00506882d09
Content-Type: text/plain; charset=UTF-8

In "xfsdump not work in 3.17", after apply the 2 patches, xfsdump work
(won't hang).
But xfsrestore can't restore the dump correctly (like the case in this
email).

Is other patch I miss?  I check the thread in Archive again, I don't see
any patch about the xfsrestore issue.

2014-10-29 12:09 GMT+08:00 Eric Sandeen <sandeen@sandeen.net>:

>
> Is this not the same bug we already discussed in your prior email,
> "xfsdump not work in 3.17" ?  Are you testing with or without those
> bugfixes?
>
>
>


-- 

Tommy Wu

--001a1134fcba1ceef00506882d09
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>In &quot;xfsdump not work in 3.17&quot;, after a=
pply the 2 patches, xfsdump work (won&#39;t hang).<br></div>But xfsrestore =
can&#39;t restore the dump correctly (like the case in this email).<br><br>=
</div>Is other patch I miss?=C2=A0 I check the thread in Archive again, I d=
on&#39;t see any patch about the xfsrestore issue.<br><div><div><div><div c=
lass=3D"gmail_extra"><br><div class=3D"gmail_quote">2014-10-29 12:09 GMT+08=
:00 Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.ne=
t" target=3D"_blank">sandeen@sandeen.net</a>&gt;</span>:<br><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pa=
dding-left:1ex"><span class=3D""><br>
</span>Is this not the same bug we already discussed in your prior email,<b=
r>
&quot;xfsdump not work in 3.17&quot; ?=C2=A0 Are you testing with or withou=
t those bugfixes?<br>
<br>
<br>
</blockquote></div><br><br clear=3D"all"><br>-- <br><div class=3D"gmail_sig=
nature"><br>Tommy Wu</div>
</div></div></div></div></div>

--001a1134fcba1ceef00506882d09--


--===============5310254878404563271==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5310254878404563271==--
