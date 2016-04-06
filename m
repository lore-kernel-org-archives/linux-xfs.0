Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 810B87CA0
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 04:05:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 523C7304059
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 02:05:49 -0700 (PDT)
Received: from mail-ig0-f179.google.com (mail-ig0-f179.google.com
	[209.85.213.179]) by cuda.sgi.com with ESMTP id
	Brq9Y9cRzXACrwTQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Apr 2016 02:05:48 -0700 (PDT)
Received: by mail-ig0-f179.google.com with SMTP id gy3so73660902igb.0
	for <xfs@oss.sgi.com>; Wed, 06 Apr 2016 02:05:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56FD87BC.5070805@sandeen.net>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-2-git-send-email-jtulak@redhat.com>
	<56FD87BC.5070805@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 6 Apr 2016 11:05:28 +0200
Message-ID: <CACj3i70khTwoenvV1tHD_QJS7dFuNREmrK279DyKQNJyM5dvgw@mail.gmail.com>
Subject: Re: [PATCH 01/19] xfsprogs: use common code for multi-disk detection
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8656184891807425415=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============8656184891807425415==
Content-Type: multipart/alternative; boundary=089e013c60ec7f50a6052fcd4416

--089e013c60ec7f50a6052fcd4416
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 31, 2016 at 10:25 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
>
> Minor comment stuff below, otherwise seems ok.
>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>
> and feel free to add that if you make the suggested changes, too.
>

=E2=80=8BChanged, thanks. :-)=E2=80=8B


--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--089e013c60ec7f50a6052fcd4416
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div><div class=3D"gmail_extra"><br><br><div class=
=3D"gmail_quote">On Thu, Mar 31, 2016 at 10:25 PM, Eric Sandeen <span dir=
=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sande=
en@sandeen.net</a>&gt;</span> wrote:<blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span cl=
ass=3D"">
<br>
</span>Minor comment stuff below, otherwise seems ok.<br>
<br>
Reviewed-by: Eric Sandeen &lt;<a href=3D"mailto:sandeen@redhat.com">sandeen=
@redhat.com</a>&gt;<br>
<br>
and feel free to add that if you make the suggested changes, too.<br></bloc=
kquote><div><br></div><div><div class=3D"gmail_default" style=3D"font-famil=
y:arial,helvetica,sans-serif;display:inline">=E2=80=8BChanged, thanks. :-)=
=E2=80=8B</div>=C2=A0</div></div><div><br></div>-- <br><div class=3D"gmail_=
signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><=
a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=
=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a><=
/div></div></div></div>
</div></div>

--089e013c60ec7f50a6052fcd4416--


--===============8656184891807425415==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8656184891807425415==--
