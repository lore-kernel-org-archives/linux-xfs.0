Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BDD447F56
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 15:10:32 -0500 (CDT)
Date: Fri, 30 Aug 2013 15:10:32 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: finish removing IOP_* macros.
Message-ID: <20130830201032.GJ1935@sgi.com>
References: <1377688323-6404-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1377688323-6404-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: tinguely@sgi.com, xfs@oss.sgi.com

On Wed, Aug 28, 2013 at 09:12:03PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In optimising the CIL operations, some of the IOP_* macros for
> calling log item operations were removed. Remove the rest of them as
> Christoph requested.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
