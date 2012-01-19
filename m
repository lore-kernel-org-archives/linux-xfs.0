Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0JInWND033488 for <xfs@oss.sgi.com>; Thu, 19 Jan 2012 12:49:32 -0600
Received: from mail.jdlawrie.co.uk (jdlawrie.co.uk [67.207.135.72]) by
	cuda.sgi.com with ESMTP id HdaiSKzhmSnEUC9w for
	<xfs@oss.sgi.com>; Thu, 19 Jan 2012 10:49:31 -0800 (PST)
Received: from desk1.tur.bytemark.co.uk (desk1.tur.bytemark.co.uk
	[212.110.163.132])
	by mail.jdlawrie.co.uk (Postfix) with ESMTP id DA18B34163
	for <xfs@oss.sgi.com>; Thu, 19 Jan 2012 13:49:30 -0500 (EST)
Message-ID: <4F1865B9.3050908@jdlawrie.co.uk>
Date: Thu, 19 Jan 2012 18:49:29 +0000
From: James Lawrie <james@jdlawrie.co.uk>
MIME-Version: 1.0
Subject: Re: Trouble activating xfs pquotas
References: <4F170A53.9070202@jdlawrie.co.uk> <4F1862D0.1060708@sandeen.net>
In-Reply-To: <4F1862D0.1060708@sandeen.net>
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
To: xfs@oss.sgi.com

Hi,

> Based on IRC conversations, the fs was never(?) properly mounted with quota in the first place; an actual remount w/ quota forced by a reboot seems to have resolved this.

That's right, thanks for updating the list for me. The fs did originally
have quotas enabled, but lost them at some point. My attempts to umount
must not have been clean enough.

Thanks for the help.

James	

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
