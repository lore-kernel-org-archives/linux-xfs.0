Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3SHQ8Ud014131 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 12:26:08 -0500
Subject: Re: [PATCH] xfstests: coalesce contiguous extents in extent map output
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110428020846.GM12436@dastard>
References: <dd1c0747731332fed9637bc01d6c6de369a7fe6f.1303412098.git.aelder@sgi.com>
	<20110428020846.GM12436@dastard>
Date: Thu, 28 Apr 2011 12:29:38 -0500
Message-ID: <1304011778.5521.20.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: xfs@oss.sgi.com

On Thu, 2011-04-28 at 12:08 +1000, Dave Chinner wrote:
> Looks sane. Does Josef's new test need the same golden output
> treatment? 

My changes are applied on top of Josef's, so it addresses both.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
