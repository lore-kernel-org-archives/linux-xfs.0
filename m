Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o99LclPb163670 for <xfs@oss.sgi.com>; Sat, 9 Oct 2010 16:38:47 -0500
Subject: Re: [PATCH] xfstests: Fix some file permission.
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4CAE483F.1020608@sgi.com>
References: <4CAE483F.1020608@sgi.com>
Date: Sat, 09 Oct 2010 16:35:11 -0500
Message-ID: <1286660111.5392.6.camel@doink>
Mime-Version: 1.0
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
To: Alain Renaud <arenaud@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, 2010-10-07 at 17:22 -0500, Alain Renaud wrote:
> I notice that some of the test script do not have execute
> permission. To be consistent I changed the permissions to be 755.
> Can someone verify that this is valid.
> 
> Thanks.

This looks good to me but I'd like a second opinion,
to make sure there's no reason any of these should
be non-executable.

					-Alex

> Signed-off-by: Alain Renaud <arenaud@sgi.com>
> ---


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
