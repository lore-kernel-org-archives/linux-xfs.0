Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n97FIkVU197443 for <xfs@oss.sgi.com>; Wed, 7 Oct 2009 10:18:46 -0500
Received: from cdptpa-omtalb.mail.rr.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE3851751545
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2009 08:20:12 -0700 (PDT)
Received: from cdptpa-omtalb.mail.rr.com (cdptpa-omtalb.mail.rr.com
	[75.180.132.122]) by cuda.sgi.com with ESMTP id
	umk68YrrWL6RcQpn for <xfs@oss.sgi.com>;
	Wed, 07 Oct 2009 08:20:12 -0700 (PDT)
Date: Wed, 7 Oct 2009 10:20:11 -0500
From: David Engel <david@istwok.net>
Subject: Re: XFS/driver bug or bad drive?
Message-ID: <20091007152011.GA19915@opus.istwok.net>
References: <20091001232759.GA12832@opus.istwok.net>
	<4AC54BDA.20806@sandeen.net>
	<20091002165704.GA17558@opus.istwok.net>
	<20091007112959.GA17132@aurora.pimp.org.za>
	<4ACC9699.70900@sandeen.net>
	<20091007140431.GB29528@aurora.pimp.org.za>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091007140431.GB29528@aurora.pimp.org.za>
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
To: Michael-John Turner <mj@mjturner.net>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Oct 07, 2009 at 03:04:31PM +0100, Michael-John Turner wrote:
> On Wed, Oct 07, 2009 at 08:24:41AM -0500, Eric Sandeen wrote:
> > Firmware bug?  I still think it can't be an xfs problem, and I'm not
> > just trying to be protective of our turf ;)
> 
> Could very well be a firmware bug - FWIW, my drive has version 1AA01109.

A firmware bug wouldn't surprise me.  FWIW, here are my firmware
versions and latest information.

The problematic drive has firmware version 1AA01110.  I don't trust
that specific drive, don't really trust that model anymore, so I
retired it and bought a new drive to replace it.

The other HD753LJ I have (also replacement) has firmware version
1AA01110 too.  This drive hasn't shown any problems yet, but I will be
testing it more after I finish moving some files around.

> Some searching online suggests that others have solved similar problems by
> replacing their SATA cables. I'll give that a try but, as my issue isn't
> reproducible (subsequent cvs updates haven't given any problems), it'll be
> difficult to know immediately if a faulty cable was the problem.

I probably ran across all of the same stuff.  I tried multiple cables,
multiple SATA ports and multiple host systems.  The problem was nearly
100% on the intended system.  I don't know how frequent the problem
was on the second system since I stopped testing on it after the first
failure confirmed the problem was not specific to the original system.

David
-- 
David Engel
david@istwok.net

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
