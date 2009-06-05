Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n55BL1AR042123
	for <linux-xfs@oss.sgi.com>; Fri, 5 Jun 2009 06:21:02 -0500
Received: from foehn.mgras.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0CA052D4F04
	for <linux-xfs@oss.sgi.com>; Fri,  5 Jun 2009 04:21:18 -0700 (PDT)
Received: from foehn.mgras.de (quickstep.mgras.net [213.146.115.59]) by
	cuda.sgi.com with ESMTP id BO7ow7yF5TirnXlz for
	<linux-xfs@oss.sgi.com>; Fri, 05 Jun 2009 04:21:18 -0700 (PDT)
Received: from osprey.mgras.de (osprey.mgras.de [192.168.48.3])
	by foehn.mgras.de (8.13.1/8.13.0) with ESMTP id n55BKTtJ017338
	for <linux-xfs@oss.sgi.com>; Fri, 5 Jun 2009 13:20:30 +0200 (CEST)
Received: (from news@localhost) by osprey.mgras.de (AIX5.1/8.11.6p2/8.11.0) id
	n55BKTe25990 for linux-xfs@oss.sgi.com;
	Fri, 5 Jun 2009 13:20:29 +0200
From: Martin Spott <Martin.Spott@mgras.net>
Subject: Re: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Date: Fri, 5 Jun 2009 11:20:28 +0000 (UTC)
Message-ID: <h0av1s$ts8$1@osprey.mgras.de>
References: <20090520003745.GA27491@samad.com.au>
	<20090604112657.GA10738@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Hi Christoph,

Christoph Hellwig wrote:

> Sorry guys, still haven't been able to track it down.  Any chance one
> of you could run with CONFIG_XFS_DEBUG enabled and see if it trips
> over any of the asserts?

I'm running these systems as application servers for schools - with
diskless clients. Therefore it's highly impractical to to any debugging
during the week (they're going to kill me  ;-) , but I'll try to so
over the weekend.

Cheers,
	Martin.
-- 
 Unix _IS_ user friendly - it's just selective about who its friends are !
--------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
