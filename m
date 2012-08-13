Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7DBwLvp261170 for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 06:58:21 -0500
Received: from mail-bk0-f53.google.com (mail-bk0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id jnUIMspB612tM4us
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 13 Aug 2012 04:58:19 -0700 (PDT)
Received: by bkwj4 with SMTP id j4so1907562bkw.26
	for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 04:58:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1488479.ZDGdaNpFNb@saturn>
References: <CADcDJaR52zwL+aMaUuQTvbYx2d11LRmzdURE2Ok8z0tKsYTv8A@mail.gmail.com>
	<1488479.ZDGdaNpFNb@saturn>
Date: Mon, 13 Aug 2012 13:58:17 +0200
Message-ID: <CADcDJaSstv=2UZ9HmwsP1XMKNspBtuUB5gLLA=vW9vN4ezYXaQ@mail.gmail.com>
Subject: Re: xfs_repair - segemnation fault | git error
From: Velimir Galic <veli.galic@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0553852022445390202=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

--===============0553852022445390202==
Content-Type: multipart/alternative; boundary=0015175cd0f2cbf9d204c72468b3

--0015175cd0f2cbf9d204c72468b3
Content-Type: text/plain; charset=ISO-8859-1

hi,

Thanks for the fast replay and the effort!

2012/8/11 Michael Monnerie <michael.monnerie@is.it-management.at>

> Am Freitag, 10. August 2012, 10:23:03 schrieb Velimir Galic:
> > a second disk got lost in the raid. The raidsync wasn't finished and
> > now i'm fighting 3 weeks or more i don't no any more :-( to repair
> > the file system.
>
> How far did the recovery go when it broke? If it was on 10% when the 2nd
> disk broke, you can stop to try to get anything. If it was 90% finished,
> you might have a chance...
>

that's what I thought but hoped for that isn't a problem. The sync failed
at approx. 20% or beneath.


> > 4x2GB | RAID 5 | Softraid
>
> This is a 6GB net RAID 5 device? Which devices?
>

WDC WD20EARS-22MVWB0


>
> > I tried a lot of different versions of xfs_repair
>
> I hope you got a copy of all disks before you even tried to repair?
> Otherwise it might be too late now, when repair wrote something on that
> device.
>
>
Nope, I wasn't clever enough to do that, but it isn't hopeless because I
have a
3 months old backup form my important files. So I have to life with the 3
months lost, I hope is not to much.


Thanks for trying to help, but I stop her with trying to recover anything
and start over.

Shit happens! :-)

--0015175cd0f2cbf9d204c72468b3
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

hi,=A0<div><br></div><div>Thanks for the fast replay and the effort!</div><=
div><br><div class=3D"gmail_quote">2012/8/11 Michael Monnerie <span dir=3D"=
ltr">&lt;<a href=3D"mailto:michael.monnerie@is.it-management.at" target=3D"=
_blank">michael.monnerie@is.it-management.at</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Am Freitag, 10. August 2012, 10:23:03 schrie=
b Velimir Galic:<br>
<div class=3D"im">&gt; a second disk got lost in the raid. The raidsync was=
n&#39;t finished and<br>
&gt; now i&#39;m fighting 3 weeks or more i don&#39;t no any more :-( to re=
pair<br>
&gt; the file system.<br>
<br>
</div>How far did the recovery go when it broke? If it was on 10% when the =
2nd<br>
disk broke, you can stop to try to get anything. If it was 90% finished,<br=
>
you might have a chance...<br></blockquote><div><br></div><div>that&#39;s w=
hat I thought but hoped for that isn&#39;t a problem. The sync failed at ap=
prox. 20% or beneath.=A0</div><div><br></div><blockquote class=3D"gmail_quo=
te" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"=
>

<br>
&gt; 4x2GB | RAID 5 | Softraid<br>
<br>
This is a 6GB net RAID 5 device? Which devices?<br></blockquote><div><br></=
div><div>WDC WD20EARS-22MVWB0</div><div>=A0</div><blockquote class=3D"gmail=
_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:=
1ex">

<div class=3D"im"><br>
&gt; I tried a lot of different versions of xfs_repair<br>
<br>
</div>I hope you got a copy of all disks before you even tried to repair?<b=
r>
Otherwise it might be too late now, when repair wrote something on that<br>
device.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br></font></span></blockquo=
te><div><br></div><div>Nope, I wasn&#39;t clever enough to do that, but it =
isn&#39;t=A0hopeless=A0because I have a=A0</div><div>3=A0months=A0old backu=
p form my important files. So I have to life with the 3 months lost, I hope=
 is not to much.</div>
<div>=A0</div><div><br></div><div>Thanks for=A0trying to help, but I stop h=
er with trying to recover anything and start over.=A0</div><div><br></div><=
div>Shit happens! :-)=A0</div></div></div>

--0015175cd0f2cbf9d204c72468b3--


--===============0553852022445390202==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0553852022445390202==--
