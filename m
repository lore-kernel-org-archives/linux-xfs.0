Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 422267F5D
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 20:21:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 07494304039
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 18:21:14 -0800 (PST)
Received: from mail-qk0-f178.google.com (mail-qk0-f178.google.com
	[209.85.220.178]) by cuda.sgi.com with ESMTP id
	v8zuhAVnDf1ar0xL (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 18:21:10 -0800 (PST)
Received: by qkao63 with SMTP id o63so18872714qka.2
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 18:21:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151111125021.GA28745@redhat.com>
References: <CAFf1yNFYh3C9NR8OadL=wXALT3mj58LTVvnE3fypOBXOP_JzoQ@mail.gmail.com>
	<20151111125021.GA28745@redhat.com>
Date: Thu, 12 Nov 2015 10:21:09 +0800
Message-ID: <CAFf1yNFwY5uANDbTQhQsmdZj=FzOduUDcGGTNG-EnK0P0a+=7w@mail.gmail.com>
Subject: Re: xfsprogs install
From: rui li <liruilong0128@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0712383930223639883=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: rui li <liruilong0128@gmail.com>, xfs@oss.sgi.com

--===============0712383930223639883==
Content-Type: multipart/alternative; boundary=001a114953ba96b47105244e9897

--001a114953ba96b47105244e9897
Content-Type: text/plain; charset=UTF-8

thanks !
when i run mkfs.xfs -f /dev/sda2p1 ,the error is no that file or directory
acturally /dev/sda2p1  existed
could you give me some help?
thank you very much

2015-11-11 20:50 GMT+08:00 Carlos Maiolino <cmaiolino@redhat.com>:

> On Wed, Nov 11, 2015 at 02:38:24PM +0800, rui li wrote:
> >    hello
> >    when i install xfsprogs i hava follwing problems
> >    FATAL ERROR: could not find a valid BLKID header
> >    Install the Block device ID development package
> >    could you give me some help?
> >    thanks
> install libblkid-devel package in your distribution, or any similar
> package that
> your distribution provides with libblkid headers.
>
>
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
>
> --
> Carlos
>

--001a114953ba96b47105244e9897
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">thanks !<div>when i run mkfs.xfs -f /dev/sda2p1 ,the error=
 is no that file or directory=C2=A0</div><div>acturally /dev/sda2p1 =C2=A0e=
xisted</div><div>could you give me some help?</div><div>thank you very much=
=C2=A0</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote"=
>2015-11-11 20:50 GMT+08:00 Carlos Maiolino <span dir=3D"ltr">&lt;<a href=
=3D"mailto:cmaiolino@redhat.com" target=3D"_blank">cmaiolino@redhat.com</a>=
&gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8e=
x;border-left:1px #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div c=
lass=3D"h5">On Wed, Nov 11, 2015 at 02:38:24PM +0800, rui li wrote:<br>
&gt;=C2=A0 =C2=A0 hello<br>
&gt;=C2=A0 =C2=A0 when i install xfsprogs i hava follwing problems<br>
&gt;=C2=A0 =C2=A0 FATAL ERROR: could not find a valid BLKID header<br>
&gt;=C2=A0 =C2=A0 Install the Block device ID development package<br>
&gt;=C2=A0 =C2=A0 could you give me some help?<br>
&gt;=C2=A0 =C2=A0 thanks<br>
</div></div>install libblkid-devel package in your distribution, or any sim=
ilar package that<br>
your distribution provides with libblkid headers.<br>
<br>
<br>
&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"noreferrer"=
 target=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
--<br>
Carlos<br>
</font></span></blockquote></div><br></div>

--001a114953ba96b47105244e9897--


--===============0712383930223639883==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0712383930223639883==--
