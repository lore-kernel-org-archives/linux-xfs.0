Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3MLjNPM226006 for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 16:45:24 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2BBF232879
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 14:45:19 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id kDz8CIGhseAzxyUX for
	<xfs@oss.sgi.com>; Wed, 22 Apr 2009 14:45:19 -0700 (PDT)
Subject: Re: fsck.xfs proposed improvements
From: Andi Kleen <andi@firstfloor.org>
References: <mailman.0.1240318659.128675.xfs@oss.sgi.com>
	<20090421142333.GA5197@fysh.org> <49EE441E.6040606@thebarn.com>
	<20090422094527.GA16600@fysh.org>
Date: Wed, 22 Apr 2009 23:45:11 +0200
In-Reply-To: <20090422094527.GA16600@fysh.org> (Mike Ashton's message of "Wed,
	22 Apr 2009 10:45:27 +0100")
Message-ID: <87ws9cnz14.fsf@basil.nowhere.org>
MIME-Version: 1.0
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
To: Mike Ashton <mike@fysh.org>
Cc: xfs@oss.sgi.com

Mike Ashton <mike@fysh.org> writes:

> With badly behaved hardware,
> which seem prevalent, or any bugs which do get into xfs we could
> actually end up with xfs being less fault tolerant and less reliable
> in general use than other filesystems, which would be a bit of a
> shame.

Most Linux file systems are not very fault tolerant in this sense;
e.g. on ext3 you have have to press return and accept lots of scary
messages to get through fsck.

-Andi
 

-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
