Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D316529DFA
	for <xfs@oss.sgi.com>; Wed, 24 Apr 2013 10:00:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7D40DAC006
	for <xfs@oss.sgi.com>; Wed, 24 Apr 2013 08:00:46 -0700 (PDT)
Received: from mail-oa0-f47.google.com (mail-oa0-f47.google.com
	[209.85.219.47]) by cuda.sgi.com with ESMTP id EyE6tOS1AVRK75up
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 24 Apr 2013 08:00:45 -0700 (PDT)
Received: by mail-oa0-f47.google.com with SMTP id n9so1801965oag.34
	for <xfs@oss.sgi.com>; Wed, 24 Apr 2013 08:00:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5177B899.4000707@dermichi.com>
References: <5177B899.4000707@dermichi.com>
From: James Braid <jamesb@loreland.org>
Date: Wed, 24 Apr 2013 16:00:24 +0100
Message-ID: <CANXjJiac95ud6rYpRCvtMLQv6kTHFHNd0U1rzes3NVtQA=J8ZA@mail.gmail.com>
Subject: Re: XFS Support in RHEL Server 6.4 x86_64
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0369051161679491375=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Michael Weissenbacher <mw@dermichi.com>
Cc: xfs@oss.sgi.com

--===============0369051161679491375==
Content-Type: multipart/alternative; boundary=089e0149c500fa207004db1c904d

--089e0149c500fa207004db1c904d
Content-Type: text/plain; charset=ISO-8859-1

On 24 April 2013 11:48, Michael Weissenbacher <mw@dermichi.com> wrote:

> But the big question now is: can anybody actually recommend using XFS on
> stock RHEL? It does feel like being just a stepchild there. On the other
> hand there seem be be quite a number of patches that were backported for
> Red Hat's kernel and it does use delaylog by default (which IIRC wasn't
> the default with a stock 2.6.32 Kernel).
>

It's an addon product and not supported as a root filesystem on RHEL 6:

http://www.redhat.com/products/enterprise-linux-add-ons/file-systems/

A number of the XFS developers are employed by Red Hat...

--089e0149c500fa207004db1c904d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">=
On 24 April 2013 11:48, Michael Weissenbacher <span dir=3D"ltr">&lt;<a href=
=3D"mailto:mw@dermichi.com" target=3D"_blank">mw@dermichi.com</a>&gt;</span=
> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex"><div id=3D":1ge">But the big question now is: can anybody =
actually recommend using XFS on<br>


stock RHEL? It does feel like being just a stepchild there. On the other<br=
>
hand there seem be be quite a number of patches that were backported for<br=
>
Red Hat&#39;s kernel and it does use delaylog by default (which IIRC wasn&#=
39;t<br>
the default with a stock 2.6.32 Kernel).<br></div></blockquote></div><br>It=
&#39;s an addon product and not supported as a root filesystem on RHEL 6:</=
div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra"><a href=
=3D"http://www.redhat.com/products/enterprise-linux-add-ons/file-systems/">=
http://www.redhat.com/products/enterprise-linux-add-ons/file-systems/</a><b=
r>

</div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">A num=
ber of the XFS developers are employed by Red Hat...=A0<br></div><div class=
=3D"gmail_extra"><br></div></div>

--089e0149c500fa207004db1c904d--


--===============0369051161679491375==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0369051161679491375==--
