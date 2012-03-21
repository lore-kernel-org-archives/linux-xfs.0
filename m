Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2LIvDGr110496 for <xfs@oss.sgi.com>; Wed, 21 Mar 2012 13:57:14 -0500
Received: from kyle.its.monash.edu.au (kyle.its.monash.edu.au
	[130.194.13.163]) by cuda.sgi.com with ESMTP id
	QTgnesJL1Jh0r7d3 for <xfs@oss.sgi.com>;
	Wed, 21 Mar 2012 11:57:12 -0700 (PDT)
Received: from idle.its.monash.edu.au ([130.194.13.84])
	by kyle.its.monash.edu.au
	(Sun Java System Messaging Server 6.2-4.03 (built Sep 22 2005))
	with ESMTP id <0M190071Z0N90I10@kyle.its.monash.edu.au> for
	xfs@oss.sgi.com; Thu, 22 Mar 2012 05:57:10 +1100 (EST)
Received: from idle.its.monash.edu.au (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id DBFE5100A3	for <xfs@oss.sgi.com>;
	Thu, 22 Mar 2012 05:57:10 +1100 (EST)
Received: from mail-pb0-f54.google.com
	(mail-pb0-f54.google.com [209.85.160.54])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)	by idle.its.monash.edu.au (Postfix)
	with ESMTPS id 6AA8F10097	for <xfs@oss.sgi.com>; Thu,
	22 Mar 2012 05:57:10 +1100 (EST)
Received: by pbcwz17 with SMTP id wz17so1160408pbc.41 for <xfs@oss.sgi.com>;
	Wed, 21 Mar 2012 11:57:07 -0700 (PDT)
Date: Thu, 22 Mar 2012 05:57:07 +1100
From: Nathan Scott <nathans@debian.org>
Subject: Re: [patch 1/1] xfsdump: update summaries in preparation for release
In-reply-to: <20120321172813.301990261@sgi.com>
Message-id: <CAAp5ZgNpxMY=NnuwhGmjsmEgxvmDrYcwhLNr6cr7WOj26G06pg@mail.gmail.com>
MIME-version: 1.0
References: <20120320204316.811460772@sgi.com>
	<20120321172813.301990261@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3057480933943910745=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: bpm@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

--===============3057480933943910745==
Content-type: multipart/alternative; boundary=e89a8ff25518a6829304bbc55b85

--e89a8ff25518a6829304bbc55b85
Content-Type: text/plain; charset=ISO-8859-1

On 21 March 2012 07:43, <bpm@sgi.com> wrote:

> Signed-off-by: Ben Myers <bpm@sgi.com>
> ---
>  VERSION          |    4 ++--
>  debian/changelog |    6 ++++++
>  doc/CHANGES      |   15 +++++++++++++++
>  3 files changed, 23 insertions(+), 2 deletions(-)
> ...


Looks good to me, thanks.

Reviewed-by: Nathan Scott <nathans@debian.org>

--
Nathan

--e89a8ff25518a6829304bbc55b85
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div><div class=3D"gmail_quote">On 21 March 2012 07:43,  <span dir=3D"ltr">=
&lt;<a href=3D"mailto:bpm@sgi.com">bpm@sgi.com</a>&gt;</span> wrote:<br><bl=
ockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #=
ccc solid;padding-left:1ex">
Signed-off-by: Ben Myers &lt;<a href=3D"mailto:bpm@sgi.com">bpm@sgi.com</a>=
&gt;<br>
---<br>
=A0VERSION =A0 =A0 =A0 =A0 =A0| =A0 =A04 ++--<br>
=A0debian/changelog | =A0 =A06 ++++++<br>
=A0doc/CHANGES =A0 =A0 =A0| =A0 15 +++++++++++++++<br>
=A03 files changed, 23 insertions(+), 2 deletions(-)<br>...</blockquote><di=
v><br></div>Looks good to me, thanks.<div><br></div><div>Reviewed-by: Natha=
n Scott &lt;<a href=3D"mailto:nathans@debian.org">nathans@debian.org</a>&gt=
;<br>
<br></div><div>--</div><div>Nathan=A0</div></div></div>

--e89a8ff25518a6829304bbc55b85--


--===============3057480933943910745==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3057480933943910745==--
