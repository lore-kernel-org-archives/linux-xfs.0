Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8B5AE29E0E
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 14:01:47 -0500 (CDT)
Message-ID: <51FAB09A.1090201@sgi.com>
Date: Thu, 01 Aug 2013 14:01:46 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02/49] xfsprogs: port inode create transaction changes
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-3-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/19/13 01:44, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Bring across the relevant parts of the new inode create transaction
> sufficient to keep kernel/user code in sync and implement the
> infrastructure needed to make it work in xfsprogs.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

parts of kernel commits 28c8e41a, ddf6ad01, b8402b47?, and b8402b47.

No illusion to really verifying this patch and just signing off on it.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
