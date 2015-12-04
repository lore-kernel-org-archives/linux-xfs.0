Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F07AE7F37
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2015 08:04:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 786DBAC002
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2015 06:04:28 -0800 (PST)
Received: from mail-io0-f170.google.com (mail-io0-f170.google.com
	[209.85.223.170]) by cuda.sgi.com with ESMTP id
	Z7zHbSSJovBpvpqi (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Dec 2015 06:04:26 -0800 (PST)
Received: by ioir85 with SMTP id r85so116567289ioi.1
	for <xfs@oss.sgi.com>; Fri, 04 Dec 2015 06:04:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151204130000.GA47882@bfoster.bfoster>
References: <CACj3i71kgpqNvg0ru=-4x6gtJ8faOVn-P=y_AM+xwoKbm-55tQ@mail.gmail.com>
	<20151204130000.GA47882@bfoster.bfoster>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 4 Dec 2015 15:04:06 +0100
Message-ID: <CACj3i71hj1BZvjQoUxD9jiv2Wzy1Pt00keyOV8d2FNz7Er-+-A@mail.gmail.com>
Subject: Re: Is test xfs/096 correct?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5694151835969592003=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============5694151835969592003==
Content-Type: multipart/alternative; boundary=001a113ec5543827bc052612fc3f

--001a113ec5543827bc052612fc3f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 4, 2015 at 2:00 PM, Brian Foster <bfoster@redhat.com> wrote:

> max_lr_size refers to the maximum log record size (256k). When a larger
> log stripe unit is passed, mkfs warns about it and adjusts to the
> default:
>

=E2=80=8BAh, ok, thank you for explaining it to me, I understand the test n=
ow. :-)

Cheers,
Jan=E2=80=8B


--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a113ec5543827bc052612fc3f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Fri, De=
c 4, 2015 at 2:00 PM, Brian Foster </span><span dir=3D"ltr" style=3D"font-f=
amily:arial,sans-serif">&lt;<a href=3D"mailto:bfoster@redhat.com" target=3D=
"_blank">bfoster@redhat.com</a>&gt;</span><span style=3D"font-family:arial,=
sans-serif"> wrote:</span></div><div class=3D"gmail_extra"><div class=3D"gm=
ail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bor=
der-left:1px #ccc solid;padding-left:1ex">max_lr_size refers to the maximum=
 log record size (256k). When a larger<br>
log stripe unit is passed, mkfs warns about it and adjusts to the<br>
default:<br></blockquote><div><br></div><div><div class=3D"gmail_default" s=
tyle=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BAh, ok, thank you =
for explaining it to me, I understand the test now. :-)</div><div class=3D"=
gmail_default" style=3D"font-family:arial,helvetica,sans-serif"><br></div><=
div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif=
">Cheers,</div><div class=3D"gmail_default" style=3D"font-family:arial,helv=
etica,sans-serif">Jan=E2=80=8B</div><br></div><div>=C2=A0</div></div>-- <br=
><div class=3D"gmail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div=
>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">=
jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_bla=
nk">jan@tulak.me</a></div></div></div></div>
</div></div>

--001a113ec5543827bc052612fc3f--


--===============5694151835969592003==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5694151835969592003==--
