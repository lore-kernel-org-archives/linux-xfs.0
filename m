Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BF2FA7F37
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 07:43:34 -0500 (CDT)
Date: Wed, 28 Aug 2013 07:43:33 -0500
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: [PATCH] xfs: finish removing IOP_* macros.
Message-ID: <20130828124333.GA19452@sgi.com>
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
Cc: xfs@oss.sgi.com

On Wed, Aug 28, 2013 at 09:12:03PM +1000, Dave Chinner wrote:
| From: Dave Chinner <dchinner@redhat.com>
| 
| In optimising the CIL operations, some of the IOP_* macros for
| calling log item operations were removed. Remove the rest of them as
| Christoph requested.
| 
| Signed-off-by: Dave Chinner <dchinner@redhat.com>

I like macros, but apparently some do not.  The change looks correct.

Reviewed-by: Geoffrey Wehrman <gwehrman@sgi.com>


-- 
Geoffrey Wehrman
gwehrman@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
