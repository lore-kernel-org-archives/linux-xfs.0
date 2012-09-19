Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8JDZZVc204527 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 08:35:35 -0500
Message-ID: <5059CA6B.8090609@sgi.com>
Date: Wed, 19 Sep 2012 08:36:43 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix a compile warning at seek_sanity_test.c
References: <4FCA2422.90804@oracle.com>
In-Reply-To: <4FCA2422.90804@oracle.com>
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
To: jeff.liu@oracle.com
Cc: xfs@oss.sgi.com

On 06/02/12 09:33, Jeff Liu wrote:
> Hello,
>
> Compiler report warning at seek_sanity_test.c:
> seek_sanity_test.c:46:3: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'int'
>
> Below patch can fix it.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>

Sorry, looks like this clean-up patch has not been committed yet.

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
