Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o12LiGZo193832 for <xfs@oss.sgi.com>; Tue, 2 Feb 2010 15:44:16 -0600
Received: from mail-fx0-f211.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0BC11C9ADFB
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2010 13:45:23 -0800 (PST)
Received: from mail-fx0-f211.google.com (mail-fx0-f211.google.com
	[209.85.220.211]) by cuda.sgi.com with ESMTP id
	jXaVeH2vAm5xDHr3 for <xfs@oss.sgi.com>;
	Tue, 02 Feb 2010 13:45:23 -0800 (PST)
Received: by fxm3 with SMTP id 3so612129fxm.19
	for <xfs@oss.sgi.com>; Tue, 02 Feb 2010 13:45:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100202194208.GD5733@kernel.dk>
References: <201002020255.46920.edward.shishkin@gmail.com>
	<20100202081728.GA2384@infradead.org> <4B6843E9.9070600@gmail.com>
	<20100202194208.GD5733@kernel.dk>
Date: Wed, 3 Feb 2010 01:45:22 +0400
Message-ID: <5e2ec5ac1002021345g569c743dtc5ccf77cde6738ae@mail.gmail.com>
Subject: Re: [patch 0/7] per-bdi flushing model improvements. reiser4
From: Ronni Holm-Nielsen <theronni@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1436066448414146491=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: ReiserFS Development List <reiserfs-devel@vger.kernel.org>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, Edward Shishkin <edward.shishkin@gmail.com>

--===============1436066448414146491==
Content-Type: multipart/alternative; boundary=000e0ce0f19ad27bf7047ea504db

--000e0ce0f19ad27bf7047ea504db
Content-Type: text/plain; charset=UTF-8

To clarify (being a ReiserFS subscriber):

patch 0, 4-6 sent to Andrew, ReiserFS, linux-fsdevel, linux-kernel, xfs,
jens.axboe
patch 1-3, 7 sent to Andrew, ReiserFS

- Ronni

On Tue, Feb 2, 2010 at 11:42 PM, Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, Feb 02 2010, Edward Shishkin wrote:
> > Christoph Hellwig wrote:
> >> I got this introduction twice, but patches 1-3 didn't make it to any of
> >> the lists.
> >>
> >>
> >>
> > done
>
> Where?
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe reiserfs-devel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Venlig hilsen
Ronni

--000e0ce0f19ad27bf7047ea504db
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div>To clarify (being a ReiserFS subscriber):</div><div><br></div>patch 0,=
 4-6 sent to=C2=A0Andrew, ReiserFS, linux-fsdevel, linux-kernel, xfs, jens.=
axboe<div>patch 1-3, 7 sent to=C2=A0Andrew, ReiserFS</div><div><br></div><d=
iv>- Ronni<br>
<br><div class=3D"gmail_quote">On Tue, Feb 2, 2010 at 11:42 PM, Jens Axboe =
<span dir=3D"ltr">&lt;<a href=3D"mailto:jens.axboe@oracle.com">jens.axboe@o=
racle.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
<div class=3D"im">On Tue, Feb 02 2010, Edward Shishkin wrote:<br>
&gt; Christoph Hellwig wrote:<br>
&gt;&gt; I got this introduction twice, but patches 1-3 didn&#39;t make it =
to any of<br>
&gt;&gt; the lists.<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt; done<br>
<br>
</div>Where?<br>
<br>
--<br>
<font color=3D"#888888">Jens Axboe<br>
</font><div><div></div><div class=3D"h5"><br>
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe reiserfs-dev=
el&quot; in<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org">major=
domo@vger.kernel.org</a><br>
More majordomo info at =C2=A0<a href=3D"http://vger.kernel.org/majordomo-in=
fo.html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a><b=
r>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br>Venlig hils=
en<br>Ronni<br>
</div>

--000e0ce0f19ad27bf7047ea504db--


--===============1436066448414146491==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1436066448414146491==--
