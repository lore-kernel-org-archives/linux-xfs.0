Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 594D97F37
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 16:14:53 -0500 (CDT)
Date: Tue, 25 Jun 2013 16:14:49 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfsprogs: replace umode_t with xfs_mode_t
Message-ID: <20130625211449.GF20932@sgi.com>
References: <51BA219B.4070503@gmail.com> <20130614023758.GT29338@dastard>
	<51BB6028.1080602@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51BB6028.1080602@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

> From: "Michael L. Semon" <mlsemon35@gmail.com>
> Date: Fri, 14 Jun 2013 03:00:34 -0400
> Subject: [PATCH] xfsprogs: define umode_t for build if not defined already
> 
> umode_t has not been exported to the kernel private headers since
> around kernel 3.2.0-rc7.  Add a check for umode_t and define it
> if it has not been defined already.
> 
> Signed-off-by: Michael L. Semon <mlsemon35@gmail.com>

Looks ok to me.

Reviewed-by: Ben Myers <bpm@sgi.com>

Applied..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
