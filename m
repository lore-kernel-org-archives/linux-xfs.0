Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q468lxe7163841 for <xfs@oss.sgi.com>; Sun, 6 May 2012 03:47:59 -0500
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id nE4lHVO0JIEpqLBT for
	<xfs@oss.sgi.com>; Sun, 06 May 2012 01:47:58 -0700 (PDT)
Date: Sun, 6 May 2012 08:47:55 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Storage server, hung tasks and tracebacks
Message-ID: <20120506084755.GC7633@nsrc.org>
References: <20120502184450.GA2557@nsrc.org>
	<4FA27EF8.6040002@hardwarefreak.com> <20120503204157.GC4387@nsrc.org>
	<4FA3047D.8060908@hardwarefreak.com> <20120504163237.GA6128@nsrc.org>
	<4FA4C321.2070105@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FA4C321.2070105@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Sat, May 05, 2012 at 01:05:21AM -0500, Stan Hoeppner wrote:
> Did I already mention checking the AC lines feeding these 3 boxes?
> Assuming they're on UPS are the boost/buck features working properly?
> Is your area known for fantastic clean power or dirty power with lots of
> sags?  That's the first thing I'd suspect with 3 new machines all
> behaving this way.

We thought that too. These boxes are installed in a data centre; however we
just took power to a new rack and these three machines are installed in
there, so it's not impossible there's a problem with the feed to that rack.

We did have some machines on the A and B PDUs in this rack, but we may also
try powering one from an adjacent rack.

Many thanks for your helpful suggestions, and we are working through this
with the equipment supplier (who is extraordinarily helpful and
knowledgeable and as keen to get to the bottom of this as we are). I'll
certainly let you know when we have a resolution.

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
