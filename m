Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKJ3fn6204773 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 13:03:42 -0600
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v1 0/9] fs: fix up AIO+DIO+O_SYNC to actually do the sync
	part
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<x49pq38jquh.fsf@segfault.boston.devel.redhat.com>
	<20121120185700.GD8740@blackbox.djwong.org>
Date: Tue, 20 Nov 2012 14:05:40 -0500
In-Reply-To: <20121120185700.GD8740@blackbox.djwong.org> (Darrick J. Wong's
	message of "Tue, 20 Nov 2012 10:57:00 -0800")
Message-ID: <x494nkkjdrv.fsf@segfault.boston.devel.redhat.com>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: axboe@kernel.dk, tytso@mit.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, bpm@sgi.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org

"Darrick J. Wong" <darrick.wong@oracle.com> writes:

>> Would you like to push the set in, or should I post the patches I've
>> got?  Doesn't matter to me, just let me know.
>
> Since you're the original author of most of the patches in my set anyway, would
> you mind simply picking up my blockdev patch for your next submission?  It
> sounds like you're a little further along in the testing than I am anyway.

Not at all.  I'll address the comments so far and get another version
out tomorrow.

Cheers,
Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
