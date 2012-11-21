Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qALEuIqf058458 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 08:56:18 -0600
Message-ID: <50ACEC27.6020204@sgi.com>
Date: Wed, 21 Nov 2012 08:58:47 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] xfstests: remove unused code and resolve warnings
References: <20121109132358.256359544@sgi.com>
In-Reply-To: <20121109132358.256359544@sgi.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Mark Tinguely <tinguely@sgi.com>

On 11/09/2012 07:23 AM, rjohnston@sgi.com wrote:
> This patchset:
>     1. Removes the unsupported sgi and CRAY conditionals
>     2. Removes the unused conditional NO_XFS
>     3. Resolves compiler/configure warnings
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

Christoph and Mark thanks for the review. This series has been committed 
to git://oss.sgi.com/xfs/cmds/xfstests master branch, commit 062f9b, 
a07ce0, and 2924ad.


--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
