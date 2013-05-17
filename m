Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7E0117F37
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 06:53:02 -0500 (CDT)
Message-ID: <51961A3F.90301@sgi.com>
Date: Fri, 17 May 2013 06:53:35 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] xfstests: generic/235 breaks /etc/mtab symlinks breaks
	xfs/189
References: <1368062501-15046-1-git-send-email-david@fromorbit.com>
	<1368062501-15046-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1368062501-15046-4-git-send-email-david@fromorbit.com>
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

On 05/08/2013 08:21 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Serenity lost.
> Insanity looms darkly.
> /etc/mtab
>
Fair enough Dave.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

This has been committed:

commit 1bd086437fac4007610ab0d42f75ae6701f6da1a
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu May 16 06:53:05 2013 -0500

     xfstests: generic/235 breaks /etc/mtab symlinks breaks xfs/189

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
