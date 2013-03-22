Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 054687F52
	for <xfs@oss.sgi.com>; Fri, 22 Mar 2013 18:17:08 -0500 (CDT)
Date: Fri, 22 Mar 2013 18:17:04 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v5 0/6] speculative preallocation quota throttling
Message-ID: <20130322231704.GQ22182@sgi.com>
References: <1363618308-53594-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363618308-53594-1-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

Brian,

On Mon, Mar 18, 2013 at 10:51:42AM -0400, Brian Foster wrote:
> Here is v5 of speculative prealloc. quota throttling. Sorry for the delay. This
> is mostly a rebase. I'm running some quick xfstests tests since we've moved onto
> 3.9-rc1 now, but the only real merge conflict was inheritance of the infinite
> loop alloc_blocks fix. Otherwise, this just includes some extra fixups to remove
> dependence on typedef's of various functions we happen to modify.

Applied this series.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
