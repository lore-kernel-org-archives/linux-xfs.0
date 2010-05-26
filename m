Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4QJtLsZ092600 for <xfs@oss.sgi.com>; Wed, 26 May 2010 14:55:22 -0500
Received: from smtp.sauce.co.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F78A143F9EC
	for <xfs@oss.sgi.com>; Wed, 26 May 2010 12:57:42 -0700 (PDT)
Received: from smtp.sauce.co.nz (smtp.sauce.co.nz [210.48.49.72]) by
	cuda.sgi.com with ESMTP id kDRJYZGvSBxVZc6V for
	<xfs@oss.sgi.com>; Wed, 26 May 2010 12:57:42 -0700 (PDT)
Message-ID: <4BFD7D34.9060006@sauce.co.nz>
Date: Thu, 27 May 2010 07:57:40 +1200
From: Richard Scobie <richard@sauce.co.nz>
MIME-Version: 1.0
Subject: Re: xfsdump -- not enough memory to dump attributes? w/>20G free
 --
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Linda A. Walsh wrote:

BTW -- how do you tell the version of the xfs progs from
the individual progs -- I'm going from the installed rpm
name, but if I build from the git, that won't be helpful.
I don't see a VERSION command in xfsdump/restore?



Hi Linda,

xfsdump with no arguments shows the version:

[rs@sam ~]$ xfsdump
xfsdump: version 3.0.1 (dump format 3.0)
xfsdump: usage: xfsdump [ -a (dump DMF dualstate files as offline) ]
                         [ -b <blocksize> ]
....


Regards,

Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
