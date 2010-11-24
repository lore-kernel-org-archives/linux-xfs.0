Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAO4cnxU059146 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 22:38:49 -0600
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C0791C6CD95
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 20:40:27 -0800 (PST)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id eQTgvtHk3UWviShY
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 20:40:27 -0800 (PST)
Received: by qwd7 with SMTP id 7so82248qwd.26
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 20:40:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101123132104.GA15462@infradead.org>
References: <AANLkTimNBapoCGa--2+PDME0q4nD5soLEudznHjFVB84@mail.gmail.com>
	<20101123132104.GA15462@infradead.org>
Date: Wed, 24 Nov 2010 10:10:26 +0530
Message-ID: <AANLkTindhNoY02cNJ6KixyUO8Kx-K_Wwr=E7z+oYxF_m@mail.gmail.com>
Subject: Re: 2.6.34 - XFS crash radix_tree_tag_set
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3863619056489819888=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============3863619056489819888==
Content-Type: multipart/alternative; boundary=0016361e803e9755850495c516f2

--0016361e803e9755850495c516f2
Content-Type: text/plain; charset=ISO-8859-1

We have backported complete xfs from 2.6.34 to 2.6.30.9, because there were
many fixes since 2.6.30.9
On Tue, Nov 23, 2010 at 6:51 PM, Christoph Hellwig <hch@infradead.org>wrote:

> On Tue, Nov 23, 2010 at 03:50:37PM +0530, Ajeet Yadav wrote:
> > I have the following backtrace on my ARM target, please have a look
>
> Are sure you're on 2.6.34?  Something similar was fixed by commit
> f1f724e4b523d444c5a598d74505aefa3d6844d2 in 2.6.34.
>
>

--0016361e803e9755850495c516f2
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>We have backported complete xfs from 2.6.34 to 2.6.30.9, because there=
 were many fixes since 2.6.30.9<br></div>
<div class=3D"gmail_quote">On Tue, Nov 23, 2010 at 6:51 PM, Christoph Hellw=
ig <span dir=3D"ltr">&lt;<a href=3D"mailto:hch@infradead.org">hch@infradead=
.org</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">On Tue, Nov 23, 2010 at 03:50:37PM +0530, Ajeet Yadav wro=
te:<br>&gt; I have the following backtrace on my ARM target, please have a =
look<br><br></div>Are sure you&#39;re on 2.6.34? =A0Something similar was f=
ixed by commit<br>
f1f724e4b523d444c5a598d74505aefa3d6844d2 in 2.6.34.<br><br></blockquote></d=
iv><br>

--0016361e803e9755850495c516f2--


--===============3863619056489819888==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3863619056489819888==--
