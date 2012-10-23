Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9NJ8TxN097517 for <xfs@oss.sgi.com>; Tue, 23 Oct 2012 14:08:29 -0500
Date: Tue, 23 Oct 2012 14:10:10 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v5 00/10] speculative preallocation inode tracking
Message-ID: <20121023191010.GO1377@sgi.com>
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

Hey Brian,

On Fri, Oct 05, 2012 at 10:17:06AM -0400, Brian Foster wrote:
> This is v3 of the speculative preallocation inode tracking patchset.

I was going to pull this in based upon Mark's review, but it looks like Dave
still has some questions related to patches 5, 8, and 10.  If you can address
those items we can proceed.  I think at this point there is not a need to
repost the entire series... just keep any updates in this thread.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
