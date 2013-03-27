Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 281847F50
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 16:48:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E7449304090
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 14:48:08 -0700 (PDT)
Date: Wed, 27 Mar 2013 17:48:04 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Announce re-factor all current xfstests patches request
Message-ID: <20130327214804.GA28143@thunk.org>
References: <5152F2BB.4000709@sgi.com> <20130327134606.GJ5861@thunk.org>
	<20130327205407.GU6369@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130327205407.GU6369@dastard>
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
Cc: linux-ext4@vger.kernel.org, Rich Johnston <rjohnston@sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Thu, Mar 28, 2013 at 07:54:07AM +1100, Dave Chinner wrote:
> 
> Support for named tests have not yet been added. From the check
> script:
> 
> SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"

Ah, I thought support for named tests was there.  For right now,
though, if we have test ext4/123 and btrfs/123, that's OK and they are
considered separate tests, right?  Or do we still need to keep the
numbers unique for now?

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
