Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CF9D429E01
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2015 18:43:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6B172AC002
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2015 16:43:00 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	QDHpHmZVOIYtQz2y for <xfs@oss.sgi.com>;
	Mon, 06 Apr 2015 16:42:58 -0700 (PDT)
Date: Tue, 7 Apr 2015 09:42:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] libhandle: add fd_to_handle to handle.h
Message-ID: <20150406234243.GA15810@dastard>
References: <1428360181-10401-1-git-send-email-sage@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1428360181-10401-1-git-send-email-sage@redhat.com>
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
To: Sage Weil <sage@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 06, 2015 at 03:43:01PM -0700, Sage Weil wrote:
> It's on the man page but strangely missing from the header.
> 
> Signed-off-by: Sage Weil <sage@redhat.com>

It was missed when the function was merged from the Irix userspace
xfs-cmds code base back in 2005. Nobody has noticed since then, so
clearly it is a well used function. ;)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
