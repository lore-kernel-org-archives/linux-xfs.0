Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E4F457F3F
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 08:20:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B2F958F804B
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 06:20:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ECkyLvqvbn4SNQu4 for <xfs@oss.sgi.com>;
	Mon, 18 Aug 2014 06:20:39 -0700 (PDT)
Date: Mon, 18 Aug 2014 23:20:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFD]: Help in setting up XFS
Message-ID: <20140818132026.GO20518@dastard>
References: <BLU181-W3698AB216D54D0CCE5A9739CD40@phx.gbl>
	<20140818070312.GM20518@dastard>
	<BLU181-W782ECB29BAB77090E0292A9CD40@phx.gbl>
	<alpine.LSU.2.11.1408181223400.5417@Telcontar.valinor>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1408181223400.5417@Telcontar.valinor>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Mon, Aug 18, 2014 at 12:25:57PM +0200, Carlos E. R. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> =

> Content-ID: <alpine.LSU.2.11.1408181224240.5417@Telcontar.valinor>
> =

> =

> On Monday, 2014-08-18 at 15:00 +0530, Prithvi Rathore wrote:
> =

> >About the part where you say mount it properly, I just wanted to check i=
f this is correct.
> >
> >1)Create a mount point.
> >=A0 =A0 $ mkdir /mnt/dat1
> =

> Just plug in the stick and click on the icon to mount it. No
> different than any other filesystem.

That doesn't work for machines with no desktop or ones that you
access via ssh. Learn the command line first then you can always get
the machine to do what you want regardless of how you need to access
it. Indeed, typing commands is often faster than using the mouse,
especially if you know how to use command history search
effectively...

> If it doesn't work, just ask on the help forum or mail lists of your
> distribution.

That's just wrong. If you've got an XFS problem or question, then
this mailing list is exactly the right place to be asking for help.

Cheers,

Dave.

-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
