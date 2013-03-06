Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 69FF28004
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 07:03:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EF31BAC005
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 05:03:28 -0800 (PST)
Received: from mail-la0-f45.google.com (mail-la0-f45.google.com
	[209.85.215.45]) by cuda.sgi.com with ESMTP id QxbwjZvEAzHfH3nE
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Mar 2013 05:03:27 -0800 (PST)
Received: by mail-la0-f45.google.com with SMTP id er20so7365854lab.18
	for <xfs@oss.sgi.com>; Wed, 06 Mar 2013 05:03:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <51373DB8.2020707@redhat.com>
References: <CAOdS1h=7X4O1O7X8YOwxtLm7G=fc+J+6hJxJ1RKbDmfTZXTpeg@mail.gmail.com>
	<51373DB8.2020707@redhat.com>
From: Shrinath M <shrinath.m@webyog.com>
Date: Wed, 6 Mar 2013 18:33:05 +0530
Message-ID: <CAOdS1hnXGj9puaHxeToqmpK40A-3WvJnM7=5HckpyyZYqZTvEQ@mail.gmail.com>
Subject: Re: XFS filesystem on EC2 instance corrupts and shuts down
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3432323565341563404=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ric Wheeler <rwheeler@redhat.com>, Supratik Goswami <supratik.goswami@webyog.com>
Cc: Sabyasachi Ruj <sabyasachi.ruj@webyog.com>, Vivek Goel <vivek.goel@webyog.com>, xfs@oss.sgi.com

--===============3432323565341563404==
Content-Type: multipart/alternative; boundary=e0cb4efe29d230549c04d7413786

--e0cb4efe29d230549c04d7413786
Content-Type: text/plain; charset=UTF-8

On Wed, Mar 6, 2013 at 6:29 PM, Ric Wheeler <rwheeler@redhat.com> wrote:

> I think that you would need to verify that the Amazon storage is not
> throwing errors - do your logs show IO errors or issues before XFS hits an
> issue?


No IO errors in /var/log/messages.
Where else should I be looking?



-- 
Regards
*Shrinath.M*

--e0cb4efe29d230549c04d7413786
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><br></div><div class=3D"gmail_e=
xtra"><div class=3D"gmail_quote">On Wed, Mar 6, 2013 at 6:29 PM, Ric Wheele=
r <span dir=3D"ltr">&lt;<a href=3D"mailto:rwheeler@redhat.com" target=3D"_b=
lank">rwheeler@redhat.com</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex">I think that you would need to verify that the Amazon stor=
age is not throwing errors - do your logs show IO errors or issues before X=
FS hits an issue?</blockquote>

</div><div class=3D"gmail_extra"><br></div>No IO errors in /var/log/message=
s.=C2=A0</div><div class=3D"gmail_extra">Where else should I be looking?</d=
iv><div class=3D"gmail_extra"><br><br clear=3D"all"><div><br></div>-- <br><=
font face=3D"&#39;courier new&#39;, monospace" color=3D"#666666">Regards</f=
ont><div>

<b><font face=3D"&#39;courier new&#39;, monospace" color=3D"#666666">Shrina=
th.M</font></b></div><div><br></div>
</div></div>

--e0cb4efe29d230549c04d7413786--


--===============3432323565341563404==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3432323565341563404==--
