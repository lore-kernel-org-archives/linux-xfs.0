Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3L0wCWr038735 for <xfs@oss.sgi.com>; Fri, 20 Apr 2012 19:58:12 -0500
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	CG4xFx9F7MXM9a3u (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Apr 2012 17:58:11 -0700 (PDT)
Received: by iagk10 with SMTP id k10so16182814iag.26
	for <xfs@oss.sgi.com>; Fri, 20 Apr 2012 17:58:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F919670.3090603@sandeen.net>
References: <CALcU-6goaENFYsvUxz3yQD=w6ipmHuo-GxoRHT1GaQ6+yW5-pA@mail.gmail.com>
	<4F917B77.6040403@sandeen.net>
	<CALcU-6i3MY+Z-dFzE5p34DSMxcQi2dPdXZHenh+=5TObyiB8eQ@mail.gmail.com>
	<4F919670.3090603@sandeen.net>
From: Drew Wareham <m3rlin@gmail.com>
Date: Sat, 21 Apr 2012 10:57:50 +1000
Message-ID: <CALcU-6jo77z4r=J87jeRyN3J7Q0KtUS8DUO5LL84=MXj8VkU6Q@mail.gmail.com>
Subject: Re: xfs_check segfault / xfs_repair I/O error
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9028709328546196975=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============9028709328546196975==
Content-Type: multipart/alternative; boundary=e89a8f2349c11e547b04be25e679

--e89a8f2349c11e547b04be25e679
Content-Type: text/plain; charset=UTF-8

Thanks Eric - It might be time for us to switch up to RHEL to be honest ;).

Thanks again everyone.

Drew


On Sat, Apr 21, 2012 at 3:01 AM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 4/20/12 10:46 AM, Drew Wareham wrote:
> > Good point!  We're running CentOS 5, so is the CentOS-Plus repo the way
> to go?  These servers are all setup from a fairly old base image hence
> using kmod-xfs, definitely something I'll address.
>
> as long as you're on x86_64, the stock kernel has the xfs.ko you want.
>
> I'm not big on offering too much centos support, but i would rather not
> see people using reaaaly crufty xfs.  :)
>
> -Eric
>

--e89a8f2349c11e547b04be25e679
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Thanks Eric - It might be time for us to switch up to RHEL to be honest ;).=
<br><br>Thanks again everyone.<br><br>Drew<br>
<br><br><div class=3D"gmail_quote">On Sat, Apr 21, 2012 at 3:01 AM, Eric Sa=
ndeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@=
sandeen.net</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">

<div class=3D"im">On 4/20/12 10:46 AM, Drew Wareham wrote:<br>
&gt; Good point! =C2=A0We&#39;re running CentOS 5, so is the CentOS-Plus re=
po the way to go? =C2=A0These servers are all setup from a fairly old base =
image hence using kmod-xfs, definitely something I&#39;ll address.<br>
<br>
</div>as long as you&#39;re on x86_64, the stock kernel has the xfs.ko you =
want.<br>
<br>
I&#39;m not big on offering too much centos support, but i would rather not=
 see people using reaaaly crufty xfs. =C2=A0:)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-Eric<br>
</font></span></blockquote></div><br>

--e89a8f2349c11e547b04be25e679--


--===============9028709328546196975==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9028709328546196975==--
