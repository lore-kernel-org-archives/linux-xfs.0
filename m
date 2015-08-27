Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D0F987F37
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2015 01:06:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BEEBA8F8033
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 23:06:26 -0700 (PDT)
Received: from mail-ig0-f176.google.com (mail-ig0-f176.google.com
	[209.85.213.176]) by cuda.sgi.com with ESMTP id
	XE0poYVs5wec1CGU (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 23:06:25 -0700 (PDT)
Received: by igcse8 with SMTP id se8so59466411igc.1
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 23:06:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150826220122.GD3902@dastard>
References: <1440590449-20372-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-2-git-send-email-jtulak@redhat.com>
	<20150826220122.GD3902@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 27 Aug 2015 08:06:05 +0200
Message-ID: <CACj3i71CGrBYT-n6x5E1q7xT17wwTF89YEu_Mhp0Et3yO1-c3Q@mail.gmail.com>
Subject: Re: [PATCH 02/11] xfsprogs: avoid dependency on linux
	XATTR_SIZE/LIST_MAX
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3665880316703961655=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

--===============3665880316703961655==
Content-Type: multipart/alternative; boundary=089e0102f83e639adb051e44c428

--089e0102f83e639adb051e44c428
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2015 at 12:01 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Aug 26, 2015 at 02:02:26PM +0200, Jan Tulak wrote:
> > Signed-off-by: Jan Tulak <jtulak@redhat.com>
>
> Explanation of the change?
>

Submitted. And sorry, I realized I didn't add v2 to the patch the moment
I sent it.
=E2=80=8B =E2=80=8B
:-( Though only the commit message is changed.

=E2=80=8BCheers,
Jan=E2=80=8B

--
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--089e0102f83e639adb051e44c428
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Thu, Aug 27, 2015 at 12:01 AM, Dave Chinner <span dir=3D"lt=
r">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromo=
rbit.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On Wed, =
Aug 26, 2015 at 02:02:26PM +0200, Jan Tulak wrote:<br>
&gt; Signed-off-by: Jan Tulak &lt;<a href=3D"mailto:jtulak@redhat.com" targ=
et=3D"_blank">jtulak@redhat.com</a>&gt;<br>
<br>
Explanation of the change?<br></blockquote><br>Submitted. And sorry, I real=
ized I didn&#39;t add v2 to the patch the moment<br>I sent it.<div class=3D=
"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;display:inl=
ine">=E2=80=8B =E2=80=8B</div>:-( Though only the commit message is changed=
.</div><div class=3D"gmail_quote"><br></div><div class=3D"gmail_quote"><div=
 class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">=
=E2=80=8BCheers,</div><div class=3D"gmail_default" style=3D"font-family:ari=
al,helvetica,sans-serif">Jan=E2=80=8B</div></div><div class=3D"gmail_quote"=
><div><br></div><div>--</div></div><div><div dir=3D"ltr"><div><div dir=3D"l=
tr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" target=3D"=
_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=
=3D"_blank">jan@tulak.me</a></div></div></div></div>
</div></div>

--089e0102f83e639adb051e44c428--


--===============3665880316703961655==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3665880316703961655==--
