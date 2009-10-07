Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n97E3C0v192824 for <xfs@oss.sgi.com>; Wed, 7 Oct 2009 09:03:13 -0500
Received: from zen.pimp.org.za (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCBB14AAF6A
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2009 07:04:38 -0700 (PDT)
Received: from zen.pimp.org.za (zen.pimp.org.za [70.85.31.111]) by
	cuda.sgi.com with ESMTP id syg19UGTGWYkaxR5 for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2009 07:04:38 -0700 (PDT)
Date: Wed, 7 Oct 2009 15:04:31 +0100
From: Michael-John Turner <mj@mjturner.net>
Subject: Re: XFS/driver bug or bad drive?
Message-ID: <20091007140431.GB29528@aurora.pimp.org.za>
References: <20091001232759.GA12832@opus.istwok.net>
	<4AC54BDA.20806@sandeen.net>
	<20091002165704.GA17558@opus.istwok.net>
	<20091007112959.GA17132@aurora.pimp.org.za>
	<4ACC9699.70900@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ACC9699.70900@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Engel <david@istwok.net>, xfs@oss.sgi.com

On Wed, Oct 07, 2009 at 08:24:41AM -0500, Eric Sandeen wrote:
> Firmware bug?  I still think it can't be an xfs problem, and I'm not
> just trying to be protective of our turf ;)

Could very well be a firmware bug - FWIW, my drive has version 1AA01109.

Some searching online suggests that others have solved similar problems by
replacing their SATA cables. I'll give that a try but, as my issue isn't
reproducible (subsequent cvs updates haven't given any problems), it'll be
difficult to know immediately if a faulty cable was the problem.

-mj
-- 
 Michael-John Turner
 mj@mjturner.net      <>     http://mjturner.net/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
