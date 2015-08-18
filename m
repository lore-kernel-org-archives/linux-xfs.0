Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 15CCE7F50
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 01:49:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EC415304043
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 23:49:47 -0700 (PDT)
Received: from mail-io0-f174.google.com (mail-io0-f174.google.com
	[209.85.223.174]) by cuda.sgi.com with ESMTP id
	yruyFx8sybDYOO5t (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 23:49:43 -0700 (PDT)
Received: by iodb91 with SMTP id b91so177778927iod.1
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 23:49:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150817192300.GC26222@infradead.org>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-3-git-send-email-jtulak@redhat.com>
	<20150817192300.GC26222@infradead.org>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 18 Aug 2015 08:49:23 +0200
Message-ID: <CACj3i71vOZXx4AR0s5r0Riesm=L3-UMSXh2HQmej5sTp+DO7zw@mail.gmail.com>
Subject: Re: [PATCH 02/11] xfsprogs: Add ifdef dirent checks where it was
	missing
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6848378391472264599=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============6848378391472264599==
Content-Type: multipart/alternative; boundary=001a1140f3a6a899fb051d905288

--001a1140f3a6a899fb051d905288
Content-Type: text/plain; charset=UTF-8

On Mon, Aug 17, 2015 at 9:23 PM, Christoph Hellwig <hch@infradead.org>
wrote:
>
> Looks fine,
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>

Thanks.


>
> (and didn't I review this one previously?)
>

I think not this last iteration, with the d_reclen approximation. Or at
least I didn't get any reply to that.

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

--001a1140f3a6a899fb051d905288
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Mon, Aug 17, 2015 at 9:23 PM, Christoph Hellwig <span dir=3D"ltr">&l=
t;<a href=3D"mailto:hch@infradead.org" target=3D"_blank">hch@infradead.org<=
/a>&gt;</span> wrote:<blockquote class=3D"gmail_quote" style=3D"margin:0 0 =
0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Looks fine,<br>
<br>
Reviewed-by: Christoph Hellwig &lt;<a href=3D"mailto:hch@lst.de" target=3D"=
_blank">hch@lst.de</a>&gt;<br></blockquote><div><br></div><div>Thanks.</div=
><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .=
8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
(and didn&#39;t I review this one previously?)<br>
</blockquote></div><div class=3D"gmail_extra"><br></div>I think not this la=
st iteration, with the=C2=A0<span style=3D"background-color:rgb(255,255,255=
)">d_reclen approximation. Or at least I didn&#39;t get any reply to that.<=
/span></div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra"=
>Cheers,</div><div class=3D"gmail_extra">Jan<br clear=3D"all"><div><br></di=
v>-- <br><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jt=
ulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a><br></div></div>
</div></div>

--001a1140f3a6a899fb051d905288--


--===============6848378391472264599==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6848378391472264599==--
