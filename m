Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E558A7F4E
	for <xfs@oss.sgi.com>; Sun,  4 Aug 2013 18:37:13 -0500 (CDT)
Message-ID: <51FEE5A6.6030908@sgi.com>
Date: Sun, 04 Aug 2013 18:37:10 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 18/49] xfs: split out buf log item format definitions
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-19-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-19-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:44, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

sync the new user/kernel xfs_buf_log_item to 03/49 of the for Linux 3.12 
kernel patch series which also means remove kernel-only in xfs_buf_item.h

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
