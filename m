Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9IFwpq7199413 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 10:58:51 -0500
Received: from ppsw-51.csi.cam.ac.uk (ppsw-51.csi.cam.ac.uk [131.111.8.151])
	by cuda.sgi.com with ESMTP id K2exAFJELJ4NarpQ for
	<xfs@oss.sgi.com>; Thu, 18 Oct 2012 09:00:29 -0700 (PDT)
Received: from mail.mrc-lmb.cam.ac.uk ([131.111.85.9]:58456
	helo=mail.lmb.internal)
	by ppsw-51.csi.cam.ac.uk (ppsw.cam.ac.uk [131.111.8.138]:25)
	with esmtp id 1TOsWL-00057n-Wn (Exim 4.72) for xfs@oss.sgi.com
	(return-path <dhoworth@mrc-lmb.cam.ac.uk>);
	Thu, 18 Oct 2012 17:00:29 +0100
Received: from cpepc210-3.lmb.internal ([10.14.0.2])
	by mail.lmb.internal with esmtp (Exim 4.63)
	(envelope-from <dhoworth@mrc-lmb.cam.ac.uk>) id 1TOsWL-00070j-1Z
	for xfs@oss.sgi.com; Thu, 18 Oct 2012 17:00:29 +0100
Message-ID: <5080279C.8030702@mrc-lmb.cam.ac.uk>
Date: Thu, 18 Oct 2012 17:00:28 +0100
From: Dave Howorth <dhoworth@mrc-lmb.cam.ac.uk>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Update mount options documentation
References: <1350574138-30305-1-git-send-email-cmaiolino@redhat.com>
	<5080253A.9060906@sgi.com>
In-Reply-To: <5080253A.9060906@sgi.com>
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

Mark Tinguely wrote:
> Would "Indicates that XFS is allowed to create inodes at locations up to
> 32 bits of significance .."

I prefer the original wording. Your suggestion says something about what
XFS can do, but nothing about what it is not allowed to do, which is
rather more important.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
