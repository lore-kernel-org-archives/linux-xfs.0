Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16LlglV167712 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 15:47:42 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uHQ83UHBhvgMThuq for
	<xfs@oss.sgi.com>; Mon, 06 Feb 2012 13:47:41 -0800 (PST)
Message-ID: <4F304A79.8050004@redhat.com>
Date: Mon, 06 Feb 2012 15:47:37 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
References: <4F2D8F30.3090802@redhat.com> <20120206214132.GA22019@thunk.org>
In-Reply-To: <20120206214132.GA22019@thunk.org>
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
To: Ted Ts'o <tytso@mit.edu>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 2/6/12 3:41 PM, Ted Ts'o wrote:
> Cool!  I assume you're going to try to get this into util-linux-ng?
> 
> I'm tempted to drop it in e2fsprogs's contrib directxory for now, but
> I think the best home for it is util-linux-ng.
> 
> 							- Ted

Yep, I will do that, though it could use a fair bit of cleanup first.
kzak seemed amenable to taking it in.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
