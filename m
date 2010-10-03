Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o936o85Z240263 for <xfs@oss.sgi.com>; Sun, 3 Oct 2010 01:50:08 -0500
Received: from casper.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8D70BBEB7
	for <xfs@oss.sgi.com>; Sat,  2 Oct 2010 23:45:51 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id 7eZM2r0VW4GAjeD9 for
	<xfs@oss.sgi.com>; Sat, 02 Oct 2010 23:45:51 -0700 (PDT)
Date: Sun, 3 Oct 2010 02:45:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_db -c frag -r /dev/sdb1 segmentation fault
Message-ID: <20101003064547.GA9071@infradead.org>
References: <AANLkTi=kzGSGtmk8a_eu5n9w6wbvt_f28Va9gSeWNgCe@mail.gmail.com>
	<20101002103902.GE4681@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101002103902.GE4681@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Robert Pipca <robertpipca@gmail.com>, xfs@oss.sgi.com

On Sat, Oct 02, 2010 at 08:39:03PM +1000, Dave Chinner wrote:
> Note that the crash could be caused by a corrupted filesystem.

Or running it on a mounted filesystem.  Robert, did you run the command
on a mounted or unmounted filesystem?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
