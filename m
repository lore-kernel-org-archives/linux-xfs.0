Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p57E0DPc026784 for <xfs@oss.sgi.com>; Tue, 7 Jun 2011 09:00:14 -0500
Received: from ppsw-51.csi.cam.ac.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4BB6412D1187
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2011 07:00:11 -0700 (PDT)
Received: from ppsw-51.csi.cam.ac.uk (ppsw-51.csi.cam.ac.uk [131.111.8.151])
	by cuda.sgi.com with ESMTP id hmAvPILU7T00cpM5 for
	<xfs@oss.sgi.com>; Tue, 07 Jun 2011 07:00:11 -0700 (PDT)
Received: from mail.mrc-lmb.cam.ac.uk ([131.111.85.9]:38173
	helo=mail.lmb.internal)
	by ppsw-51.csi.cam.ac.uk (ppsw.cam.ac.uk [131.111.8.138]:25)
	with esmtp id 1QTwpG-0007yN-Z4 (Exim 4.72) for xfs@oss.sgi.com
	(return-path <dhoworth@mrc-lmb.cam.ac.uk>);
	Tue, 07 Jun 2011 15:00:10 +0100
Received: from cpepc210-3.lmb.internal ([10.14.0.2])
	by mail.lmb.internal with esmtp (Exim 4.63)
	(envelope-from <dhoworth@mrc-lmb.cam.ac.uk>) id 1QTwpG-00054D-PE
	for xfs@oss.sgi.com; Tue, 07 Jun 2011 15:00:10 +0100
Message-ID: <4DEE2EEA.3080705@mrc-lmb.cam.ac.uk>
Date: Tue, 07 Jun 2011 15:00:10 +0100
From: Dave Howorth <dhoworth@mrc-lmb.cam.ac.uk>
MIME-Version: 1.0
Subject: Re: XFS: accounting of reclaimable inodes is incorrect
References: <4DEE0EA4.9090002@profihost.ag>	<20110607115441.GA4653@infradead.org>	<4DEE2078.3010102@profihost.ag>
	<20110607133429.GA9049@infradead.org>
In-Reply-To: <20110607133429.GA9049@infradead.org>
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

Christoph Hellwig wrote:
> Linux 2.6.32 isn't really something supported by us.  It's not just a
> very old codebase, but also one where a lot of the XFS code was pretty
> much in flux.  If you want supported old releases work use one of
> the commercially supported one like RedHat or SuSE.

2.6.32 is also the kernel in Ubuntu 10.04 LTS

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
