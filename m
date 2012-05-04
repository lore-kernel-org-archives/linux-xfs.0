Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q44FtWKT052228 for <xfs@oss.sgi.com>; Fri, 4 May 2012 10:55:33 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id CRasshnpHMZyUBLb for <xfs@oss.sgi.com>;
	Fri, 04 May 2012 08:55:31 -0700 (PDT)
Message-ID: <4FA3FBF2.1030508@sandeen.net>
Date: Fri, 04 May 2012 10:55:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: corrupt dinode 4345, extent total = 1, nblocks = 0.  This is
	a bug.
References: <zarafa.4fa3b8af.2072.03b91b1f6d9ca76b@Solaris>
In-Reply-To: <zarafa.4fa3b8af.2072.03b91b1f6d9ca76b@Solaris>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dr Peter A Barlow <peter@redcliffmicro.co.uk>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 5/4/12 6:08 AM, Dr Peter A Barlow wrote:
> Hello,
> =

>  =

> =

> I=92ve received the following error..
> =

>  =

> =

> /corrupt dinode 4345, extent total =3D 1, nblocks =3D 0.  This is a bug./
> =

> /Please capture the filesystem metadata with xfs_metadump and/
> =

> /report it to xfs@oss.sgi.com./
> =

> /cache_node_purge: refcount was 1, not zero (node=3D0x7f80593d8fc0)/
> =

> / /
> =

> /fatal error -- 117 - couldn't iget disconnected inode/
> =


First of all, are you using the latest xfsprogs?

> the zipped metadata is 60MB so emailing it is not feasible.

Is posting it somewhere feasible?

I'll contact you offlist with another idea.

-Eric

> Please advise as I am  desperate to recover my data.
> =

>  =

> =

> Many thanks,
> =

>  =

> =

> Peter.
> =

>  =

> =

> =

> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
