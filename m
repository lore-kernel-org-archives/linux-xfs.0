Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92LRjRg087991 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 16:27:45 -0500
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id Y3VzD4tKgMJvAprw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Oct 2012 14:29:09 -0700 (PDT)
Message-ID: <506B5CA0.7050306@tlinx.org>
Date: Tue, 02 Oct 2012 14:29:04 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: Why xfs_<utils> not 'readline' w/line-edit & history enabled?
References: <506B1A03.7030600@tlinx.org> <20121002201748.GQ23520@dastard>
In-Reply-To: <20121002201748.GQ23520@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>



Dave Chinner wrote:
> $ sudo xfs_db -r /dev/vdb
> xfs_db> inode 128
> (reverse-i-search)`in': inode 128
----
Um...When I press up-arrow, I get nothing.

When I press down arrow -- also nothing.

Try hitting home for beginning of line --
nothing.   Tried ESC to re-edit line -- nothing. (enters ^[).

What are you typing to get the above?  does it require a config somewhere?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
