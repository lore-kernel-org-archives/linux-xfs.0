Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 24A4A7F4E
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 16:09:57 -0500 (CDT)
Received: from whiskey.americas.sgi.com (whiskey.americas.sgi.com
	[128.162.233.19])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B5526AC004
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 14:09:53 -0700 (PDT)
Date: Thu, 15 Aug 2013 16:09:53 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [XFS updates] XFS development tree branch, master, updated.
	for-linus-v3.11-rc1-2-12170-g4bb928c
Message-ID: <20130815210953.GM12719@sgi.com>
References: <20130815210702.B057E7F37@oss.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130815210702.B057E7F37@oss.sgi.com>
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
To: xfs@oss.sgi.com

On Thu, Aug 15, 2013 at 04:07:01PM -0500, xfs@oss.sgi.com wrote:
> This is an automated email from the git hooks/post-receive script. It was
> generated because a ref change was pushed to the repository containing
> the project "XFS development tree".
> 
> The branch, master has been updated
>   4bb928c xfs: split the CIL lock
>   991aaf6 xfs: Combine CIL insert and prepare passes
>   f5baac3 xfs: avoid CIL allocation during insert
>   7492c5b xfs: Reduce allocations during CIL insertion
>   166d136 xfs: return log item size in IOP_SIZE
>   050a195 xfs:free bp in xlog_find_tail() error path
>   5d0a654 xfs: free bp in xlog_find_zeroed() error path
>   6dd93e9 xfs: avoid double-free in xfs_attr_node_addname
>       from  2c2bcc0735f4ab052559b539f3fcab4087187232 (commit)

Bah.  Apparently I lied on the call when I said these are applied.  Looks like
I committed them Tuesday but forgot to push.  Sorry for the confusion.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
