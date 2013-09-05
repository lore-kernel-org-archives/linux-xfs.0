Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 569D87F4E
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 10:36:06 -0500 (CDT)
Message-ID: <5228A4E5.4020409@sgi.com>
Date: Thu, 05 Sep 2013 10:36:05 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 04/55] libxfs: fix directory/attribute format issues
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-5-git-send-email-david@fromorbit.com>
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

On 09/04/13 17:05, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> directory data headers and attr leaf headers need padding for 32 bit
> systems to correctly align the data sections on 64 bit boundaries.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

This patch has not changed since the last posting. It brings xfsprogs to
kernel commit 5170711d

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
